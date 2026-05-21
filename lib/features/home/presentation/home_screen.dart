import 'package:ai_interior/bloc/create_user/create_user_bloc.dart';
import 'package:ai_interior/features/style_transfer/presentation/style_transfer_screeen.dart';
import 'package:ai_interior/models/create_user_model_response.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../../services/device_indentification_service.dart';
import '../../credit/presentataion/credit_screen.dart';
import '../../dream/presentation/dream_screen.dart';
import '../../exterior/presentation/exterior_screen.dart';
import '../../interior/presentation/interior_screen.dart';
import '../../main/presentaion/main_screen.dart';
import '../../replace/presentation/replace_screen.dart';
import '../../setting/presentation/setting_screens.dart';
import '../../staging/presentation/staging_screen.dart';

final ValueNotifier<String> creditsNotifier = ValueNotifier<String>("0");

class FeatureItem {
  final String title;
  final String subtitle;
  final String icon;
  CustomPainter? imagePainter;
  final String imagePath;

  FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.imagePainter,
    required this.imagePath,
  });
}

// ─────────────────────────────────────────────
// Home Screen
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "/home-screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    getDeviceId().then((value) {
      _createUserBloc.add(
        CreateUserDataEvent(login: {"uuid": deviceId.toString()}),
      );
    });
  }

  Future<void> setCredits(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('credits', userId);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final features = [
      FeatureItem(
        title: 'Revamp Your Interior',
        subtitle: 'Transform your space with a fresh design',
        icon: "assets/images/home_icon_1.png",
        imagePath: "assets/images/home_0.png",
      ),
      FeatureItem(
        title: 'Redesign Your Exterior',
        subtitle: 'Transform your outdoor space',
        icon: "assets/images/home_icon_2.png",
        imagePath: "assets/images/home_3.png",
      ),
      FeatureItem(
        title: 'Style Transfer',
        subtitle: 'Apply a style from any reference image',
        icon: "assets/images/home_icon_3.png",
        imagePath: "assets/images/home_6.png",
      ),
      FeatureItem(
        title: 'Smart Staging',
        subtitle: 'Effortlessly furnish and style your room',
        icon: "assets/images/home_icon_4.png",
        imagePath: "assets/images/home_9.png",
      ),
      FeatureItem(
        title: 'Replace',
        subtitle: 'Replace any part of your space with ease',
        icon: "assets/images/home_icon_5.png",
        imagePath: "assets/images/home_8.png",
      ),
      FeatureItem(
        title: 'Design Your Dream Space',
        subtitle: 'Build your ideal space from scratch',
        icon: "assets/images/home_icon_6.png",
        imagePath: "assets/images/home_2.png",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      appBar: TopBarAppBar(),
      body: BlocConsumer<CreateUserBloc, CreateUserState>(
        bloc: _createUserBloc,
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            createUserModelResponse = state.login;
            setCredits(createUserModelResponse?.credits.toString() ?? "");
            creditsNotifier.value =
                createUserModelResponse?.credits.toString() ?? "";
          } else if (state is CreateUserExceptionState ||
              state is CreateUserExceptionState) {}
        },
        builder: (context, state) {
          return Column(
            children: [
              // ── Main scrollable content ──
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Top App Bar
                    // SliverToBoxAdapter(child: ()),

                    // Feature cards list
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _FeatureCard(item: features[index], index: index),
                        childCount: features.length,
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  ],
                ),
              ),

              // ── Bottom Navigation Bar ──
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────
class TopBarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBarAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    final titleFontSize = r.sp(context, 30);
    final creditsFontSize = r.sp(context, 16);
    final iconSize = r.adaptiveValue(context, mobile: 25, tablet: 35);
    final badgePaddingH = r.wp(context, 10);
    final badgePaddingV = r.hp(context, 5);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: r.wp(context, 16),
      title: Text(
        'AI Interior Design',
        style: TextStyle(
          fontSize: titleFontSize,
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(135, 63, 0, 1),
          letterSpacing: -0.2,
        ),
      ),
      actions: [
        // Coin balance
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(CreditsScreen.routeName);
          },
          child: Container(
            margin: EdgeInsets.only(right: r.wp(context, 8)),
            padding: EdgeInsets.symmetric(
              horizontal: badgePaddingH,
              vertical: badgePaddingV,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(r.wp(context, 20)),
              border: Border.all(
                color: const Color(0xFFE8873A).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: creditsNotifier,
                  builder: (context, credits, _) {
                    return Text(
                      creditsNotifier.value.toString(),
                      style: TextStyle(
                        fontSize: creditsFontSize,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.2,
                      ),
                    );
                  },
                ),
                SizedBox(width: r.wp(context, 4)),
                CustomImageview(
                  imagePath: "assets/images/credit.png",
                  height: iconSize,
                  width: iconSize,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),

        // Settings icon
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(SettingsScreen.routeName);
          },
          child: Padding(
            padding: EdgeInsets.only(right: r.wp(context, 16)),
            child: CustomImageview(
              imagePath: "assets/images/setting.png",
              height: iconSize,
              width: iconSize,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Feature Card
// ─────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final FeatureItem item;
  final int index;

  const _FeatureCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final hPadding = r.wp(context, 14);
    final vPadding = r.hp(context, 6);
    final imageHeight = r.clampedHeight(
      context,
      percent: 37,
      minHeight: 200,
      maxHeight: 450,
    );
    final borderRadius = r.wp(context, 18);
    final iconSize = r.adaptiveValue(context, mobile: 45, tablet: 60);
    final titleFontSize = r.sp(context, 18);
    final subtitleFontSize = r.sp(context, 16);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: Column(
        children: [
          // Image area
          GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.of(context).pushNamed(InteriorDesignScreen.routeName);
              }
              if (index == 1) {
                Navigator.of(context).pushNamed(ExteriorDesignScreen.routeName);
              }
              if (index == 2) {
                Navigator.of(context).pushNamed(StyleTransferScreen.routeName);
              }
              if (index == 3) {
                Navigator.of(context).pushNamed(StagingDesignScreen.routeName);
              }
              if (index == 4) {
                Navigator.of(context).pushNamed(ReplaceScreen.routeName);
              }
              if (index == 5) {
                Navigator.of(context).pushNamed(DreamSpaceScreen.routeName);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [CustomImageview(imagePath: item.imagePath)],
                ),
              ),
            ),
          ),

          // Label row
          Padding(
            padding: EdgeInsets.only(
              top: r.hp(context, 10),
              bottom: r.hp(context, 4),
              left: r.wp(context, 2),
              right: r.wp(context, 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                CustomImageview(
                  imagePath: item.icon,
                  height: iconSize,
                  width: iconSize,
                ),
                SizedBox(width: r.wp(context, 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(46, 46, 46, 1),
                        ),
                      ),
                      SizedBox(height: r.hp(context, 2)),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontFamily: 'Lato',
                          color: Color.fromRGBO(46, 46, 46, 1),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Overlays
// ─────────────────────────────────────────────

// Style swatch overlay (style transfer card)
class _StyleSwatchOverlay extends StatelessWidget {
  const _StyleSwatchOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Swatch(color: const Color(0xFF2A2A2A)),
            const SizedBox(width: 6),
            _Swatch(color: const Color(0xFF8A7A60)),
            const SizedBox(width: 6),
            _Swatch(color: const Color(0xFF3A8A8A), selected: true),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final bool selected;

  const _Swatch({required this.color, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: selected ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow:
            selected
                ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)]
                : null,
      ),
    );
  }
}

// Before / After overlay (smart staging)
class _BeforeAfterOverlay extends StatelessWidget {
  const _BeforeAfterOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Before label top-left
        Positioned(top: 12, left: 14, child: _Label(text: 'Before')),
        // After label bottom-right
        Positioned(bottom: 12, right: 14, child: _Label(text: 'After')),
        // Divider line
        Center(child: Container(width: 2, color: Colors.white)),
      ],
    );
  }
}

// Replace prompt overlay
class _ReplacePromptOverlay extends StatelessWidget {
  const _ReplacePromptOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 14,
      left: 14,
      right: 14,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A5A).withOpacity(0.82),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Text(
              'Replace',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF60C8E8),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'bed with armchair & chandelier with light',
                style: TextStyle(fontSize: 13, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Imagine prompt overlay (dream space)
class _ImaginePromptOverlay extends StatelessWidget {
  const _ImaginePromptOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 14,
      left: 14,
      right: 14,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFD4A840).withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Text(
              'Imagine',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFD4A840),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'A futuristic mansion with dark aesthetics',
                style: TextStyle(fontSize: 13, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C2C),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Navigation Bar
// ─────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F4),
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.15))),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPad, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NavItem(icon: Icons.home_rounded, label: 'Home', isActive: true),
            _NavItem(icon: Icons.auto_awesome_outlined, label: 'Explore'),
            _NavItem(icon: Icons.history_rounded, label: 'Recents'),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF2C2C2C) : const Color(0xFFAAAAAA);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
// IMAGE PAINTERS — one per feature card
// ═══════════════════════════════════════════════════════

// ── 1. Interior Revamp ──
class _InteriorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Warm cream wall
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFEDE4D8),
    );

    // Ceiling light glow
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.08),
      Paint()..color = const Color(0xFFD8C8A8),
    );

    // Large window left — natural light
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.04, w * 0.28, h * 0.70),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [const Color(0xFFD8E8F0), const Color(0xFFECE4D8)],
        ).createShader(Rect.fromLTWH(0, 0, w * 0.28, h)),
    );

    // Bookshelf right
    canvas.drawRect(
      Rect.fromLTWH(w * 0.78, 0, w * 0.22, h),
      Paint()..color = const Color(0xFF8A6840),
    );
    // Shelf planks
    for (int i = 1; i <= 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.78, h * 0.22 * i, w * 0.22, h * 0.025),
        Paint()..color = const Color(0xFF6A5030),
      );
    }
    // Books
    final bookColors = [
      const Color(0xFFD4A060),
      const Color(0xFF8A9870),
      const Color(0xFF6A8098),
      const Color(0xFFB86040),
      const Color(0xFFD0B880),
      const Color(0xFF7A6A90),
    ];
    for (int shelf = 0; shelf < 4; shelf++) {
      double x = w * 0.80;
      for (int b = 0; b < 4; b++) {
        final bw = w * 0.03 + (b % 2) * w * 0.01;
        canvas.drawRect(
          Rect.fromLTWH(x, h * 0.22 * shelf + h * 0.025, bw, h * 0.18),
          Paint()..color = bookColors[(shelf * 4 + b) % bookColors.length],
        );
        x += bw + 1;
      }
    }

    // Floor — warm light wood
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.74, w, h * 0.26),
      Paint()..color = const Color(0xFFD0B890),
    );
    // Floor grain lines
    final grainPaint =
        Paint()
          ..color = const Color(0xFFC0A880)
          ..strokeWidth = 1;
    for (double y = h * 0.76; y < h; y += 14) {
      canvas.drawLine(Offset(0, y), Offset(w, y), grainPaint);
    }

    // Large cream sectional sofa
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.52, w * 0.62, h * 0.24),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFE8DDD0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.44, w * 0.62, h * 0.10),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFDDD2C4),
    );
    // L-shaped extension
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.62, h * 0.52, w * 0.15, h * 0.20),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFE0D5C8),
    );

    // Coffee table — dark walnut round
    canvas.drawOval(
      Rect.fromLTWH(w * 0.28, h * 0.68, w * 0.22, w * 0.10),
      Paint()..color = const Color(0xFF6A4820),
    );

    // Small side table
    canvas.drawOval(
      Rect.fromLTWH(w * 0.06, h * 0.66, w * 0.10, w * 0.06),
      Paint()..color = const Color(0xFF4A3010),
    );

    // Floor lamp
    final lampPaint =
        Paint()
          ..color = const Color(0xFFD4B060)
          ..strokeWidth = 2;
    canvas.drawLine(
      Offset(w * 0.10, h * 0.74),
      Offset(w * 0.10, h * 0.30),
      lampPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.04, h * 0.26, w * 0.12, w * 0.05),
      Paint()..color = const Color(0xFFD4B060),
    );
    // Lamp glow
    canvas.drawCircle(
      Offset(w * 0.10, h * 0.34),
      w * 0.10,
      Paint()
        ..color = const Color(0xFFFFD080).withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Vase on table
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.36, h * 0.58, w * 0.05, h * 0.10),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFD4A840),
    );

    // Plants
    _drawBlobPlant(
      canvas,
      Offset(w * 0.72, h * 0.74),
      w * 0.10,
      h * 0.38,
      const Color(0xFF4A7030),
    );
  }

  void _drawBlobPlant(
    Canvas canvas,
    Offset base,
    double pw,
    double ph,
    Color color,
  ) {
    final paint = Paint()..color = color;
    canvas.drawOval(
      Rect.fromLTWH(base.dx - pw / 2, base.dy - ph, pw, ph),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        base.dx - pw * 0.8,
        base.dy - ph * 0.65,
        pw * 0.55,
        ph * 0.45,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        base.dx + pw * 0.2,
        base.dy - ph * 0.55,
        pw * 0.45,
        ph * 0.38,
      ),
      paint,
    );
    // pot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          base.dx - pw * 0.3,
          base.dy - h * 0.03,
          pw * 0.6,
          h * 0.05,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF8A6840),
    );
  }

  double get h => 200; // approx
  @override
  bool shouldRepaint(_) => false;
}

// ── 2. Exterior Redesign ──
class _ExteriorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky — dramatic cloudy dusk
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.55),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF7090B0), const Color(0xFFB0C4D8)],
        ).createShader(Rect.fromLTWH(0, 0, w, h * 0.55)),
    );

    // Mountains / hills bg
    final hillPaint = Paint()..color = const Color(0xFF8090A0).withOpacity(0.6);
    final hills =
        Path()
          ..moveTo(0, h * 0.40)
          ..quadraticBezierTo(w * 0.15, h * 0.18, w * 0.30, h * 0.32)
          ..quadraticBezierTo(w * 0.50, h * 0.10, w * 0.70, h * 0.28)
          ..quadraticBezierTo(w * 0.85, h * 0.38, w, h * 0.35)
          ..lineTo(w, h * 0.55)
          ..lineTo(0, h * 0.55)
          ..close();
    canvas.drawPath(hills, hillPaint);

    // Ground / lawn
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.54, w, h * 0.46),
      Paint()..color = const Color(0xFF2A4020),
    );

    // Driveway / path
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.32, h * 0.60, w * 0.36, h * 0.40),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8A8878),
    );

    // House — modern black/stone
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.30, w * 0.92, h * 0.42),
      Paint()..color = const Color(0xFF3A3830),
    );
    // Upper storey
    canvas.drawRect(
      Rect.fromLTWH(w * 0.15, h * 0.14, w * 0.65, h * 0.18),
      Paint()..color = const Color(0xFF4A4840),
    );
    // Stone texture overlay (left wing)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.30, w * 0.28, h * 0.42),
      Paint()..color = const Color(0xFF686058),
    );

    // Glowing windows
    final winPaint = Paint()..color = const Color(0xFFE8C060);
    // Main large windows
    canvas.drawRect(
      Rect.fromLTWH(w * 0.32, h * 0.32, w * 0.28, h * 0.18),
      winPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.62, h * 0.32, w * 0.14, h * 0.18),
      winPaint,
    );
    // Upper storey windows
    canvas.drawRect(
      Rect.fromLTWH(w * 0.22, h * 0.16, w * 0.16, h * 0.10),
      winPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.55, h * 0.16, w * 0.16, h * 0.10),
      winPaint,
    );
    // Window glow bloom
    canvas.drawRect(
      Rect.fromLTWH(w * 0.20, h * 0.25, w * 0.65, h * 0.30),
      Paint()
        ..color = const Color(0xFFE8C060).withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    // Trees — dark silhouette
    final treePaint = Paint()..color = const Color(0xFF1A2A18);
    for (final x in [0.02, 0.88]) {
      canvas.drawRect(
        Rect.fromLTWH(w * x, h * 0.20, w * 0.06, h * 0.54),
        treePaint,
      );
      canvas.drawOval(
        Rect.fromLTWH(w * (x - 0.04), h * 0.06, w * 0.14, h * 0.20),
        treePaint,
      );
    }

    // Accent path lighting
    final lightGlow =
        Paint()
          ..color = const Color(0xFFFFD060).withOpacity(0.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    for (final pos in [0.36, 0.44, 0.52, 0.60]) {
      canvas.drawCircle(Offset(w * pos, h * 0.64), 4, lightGlow);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── 3. Style Transfer ──
class _StyleTransferPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Dark navy/teal accent wall (right)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, 0, w * 0.50, h),
      Paint()..color = const Color(0xFF1A3A40),
    );
    // Light cream wall (left)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w * 0.50, h),
      Paint()..color = const Color(0xFFE8E0D4),
    );

    // White marble floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.72, w, h * 0.28),
      Paint()..color = const Color(0xFFECE8E0),
    );
    // Marble veins
    final veinPaint =
        Paint()
          ..color = const Color(0xFFD0C8C0).withOpacity(0.5)
          ..strokeWidth = 1;
    canvas.drawLine(Offset(0, h * 0.78), Offset(w * 0.3, h * 0.82), veinPaint);
    canvas.drawLine(
      Offset(w * 0.4, h * 0.74),
      Offset(w * 0.7, h * 0.80),
      veinPaint,
    );

    // Fireplace (center-right)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.30, w * 0.26, h * 0.40),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF1A1A18),
    );
    // Fire glow
    canvas.drawRect(
      Rect.fromLTWH(w * 0.40, h * 0.32, w * 0.22, h * 0.36),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [const Color(0xFFE85020), const Color(0xFFE8A030)],
        ).createShader(Rect.fromLTWH(w * 0.40, h * 0.32, w * 0.22, h * 0.36)),
    );

    // White sofa (left)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.02, h * 0.52, w * 0.35, h * 0.22),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFF0EBE4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.02, h * 0.44, w * 0.35, h * 0.10),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFE8E0D8),
    );

    // Teal sofa (right)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.60, h * 0.52, w * 0.38, h * 0.22),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF2A8080),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.60, h * 0.44, w * 0.38, h * 0.10),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF206868),
    );

    // Chandelier
    final chandPaint =
        Paint()
          ..color = const Color(0xFFD4A840)
          ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(w * 0.50, 0),
      Offset(w * 0.50, h * 0.14),
      chandPaint,
    );
    for (final angle in [-0.5, -0.25, 0.0, 0.25, 0.5]) {
      final x = w * 0.50 + angle * w * 0.20;
      canvas.drawLine(
        Offset(w * 0.50, h * 0.14),
        Offset(x, h * 0.20),
        chandPaint,
      );
      canvas.drawCircle(
        Offset(x, h * 0.22),
        4,
        Paint()..color = const Color(0xFFFFE080),
      );
    }

    // Large windows (teal side)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.80, h * 0.08, w * 0.18, h * 0.44),
      Paint()..color = const Color(0xFF2A4860).withOpacity(0.8),
    );

    // Plant (left side)
    canvas.drawOval(
      Rect.fromLTWH(0, h * 0.22, w * 0.12, h * 0.28),
      Paint()..color = const Color(0xFF3A6028),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── 4. Smart Staging (Before/After split) ──
class _StagingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // LEFT SIDE — Before (empty room)
    // Warm beige walls
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w * 0.50, h),
      Paint()..color = const Color(0xFFEAE0D4),
    );
    // Bright window
    canvas.drawRect(
      Rect.fromLTWH(w * 0.08, h * 0.10, w * 0.30, h * 0.55),
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFD8ECF8), const Color(0xFFECF4F8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(w * 0.08, h * 0.10, w * 0.30, h * 0.55)),
    );
    // Empty floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.70, w * 0.50, h * 0.30),
      Paint()..color = const Color(0xFFD8C8A8),
    );

    // RIGHT SIDE — After (furnished)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, 0, w * 0.50, h),
      Paint()..color = const Color(0xFFDDD4C4),
    );
    // Warm ceiling
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, 0, w * 0.50, h * 0.08),
      Paint()..color = const Color(0xFFCCC0A0),
    );
    // Treadmill / equipment
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.54, h * 0.38, w * 0.40, h * 0.34),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF3A3A3A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.56, h * 0.32, w * 0.36, h * 0.08),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF5A5050),
    );
    // Window after side
    canvas.drawRect(
      Rect.fromLTWH(w * 0.78, h * 0.08, w * 0.18, h * 0.50),
      Paint()..color = const Color(0xFFBED4E0).withOpacity(0.8),
    );
    // Ambient ceiling glow
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, 0, w * 0.50, h * 0.06),
      Paint()
        ..color = const Color(0xFFE8C040).withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // After floor
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, h * 0.72, w * 0.50, h * 0.28),
      Paint()..color = const Color(0xFFD0B888),
    );

    // White divider line
    canvas.drawLine(
      Offset(w * 0.50, 0),
      Offset(w * 0.50, h),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── 5. Replace ──
class _ReplacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background — elegant white room
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFF5F0E8),
    );

    // Large windows
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.04, w * 0.40, h * 0.68),
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFD0E4F0), const Color(0xFFECF0F4)],
        ).createShader(Rect.fromLTWH(0, 0, w * 0.40, h)),
    );

    // Floor — cream marble
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.72, w, h * 0.28),
      Paint()..color = const Color(0xFFECE8E0),
    );

    // Left section — white bed (being replaced)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.03, h * 0.35, w * 0.40, h * 0.37),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFEEE8E0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.03, h * 0.28, w * 0.40, h * 0.10),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFE4DCD4),
    );
    // Blue selection highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.03, h * 0.28, w * 0.40, h * 0.44),
        const Radius.circular(6),
      ),
      Paint()
        ..color = const Color(0xFF4090D0).withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Right section — armchair (replacement)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.52, h * 0.44, w * 0.40, h * 0.26),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFB09070),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.52, h * 0.34, w * 0.40, h * 0.12),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFA08060),
    );
    // Armchair legs
    final legPaint =
        Paint()
          ..color = const Color(0xFF5A3A18)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.56, h * 0.70),
      Offset(w * 0.54, h * 0.75),
      legPaint,
    );
    canvas.drawLine(
      Offset(w * 0.88, h * 0.70),
      Offset(w * 0.90, h * 0.75),
      legPaint,
    );

    // Chandelier (top center)
    final cPaint =
        Paint()
          ..color = const Color(0xFFD4B848)
          ..strokeWidth = 1.5;
    canvas.drawLine(Offset(w * 0.50, 0), Offset(w * 0.50, h * 0.10), cPaint);
    canvas.drawOval(
      Rect.fromLTWH(w * 0.36, h * 0.10, w * 0.28, h * 0.06),
      Paint()..color = const Color(0xFFD4B848),
    );
    // Light bulbs hanging
    for (final x in [0.40, 0.46, 0.52, 0.58, 0.64]) {
      canvas.drawLine(Offset(w * x, h * 0.16), Offset(w * x, h * 0.22), cPaint);
      canvas.drawCircle(
        Offset(w * x, h * 0.23),
        4,
        Paint()..color = const Color(0xFFFFE080),
      );
    }
    // Chandelier glow
    canvas.drawOval(
      Rect.fromLTWH(w * 0.30, h * 0.10, w * 0.40, h * 0.18),
      Paint()
        ..color = const Color(0xFFFFE060).withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── 6. Dream Space / Imagine ──
class _DreamSpacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Dark dramatic background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF0A1020), const Color(0xFF1A1A28)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Futuristic curved structure
    final archPaint = Paint()..color = const Color(0xFF2A2A3A);
    final archPath =
        Path()
          ..moveTo(0, h * 0.30)
          ..quadraticBezierTo(w * 0.30, h * 0.05, w * 0.70, h * 0.15)
          ..quadraticBezierTo(w, h * 0.25, w, h * 0.35)
          ..lineTo(w, h * 0.55)
          ..quadraticBezierTo(w * 0.70, h * 0.48, w * 0.30, h * 0.58)
          ..quadraticBezierTo(0, h * 0.65, 0, h * 0.50)
          ..close();
    canvas.drawPath(archPath, archPaint);

    // Glass panels — reflective
    final glassPaint =
        Paint()..color = const Color(0xFF203040).withOpacity(0.8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.15, w * 0.35, h * 0.40),
        const Radius.circular(2),
      ),
      glassPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.55, h * 0.18, w * 0.32, h * 0.35),
        const Radius.circular(2),
      ),
      glassPaint,
    );

    // Amber interior light glow through panels
    canvas.drawRect(
      Rect.fromLTWH(w * 0.10, h * 0.15, w * 0.35, h * 0.40),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFE8A820).withOpacity(0.4),
            Colors.transparent,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(Rect.fromLTWH(w * 0.10, h * 0.15, w * 0.35, h * 0.40)),
    );

    // Ground / reflection pool
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.60, w, h * 0.40),
      Paint()..color = const Color(0xFF080E18),
    );
    // Water reflection shimmer
    final shimmerPaint =
        Paint()
          ..color = const Color(0xFFE8A820).withOpacity(0.12)
          ..strokeWidth = 1;
    for (int i = 0; i < 5; i++) {
      final y = h * 0.64 + i * h * 0.07;
      canvas.drawLine(
        Offset(w * 0.15, y),
        Offset(w * 0.85, y + h * 0.01),
        shimmerPaint,
      );
    }

    // Edge lighting strips
    final edgePaint =
        Paint()
          ..color = const Color(0xFFD49020)
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(Offset(0, h * 0.30), Offset(w, h * 0.35), edgePaint);
    canvas.drawLine(Offset(0, h * 0.50), Offset(w, h * 0.55), edgePaint);

    // Stars / ambient particles
    final starPaint = Paint()..color = Colors.white.withOpacity(0.6);
    final rng = math.Random(42);
    for (int i = 0; i < 30; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * w, rng.nextDouble() * h * 0.30),
        rng.nextDouble() * 1.5,
        starPaint,
      );
    }

    // Dark trees silhouette sides
    final treePaint = Paint()..color = const Color(0xFF08100A);
    canvas.drawOval(
      Rect.fromLTWH(-w * 0.05, h * 0.10, w * 0.15, h * 0.25),
      treePaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.90, h * 0.12, w * 0.15, h * 0.22),
      treePaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
