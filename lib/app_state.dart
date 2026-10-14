import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

/// ---------------------------------------------------------------------------
/// Application state
/// ---------------------------------------------------------------------------
/// The prototype has no server, so this single [ChangeNotifier] is the source
/// of truth for everything a user can *do*: the cart, orders, course
/// enrolments, lesson progress, issued certificates, employer employees and the
/// admin-managed catalogue. It persists to `SharedPreferences` (localStorage on
/// web) so data survives reloads.
///
/// Backend-ready seam: all reads/writes go through this class. To move to a
/// real backend, implement [RemoteSource] (see `lib/remote_source.dart`) and
/// set `AppState.remote`; the UI never changes.
/// ---------------------------------------------------------------------------
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  static const _storageKey = 'mt_alchemy_state_v1';

  SharedPreferences? _prefs;
  bool _ready = false;
  bool get ready => _ready;

  /// Optional remote backend (Firebase/Supabase/REST). Null = local only.
  RemoteSource? remote;

  // ---- Catalogue (seeded from data.dart, mutated by the admin portal) ----
  final List<Course> courses = [...seedCoursesList];
  final List<Product> products = [...seedProductsList];

  // ---- Shopping ----
  final List<CartLine> cart = [];
  final List<Order> orders = [];

  // ---- Learning ----
  final Set<String> enrolled = {};
  final Map<String, double> progress = {};
  final Map<String, String> certificates = {};

  // ---- Employer ----
  final List<Employee> employees = [
    for (final e in seedEmployees)
      Employee(
          name: e.name,
          email: e.email,
          department: e.department,
          role: e.role,
          completion: e.completion),
  ];
  final List<Assignment> assignments = [
    Assignment(
        employeeEmail: 'a@abcsdn.com', courseId: 'eq101', due: '30 Nov 2026'),
    Assignment(
        employeeEmail: 'c@abcsdn.com',
        courseId: 'comm104',
        due: '15 Dec 2026'),
  ];

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString(_storageKey);
      if (raw != null) {
        _restore(jsonDecode(raw) as Map<String, dynamic>);
      } else {
        _seedDemo();
      }
    } catch (_) {
      // No storage available (e.g. tests) - keep in-memory defaults.
      _seedDemo();
    }
    _ready = true;
    notifyListeners();
  }

  void _seedDemo() {
    if (enrolled.isNotEmpty || orders.isNotEmpty) return;
    enrolled.addAll({'eq101', 'lead103', 'mind102'});
    progress.addAll({'eq101': 0.65, 'lead103': 0.32, 'mind102': 1.0});
    certificates.addAll({'mind102': '13 Oct 2026', 'eq101': '02 Sep 2026'});
  }

  Future<void> _persist() async {
    final p = _prefs;
    if (p == null) return;
    final map = {
      'courses': courses.map((c) => c.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
      'cart': cart.map((c) => c.toJson()).toList(),
      'orders': orders.map((o) => o.toJson()).toList(),
      'enrolled': enrolled.toList(),
      'progress': progress,
      'certificates': certificates,
      'employees': employees.map((e) => e.toJson()).toList(),
      'assignments': assignments.map((a) => a.toJson()).toList(),
    };
    try {
      await p.setString(_storageKey, jsonEncode(map));
    } catch (_) {/* ignore */}
  }

  void _restore(Map<String, dynamic> m) {
    courses
      ..clear()
      ..addAll(((m['courses'] as List?) ?? [])
          .map((e) => Course.fromJson(e as Map<String, dynamic>)));
    products
      ..clear()
      ..addAll(((m['products'] as List?) ?? [])
          .map((e) => Product.fromJson(e as Map<String, dynamic>)));
    cart
      ..clear()
      ..addAll(((m['cart'] as List?) ?? [])
          .map((e) => CartLine.fromJson(e as Map<String, dynamic>)));
    orders
      ..clear()
      ..addAll(((m['orders'] as List?) ?? [])
          .map((e) => Order.fromJson(e as Map<String, dynamic>)));
    enrolled
      ..clear()
      ..addAll(((m['enrolled'] as List?) ?? []).cast<String>());
    progress
      ..clear()
      ..addAll(((m['progress'] as Map?) ?? {})
          .map((k, v) => MapEntry(k as String, (v as num).toDouble())));
    certificates
      ..clear()
      ..addAll(((m['certificates'] as Map?) ?? {})
          .map((k, v) => MapEntry(k as String, v as String)));
    employees
      ..clear()
      ..addAll(((m['employees'] as List?) ?? [])
          .map((e) => Employee.fromJson(e as Map<String, dynamic>)));
    assignments
      ..clear()
      ..addAll(((m['assignments'] as List?) ?? [])
          .map((e) => Assignment.fromJson(e as Map<String, dynamic>)));
  }

  void _changed() {
    notifyListeners();
    _persist();
    remote?.push(this);
  }

  // ---------------------------------------------------------------------------
  // Catalogue lookups
  // ---------------------------------------------------------------------------
  Product? productById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  Course? courseById(String id) {
    for (final c in courses) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<Course> get publishedCourses =>
      courses.where((c) => c.status == 'Published').toList();

  // ---------------------------------------------------------------------------
  // Cart
  // ---------------------------------------------------------------------------
  int get cartCount => cart.fold(0, (s, c) => s + c.quantity);

  List<CartEntry> get cartEntries => [
        for (final line in cart)
          if (productById(line.productId) != null)
            CartEntry(productById(line.productId)!, line.quantity),
      ];

  double get cartSubtotal =>
      cartEntries.fold(0, (s, e) => s + e.product.price * e.quantity);

  bool get cartHasPhysical =>
      cartEntries.any((e) => e.product.type == 'Physical');

  double get cartShipping => cartHasPhysical ? 12 : 0;

  double get cartTotal => cartSubtotal + cartShipping;

  void addToCart(Product p, [int quantity = 1]) {
    for (final line in cart) {
      if (line.productId == p.id) {
        line.quantity += quantity;
        _changed();
        return;
      }
    }
    cart.add(CartLine(productId: p.id, quantity: quantity));
    _changed();
  }

  void setCartQuantity(String productId, int quantity) {
    for (final line in cart) {
      if (line.productId == productId) {
        line.quantity = quantity < 1 ? 1 : quantity;
        _changed();
        return;
      }
    }
  }

  void removeFromCart(String productId) {
    cart.removeWhere((l) => l.productId == productId);
    _changed();
  }

  void clearCart() {
    cart.clear();
    _changed();
  }

  Order placeOrder({required String customer, required String payment}) {
    final items = [
      for (final e in cartEntries)
        OrderItem(
            name: e.product.name,
            type: e.product.type,
            price: e.product.price,
            quantity: e.quantity),
    ];
    final order = Order(
      id: _nextOrderId(),
      date: DateTime.now(),
      items: items,
      shipping: cartShipping,
      payment: payment,
      customer: customer,
    )..status = items.any((i) => i.type == 'Physical')
        ? 'Paid'
        : 'Available';
    orders.insert(0, order);
    clearCart();
    return order;
  }

  void setOrderStatus(String orderId, String status) {
    for (final o in orders) {
      if (o.id == orderId) {
        o.status = status;
        _changed();
        return;
      }
    }
  }

  String _nextOrderId() {
    final n = 1000 + orders.length + 1;
    return '#MA$n';
  }

  /// Products the signed-in user has bought digitally (entitlement check).
  List<Product> get purchasedDigital {
    final names = <String>{};
    for (final o in orders) {
      for (final i in o.items) {
        if (i.type == 'Digital') names.add(i.name);
      }
    }
    // Seed a couple so the library isn't empty on first run.
    final owned = products
        .where((p) => p.type == 'Digital' && names.contains(p.name))
        .toList();
    if (owned.isEmpty) {
      return products.where((p) => p.type == 'Digital').take(2).toList();
    }
    return owned;
  }

  // ---------------------------------------------------------------------------
  // Learning
  // ---------------------------------------------------------------------------
  bool isEnrolled(String courseId) => enrolled.contains(courseId);

  double progressFor(String courseId) => progress[courseId] ?? 0;

  bool isCompleted(String courseId) => (progress[courseId] ?? 0) >= 1;

  List<Course> get enrolledCourses =>
      courses.where((c) => enrolled.contains(c.id)).toList();

  void enrol(Course c) {
    enrolled.add(c.id);
    progress.putIfAbsent(c.id, () => 0);
    _changed();
  }

  void setProgress(Course c, double value) {
    enrolled.add(c.id);
    progress[c.id] = value.clamp(0.0, 1.0);
    if (progress[c.id]! >= 1 && !certificates.containsKey(c.id)) {
      certificates[c.id] = formatDate(DateTime.now());
    }
    _changed();
  }

  void completeCourse(Course c) => setProgress(c, 1);

  /// Courses with an issued certificate.
  List<Course> get certifiedCourses =>
      courses.where((c) => certificates.containsKey(c.id)).toList();

  String? certificateIdFor(Course c) =>
      certificates.containsKey(c.id) ? 'MTA-${c.id.toUpperCase()}-0001' : null;

  // ---------------------------------------------------------------------------
  // Admin: course CRUD
  // ---------------------------------------------------------------------------
  void saveCourse(Course c) {
    final i = courses.indexWhere((x) => x.id == c.id);
    if (i == -1) {
      courses.insert(0, c);
    } else {
      courses[i] = c;
    }
    _changed();
  }

  void deleteCourse(String id) {
    courses.removeWhere((c) => c.id == id);
    _changed();
  }

  String newCourseId() => 'c${DateTime.now().millisecondsSinceEpoch % 100000}';

  // ---------------------------------------------------------------------------
  // Admin: product CRUD
  // ---------------------------------------------------------------------------
  void saveProduct(Product p) {
    final i = products.indexWhere((x) => x.id == p.id);
    if (i == -1) {
      products.insert(0, p);
    } else {
      products[i] = p;
    }
    _changed();
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
    _changed();
  }

  String newProductId() => 'p${DateTime.now().millisecondsSinceEpoch % 100000}';

  // ---------------------------------------------------------------------------
  // Employer
  // ---------------------------------------------------------------------------
  void addEmployee(Employee e) {
    employees.add(e);
    _changed();
  }

  void removeEmployee(String email) {
    employees.removeWhere((e) => e.email == email);
    assignments.removeWhere((a) => a.employeeEmail == email);
    _changed();
  }

  void assignCourse(Assignment a) {
    assignments.add(a);
    _changed();
  }

  List<Employee> get completedEmployees =>
      employees.where((e) => e.completion >= 1).toList();
}

/// A product plus its quantity, resolved against the current catalogue.
class CartEntry {
  final Product product;
  final int quantity;
  const CartEntry(this.product, this.quantity);
}

class CartLine {
  final String productId;
  int quantity;
  CartLine({required this.productId, this.quantity = 1});
  Map<String, dynamic> toJson() =>
      {'productId': productId, 'quantity': quantity};
  factory CartLine.fromJson(Map<String, dynamic> j) => CartLine(
      productId: j['productId'] as String,
      quantity: (j['quantity'] as num).toInt());
}

class OrderItem {
  final String name;
  final String type;
  final double price;
  final int quantity;
  const OrderItem(
      {required this.name,
      required this.type,
      required this.price,
      this.quantity = 1});
  Map<String, dynamic> toJson() =>
      {'name': name, 'type': type, 'price': price, 'quantity': quantity};
  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
      name: j['name'] as String,
      type: j['type'] as String,
      price: (j['price'] as num).toDouble(),
      quantity: (j['quantity'] as num).toInt());
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final double shipping;
  final String payment; // Paid / Failed / Pending
  final String customer;
  String status; // Pending/Paid/Processing/Shipped/Delivered/Available
  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.shipping,
    required this.payment,
    required this.customer,
    this.status = 'Pending',
  });

  double get subtotal => items.fold(0, (s, i) => s + i.price * i.quantity);
  double get total => subtotal + shipping;
  bool get hasPhysical => items.any((i) => i.type == 'Physical');
  bool get isDigitalOnly => items.isNotEmpty && !hasPhysical;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'shipping': shipping,
        'payment': payment,
        'customer': customer,
        'status': status,
      };
  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        items: (j['items'] as List)
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        shipping: (j['shipping'] as num).toDouble(),
        payment: j['payment'] as String,
        customer: j['customer'] as String,
        status: j['status'] as String? ?? 'Pending',
      );
}

class Employee {
  final String name;
  final String email;
  final String department;
  final String role;
  double completion; // 0..1 across assigned courses
  Employee({
    required this.name,
    required this.email,
    required this.department,
    this.role = 'Learner',
    this.completion = 0,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'department': department,
        'role': role,
        'completion': completion,
      };
  factory Employee.fromJson(Map<String, dynamic> j) => Employee(
        name: j['name'] as String,
        email: j['email'] as String,
        department: j['department'] as String,
        role: j['role'] as String? ?? 'Learner',
        completion: (j['completion'] as num?)?.toDouble() ?? 0,
      );
}

class Assignment {
  final String employeeEmail;
  final String courseId;
  final String due;
  const Assignment(
      {required this.employeeEmail, required this.courseId, required this.due});
  Map<String, dynamic> toJson() => {
        'employeeEmail': employeeEmail,
        'courseId': courseId,
        'due': due,
      };
  factory Assignment.fromJson(Map<String, dynamic> j) => Assignment(
        employeeEmail: j['employeeEmail'] as String,
        courseId: j['courseId'] as String,
        due: j['due'] as String,
      );
}

/// DD Mmm YYYY without pulling in intl.
String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
}

/// Global convenience handle.
final app = AppState.instance;

/// ---------------------------------------------------------------------------
/// Backend seam
/// ---------------------------------------------------------------------------
/// Implement this to sync [AppState] with a real backend. The default is a
/// no-op so the prototype runs entirely on-device. See `lib/remote_source.dart`
/// for the Firebase/Supabase/REST integration guide.
abstract class RemoteSource {
  Future<void> push(AppState state);
  Future<void> pull(AppState state);
}

class NoopRemoteSource implements RemoteSource {
  const NoopRemoteSource();
  @override
  Future<void> push(AppState state) async {}
  @override
  Future<void> pull(AppState state) async {}
}
