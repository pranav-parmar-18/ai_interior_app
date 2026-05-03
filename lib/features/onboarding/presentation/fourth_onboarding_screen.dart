import 'package:ai_interior/models/create_user_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../../bloc/create_user/create_user_bloc.dart';
import '../../../services/device_indentification_service.dart';
import '../../main/presentaion/main_screen.dart';

class OnboardingFourScreen extends StatefulWidget {
  const OnboardingFourScreen({super.key});

  static const routeName = "/onboarding-four";

  @override
  State<OnboardingFourScreen> createState() => _OnboardingFourScreenState();
}

class _OnboardingFourScreenState extends State<OnboardingFourScreen> {
  final CreateUserBloc _createUserBloc = CreateUserBloc();
  CreateUserModelResponse? createUserModelResponse;
  String? deviceId;

  Future<void> getDeviceId() async {
    deviceId = await DeviceIdManager.getDeviceId();
    print('Persistent Device ID: $deviceId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      body: BlocConsumer<CreateUserBloc, CreateUserState>(
        bloc: _createUserBloc,
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            createUserModelResponse = state.login;
            setUserId(createUserModelResponse?.data?.id.toString() ?? "");
            setIsOnboardingDone();
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
          } else if (state is CreateUserExceptionState ||
              state is CreateUserFailureState) {}
        },

        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.615,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topPadding + 12,
                    left: 16,
                    right: 16,
                  ),
                  child: _ImageGrid(),
                ),
              ),

              // ── Bottom content ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),

                      // Title
                      const Text(
                        'Upgrade Your Vision',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2C2C2C),
                          height: 1.15,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Subtitle with inline auto-renew icon
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7A8080),
                            height: 1.55,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Go beyond the basics — unlimited creations,\nexclusive styles, & more for just \$3.99/week,\n',
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: _AutoRenewIcon(),
                            ),
                            TextSpan(text: ' auto renews, cancel anytime.'),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Continue button
                      _ContinueButton(
                        onTap: () {
                          _createUserBloc.add(
                            CreateUserDataEvent(
                              login: {"uuid": deviceId.toString()},
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> setIsOnboardingDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_onboarding_done', true);
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_id', userId);
  }
}

// ─────────────────────────────────────────────
// Auto-Renew Icon (circular arrows)
// ─────────────────────────────────────────────
class _AutoRenewIcon extends StatelessWidget {
  const _AutoRenewIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF6A8CAA),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Icon(Icons.autorenew_rounded, color: Colors.white, size: 14),
    );
  }
}

// ─────────────────────────────────────────────
// 2×2 Image Grid
// ─────────────────────────────────────────────
class _ImageGrid extends StatelessWidget {
  final CreateUserBloc _createUserBloc = CreateUserBloc();
  CreateUserModelResponse? createUserModelResponse;
  String? deviceId;

  Future<void> getDeviceId() async {
    deviceId = await DeviceIdManager.getDeviceId();
    print('Persistent Device ID: $deviceId');
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_id', userId);
  }

  Future<void> setIsOnboardingDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_onboarding_done', true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateUserBloc, CreateUserState>(
      bloc: _createUserBloc,
      listener: (context, state) {
        if (state is CreateUserSuccessState) {
          createUserModelResponse = state.login;
          setUserId(createUserModelResponse?.data?.id.toString() ?? "");
          setIsOnboardingDone();
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
        } else if (state is CreateUserExceptionState ||
            state is CreateUserFailureState) {}
      },
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns → 2x2 grid
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85, // square cells
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final items = [
              {
                "painter": _LivingRoomPainter(),
                "image": "assets/images/exterior/exterior_1.png",
                "showClose": false,
              },
              {
                "painter": _ModernLivingPainter(),
                "image": "assets/images/interior/interior_2.jpg",
                "showClose": true,
              },
              {
                "painter": _ExteriorPainter(),
                "image": "assets/images/exterior/exterior_3.png",
                "showClose": false, // close button here
              },
              {
                "painter": _GreenBedroomPainter(),
                "image": "assets/images/interior/interior_7.jpg",
                "showClose": false,
              },
            ];

            final item = items[index];

            return Stack(
              children: [
                _GridCell(
                  painter: item["painter"] as CustomPainter,
                  imagePath: item["image"] as String,
                  borderRadius: BorderRadius.circular(16),
                ),

                // Close button (only on one tile)
                if (item["showClose"] == true)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _createUserBloc.add(
                          CreateUserDataEvent(
                            login: {"uuid": deviceId.toString()},
                          ),
                        );
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _GridCell extends StatelessWidget {
  final CustomPainter painter;
  final String imagePath;
  final BorderRadius borderRadius;

  const _GridCell({
    required this.painter,
    required this.imagePath,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox.expand(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => CustomPaint(painter: painter, child: Container()),
        ),
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
    return Container(
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

// ═══════════════════════════════════════════════════════
// PLACEHOLDER PAINTERS — one per grid cell
// ═══════════════════════════════════════════════════════

// ── Cell 1: Warm Living Room (top-left) ──
class _LivingRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Warm cream wall
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFEDE4D8),
    );

    // Floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.65, w, h * 0.35),
      Paint()..color = const Color(0xFFD4C4A8),
    );

    // Rug
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.62, w * 0.9, h * 0.22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFB8B0A0),
    );

    // Sideboard — golden yellow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.1, h * 0.44, w * 0.65, h * 0.22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFB8963C),
    );

    // Large plant (left)
    _drawPlantBlob(
      canvas,
      Offset(w * 0.08, h * 0.62),
      w * 0.12,
      h * 0.35,
      const Color(0xFF4A7030),
    );

    // Golden vase
    canvas.drawOval(
      Rect.fromLTWH(w * 0.08, h * 0.38, w * 0.1, h * 0.1),
      Paint()..color = const Color(0xFFD4A030),
    );

    // Orange armchair
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.32, h * 0.50, w * 0.32, h * 0.22),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFD4601A),
    );
    // Chair back
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.32, h * 0.38, w * 0.32, h * 0.14),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFC05010),
    );

    // Round mirror
    canvas.drawCircle(
      Offset(w * 0.62, h * 0.22),
      w * 0.12,
      Paint()..color = const Color(0xFFD4C090),
    );
    canvas.drawCircle(
      Offset(w * 0.62, h * 0.22),
      w * 0.1,
      Paint()
        ..color = const Color(0xFFCCD4DC)
        ..style = PaintingStyle.fill,
    );

    // Right plants
    _drawPlantBlob(
      canvas,
      Offset(w * 0.85, h * 0.60),
      w * 0.1,
      h * 0.30,
      const Color(0xFF3A6020),
    );

    // White globe lamp
    canvas.drawCircle(
      Offset(w * 0.72, h * 0.46),
      w * 0.07,
      Paint()..color = Colors.white,
    );
  }

  void _drawPlantBlob(
    Canvas canvas,
    Offset base,
    double w,
    double h,
    Color color,
  ) {
    final paint = Paint()..color = color;
    canvas.drawOval(Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h), paint);
    canvas.drawOval(
      Rect.fromLTWH(base.dx - w * 0.7, base.dy - h * 0.7, w * 0.6, h * 0.5),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(base.dx + w * 0.1, base.dy - h * 0.6, w * 0.5, h * 0.4),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Cell 2: Exterior / Garden (top-right) ──
class _ExteriorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky — dusk grey-blue
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.45),
      Paint()..color = const Color(0xFF7888A0),
    );

    // Dark trees silhouette
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.1, w, h * 0.36),
      Paint()..color = const Color(0xFF2A3828),
    );

    // House facade — stone/concrete
    canvas.drawRect(
      Rect.fromLTWH(w * 0.05, h * 0.20, w * 0.9, h * 0.45),
      Paint()..color = const Color(0xFF8A8A7A),
    );

    // Roof overhang
    canvas.drawRect(
      Rect.fromLTWH(w * 0.02, h * 0.18, w * 0.96, h * 0.05),
      Paint()..color = const Color(0xFF3A3A30),
    );

    // Glowing windows
    final glowPaint = Paint()..color = const Color(0xFFE8B840);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.1, h * 0.24, w * 0.35, h * 0.18),
      glowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.55, h * 0.24, w * 0.35, h * 0.18),
      glowPaint,
    );
    // Window glow bloom
    final bloomPaint =
        Paint()
          ..color = const Color(0xFFE8B840).withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.05, h * 0.20, w * 0.9, h * 0.25),
      bloomPaint,
    );

    // Lawn — dark green
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.65, w, h * 0.35),
      Paint()..color = const Color(0xFF2A4A20),
    );

    // Winding stone path
    final pathPaint = Paint()..color = const Color(0xFFD0C8A8);
    final stonePath =
        Path()
          ..moveTo(w * 0.35, h)
          ..quadraticBezierTo(w * 0.2, h * 0.78, w * 0.45, h * 0.70)
          ..quadraticBezierTo(w * 0.65, h * 0.65, w * 0.5, h * 0.60)
          ..lineTo(w * 0.6, h * 0.60)
          ..quadraticBezierTo(w * 0.75, h * 0.65, w * 0.55, h * 0.72)
          ..quadraticBezierTo(w * 0.35, h * 0.80, w * 0.5, h)
          ..close();
    canvas.drawPath(stonePath, pathPaint);

    // Glowing path lights
    final lightPaint =
        Paint()
          ..color = const Color(0xFFE8C050).withOpacity(0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    for (final pos in [
      [0.28, 0.78],
      [0.42, 0.70],
      [0.58, 0.66],
      [0.65, 0.73],
      [0.48, 0.82],
    ]) {
      canvas.drawCircle(Offset(w * pos[0], h * pos[1]), 5, lightPaint);
    }

    // Rounded hedge bushes
    final bushPaint = Paint()..color = const Color(0xFF3A5C28);
    for (final pos in [
      [0.12, 0.68],
      [0.22, 0.70],
      [0.75, 0.68],
      [0.85, 0.70],
    ]) {
      canvas.drawCircle(Offset(w * pos[0], h * pos[1]), w * 0.07, bushPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Cell 3: Modern Dark Living Room (bottom-left) ──
class _ModernLivingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Dark warm brown walls
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF3A3020),
    );

    // Floor — warm beige
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.70, w, h * 0.30),
      Paint()..color = const Color(0xFFB8A888),
    );

    // Large floor-to-ceiling windows left
    final windowPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF4468A0), const Color(0xFF203050)],
          ).createShader(Rect.fromLTWH(0, 0, w * 0.45, h * 0.72));
    canvas.drawRect(Rect.fromLTWH(0, 0, w * 0.45, h * 0.72), windowPaint);
    // Window grid lines
    final gridPaint =
        Paint()
          ..color = const Color(0xFF1A2030)
          ..strokeWidth = 2;
    canvas.drawLine(Offset(w * 0.15, 0), Offset(w * 0.15, h * 0.72), gridPaint);
    canvas.drawLine(Offset(w * 0.30, 0), Offset(w * 0.30, h * 0.72), gridPaint);
    canvas.drawLine(Offset(0, h * 0.24), Offset(w * 0.45, h * 0.24), gridPaint);
    canvas.drawLine(Offset(0, h * 0.48), Offset(w * 0.45, h * 0.48), gridPaint);

    // City skyline silhouette
    final skylinePaint =
        Paint()..color = const Color(0xFF0A1828).withOpacity(0.7);
    final skyPath =
        Path()
          ..moveTo(0, h * 0.45)
          ..lineTo(w * 0.05, h * 0.30)
          ..lineTo(w * 0.08, h * 0.30)
          ..lineTo(w * 0.08, h * 0.22)
          ..lineTo(w * 0.11, h * 0.22)
          ..lineTo(w * 0.11, h * 0.28)
          ..lineTo(w * 0.18, h * 0.15)
          ..lineTo(w * 0.21, h * 0.28)
          ..lineTo(w * 0.25, h * 0.35)
          ..lineTo(w * 0.30, h * 0.20)
          ..lineTo(w * 0.33, h * 0.30)
          ..lineTo(w * 0.38, h * 0.38)
          ..lineTo(w * 0.45, h * 0.45)
          ..lineTo(w * 0.45, h * 0.72)
          ..lineTo(0, h * 0.72)
          ..close();
    canvas.drawPath(skyPath, skylinePaint);

    // Large sectional sofa
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.55, w * 0.82, h * 0.18),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFD0C4A8),
    );
    // Back cushions
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.48, w * 0.82, h * 0.09),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFC0B498),
    );
    // Sofa pillows
    for (final x in [0.15, 0.30, 0.52, 0.68]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * x, h * 0.49, w * 0.12, h * 0.07),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFFB8AC98),
      );
    }

    // Coffee table
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.67, w * 0.50, h * 0.06),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8A7850),
    );

    // Abstract wall art panel (right side)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.52, h * 0.12, w * 0.38, h * 0.32),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF5A4030),
    );

    // Floor lamps
    final lampPaint =
        Paint()
          ..color = const Color(0xFFD4A840)
          ..strokeWidth = 2;
    canvas.drawLine(
      Offset(w * 0.80, h * 0.70),
      Offset(w * 0.80, h * 0.40),
      lampPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.74, h * 0.36, w * 0.12, h * 0.06),
      Paint()..color = const Color(0xFFD4A840),
    );
    // Lamp glow
    canvas.drawCircle(
      Offset(w * 0.80, h * 0.43),
      w * 0.12,
      Paint()
        ..color = const Color(0xFFE8C050).withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Cell 4: Green Bedroom (bottom-right) ──
class _GreenBedroomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sage green wall
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.75),
      Paint()..color = const Color(0xFF6A8060),
    );

    // Floor — light wood
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.75, w, h * 0.25),
      Paint()..color = const Color(0xFFD8C8A8),
    );

    // Right window — sheer curtain light
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w * 0.18, h * 0.75),
      Paint()..color = const Color(0xFFE8E0D0).withOpacity(0.8),
    );
    // Curtain light bloom
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w * 0.30, h * 0.75),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFE8E0D0).withOpacity(0.6),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, 0, w * 0.30, h * 0.75)),
    );

    // Bed headboard — sage green upholstered
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.28, w * 0.90, h * 0.22),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF5A7050),
    );

    // White duvet
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.02, h * 0.46, w * 0.96, h * 0.30),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFF0EDE8),
    );
    // Green throw
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.50, w * 0.70, h * 0.15),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF7A9060).withOpacity(0.85),
    );

    // Pillows
    for (final x in [0.06, 0.30, 0.54, 0.72]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * x, h * 0.38, w * 0.2, h * 0.10),
          const Radius.circular(5),
        ),
        Paint()..color = const Color(0xFFE8E4DC),
      );
    }
    // Green accent pillow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.40, w * 0.14, h * 0.08),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF7A9060),
    );

    // Hanging pendant lights (3 bulbs)
    final cordPaint =
        Paint()
          ..color = const Color(0xFF2A2010)
          ..strokeWidth = 1;
    final bulbPositions = [w * 0.42, w * 0.58, w * 0.74];
    final bulbHeights = [h * 0.18, h * 0.28, h * 0.22];
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(bulbPositions[i], 0),
        Offset(bulbPositions[i], bulbHeights[i]),
        cordPaint,
      );
      // Bulb
      canvas.drawCircle(
        Offset(bulbPositions[i], bulbHeights[i]),
        w * 0.045,
        Paint()..color = const Color(0xFFE8D080),
      );
      // Glow
      canvas.drawCircle(
        Offset(bulbPositions[i], bulbHeights[i]),
        w * 0.10,
        Paint()
          ..color = const Color(0xFFE8D080).withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Art frames on wall
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.08, w * 0.16, h * 0.18),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFF0EDE8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.11, w * 0.14, h * 0.14),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFF0EDE8),
    );
    // Art frame borders
    for (final rect in [
      Rect.fromLTWH(w * 0.25, h * 0.08, w * 0.16, h * 0.18),
      Rect.fromLTWH(w * 0.43, h * 0.11, w * 0.14, h * 0.14),
    ]) {
      canvas.drawRect(
        rect,
        Paint()
          ..color = const Color(0xFF2A2A2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Large plant (left of bed)
    _drawLeafPlant(canvas, Offset(w * 0.88, h * 0.65), w, h);
  }

  void _drawLeafPlant(Canvas canvas, Offset base, double w, double h) {
    final paint = Paint()..color = const Color(0xFF3A6830);
    for (int i = 0; i < 4; i++) {
      final angle = -0.8 + i * 0.5;
      final path =
          Path()
            ..moveTo(base.dx, base.dy)
            ..quadraticBezierTo(
              base.dx + math.cos(angle) * w * 0.2,
              base.dy - h * 0.12,
              base.dx + math.cos(angle) * w * 0.16,
              base.dy - h * 0.22,
            )
            ..quadraticBezierTo(base.dx, base.dy - h * 0.15, base.dx, base.dy)
            ..close();
      canvas.drawPath(path, paint);
    }
    // Pot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(base.dx - w * 0.07, base.dy, w * 0.14, h * 0.06),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2A2A2A),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
