import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:user_profile_isar/model/user.dart';
import 'package:user_profile_isar/providers/provider.dart';
import 'package:user_profile_isar/screen/home_screen.dart';
import 'package:user_profile_isar/screen/onboarding/profile_setup_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isar = ref.watch(isarProvider);

    return MaterialApp(
      title: 'Onboarding App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: FutureBuilder<bool>(
        future: _hasUser(isar),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final hasUser = snapshot.data!;
          return hasUser ? const HomeScreen() : const OnboardingScreen();
        },
      ),
    );
  }

  Future<bool> _hasUser(Isar isar) async {
    final userCount = await isar.users.count();
    return userCount > 0;
  }
}
