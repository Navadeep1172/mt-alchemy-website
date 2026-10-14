import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../motion.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets.dart';
import 'dashboards.dart';

/// ---------------------------------------------------------------------------
/// Admin / Trainer portal pages.
/// These are real, stateful screens backed by [AppState]: courses, products and
/// orders are created, edited and deleted here and persist across reloads.
/// ---------------------------------------------------------------------------
Widget _admin({
  required String title,
  required String subtitle,
  required Widget content,
  List<Widget> actions = const [],
  String workspace = 'Admin Portal',
}) =>
    PortalScaffold(
      workspace: workspace,
      title: title,
      subtitle: subtitle,
      nav: adminNav,
      actions: actions,
      content: content,
    );

/// ---------------------------------------------------------------------------
/// Course management (CRUD)
/// ---------------------------------------------------------------------------
class AdminCoursesPage extends StatelessWidget {
  const AdminCoursesPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => _admin(
          title: 'Course Management',
          subtitle: 'Create, edit, publish or archive courses.',
          actions: [
            FilledButton.icon(
                onPressed: () => _openCourseDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Course')),
          ],
          content: Column(children: [
            for (final c in app.courses) _courseCard(context, c),
          ]),
        ),
      );

  Widget _courseCard(BuildContext context, Course c) {
    final color = switch (c.status) {
      'Draft' => Brand.grey,
      'Archived' => Brand.clayDeep,
      _ => Brand.success,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Panel(
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(c.image, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.title, style: heading(16), maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('${c.category} · ${c.instructor} · RM${c.price.toStringAsFixed(0)}',
                  style: body(12.5, color: Brand.grey)),
              const SizedBox(height: 8),
              _chip(c.status, color),
            ]),
          ),
          IconButton(
              tooltip: 'Edit',
              onPressed: () => _openCourseDialog(context, existing: c),
              icon: const Icon(Icons.edit_outlined)),
          IconButton(
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, 'course "${c.title}"',
                  () => app.deleteCourse(c.id)),
              icon: const Icon(Icons.delete_outline, color: Brand.clayDeep)),
        ]),
      ),
    );
  }
}

Future<void> _openCourseDialog(BuildContext context, {Course? existing}) async {
  final title = TextEditingController(text: existing?.title ?? '');
  final instructor = TextEditingController(text: existing?.instructor ?? 'Mabel Tan KH');
  final duration = TextEditingController(text: existing?.duration ?? '3h 00m');
  final price = TextEditingController(text: (existing?.price ?? 199).toStringAsFixed(0));
  final description = TextEditingController(text: existing?.description ?? '');
  String category = existing?.category ?? courseCategories.first;
  String level = existing?.level ?? 'Beginner';
  String status = existing?.status ?? 'Published';
  String image = existing?.image ?? Img.features.first;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? 'Create course' : 'Edit course'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _tf(title, 'Title', Icons.school_outlined),
              _tf(instructor, 'Instructor', Icons.person_outline),
              Row(children: [
                Expanded(child: _tf(duration, 'Duration', Icons.schedule)),
                const SizedBox(width: 12),
                Expanded(child: _tf(price, 'Price (RM)', Icons.payments_outlined,
                    keyboard: TextInputType.number)),
              ]),
              _dropdown<String>('Category', category, courseCategories,
                  (v) => setState(() => category = v)),
              Row(children: [
                Expanded(
                  child: _dropdown<String>(
                      'Level',
                      level,
                      const ['Beginner', 'Intermediate', 'Advanced'],
                      (v) => setState(() => level = v)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown<String>(
                      'Status',
                      status,
                      const ['Draft', 'Published', 'Archived'],
                      (v) => setState(() => status = v)),
                ),
              ]),
              _dropdown<String>('Image', image, Img.features,
                  (v) => setState(() => image = v)),
              _tf(description, 'Description', Icons.notes, lines: 3),
            ]),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
    ),
  );

  if (result == true && title.text.trim().isNotEmpty) {
    app.saveCourse(Course(
      id: existing?.id ?? app.newCourseId(),
      title: title.text.trim(),
      category: category,
      instructor: instructor.text.trim(),
      duration: duration.text.trim(),
      level: level,
      modules: existing?.modules ?? 5,
      rating: existing?.rating ?? 4.7,
      price: double.tryParse(price.text) ?? 0,
      image: image,
      description: description.text.trim(),
      objectives: existing?.objectives ??
          const ['Apply the skills immediately at work'],
      curriculum: existing?.curriculum ??
          const [
            CurriculumItem('Introduction', 'Video'),
            CurriculumItem('Core concepts', 'Video'),
            CurriculumItem('Knowledge Check', 'Quiz'),
          ],
      status: status,
    ));
  }
}

/// ---------------------------------------------------------------------------
/// Product management (CRUD)
/// ---------------------------------------------------------------------------
class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => _admin(
          title: 'Product Management',
          subtitle: 'Manage store products, prices and stock.',
          actions: [
            FilledButton.icon(
                onPressed: () => _openProductDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Product')),
          ],
          content: Column(children: [
            for (final p in app.products) _productCard(context, p),
          ]),
        ),
      );

  Widget _productCard(BuildContext context, Product p) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Panel(
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  Image.asset(p.image, width: 72, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: heading(16), maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                    '${p.type} · ${p.category} · RM${p.price.toStringAsFixed(0)} · stock ${p.stock}',
                    style: body(12.5, color: Brand.grey)),
              ]),
            ),
            IconButton(
                tooltip: 'Edit',
                onPressed: () => _openProductDialog(context, existing: p),
                icon: const Icon(Icons.edit_outlined)),
            IconButton(
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, 'product "${p.name}"',
                    () => app.deleteProduct(p.id)),
                icon: const Icon(Icons.delete_outline, color: Brand.clayDeep)),
          ]),
        ),
      );
}

Future<void> _openProductDialog(BuildContext context, {Product? existing}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final price = TextEditingController(text: (existing?.price ?? 49).toStringAsFixed(0));
  final stock = TextEditingController(text: (existing?.stock ?? 10).toString());
  final category = TextEditingController(text: existing?.category ?? 'Workbook');
  final description = TextEditingController(text: existing?.description ?? '');
  String type = existing?.type ?? 'Digital';
  String image = existing?.image ?? Img.products.first;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? 'Add product' : 'Edit product'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _tf(name, 'Name', Icons.inventory_2_outlined),
              Row(children: [
                Expanded(child: _tf(category, 'Category', Icons.category_outlined)),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown<String>(
                      'Type', type, const ['Digital', 'Physical'],
                      (v) => setState(() => type = v)),
                ),
              ]),
              Row(children: [
                Expanded(child: _tf(price, 'Price (RM)', Icons.payments_outlined,
                    keyboard: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _tf(stock, 'Stock', Icons.warehouse_outlined,
                    keyboard: TextInputType.number)),
              ]),
              _dropdown<String>('Image', image, Img.products,
                  (v) => setState(() => image = v)),
              _tf(description, 'Description', Icons.notes, lines: 3),
            ]),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
    ),
  );

  if (result == true && name.text.trim().isNotEmpty) {
    app.saveProduct(Product(
      id: existing?.id ?? app.newProductId(),
      name: name.text.trim(),
      type: type,
      category: category.text.trim(),
      price: double.tryParse(price.text) ?? 0,
      description: description.text.trim(),
      image: image,
      stock: int.tryParse(stock.text) ?? 0,
    ));
  }
}

/// ---------------------------------------------------------------------------
/// Order management
/// ---------------------------------------------------------------------------
class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});
  static const _statuses = [
    'Pending', 'Paid', 'Processing', 'Shipped', 'Delivered', 'Available',
  ];

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final orders = app.orders;
          return _admin(
            title: 'Order Management',
            subtitle: 'Process orders and update fulfilment status.',
            content: orders.isEmpty
                ? Panel(
                    child: Text('No orders yet.',
                        style: body(15, color: Brand.grey)))
                : Column(
                    children: [
                      for (final o in orders)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Panel(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(
                                        child: Text(o.id, style: heading(16))),
                                    Text(
                                        'RM${o.total.toStringAsFixed(0)} · ${o.payment}',
                                        style: body(13, color: Brand.grey)),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text(
                                      '${formatDate(o.date)} · ${o.customer} · ${o.items.length} item(s)',
                                      style: body(12.5, color: Brand.grey)),
                                  const SizedBox(height: 12),
                                  Row(children: [
                                    const Text('Status:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 12),
                                    DropdownButton<String>(
                                      value: _statuses.contains(o.status)
                                          ? o.status
                                          : 'Pending',
                                      underline: const SizedBox.shrink(),
                                      items: [
                                        for (final s in _statuses)
                                          DropdownMenuItem(
                                              value: s, child: Text(s)),
                                      ],
                                      onChanged: (v) => app.setOrderStatus(
                                          o.id, v ?? o.status),
                                    ),
                                  ]),
                                ]),
                          ),
                        ),
                    ],
                  ),
          );
        },
      );
}

/// ---------------------------------------------------------------------------
/// Users
/// ---------------------------------------------------------------------------
class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});
  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  static const _seedUsers = [
    ('Mabel Tan KH', 'mabel@mtalchemy.com', 'Administrator'),
    ('Nadia Rahman', 'nadia@abcsdn.com', 'Employer'),
    ('Ahmad Zaki', 'ahmad@gmail.com', 'Individual Learner'),
    ('Priya Nair', 'priya@abcsdn.com', 'Individual Learner'),
    ('Sofia Lim', 'sofia@mtalchemy.com', 'Trainer'),
  ];
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final me = session.value;
    final users = <(String, String, String)>[
      ..._seedUsers,
      if (me != null) (me.name, me.email, me.role.label),
    ].where((u) => u.$1.toLowerCase().contains(_q.toLowerCase())).toList();

    return _admin(
      title: 'Users',
      subtitle: 'People with access to MT Alchemy.',
      actions: [
        SizedBox(
          width: 260,
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: const InputDecoration(
                hintText: 'Search users',
                prefixIcon: Icon(Icons.search),
                isDense: true),
          ),
        ),
      ],
      content: Panel(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle:
                body(13, color: Brand.green, weight: FontWeight.w700),
            dataTextStyle: body(13),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Role')),
            ],
            rows: [
              for (final u in users)
                DataRow(cells: [
                  DataCell(Text(u.$1)),
                  DataCell(Text(u.$2)),
                  DataCell(_chip(u.$3, Brand.sage)),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Organizations
/// ---------------------------------------------------------------------------
class AdminOrganizationsPage extends StatelessWidget {
  const AdminOrganizationsPage({super.key});
  static const _orgs = [
    ('ABC Sdn Bhd', 'Manufacturing', '120', '64%'),
    ('GreenRetail Group', 'Retail', '58', '71%'),
    ('Nova Logistics', 'Logistics', '96', '58%'),
    ('BrightEd Institute', 'Education', '34', '82%'),
  ];

  @override
  Widget build(BuildContext context) => _admin(
        title: 'Organizations',
        subtitle: 'Corporate accounts and their engagement.',
        content: Panel(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle:
                  body(13, color: Brand.green, weight: FontWeight.w700),
              dataTextStyle: body(13),
              columns: const [
                DataColumn(label: Text('Organization')),
                DataColumn(label: Text('Industry')),
                DataColumn(label: Text('Employees')),
                DataColumn(label: Text('Completion')),
              ],
              rows: [
                for (final o in _orgs)
                  DataRow(cells: [
                    DataCell(Text(o.$1)),
                    DataCell(Text(o.$2)),
                    DataCell(Text(o.$3)),
                    DataCell(Text(o.$4)),
                  ]),
              ],
            ),
          ),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Assessments
/// ---------------------------------------------------------------------------
class AdminAssessmentsPage extends StatelessWidget {
  const AdminAssessmentsPage({super.key});

  @override
  Widget build(BuildContext context) => _admin(
        title: 'Assessments',
        subtitle: 'Question banks attached to each course.',
        content: Column(children: [
          for (final c in app.courses)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Panel(
                child: Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Brand.sageTint,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.quiz_outlined, color: Brand.sage),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${c.title} - Knowledge Check',
                              style: body(15, weight: FontWeight.w600)),
                          Text('4 questions · single, true/false, multiple, short',
                              style: body(12.5, color: Brand.grey)),
                        ]),
                  ),
                  TextButton(
                      onPressed: () => go(context, '/admin/assessments'),
                      child: const Text('Edit')),
                ]),
              ),
            ),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Certificates (issued)
/// ---------------------------------------------------------------------------
class AdminCertificatesPage extends StatelessWidget {
  const AdminCertificatesPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final issued = app.certifiedCourses;
          return _admin(
            title: 'Certificates',
            subtitle: 'Certificates issued to learners.',
            content: issued.isEmpty
                ? Panel(
                    child: Text('No certificates issued yet.',
                        style: body(15, color: Brand.grey)))
                : Panel(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: body(13,
                            color: Brand.green, weight: FontWeight.w700),
                        dataTextStyle: body(13),
                        columns: const [
                          DataColumn(label: Text('Certificate ID')),
                          DataColumn(label: Text('Course')),
                          DataColumn(label: Text('Issued')),
                        ],
                        rows: [
                          for (final c in issued)
                            DataRow(cells: [
                              DataCell(Text(
                                  app.certificateIdFor(c) ??
                                      'MTA-${c.id.toUpperCase()}')),
                              DataCell(Text(c.title)),
                              DataCell(Text(app.certificates[c.id] ?? '-')),
                            ]),
                        ],
                      ),
                    ),
                  ),
          );
        },
      );
}

/// ---------------------------------------------------------------------------
/// Payments
/// ---------------------------------------------------------------------------
class AdminPaymentsPage extends StatelessWidget {
  const AdminPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final paid = app.orders
              .fold<double>(0, (s, o) => s + (o.payment == 'Paid' ? o.total : 0));
          return _admin(
            title: 'Payments',
            subtitle: 'Revenue and transaction records.',
            content: Column(children: [
              CardGrid(children: [
                DashStat('RM${paid.toStringAsFixed(0)}', 'Collected',
                    Icons.payments_outlined, Brand.success),
                DashStat('${app.orders.length}', 'Transactions',
                    Icons.receipt_long_outlined, Brand.sage),
              ]),
              const SizedBox(height: 20),
              if (app.orders.isEmpty)
                Panel(
                    child: Text('No transactions yet.',
                        style: body(15, color: Brand.grey)))
              else
                Panel(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: body(13,
                          color: Brand.green, weight: FontWeight.w700),
                      dataTextStyle: body(13),
                      columns: const [
                        DataColumn(label: Text('Order')),
                        DataColumn(label: Text('Customer')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        for (final o in app.orders)
                          DataRow(cells: [
                            DataCell(Text(o.id)),
                            DataCell(Text(o.customer)),
                            DataCell(Text('RM${o.total.toStringAsFixed(0)}')),
                            DataCell(_chip(o.payment,
                                o.payment == 'Paid'
                                    ? Brand.success
                                    : Brand.grey)),
                          ]),
                      ],
                    ),
                  ),
                ),
            ]),
          );
        },
      );
}

/// ---------------------------------------------------------------------------
/// Content / CMS
/// ---------------------------------------------------------------------------
class AdminContentPage extends StatefulWidget {
  const AdminContentPage({super.key});
  @override
  State<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends State<AdminContentPage> {
  final _published = <String, bool>{
    'Home hero copy': true,
    'About the founder': true,
    'Services overview': true,
    'Impact stories': false,
    'Insights articles': true,
    'Footer links': true,
  };

  @override
  Widget build(BuildContext context) => _admin(
        title: 'Content',
        subtitle: 'Manage public website copy and pages.',
        content: Column(children: [
          for (final e in _published.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Panel(
                child: Row(children: [
                  Expanded(
                      child: Text(e.key,
                          style: body(15, weight: FontWeight.w600))),
                  Switch(
                    value: e.value,
                    activeThumbColor: Brand.green,
                    onChanged: (v) =>
                        setState(() => _published[e.key] = v),
                  ),
                  Text(e.value ? 'Published' : 'Draft',
                      style: body(12.5, color: Brand.grey)),
                ]),
              ),
            ),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Reports
/// ---------------------------------------------------------------------------
class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => _admin(
          title: 'Reports',
          subtitle: 'Platform analytics at a glance.',
          content: Column(children: [
            CardGrid(children: [
              DashStat('${app.courses.length}', 'Courses', Icons.school_outlined,
                  Brand.sage),
              DashStat('${app.products.length}', 'Products',
                  Icons.inventory_2_outlined, Brand.green),
              DashStat('${app.orders.length}', 'Orders',
                  Icons.receipt_long_outlined, Brand.clayDeep),
              DashStat('${app.certifiedCourses.length}', 'Certificates',
                  Icons.workspace_premium_outlined, Brand.success),
            ]),
            const SizedBox(height: 20),
            Panel(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Enrolments by course', style: heading(18)),
                const SizedBox(height: 16),
                for (final c in app.courses.take(5))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(c.title,
                                    style: body(13.5,
                                        weight: FontWeight.w600)),
                                Text('${c.modules} modules',
                                    style: body(12.5, color: Brand.grey)),
                              ]),
                          const SizedBox(height: 6),
                          GradientProgressBar(
                              value: (c.rating / 5).clamp(0.0, 1.0), height: 8),
                        ]),
                  ),
              ]),
            ),
          ]),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Settings
/// ---------------------------------------------------------------------------
class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});
  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _orgSignups = true;
  bool _autoCertificates = true;
  bool _maintenance = false;
  String _currency = 'MYR';

  @override
  Widget build(BuildContext context) => _admin(
        title: 'Settings',
        subtitle: 'Platform-wide configuration.',
        content: Panel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('General', style: heading(18)),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Brand.green,
                value: _orgSignups,
                onChanged: (v) => setState(() => _orgSignups = v),
                title: const Text('Allow organisation sign-ups')),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Brand.green,
                value: _autoCertificates,
                onChanged: (v) => setState(() => _autoCertificates = v),
                title: const Text('Auto-issue certificates on completion')),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: Brand.clayDeep,
                value: _maintenance,
                onChanged: (v) => setState(() => _maintenance = v),
                title: const Text('Maintenance mode')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: const InputDecoration(
                  labelText: 'Currency', prefixIcon: Icon(Icons.attach_money)),
              items: const [
                DropdownMenuItem(value: 'MYR', child: Text('MYR (RM)')),
                DropdownMenuItem(value: 'SGD', child: Text('SGD (S\$)')),
                DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
              ],
              onChanged: (v) => setState(() => _currency = v!),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved'))),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save settings'),
            ),
          ]),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Trainer: materials + learners
/// ---------------------------------------------------------------------------
class AdminMaterialsPage extends StatelessWidget {
  const AdminMaterialsPage({super.key});
  static const _materials = [
    ('EQ Fundamentals - Slide deck', 'PDF', '2.4 MB'),
    ('Active Listening - Worksheet', 'PDF', '640 KB'),
    ('Mindfulness - Guided Audio', 'Audio', '12 MB'),
    ('Leadership - Case Studies', 'PDF', '1.1 MB'),
  ];

  @override
  Widget build(BuildContext context) => _admin(
        workspace: 'Trainer Studio',
        title: 'Materials',
        subtitle: 'Upload and share course materials.',
        actions: [
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload')),
        ],
        content: Column(children: [
          for (final m in _materials)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Panel(
                child: Row(children: [
                  const Icon(Icons.insert_drive_file_outlined,
                      color: Brand.sage),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Text(m.$1,
                          style: body(15, weight: FontWeight.w600))),
                  _chip(m.$2, Brand.green),
                  const SizedBox(width: 10),
                  Text(m.$3, style: body(12.5, color: Brand.grey)),
                ]),
              ),
            ),
        ]),
      );
}

class AdminLearnersPage extends StatelessWidget {
  const AdminLearnersPage({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => _admin(
          workspace: 'Trainer Studio',
          title: 'Learners',
          subtitle: 'Monitor learner progress across your courses.',
          content: app.employees.isEmpty
              ? Panel(
                  child: Text('No learners yet.',
                      style: body(15, color: Brand.grey)))
              : Panel(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: body(13,
                          color: Brand.green, weight: FontWeight.w700),
                      dataTextStyle: body(13),
                      columns: const [
                        DataColumn(label: Text('Learner')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Progress')),
                      ],
                      rows: [
                        for (final e in app.employees)
                          DataRow(cells: [
                            DataCell(Text(e.name)),
                            DataCell(Text(e.department)),
                            DataCell(SizedBox(
                              width: 140,
                              child: Row(children: [
                                Expanded(
                                    child: GradientProgressBar(
                                        value: e.completion, height: 6)),
                                const SizedBox(width: 8),
                                Text('${(e.completion * 100).round()}%'),
                              ]),
                            )),
                          ]),
                      ],
                    ),
                  ),
                ),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Shared helpers
/// ---------------------------------------------------------------------------
Widget _chip(String label, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20)),
      child:
          Text(label, style: body(11.5, color: color, weight: FontWeight.w700)),
    );

Future<void> _confirmDelete(
    BuildContext context, String label, VoidCallback onConfirm) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm delete'),
      content: Text('Delete $label? This cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Brand.clayDeep),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (ok == true) onConfirm();
}

Widget _tf(TextEditingController c, String label, IconData icon,
        {TextInputType? keyboard, int lines = 1}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        maxLines: lines,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );

Widget _dropdown<T>(String label, T value, List<T> items, ValueChanged<T> onChanged) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final i in items) DropdownMenuItem(value: i, child: Text('$i')),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
