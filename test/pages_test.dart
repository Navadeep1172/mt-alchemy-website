import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mt_alchemy_website/main.dart';

/// Routes that do not require arguments (argument routes fall back to the
/// first Course / Product automatically, so they are still covered).
const routes = [
  '/',
  '/about',
  '/services',
  '/coaching',
  '/organisations',
  '/programmes',
  '/upskilling',
  '/insights',
  '/impact',
  '/contact',
  '/login',
  '/register',
  '/store',
  '/product',
  '/cart',
  '/checkout',
  '/order',
  '/myorders',
  '/library',
  '/course',
  '/player',
  '/quiz',
  '/certificate',
  '/learner',
  '/mylearning',
  '/certificates',
  '/profile',
  '/employer',
  '/employer/employees',
  '/employer/assign',
  '/employer/reports',
  '/admin',
  '/admin/users',
  '/admin/organizations',
  '/admin/courses',
  '/admin/assessments',
  '/admin/certificates',
  '/admin/products',
  '/admin/orders',
  '/admin/payments',
  '/admin/content',
  '/admin/reports',
  '/admin/settings',
  '/admin/materials',
  '/admin/learners',
];

void main() {
  final sizes = {
    'desktop': const Size(1400, 1000),
    'tablet': const Size(820, 1100),
    'mobile': const Size(390, 844),
  };

  for (final entry in sizes.entries) {
    for (final route in routes) {
      testWidgets('${entry.key} renders $route without overflow',
          (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Tickers are muted so the endless ambient animations do not prevent
        // pumpAndSettle from settling; layout is identical either way.
        await tester.pumpWidget(
            const TickerMode(enabled: false, child: MtAlchemyApp()));
        await tester.pumpAndSettle();
        final nav = tester.state<NavigatorState>(find.byType(Navigator));
        nav.pushNamed(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
