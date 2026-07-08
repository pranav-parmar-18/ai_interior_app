import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

/// Centralized responsive utility for the entire app.
///
/// Reference design: 375 × 812 (iPhone 13 mini / standard phone).
/// All `wp`, `hp`, and `sp` methods scale proportionally from this base.
class ResponsiveUtils {
  ResponsiveUtils._();

  // ── Design reference ──────────────────────────────────────────────────
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  // ── Device-type helpers ───────────────────────────────────────────────

  /// True when the device's shortest side ≥ 600 (tablets / iPads).
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  /// True when the device's shortest side < 600 (phones).
  static bool isMobile(BuildContext context) {
    return !isTablet(context);
  }

  /// True for iOS devices only.
  static bool isIOS(BuildContext context) => Platform.isIOS;

  /// True for iPads specifically.
  static bool isIPad(BuildContext context) {
    return Platform.isIOS && isTablet(context);
  }

  /// True when landscape orientation is active.
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// True for small phones (width ≤ 360 in portrait).
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width <= 360 && isMobile(context);
  }

  // ── Screen dimensions ─────────────────────────────────────────────────

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double safeAreaTop(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double safeAreaBottom(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  // ── Proportional scaling ──────────────────────────────────────────────

  /// Width-proportional value.
  /// `wp(context, 20)` → 20 on a 375-wide screen, scales up/down on others.
  static double wp(BuildContext context, double value) {
    return value * screenWidth(context) / _designWidth;
  }

  /// Height-proportional value.
  /// `hp(context, 20)` → 20 on an 812-high screen, scales up/down on others.
  static double hp(BuildContext context, double value) {
    return value * screenHeight(context) / _designHeight;
  }

  /// Scaled font size — uses width-proportion but clamps to avoid
  /// excessively large text on tablets.
  static double sp(BuildContext context, double fontSize) {
    final scale = screenWidth(context) / _designWidth;
    // On tablets, dampen the scale to avoid oversized text
    final dampened = isTablet(context) ? 1.0 + (scale - 1.0) * 0.5 : scale;
    return fontSize * dampened;
  }

  // ── Adaptive values ───────────────────────────────────────────────────

  /// Returns [mobile] on phones and [tablet] on tablets.
  static double adaptiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
  }) {
    return isTablet(context) ? tablet : mobile;
  }

  /// Returns [mobile] on phones, [tablet] on tablets, and optionally
  /// a different value for [landscape] mode.
  static double adaptiveValueFull(
    BuildContext context, {
    required double mobile,
    required double tablet,
    double? landscape,
  }) {
    if (landscape != null && isLandscape(context)) return landscape;
    return isTablet(context) ? tablet : mobile;
  }

  /// Returns different int values based on device type.
  static int adaptiveInt(
    BuildContext context, {
    required int mobile,
    required int tablet,
  }) {
    return isTablet(context) ? tablet : mobile;
  }

  // ── Responsive padding / margins ──────────────────────────────────────

  /// Standard horizontal padding: 20 on phones, 40 on tablets.
  static EdgeInsets horizontalPadding(BuildContext context) {
    final h = adaptiveValue(context, mobile: 20, tablet: 40);
    return EdgeInsets.symmetric(horizontal: h);
  }

  /// Screen-edge padding with safe areas included.
  static EdgeInsets screenPadding(BuildContext context) {
    final h = adaptiveValue(context, mobile: 20, tablet: 40);
    return EdgeInsets.fromLTRB(
      h,
      safeAreaTop(context) + 8,
      h,
      safeAreaBottom(context) + 8,
    );
  }

  /// Responsive symmetric padding.
  static EdgeInsets symmetricPadding(
    BuildContext context, {
    required double horizontalMobile,
    required double horizontalTablet,
    double verticalMobile = 0,
    double verticalTablet = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: adaptiveValue(
        context,
        mobile: horizontalMobile,
        tablet: horizontalTablet,
      ),
      vertical: adaptiveValue(
        context,
        mobile: verticalMobile,
        tablet: verticalTablet,
      ),
    );
  }

  // ── Grid helpers ──────────────────────────────────────────────────────

  /// Grid cross-axis count: 2 on phones, 3 on tablets (landscape gets +1).
  static int gridColumns(BuildContext context) {
    if (isTablet(context)) {
      return isLandscape(context) ? 4 : 3;
    }
    return isLandscape(context) ? 3 : 2;
  }

  /// Grid child aspect ratio, adjusted for device.
  static double gridAspectRatio(
    BuildContext context, {
    double mobile = 0.75,
    double tablet = 0.8,
  }) {
    return isTablet(context) ? tablet : mobile;
  }

  // ── Spacing helpers ───────────────────────────────────────────────────

  /// Vertical spacing that scales proportionally.
  static SizedBox verticalSpace(BuildContext context, double height) {
    return SizedBox(height: hp(context, height));
  }

  /// Horizontal spacing that scales proportionally.
  static SizedBox horizontalSpace(BuildContext context, double width) {
    return SizedBox(width: wp(context, width));
  }

  // ── Icon size helper ──────────────────────────────────────────────────

  /// Responsive icon size.
  static double iconSize(
    BuildContext context, {
    double mobile = 24,
    double tablet = 32,
  }) {
    return adaptiveValue(context, mobile: mobile, tablet: tablet);
  }

  // ── Border radius helper ──────────────────────────────────────────────

  /// Responsive border radius.
  static double radius(BuildContext context, double value) {
    return wp(context, value);
  }

  // ── Clamped height helper ──────────────────────────────────────────────

  /// Returns a height that is a percentage of screen height, clamped
  /// between [minHeight] and [maxHeight].
  static double clampedHeight(
    BuildContext context, {
    required double percent,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) {
    final h = screenHeight(context) * percent / 100;
    return h.clamp(minHeight, maxHeight);
  }

  /// Returns a width that is a percentage of screen width, clamped.
  static double clampedWidth(
    BuildContext context, {
    required double percent,
    double minWidth = 0,
    double maxWidth = double.infinity,
  }) {
    final w = screenWidth(context) * percent / 100;
    return w.clamp(minWidth, maxWidth);
  }
}

/// Global helper class to allow the shortcut `r.` syntax for responsive utilities.
class _R {
  const _R();

  bool isTablet(BuildContext context) => ResponsiveUtils.isTablet(context);
  bool isMobile(BuildContext context) => ResponsiveUtils.isMobile(context);
  bool isIOS(BuildContext context) => ResponsiveUtils.isIOS(context);
  bool isIPad(BuildContext context) => ResponsiveUtils.isIPad(context);
  bool isLandscape(BuildContext context) => ResponsiveUtils.isLandscape(context);
  bool isSmallPhone(BuildContext context) => ResponsiveUtils.isSmallPhone(context);

  double screenWidth(BuildContext context) => ResponsiveUtils.screenWidth(context);
  double screenHeight(BuildContext context) => ResponsiveUtils.screenHeight(context);
  double safeAreaTop(BuildContext context) => ResponsiveUtils.safeAreaTop(context);
  double safeAreaBottom(BuildContext context) => ResponsiveUtils.safeAreaBottom(context);

  double wp(BuildContext context, double value) => ResponsiveUtils.wp(context, value);
  double hp(BuildContext context, double value) => ResponsiveUtils.hp(context, value);
  double sp(BuildContext context, double fontSize) => ResponsiveUtils.sp(context, fontSize);

  double adaptiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
  }) => ResponsiveUtils.adaptiveValue(context, mobile: mobile, tablet: tablet);

  double adaptiveValueFull(
    BuildContext context, {
    required double mobile,
    required double tablet,
    double? landscape,
  }) => ResponsiveUtils.adaptiveValueFull(context, mobile: mobile, tablet: tablet, landscape: landscape);

  int adaptiveInt(
    BuildContext context, {
    required int mobile,
    required int tablet,
  }) => ResponsiveUtils.adaptiveInt(context, mobile: mobile, tablet: tablet);

  EdgeInsets horizontalPadding(BuildContext context) => ResponsiveUtils.horizontalPadding(context);
  EdgeInsets screenPadding(BuildContext context) => ResponsiveUtils.screenPadding(context);
  EdgeInsets symmetricPadding(
    BuildContext context, {
    required double horizontalMobile,
    required double horizontalTablet,
    double verticalMobile = 0,
    double verticalTablet = 0,
  }) => ResponsiveUtils.symmetricPadding(
    context,
    horizontalMobile: horizontalMobile,
    horizontalTablet: horizontalTablet,
    verticalMobile: verticalMobile,
    verticalTablet: verticalTablet,
  );

  int gridColumns(BuildContext context) => ResponsiveUtils.gridColumns(context);
  double gridAspectRatio(
    BuildContext context, {
    double mobile = 0.75,
    double tablet = 0.8,
  }) => ResponsiveUtils.gridAspectRatio(context, mobile: mobile, tablet: tablet);

  SizedBox verticalSpace(BuildContext context, double height) => ResponsiveUtils.verticalSpace(context, height);
  SizedBox horizontalSpace(BuildContext context, double width) => ResponsiveUtils.horizontalSpace(context, width);

  double iconSize(
    BuildContext context, {
    double mobile = 24,
    double tablet = 32,
  }) => ResponsiveUtils.iconSize(context, mobile: mobile, tablet: tablet);

  double radius(BuildContext context, double value) => ResponsiveUtils.radius(context, value);

  double clampedHeight(
    BuildContext context, {
    required double percent,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) => ResponsiveUtils.clampedHeight(context, percent: percent, minHeight: minHeight, maxHeight: maxHeight);

  double clampedWidth(
    BuildContext context, {
    required double percent,
    double minWidth = 0,
    double maxWidth = double.infinity,
  }) => ResponsiveUtils.clampedWidth(context, percent: percent, minWidth: minWidth, maxWidth: maxWidth);
}

const r = _R();

extension StringCasingExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
