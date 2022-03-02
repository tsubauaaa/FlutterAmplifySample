import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:app/providers/event_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/DisplayedEvent.dart';

final displayedEventProvider =
    FutureProvider.autoDispose<List<DisplayedEvent>>((ref) async {
  final events = await ref.watch(eventStreamProvider.future);
  String imageUrl =
      'https://i.pinimg.com/originals/01/7c/44/017c44c97a38c1c4999681e28c39271d.png';
  return Future.wait(events.map((e) async {
    if (e.imageKey != null) {
      final result = await Amplify.Storage.getUrl(
        key: e.imageKey!,
        options: GetUrlOptions(accessLevel: StorageAccessLevel.private),
      );
      imageUrl = result.url;
    }
    return DisplayedEvent(
        id: e.id, name: e.name, description: e.description, imageUrl: imageUrl);
  }).toList());
});
