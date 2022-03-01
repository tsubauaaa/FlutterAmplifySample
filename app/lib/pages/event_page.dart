import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app/models/Event.dart';
import 'package:app/providers/auth_user_provider.dart';
import 'package:app/providers/auth_repository_provider.dart';
import 'package:app/providers/event_stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventPage extends ConsumerWidget {
  const EventPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepoProvider = ref.read(authRepositoryProvider);
    final items = ref.watch(eventStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.lock_open),
            onPressed: () async {
              await authRepoProvider.logOut();
              ref.refresh(authUserProvider);
            },
          ),
        ],
      ),
      body: items.when(
        data: (data) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Amplify.DataStore.delete(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Text(item.name),
                            Text(item.description ?? 'No description'),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        error: (error, stack) => Text(
          error.toString(),
        ),
        loading: () => const CircularProgressIndicator(),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await Amplify.DataStore.save(
              Event(name: "イベント名2", description: "イベント情報2"));
        },
        child: const Text('イベント追加'),
      ),
    );
  }
}
