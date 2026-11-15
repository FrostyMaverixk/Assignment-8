import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:org_fair/screens/about_screen.dart';

void main() {
  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');

  testWidgets('About does not invent a version when metadata fails', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => throw PlatformException(code: 'unavailable'),
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Version unavailable'), findsOneWidget);
    expect(find.text('Version 1.1.0 (build 2)'), findsNothing);
  });

  testWidgets('About shows a loading state until metadata arrives', (
    tester,
  ) async {
    final reply = Completer<Map<String, Object>>();
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) => reply.future,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    expect(find.text('Loading version...'), findsOneWidget);
    expect(find.text('Version 1.1.0 (build 2)'), findsNothing);

    reply.completeError(PlatformException(code: 'unavailable'));
    await tester.pumpAndSettle();
  });
}
