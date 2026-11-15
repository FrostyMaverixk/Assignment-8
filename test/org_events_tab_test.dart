import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:org_fair/data/event_repository.dart';
import 'package:org_fair/data/event_source.dart';
import 'package:org_fair/models/fair_event.dart';
import 'package:org_fair/screens/org_detail_screen.dart';

import 'helpers.dart';

void main() {
  testWidgets('An org labels saved events and can retry the CMS', (
    tester,
  ) async {
    final source = FakeEventSource();
    final repository = EventRepository(source);
    await tester.runAsync(repository.load);
    source.failWith = const CmsException('No connection.');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrgEventsTab(orgId: 'csc', repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hour of Code'), findsOneWidget);
    expect(
      find.text('No connection. Showing the events saved earlier.'),
      findsOneWidget,
    );

    source.failWith = null;
    source.events = [
      FairEvent(
        id: 'moved',
        orgId: 'csc',
        title: 'Moved event',
        startsAt: DateTime.utc(2026, 11, 8),
        venue: 'Gym',
      ),
    ];
    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialBanner), findsNothing);
    expect(find.text('Moved event'), findsOneWidget);
    expect(find.text('Hour of Code'), findsNothing);
  });

  testWidgets('An empty saved org list is still marked as offline', (
    tester,
  ) async {
    final source = FakeEventSource([]);
    final repository = EventRepository(source);
    await tester.runAsync(repository.load);
    source.failWith = const CmsException('No connection.');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrgEventsTab(orgId: 'csc', repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No events yet.'), findsOneWidget);
    expect(find.byType(MaterialBanner), findsOneWidget);
  });
}
