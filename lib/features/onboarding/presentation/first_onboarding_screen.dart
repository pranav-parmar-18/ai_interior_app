import 'dart:io';

import 'package:ai_interior/bloc/login/login_bloc.dart';
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

class OnBoardingFirstScreen extends StatefulWidget {
  const OnBoardingFirstScreen({super.key});
  static const routeName = "";
  @override
  State<OnBoardingFirstScreen> createState() => _OnBoardingFirstScreenState();
}

class _OnBoardingFirstScreenState extends State<OnBoardingFirstScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      imagePath: 'assets/images/room1.jpg',
      title: 'Effortless Home Redesign',
      subtitle:
      'Upload a photo and let AI redesign your interiors and exteriors effortlessly.',
    ),
    OnboardingData(
      imagePath: 'assets/images/room2.jpg',
      title: 'AI-Powered Design',
      subtitle:
      'Get stunning design suggestions tailored to your style and preferences.',
    ),
    OnboardingData(
      imagePath: 'assets/images/room3.jpg',
      title: 'Transform Any Space',
      subtitle:
      'From living rooms to exteriors, reimagine every corner of your home.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to main app
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use status bar with dark icons (matches screenshot)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      body: Column(
        children: [
          // Image Section — takes up ~60% of screen
          Expanded(
            flex: 60,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return _HeroImage(imagePath: _pages[index].imagePath);
              },
            ),
          ),

          // Bottom Content Section
          Expanded(
            flex: 40,
            child: Container(
              color: const Color(0xFFF5F0EA),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Title
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _pages[_currentPage].title,
                        key: ValueKey(_currentPage),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2C2C2C),
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Subtitle
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _pages[_currentPage].subtitle,
                        key: ValueKey('sub_$_currentPage'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7A8080),
                          height: 1.5,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                            (index) => _PageDot(isActive: index == _currentPage),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Continue Button
                    _ContinueButton(onTap: _onContinue),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero Image Widget
// ─────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  final String imagePath;

  const _HeroImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        // Fallback placeholder when asset is not available
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE8E0D5),
            child: Stack(
              children: [
                // Simulated room scene using gradients/shapes
                Positioned.fill(
                  child: CustomPaint(painter: _RoomPainter()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Room Painter (placeholder background)
// ─────────────────────────────────────────────
class _RoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Wall — light grey
    final wallPaint = Paint()..color = const Color(0xFFEFEDEA);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.72), wallPaint);

    // Floor — warm wood tone
    final floorPaint = Paint()..color = const Color(0xFFD9C4A8);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.72, size.width, size.height * 0.28),
      floorPaint,
    );

    // Floor planks
    final plankPaint = Paint()
      ..color = const Color(0xFFC4AE90)
      ..strokeWidth = 1;
    for (double y = size.height * 0.72; y < size.height; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), plankPaint);
    }

    // Sofa body
    final sofaPaint = Paint()..color = const Color(0xFFB0A898);
    final sofaRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.42, size.height * 0.52, size.width * 0.62, size.height * 0.26),
      const Radius.circular(12),
    );
    canvas.drawRRect(sofaRect, sofaPaint);

    // Sofa back cushion
    final cushionPaint = Paint()..color = const Color(0xFF9A9088);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.44, size.height * 0.45, size.width * 0.58, size.height * 0.12),
        const Radius.circular(8),
      ),
      cushionPaint,
    );

    // Throw blanket
    final throwPaint = Paint()..color = const Color(0xFFD9C9B2);
    final throwPath = Path()
      ..moveTo(size.width * 0.42, size.height * 0.56)
      ..lineTo(size.width * 0.75, size.height * 0.50)
      ..lineTo(size.width * 0.78, size.height * 0.72)
      ..lineTo(size.width * 0.42, size.height * 0.72)
      ..close();
    canvas.drawPath(throwPath, throwPaint);

    // Small side table
    final tablePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(
      Offset(size.width * 0.38, size.height * 0.68),
      size.width * 0.07,
      tablePaint,
    );
    // Table legs
    final legPaint = Paint()
      ..color = const Color(0xFFD4A96A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.34, size.height * 0.68),
      Offset(size.width * 0.31, size.height * 0.76),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.68),
      Offset(size.width * 0.45, size.height * 0.76),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.38, size.height * 0.68),
      Offset(size.width * 0.38, size.height * 0.76),
      legPaint,
    );

    // Small plant pot on table (gold)
    final potPaint = Paint()..color = const Color(0xFFD4A96A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.35, size.height * 0.61, size.width * 0.06, size.height * 0.07),
        const Radius.circular(4),
      ),
      potPaint,
    );

    // Large plant (left side)
    final stemPaint = Paint()
      ..color = const Color(0xFF4A6741)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.72),
      Offset(size.width * 0.12, size.height * 0.2),
      stemPaint,
    );

    // Large leaves
    final leafPaint = Paint()..color = const Color(0xFF5A8050);
    _drawLeaf(canvas, leafPaint, Offset(size.width * 0.12, size.height * 0.22),
        size.width * 0.18, -0.4);
    _drawLeaf(canvas, leafPaint, Offset(size.width * 0.12, size.height * 0.3),
        size.width * 0.16, 0.5);
    _drawLeaf(canvas, leafPaint, Offset(size.width * 0.12, size.height * 0.38),
        size.width * 0.15, -0.3);

    // Plant pot (large, black/white)
    final largePotPaint = Paint()..color = const Color(0xFF2C2C2C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.06, size.height * 0.67, size.width * 0.12, size.height * 0.08),
        const Radius.circular(6),
      ),
      largePotPaint,
    );
    // white band
    final bandPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.06, size.height * 0.67, size.width * 0.12, size.height * 0.025),
      bandPaint,
    );
  }

  void _drawLeaf(Canvas canvas, Paint paint, Offset start, double length, double angle) {
    final path = Path();
    final endX = start.dx + length * (-0.6 + angle);
    final endY = start.dy - length * 0.3;
    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(
      start.dx + length * 0.3,
      start.dy - length * 0.5,
      endX,
      endY,
    );
    path.quadraticBezierTo(
      start.dx + length * 0.1,
      start.dy - length * 0.2,
      start.dx,
      start.dy,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// Page Dot Indicator
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
        color: isActive
            ? const Color(0xFF4A5050) // dark filled — active (pentagon-like in screenshot)
            : const Color(0xFFCDC9C3), // light grey — inactive
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
          color: const Color(0xFFD9B48C), // warm tan/sand
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Continue',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3C3228),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_right,
                color: Color(0xFF3C3228),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────
class OnboardingData {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}
