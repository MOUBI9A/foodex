import 'package:flutter/material.dart';

/// Responsive utility class for adaptive sizing across different screen sizes
class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  /// Get screen width
  double get width => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get height => MediaQuery.of(context).size.height;
  
  /// Get responsive width based on percentage (0.0 - 1.0)
  double wp(double percentage) => width * percentage;
  
  /// Get responsive height based on percentage (0.0 - 1.0)
  double hp(double percentage) => height * percentage;
  
  /// Get responsive font size based on screen width
  /// Base size is for 375px width (iPhone SE)
  double sp(double baseSize) => baseSize * (width / 375);
  
  /// Check if device is small (width < 375)
  bool get isSmall => width < 375;
  
  /// Check if device is medium (width >= 375 && width < 768)
  bool get isMedium => width >= 375 && width < 768;
  
  /// Check if device is large (width >= 768 && width < 1024)
  bool get isLarge => width >= 768 && width < 1024;
  
  /// Check if device is extra large (width >= 1024)
  bool get isExtraLarge => width >= 1024;
  
  /// Check if device is tablet
  bool get isTablet => width >= 600;
  
  /// Check if device is desktop
  bool get isDesktop => width >= 1024;
  
  /// Get safe area padding
  EdgeInsets get padding => MediaQuery.of(context).padding;
  
  /// Get bottom safe area (for notch/home indicator)
  double get bottomPadding => padding.bottom;
  
  /// Get top safe area (for status bar/notch)
  double get topPadding => padding.top;
}

/// Extension method for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  Responsive get responsive => Responsive(this);
}
