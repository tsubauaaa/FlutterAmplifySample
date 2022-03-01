import 'package:app/providers/auth_user_provider.dart';
import 'package:app/providers/auth_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventPage extends ConsumerWidget {
  const EventPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepoProvider = ref.read(authRepositoryProvider);
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
      body: const Center(
        child: Text('Event Page'),
      ),
    );
  }
}
