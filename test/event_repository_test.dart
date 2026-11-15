import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:org_fair/data/event_repository.dart';
import 'package:org_fair/data/event_source.dart';
import 'package:org_fair/models/fair_event.dart';

class _ControlledSource implements EventSource {
  final requests = <Completer<List<FairEvent>>>[];

  @override
  String get name => 'Controlled CMS';

  @override
  Future<List<FairEvent>> fetchEvents() {
    final request = Completer<List<FairEvent>>();
    requests.add(request);
    return request.future;
  }
}

FairEvent event(String title) => FairEvent(
  id: title,
  orgId: 'csc',
  title: title,
  startsAt: DateTime.utc(2026, 11, 8),
  venue: 'Lab',
);

void main() {
  test('An older response cannot replace the newer successful cache', () async {
    final source = _ControlledSource();
    final repository = EventRepository(source);
    final older = repository.load();
    final newer = repository.load();

    source.requests[1].complete([event('Newer CMS content')]);
    await newer;
    source.requests[0].complete([event('Older CMS content')]);
    await older;

    final offline = repository.load();
    source.requests[2].completeError(const CmsException('No connection.'));
    final saved = await offline;

    expect(saved.savedCopy, isTrue);
    expect(saved.events.single.title, 'Newer CMS content');
  });

  test(
    'An older success is still cached when the newer request fails',
    () async {
      final source = _ControlledSource();
      final repository = EventRepository(source);
      final older = repository.load();
      final newer = repository.load();
      final failedNewer = expectLater(newer, throwsA(isA<CmsException>()));
      source.requests[1].completeError(const CmsException('No connection.'));
      await failedNewer;
      source.requests[0].complete([event('Available content')]);
      await older;

      final offline = repository.load();
      source.requests[2].completeError(const CmsException('No connection.'));
      final saved = await offline;

      expect(saved.savedCopy, isTrue);
      expect(saved.events.single.title, 'Available content');
    },
  );
}
