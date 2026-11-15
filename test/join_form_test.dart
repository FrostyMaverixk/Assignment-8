import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:org_fair/data/orgs.dart';
import 'package:org_fair/screens/join_form_screen.dart';

void main() {
  testWidgets('Reset clears the year and restores required-year validation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(home: JoinFormScreen(org: sampleOrgs.first)),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Year 3').last);
    await tester.pumpAndSettle();
    expect(find.text('Year 3'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Year 3'), findsNothing);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pump();
    expect(find.text('Choose your year level'), findsOneWidget);
  });
}
