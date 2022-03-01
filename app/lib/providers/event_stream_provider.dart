import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Event.dart';

final eventStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  Stream<QuerySnapshot<Event>> stream =
      Amplify.DataStore.observeQuery(Event.classType);
  debugPrint('stream: $stream');
  return stream.map(((snapshot) => snapshot.items));
});
