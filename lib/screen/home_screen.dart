import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:user_profile_isar/model/user.dart';
import 'package:user_profile_isar/providers/provider.dart';
import 'package:user_profile_isar/utility/image_utils.dart';

/// Displays the current user's profile information in a centered layout.
/// Automatically updates when user data changes using Isar's reactive stream.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the Isar database instance
    final db = ref.watch(isarProvider);

    return StreamBuilder<List<User>>(
      // Watch for changes in the users collection, triggering immediately
      stream: db.users.where().watch(fireImmediately: true),
      builder: (context, snapshot) {
        // Show loading indicator while initial data is loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message if data loading fails
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Get users list or empty list if null
        final users = snapshot.data ?? [];

        // Show empty state if no users exist
        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        // For demo purposes, use the first user in the list
        final currentUser = users.first;

        return Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile avatar with fallback handling
                CircleAvatar(
                  radius: 50,
                  backgroundImage: getProfileImage(
                    currentUser.profileImage ?? '', // Handle null case
                  ),
                ),
                const SizedBox(height: 16),

                // User name with empty string fallback
                Text('Name: ${currentUser.name ?? ''}'),
                const SizedBox(height: 8),

                // Conditionally show email if available
                if (currentUser.email != null)
                  Text('Email: ${currentUser.email}'),
                const SizedBox(height: 8),

                // Conditionally show bio if available
                if (currentUser.bio != null) Text('Bio: ${currentUser.bio}'),
                const SizedBox(height: 8),

                // Show formatted last updated timestamp if available
                if (currentUser.updatedAt != null)
                  Text(
                    'Last Updated: ${DateFormat('MMM dd, yyyy').format(currentUser.updatedAt!)}',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
