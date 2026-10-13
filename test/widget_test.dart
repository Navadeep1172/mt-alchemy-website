import 'package:flutter_test/flutter_test.dart';

import 'package:mt_alchemy_website/main.dart';

void main() {
  testWidgets('Home page renders MT Alchemy branding', (tester) async {
    await tester.pumpWidget(const MtAlchemyApp());
    await tester.pumpAndSettle();

    expect(find.text('MT Alchemy'), findsWidgets);
    expect(find.textContaining('Elevate your value'), findsWidgets);
  });
}
