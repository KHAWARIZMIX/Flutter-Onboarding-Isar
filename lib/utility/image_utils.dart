import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

/// Helper method to determine the appropriate ImageProvider based on profile image data
/// Supports multiple image sources:
/// - Asset images
/// - Network images
/// - File paths
/// - Base64 encoded images
ImageProvider getProfileImage(String imageData) {
  // Return default avatar if no image data
  if (imageData.isEmpty) return const AssetImage('assets/default_avatar.png');

  // Handle network images (URLs starting with http)
  if (imageData.startsWith('http')) {
    return NetworkImage(imageData);
  }

  // Handle local file paths
  if (imageData.startsWith('/')) {
    return FileImage(File(imageData));
  }

  // Handle base64 encoded images
  if (imageData.startsWith('data:image')) {
    return MemoryImage(base64Decode(imageData.split(',').last));
  }

  // Default case - treat as asset image
  return AssetImage(imageData);
}
