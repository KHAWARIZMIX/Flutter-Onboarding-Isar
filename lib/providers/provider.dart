// Providers
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:user_profile_isar/notfiers/onboarding_notifier.dart';

/// Provides access to the Isar database instance throughout the app.
/// 
/// This provider must be overridden at the app's root level with a valid Isar instance.
/// Throws [UnimplementedError] if used without being overridden.
///
/// Usage:
/// ```dart
/// void main() {
///   final isar = await openIsar();
///   runApp(
///     ProviderScope(
///       overrides: [
///         isarProvider.overrideWithValue(isar),
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

/// Manages the onboarding process state and business logic.
/// 
/// Combines:
/// - Access to Isar database (via [isarProvider])
/// - Onboarding state management
/// - Validation and persistence logic
///
/// Usage:
/// ```dart
/// final onboardingState = ref.watch(onboardingProvider);
/// final onboardingNotifier = ref.read(onboardingProvider.notifier);
/// ```
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(ref.read(isarProvider)),
);



/// Represents the immutable state of the onboarding process.
/// Stores all user-provided data and tracks current onboarding progress.
class OnboardingState {
  /// User's full name (empty string if not provided yet)
  final String name;

  /// User's email address (empty string if not provided yet)
  final String email;

  /// User's biography/description (empty string if not provided yet)
  final String bio;

  /// URL or path to the user's profile image 
  /// (empty string if no image selected yet)
  final String profileImage;

  /// Current page index in the onboarding flow (0-based)
  /// Tracks which step the user is currently on
  final int currentPage;

  /// Creates an onboarding state with default empty values
  const OnboardingState({
    this.name = '',
    this.email = '',
    this.bio = '',
    this.profileImage = '',
    this.currentPage = 0,
  });

  /// Creates a new state by copying the current state and updating
  /// only the specified properties (null values will keep current values)
  /// 
  /// This immutable update pattern enables:
  /// 1. Predictable state management
  /// 2. Easy change tracking
  /// 3. Efficient widget rebuilds
  OnboardingState copyWith({
    String? name,
    String? email,
    String? bio,
    String? profileImage,
    int? currentPage,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  /// Optionally add equality comparison and toString() for debugging:
  /// @override
  /// bool operator ==(Object other) => ...
  /// 
  /// @override 
  /// int get hashCode => ...
  /// 
  /// @override
  /// String toString() => ...
}