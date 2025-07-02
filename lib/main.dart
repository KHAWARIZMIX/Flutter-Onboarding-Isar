import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_profile_isar/app.dart';
import 'package:user_profile_isar/model/user.dart';
import 'package:user_profile_isar/providers/provider.dart';

// 1. Ensure this provider is declared somewhere (e.g., `providers.dart`)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([UserSchema], directory: dir.path);
  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MyApp(),
    ),
  );
}
