import 'package:app/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUserProvider =
    FutureProvider<String>((ref) async {
      final authRepoProvider = ref.watch(authRepositoryProvider);
      return await authRepoProvider.user;
    });

