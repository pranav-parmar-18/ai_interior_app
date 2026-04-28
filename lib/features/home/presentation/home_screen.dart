import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────
class FeatureItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final CustomPainter imagePainter;
  final Widget? overlay;

  const FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imagePainter,
    this.overlay,
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
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final features = [
      FeatureItem(
        title: 'Revamp Your Interior',
        subtitle: 'Transform your space with a fresh design',
        icon: Icons.weekend_outlined,
        imagePainter: _InteriorPainter(),
      ),
      FeatureItem(
        title: 'Redesign Your Exterior',
        subtitle: 'Transform your outdoor space',
        icon: Icons.home_outlined,
        imagePainter: _ExteriorPainter(),
      ),
      FeatureItem(
        title: 'Style Transfer',
        subtitle: 'Apply a style from any reference image',
        icon: Icons.palette_outlined,
        imagePainter: _StyleTransferPainter(),
        overlay: const _StyleSwatchOverlay(),
      ),
      FeatureItem(
        title: 'Smart Staging',
        subtitle: 'Effortlessly furnish and style your room',
        icon: Icons.auto_awesome_outlined,
        imagePainter: _StagingPainter(),
        overlay: const _BeforeAfterOverlay(),
      ),
      FeatureItem(
        title: 'Replace',
        subtitle: 'Replace any part of your space with ease',
        icon: Icons.swap_horiz_rounded,
        imagePainter: _ReplacePainter(),
        overlay: const _ReplacePromptOverlay(),
      ),
      FeatureItem(
        title: 'Design Your Dream Space',
        subtitle: 'Build your ideal space from scratch',
        icon: Icons.auto_fix_high_rounded,
        imagePainter: _DreamSpacePainter(),
        overlay: const _ImaginePromptOverlay(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      body: Column(
        children: [
          // ── Main scrollable content ──
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Top App Bar
                SliverToBoxAdapter(child: _TopBar()),

                // Feature cards list
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _FeatureCard(item: features[index]),
                    childCount: features.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
            ),
          ),

          // ── Bottom Navigation Bar ──
          const _BottomNavBar(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: topPad + 6, left: 16, right: 16, bottom: 4),
      child: Row(
        children: [
          // Title
          const Text(
            'AI Interior Design',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB87333),
              // warm copper/amber
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          // Coin balance
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text(
                  '200',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8A020),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt, color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Settings
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90B8).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF4A90B8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Feature Card
// ─────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final FeatureItem item;

  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        children: [
          // Image area
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: item.imagePainter),
                  if (item.overlay != null) item.overlay!,
                ],
              ),
            ),
          ),

          // Label row
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 4,
              left: 2,
              right: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E8DC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: const Color(0xFF8A6A40),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A8A8A),
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
