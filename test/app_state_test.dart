import 'package:flutter_test/flutter_test.dart';
import 'package:mt_alchemy_website/app_state.dart';
import 'package:mt_alchemy_website/data.dart';

void main() {
  final app = AppState.instance;

  test('catalogue is seeded from data.dart', () {
    expect(app.products, isNotEmpty);
    expect(app.courses.length, seedCoursesList.length);
    expect(app.publishedCourses, isNotEmpty);
  });

  test('cart supports add, quantity, totals and checkout', () {
    app.clearCart();
    final physical =
        app.products.firstWhere((p) => p.type == 'Physical');
    app.addToCart(physical, 2);
    expect(app.cartCount, 2);
    expect(app.cartHasPhysical, isTrue);
    expect(app.cartSubtotal, physical.price * 2);
    expect(app.cartTotal, app.cartSubtotal + app.cartShipping);

    app.setCartQuantity(physical.id, 1);
    expect(app.cartCount, 1);

    final before = app.orders.length;
    final order = app.placeOrder(customer: 'Test', payment: 'Paid');
    expect(app.orders.length, before + 1);
    expect(order.items.single.name, physical.name);
    expect(app.cartCount, 0);
    expect(order.shipping, 12);
    expect(order.total, order.subtotal + order.shipping);
  });

  test('enrolment and completion issue a certificate', () {
    final course = app.courses.first;
    app.enrol(course);
    expect(app.isEnrolled(course.id), isTrue);
    app.setProgress(course, 0.5);
    expect(app.progressFor(course.id), 0.5);
    expect(app.isCompleted(course.id), isFalse);
    app.completeCourse(course);
    expect(app.isCompleted(course.id), isTrue);
    expect(app.certificateIdFor(course), isNotNull);
    expect(app.certifiedCourses, contains(course));
  });

  test('course CRUD mutates the catalogue', () {
    final count = app.courses.length;
    app.saveCourse(Course(
      id: 'test-course',
      title: 'Test Course',
      category: courseCategories.first,
      instructor: 'Tester',
      duration: '1h',
      level: 'Beginner',
      modules: 1,
      rating: 5,
      price: 10,
      image: Img.features.first,
      description: 'desc',
      objectives: const ['o'],
      curriculum: const [CurriculumItem('Intro', 'Video')],
      status: 'Draft',
    ));
    expect(app.courses.length, count + 1);
    expect(app.publishedCourses.any((c) => c.id == 'test-course'), isFalse);

    app.deleteCourse('test-course');
    expect(app.courses.length, count);
  });
}
