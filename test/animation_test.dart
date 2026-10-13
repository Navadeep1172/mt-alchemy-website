import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mt_alchemy_website/main.dart';

/// Exercises the animated UI with tickers running. Uses fixed `pump`
/// durations rather than `pumpAndSettle` because several ambient animations
/// (aurora, marquee, halo, gradient sheen) loop forever by design.
void main() {
  testWidgets('Home page animations run without exceptions', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MtAlchemyApp());

    // Entrance animations + counters.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);

    // Scroll through the page so scroll-triggered reveals fire.
    final scrollable = find.byType(SingleChildScrollView).first;
    for (var i = 0; i < 4; i++) {
      await tester.drag(scrollable, const Offset(0, -700));
      for (var j = 0; j < 5; j++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
      expect(tester.takeException(), isNull);
    }

    // Dispose the tree while animations are still running.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Route transition animates without exceptions', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MtAlchemyApp());
    await tester.pump(const Duration(milliseconds: 600));

    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pushNamed('/store');
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.takeException(), isNull);

    nav.pop();
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}