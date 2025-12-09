import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint && width < AppConstants.desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.largeDesktopBreakpoint;
  }

  static double getResponsiveValue({required BuildContext context, required double mobile, double? tablet, double? desktop, double? largeDesktop}) {
    if (isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop;
    } else if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  static int getCrossAxisCount(BuildContext context, {int mobile = 1, int tablet = 2, int desktop = 3, int largeDesktop = 4}) {
    if (isLargeDesktop(context)) {
      return largeDesktop;
    } else if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 48);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64, vertical: 64);
    }
  }

  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > AppConstants.maxContentWidth) {
      return AppConstants.maxContentWidth;
    }
    return screenWidth * 0.9;
  }

  static double getWideContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > AppConstants.maxWideContentWidth) {
      return AppConstants.maxWideContentWidth;
    }
    return screenWidth * 0.95;
  }
}
