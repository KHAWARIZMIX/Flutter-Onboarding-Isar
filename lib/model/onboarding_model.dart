// Importing the necessary Flutter package
import 'package:flutter/material.dart';

/// Represents a single page/screen in the onboarding flow.
/// Contains all content and styling needed to render an onboarding step.
class OnboardingModel {
  /// The main heading/title for the onboarding page
  final String title;

  /// The supporting subtitle or description text
  final String subTitle;

  /// The main content widget for this onboarding step
  /// Typically contains form fields or interactive elements
  final Widget widget;

  /// Optional custom button widget to override the default navigation button
  /// If null, the default "Next/Continue" button will be used
  final Widget? button;

  /// Custom text styling for the title
  /// If null, default styling will be used:
  /// - fontSize: 24
  /// - fontWeight: bold
  final TextStyle? titleStyle;

  /// Custom text styling for the subtitle  
  /// If null, default styling will be used:
  /// - fontSize: 16
  /// - color: Colors.grey[600]
  final TextStyle? subTitleStyle;

  /// Creates an onboarding page model
  /// 
  /// Required parameters:
  /// - [title]: Main heading text
  /// - [subTitle]: Supporting description text  
  /// - [widget]: Main content area widget
  ///
  /// Optional parameters:
  /// - [button]: Custom navigation button
  /// - [titleStyle]: Custom title text styling
  /// - [subTitleStyle]: Custom subtitle text styling
  OnboardingModel({
    required this.title,
    required this.subTitle,
    required this.widget,
    this.button,
    this.titleStyle,
    this.subTitleStyle,
  });
}