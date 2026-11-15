import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:org_fair/screens/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Keep the package's static success cache isolated from metadata-failure tests.
void main() {
  testWidgets('About displays the actual package version and build', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'CICT Org Fair',
      packageName: 'org_fair',
      version: '9.4.0',
      buildNumber: '17',
      buildSignature: '',
    );

    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Version 9.4.0 (build 17)'), findsOneWidget);
  });
}
