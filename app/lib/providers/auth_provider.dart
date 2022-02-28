import 'package:app/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider =
    FutureProvider<String>((ref) async {
      final authRepo = ref.watch(authRepositoryProvider);
      return await authRepo.user;
    });

