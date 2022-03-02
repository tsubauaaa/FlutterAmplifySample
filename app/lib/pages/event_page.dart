import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:app/models/Event.dart';
import 'package:app/providers/auth_user_provider.dart';
import 'package:app/providers/auth_repository_provider.dart';
import 'package:app/providers/displayed_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EventPage extends ConsumerWidget {
  const EventPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);
    final displayedEvents = ref.watch(displayedEventProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.lock_open),
            onPressed: () async {
              await authRepo.logOut();
              ref.refresh(authUserProvider);
              Amplify.DataStore.clear();
            },
          ),
        ],
      ),
      body: displayedEvents.when(
        data: (data) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.map(
              (event) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Amplify.DataStore.delete(
                          Event(id: event.id, name: event.name));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            event.imageUrl!,
                            width: 80,
                          ),
                          Column(
                            children: [
                              Text(event.name),
                              Text(event.description ?? 'No description'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
        error: (error, stack) => Text(
          error.toString(),
        ),
        loading: () => const CircularProgressIndicator(),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? imageFile =
              await _picker.pickImage(source: ImageSource.gallery);
          if (imageFile != null) {
            final result = await Amplify.Storage.uploadFile(
                key: imageFile.name,
                local: File(imageFile.path),
                options:
                    UploadFileOptions(accessLevel: StorageAccessLevel.private));
            final Event event = Event(
              name: 'New Event',
              description: 'New Description',
              imageKey: result.key,
            );
            await Amplify.DataStore.save(event);
            return;
          }
          await Amplify.DataStore.save(
              Event(name: "イベント名2", description: "イベント情報2"));
        },
        child: const Text('イベント追加'),
      ),
    );
  }
}
