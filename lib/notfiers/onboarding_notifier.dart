//Notifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:user_profile_isar/model/user.dart';
import 'package:user_profile_isar/providers/provider.dart';

/// Manages the state and business logic for the user onboarding process.
/// Handles form data updates, navigation between pages, and profile persistence
/// using Isar database for local storage.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Isar isar; // Isar database instance for local storage

  /// Initializes the notifier with an Isar database instance
  /// and sets the initial onboarding state.
  OnboardingNotifier(this.isar) : super(OnboardingState());

  /// Updates the user's name in the onboarding state
  /// [name] - The new name value to store
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  /// Updates the profile image path/URL in the onboarding state
  /// [imageUrl] - The new image path/URL (can be local path or network URL)
  Future<void> updateProfileImage(String imageUrl) async {
    state = state.copyWith(profileImage: imageUrl);
  }

  /// Updates the user's email in the onboarding state
  /// [email] - The new email value to store
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  /// Updates the user's biography in the onboarding state
  /// [bio] - The new biography text to store
  void updateBio(String bio) {
    state = state.copyWith(bio: bio);
  }

  /// Advances to the next onboarding page by incrementing currentPage
  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  /// Returns to the previous onboarding page by decrementing currentPage
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  /// Jumps to a specific onboarding page
  /// [currentPage] - The target page index (0-based)
  void updateCurrentPage(int currentPage) {
    if (currentPage >= 0) {
      state = state.copyWith(currentPage: currentPage);
    }
  }

  /// Persists the complete user profile to Isar database
  /// Creates a new User object with all current state values
  /// and stores it in a transaction to ensure data consistency
  Future<void> saveProfile() async {
    final user = User()
      ..name = state.name
      ..email = state.email
      ..bio = state.bio
      ..profileImage = state.profileImage
      ..updatedAt = DateTime.now(); // Set current timestamp

    // Use Isar transaction for safe write operation
    await isar.writeTxn(() async {
      await isar.users.put(user); // Upsert operation
    });
  }
}