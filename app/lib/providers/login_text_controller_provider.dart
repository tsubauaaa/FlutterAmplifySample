import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameControllerProvider = StateProvider.autoDispose((ref) => TextEditingController(text: ''));
final passwordControllerProvider = StateProvider.autoDispose((ref) => TextEditingController(text: ''));