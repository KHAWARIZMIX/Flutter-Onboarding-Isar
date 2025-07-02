import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_profile_isar/utility/image_utils.dart';

/// Riverpod state provider to track avatar upload status
/// Initialized to false (not uploading) by default
final uploadingProvider = StateProvider<bool>((ref) => false);

/// A circular avatar widget with edit functionality that:
/// 1. Displays the current profile image
/// 2. Allows uploading new images from gallery
/// 3. Shows upload progress state
/// 4. Provides user feedback
class UserAvatar extends ConsumerWidget {
  final String profileImage; // Current image path/URL/data
  final Function(String) onAvatarChanged; // Callback when image changes

  const UserAvatar({
    super.key,
    required this.profileImage,
    required this.onAvatarChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Track upload state from provider
    final isUploading = ref.watch(uploadingProvider);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Main avatar display
        CircleAvatar(
          radius: 50,
          // Handle different image types (network, file, asset)
          backgroundImage: getProfileImage(profileImage),
          // Show loading indicator during upload
          child: isUploading ? const CircularProgressIndicator() : null,
        ),
        // Edit button overlay
        FloatingActionButton.small(
          // Disable during upload to prevent multiple requests
          onPressed: isUploading ? null : () => _uploadImage(context, ref),
          child: const Icon(Icons.edit), // Edit/pencil icon
        ),
      ],
    );
  }

  /// Handles the complete image upload flow:
  /// 1. Opens image picker (gallery only)
  /// 2. Sets uploading state
  /// 3. Updates preview immediately with local path
  /// 4. Shows success/error feedback
  /// 5. Resets uploading state
  Future<void> _uploadImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();

    // Launch gallery picker
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // Restrict to gallery only
      maxWidth: 800, // Prevent huge file sizes
      imageQuality: 85, // Balance quality/performance
    );

    if (pickedFile != null) {
      // Start loading state
      ref.read(uploadingProvider.notifier).state = true;

      try {
        // Immediate preview using local path before actual upload
        onAvatarChanged(pickedFile.path);

        // Show success message if widget still mounted
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Show error if upload fails
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading avatar: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        // Always reset loading state
        ref.read(uploadingProvider.notifier).state = false;
      }
    }
  }

  // Future<void> _uploadImage(BuildContext context, WidgetRef ref) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     ref.read(uploadingProvider.notifier).state = true;

  //     try {
  //       final downloadUrl = await _uploadToStorage(pickedFile);
  //       onAvatarChanged(downloadUrl);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Avatar updated successfully')),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Error uploading avatar: $e')));
  //     } finally {
  //       ref.read(uploadingProvider.notifier).state = false;
  //     }
  //   }
  // }

  // Future<String> _uploadToStorage(XFile imageFile) async {
  //   // Implement your actual storage upload logic here
  //   // This is a placeholder for Firebase Storage example:
  //   /*
  //   final ref = FirebaseStorage.instance
  //       .ref()
  //       .child('user_avatars')
  //       .child('user_${DateTime.now().millisecondsSinceEpoch}.jpg');

  //   await ref.putFile(File(imageFile.path));
  //   return await ref.getDownloadURL();
  //   */

  //   // For demo purposes, return a placeholder
  //   return 'assets/default_avatar.png';
  // }
}
