import 'dart:io';

import 'package:ai_interior/bloc/login/login_bloc.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_one.dart';
import 'package:ai_interior/models/Login_model_response.dart';
import 'package:ai_interior/widgets/custom_elevated_button.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../services/device_indentification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────
class StylePreset {
  final String label;
  final List<Color> colors;
  final bool isSelected;

  const StylePreset({
    required this.label,
    required this.colors,
    this.isSelected = false,
  });
}

// ─────────────────────────────────────────────
// Onboarding Screen 2
// ─────────────────────────────────────────────
class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  static const routeName = "/onboarding-screen-two";

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  int _selectedStyle = 0;

  final List<StylePreset> _styles = const [
    StylePreset(
      label: 'Modern',
      colors: [Color(0xFFE8C4B8), Color(0xFFB89AAE), Color(0xFF4A3860)],
    ),
    StylePreset(
      label: 'Retro',
      colors: [
        Color(0xFFF5F5F0),
        Color(0xFF6AAF6A),
        Color(0xFF2E7D2E),
        Color(0xFFE07820),
      ],
    ),
    StylePreset(
      label: 'Neon',
      colors: [
        Color(0xFFE870D0),
        Color(0xFFCC66E8),
        Color(0xFFE8E840),
        Color(0xFF60E060),
      ],
    ),
    StylePreset(
      label: 'Bold',
      colors: [Color(0xFFE83030), Color(0xFFE86820), Color(0xFF2040C8)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      body: Column(
        children: [
          // ── Hero image area ──
          SizedBox(
            height: size.height * 0.595,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.asset(
                  'assets/images/modern_bedroom.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _BedroomPlaceholder(),
                ),

                // Gradient overlay — darkens top slightly for text legibility
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [Color(0x66000000), Colors.transparent],
                    ),
                  ),
                ),

                // "MODERN" large spaced text overlay
                Positioned(
                  top: 64,
                  left: 16,
                  right: 0,
                  child: Text(
                    _styles[_selectedStyle].label.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 20,
                      height: 1,
                    ),
                  ),
                ),

                // Style chips row — bottom of image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: _styles.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedStyle;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedStyle = index),
                          child: _StyleChip(
                            preset: _styles[index],
                            isSelected: isSelected,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Title
                  const Text(
                    'Style It Your Way',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2C2C2C),
                      height: 1.15,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  const Text(
                    'Choose from presets or create a custom design\nwith AI-powered suggestions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7A8080),
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // Page dots — second dot active
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => _PageDot(isActive: i == 1),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Continue button
                  _ContinueButton(onTap: () {}),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Style Chip
// ─────────────────────────────────────────────
class _StyleChip extends StatelessWidget {
  final StylePreset preset;
  final bool isSelected;

  const _StyleChip({required this.preset, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:
            isSelected
                ? const Color(0xFFD9B48C).withOpacity(
                  0.85,
                ) // warm tan when selected
                : Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSelected
                  ? const Color(0xFFD9B48C)
                  : Colors.white.withOpacity(0.4),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color circles
          Row(
            mainAxisSize: MainAxisSize.min,
            children:
                preset.colors.asMap().entries.map((entry) {
                  final i = entry.key;
                  final color = entry.value;
                  return Transform.translate(
                    offset: Offset(i * -6.0, 0),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 6),
          Text(
            preset.label,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isSelected ? const Color(0xFF3C3228) : Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Page Dot
// ─────────────────────────────────────────────
class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF4A5050) : const Color(0xFFCDC9C3),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Continue Button
// ─────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFD9B48C),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3C3228),
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.chevron_right, color: Color(0xFF3C3228), size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bedroom Placeholder Painter
// ─────────────────────────────────────────────
class _BedroomPlaceholder extends StatelessWidget {
  const _BedroomPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BedroomPainter(), child: Container());
  }
}

class _BedroomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ceiling — warm light grey
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.12),
      Paint()..color = const Color(0xFFD8CFC0),
    );

    // Ambient warm glow at ceiling right
    final ceilingGlow =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFE8A050).withOpacity(0.5),
              Colors.transparent,
            ],
            radius: 0.5,
          ).createShader(
            Rect.fromLTWH(
              size.width * 0.6,
              0,
              size.width * 0.4,
              size.height * 0.2,
            ),
          );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.5, 0, size.width * 0.5, size.height * 0.2),
      ceilingGlow,
    );

    // Main wall — warm grey-beige
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.12, size.width, size.height * 0.55),
      Paint()..color = const Color(0xFFCCC4B4),
    );

    // Floor — lighter warm beige
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.67, size.width, size.height * 0.33),
      Paint()..color = const Color(0xFFE0D8C8),
    );

    // Curtains left
    final curtainPaint = Paint()..color = const Color(0xFF8B7355);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.18, size.height * 0.7),
      curtainPaint,
    );

    // Curtains right
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.82, 0, size.width * 0.18, size.height * 0.7),
      curtainPaint,
    );

    // Window — bright white/light blue
    final windowPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFEEEEE8), const Color(0xFFD8D8D0)],
          ).createShader(
            Rect.fromLTWH(
              size.width * 0.28,
              size.height * 0.08,
              size.width * 0.44,
              size.height * 0.52,
            ),
          );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.28,
        size.height * 0.08,
        size.width * 0.44,
        size.height * 0.52,
      ),
      windowPaint,
    );

    // Sheer curtain overlay
    final sheerPaint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.08,
        size.width * 0.36,
        size.height * 0.52,
      ),
      sheerPaint,
    );

    // Headboard
    final headboardPaint = Paint()..color = const Color(0xFFA89880);
    final headboardRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        -size.width * 0.05,
        size.height * 0.38,
        size.width * 1.1,
        size.height * 0.2,
      ),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
    );
    canvas.drawRRect(headboardRect, headboardPaint);

    // Headboard channel stitching lines
    final stitchPaint =
        Paint()
          ..color = const Color(0xFF9A8870)
          ..strokeWidth = 1.5;
    for (int i = 1; i <= 7; i++) {
      final x = -size.width * 0.05 + (size.width * 1.1 / 8) * i;
      canvas.drawLine(
        Offset(x, size.height * 0.39),
        Offset(x, size.height * 0.57),
        stitchPaint,
      );
    }

    // Bed body — duvet
    final duvetPaint = Paint()..color = const Color(0xFFD8C8B0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -size.width * 0.05,
          size.height * 0.55,
          size.width * 1.1,
          size.height * 0.2,
        ),
        const Radius.circular(8),
      ),
      duvetPaint,
    );

    // Duvet folds
    final foldPaint =
        Paint()
          ..color = const Color(0xFFC8B89A)
          ..strokeWidth = 2;
    for (int i = 0; i < 5; i++) {
      final y = size.height * 0.58 + i * size.height * 0.025;
      canvas.drawLine(
        Offset(-size.width * 0.05, y),
        Offset(size.width * 1.05, y),
        foldPaint,
      );
    }

    // Pillows
    final pillowPaint = Paint()..color = const Color(0xFFE8DDD0);
    final pillows = [
      Rect.fromLTWH(
        size.width * 0.04,
        size.height * 0.47,
        size.width * 0.22,
        size.height * 0.1,
      ),
      Rect.fromLTWH(
        size.width * 0.28,
        size.height * 0.47,
        size.width * 0.22,
        size.height * 0.1,
      ),
      Rect.fromLTWH(
        size.width * 0.52,
        size.height * 0.47,
        size.width * 0.22,
        size.height * 0.1,
      ),
      Rect.fromLTWH(
        size.width * 0.76,
        size.height * 0.47,
        size.width * 0.22,
        size.height * 0.1,
      ),
    ];
    for (final rect in pillows) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        pillowPaint,
      );
    }

    // Nightstand left
    final standPaint = Paint()..color = const Color(0xFF9A8060);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          size.height * 0.62,
          size.width * 0.14,
          size.height * 0.1,
        ),
        const Radius.circular(4),
      ),
      standPaint,
    );

    // Lamp glow (left nightstand)
    final lampGlow =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFCB70).withOpacity(0.7),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromLTWH(
              0,
              size.height * 0.5,
              size.width * 0.25,
              size.height * 0.25,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.07, size.height * 0.62),
      size.width * 0.12,
      lampGlow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
