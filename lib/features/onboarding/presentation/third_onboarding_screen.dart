import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class OnboardingScreenThree extends StatefulWidget {
  const OnboardingScreenThree({super.key});

  static const routeName = '/onboarding_screen_three';

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.60,
            width: double.infinity,
            child: Image.asset(
              'assets/images/living_room.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _LivingRoomPlaceholder(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  const Text(
                    'Reimagine Any Space',
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

                  const SizedBox(height: 14),

                  const Text(
                    'Select an area, describe your vision, and let AI\nbring it to life.',
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

                  // Page dots — third dot active
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => _PageDot(isActive: i == 2),
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
// Living Room Placeholder
// ─────────────────────────────────────────────
class _LivingRoomPlaceholder extends StatelessWidget {
  const _LivingRoomPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LivingRoomPainter(), child: Container());
  }
}

class _LivingRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Ceiling — dark wood planks ──
    final ceilPaint = Paint()..color = const Color(0xFF3D2610);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.16), ceilPaint);

    // Wood plank lines on ceiling
    final plankLinePaint =
        Paint()
          ..color = const Color(0xFF2A1A0A)
          ..strokeWidth = 1.2;
    for (int i = 1; i <= 8; i++) {
      final y = h * 0.16 / 9 * i;
      canvas.drawLine(Offset(0, y), Offset(w, y), plankLinePaint);
    }
    // Plank vertical breaks
    final plankVPaint =
        Paint()
          ..color = const Color(0xFF2A1A0A)
          ..strokeWidth = 0.8;
    for (int col = 0; col < 6; col++) {
      for (int row = 0; row < 9; row++) {
        final x = w / 6 * col + (row.isEven ? w / 12 : 0);
        final y1 = h * 0.16 / 9 * row;
        final y2 = h * 0.16 / 9 * (row + 1);
        canvas.drawLine(Offset(x, y1), Offset(x, y2), plankVPaint);
      }
    }

    // ── Crown molding ──
    final moldingPaint = Paint()..color = const Color(0xFFF0EDE8);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.155, w, h * 0.016), moldingPaint);

    // ── Wall — grey-blue ──
    final wallPaint = Paint()..color = const Color(0xFFB0B8BE);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.17, w, h * 0.48), wallPaint);

    // ── Right side curtain / window ──
    final curtainPaint = Paint()..color = const Color(0xFFE8E0D0);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.88, h * 0.17, w * 0.12, h * 0.48),
      curtainPaint,
    );
    // Window light bleed
    final windowGlow =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              const Color(0xFFEDE8DC).withOpacity(0.9),
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTWH(w * 0.65, h * 0.17, w * 0.35, h * 0.48));
    canvas.drawRect(
      Rect.fromLTWH(w * 0.65, h * 0.17, w * 0.35, h * 0.48),
      windowGlow,
    );

    // ── Herringbone parquet floor ──
    _drawHerringboneFloor(canvas, size);

    // ── Jute rug ──
    final rugPaint = Paint()..color = const Color(0xFFE0D4B8).withOpacity(0.85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.58, w * 0.85, h * 0.18),
        const Radius.circular(4),
      ),
      rugPaint,
    );

    // ── Sideboard / credenza ──
    final sideboardPaint = Paint()..color = const Color(0xFFA8904A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.22, h * 0.48, w * 0.52, h * 0.17),
        const Radius.circular(3),
      ),
      sideboardPaint,
    );
    // Sideboard legs
    final legPaint =
        Paint()
          ..color = const Color(0xFF1A1A1A)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.26, h * 0.65),
      Offset(w * 0.26, h * 0.67),
      legPaint,
    );
    canvas.drawLine(
      Offset(w * 0.70, h * 0.65),
      Offset(w * 0.70, h * 0.67),
      legPaint,
    );
    // Door panels
    final doorPaint =
        Paint()
          ..color = const Color(0xFF9A8240)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawRect(
      Rect.fromLTWH(w * 0.24, h * 0.50, w * 0.16, h * 0.13),
      doorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.42, h * 0.50, w * 0.16, h * 0.13),
      doorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.60, h * 0.50, w * 0.12, h * 0.13),
      doorPaint,
    );
    // Door handles
    final handlePaint =
        Paint()
          ..color = const Color(0xFF2A2A2A)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.315, h * 0.565),
      Offset(w * 0.345, h * 0.565),
      handlePaint,
    );
    canvas.drawLine(
      Offset(w * 0.515, h * 0.565),
      Offset(w * 0.545, h * 0.565),
      handlePaint,
    );

    // Decorative vases on sideboard
    _drawVase(
      canvas,
      Offset(w * 0.42, h * 0.48),
      w * 0.04,
      h * 0.08,
      const Color(0xFFD4781A),
    ); // tall amber
    _drawVase(
      canvas,
      Offset(w * 0.48, h * 0.50),
      w * 0.035,
      h * 0.06,
      const Color(0xFFB85A10),
    ); // medium dark orange
    _drawVase(
      canvas,
      Offset(w * 0.54, h * 0.51),
      w * 0.03,
      h * 0.05,
      const Color(0xFFE8A830),
    ); // small gold

    // ── Two art frames on wall ──
    // Left frame — botanical
    _drawArtFrame(
      canvas,
      Rect.fromLTWH(w * 0.24, h * 0.20, w * 0.22, h * 0.26),
      size,
      true,
    );
    // Right frame — abstract
    _drawArtFrame(
      canvas,
      Rect.fromLTWH(w * 0.48, h * 0.22, w * 0.22, h * 0.24),
      size,
      false,
    );

    // ── Wall sconce (left) ──
    final sconcePaint = Paint()..color = const Color(0xFF1A1A1A);
    // Sconce arm
    canvas.drawRect(
      Rect.fromLTWH(w * 0.1, h * 0.31, w * 0.02, h * 0.1),
      sconcePaint,
    );
    // Lamp shade (cylinder)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.07, h * 0.28, w * 0.08, h * 0.07),
      sconcePaint,
    );
    // Lamp glow
    final glowPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFD080).withOpacity(0.4),
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTWH(0, h * 0.25, w * 0.25, h * 0.25));
    canvas.drawCircle(Offset(w * 0.11, h * 0.38), w * 0.1, glowPaint);

    // ── Chair (mid-century dark leather) ──
    // Legs
    final chairLegPaint =
        Paint()
          ..color = const Color(0xFF5C3A1E)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.18, h * 0.62),
      Offset(w * 0.16, h * 0.67),
      chairLegPaint,
    );
    canvas.drawLine(
      Offset(w * 0.30, h * 0.62),
      Offset(w * 0.32, h * 0.67),
      chairLegPaint,
    );
    canvas.drawLine(
      Offset(w * 0.19, h * 0.60),
      Offset(w * 0.17, h * 0.65),
      chairLegPaint,
    );
    canvas.drawLine(
      Offset(w * 0.29, h * 0.60),
      Offset(w * 0.31, h * 0.65),
      chairLegPaint,
    );
    // Seat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.55, w * 0.18, h * 0.09),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF2A2A2A),
    );
    // Back
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.44, w * 0.18, h * 0.13),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF222222),
    );
    // Armrest detail
    final armPaint =
        Paint()
          ..color = const Color(0xFF5C3A1E)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.15, h * 0.52),
      Offset(w * 0.12, h * 0.58),
      armPaint,
    );
    canvas.drawLine(
      Offset(w * 0.33, h * 0.52),
      Offset(w * 0.36, h * 0.58),
      armPaint,
    );

    // ── Small side table (dark mushroom) ──
    // Pedestal top
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.57, w * 0.11, h * 0.025),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF3A3A3A),
    );
    // Pedestal base (wider)
    final pedestalPath =
        Path()
          ..moveTo(w * 0.05, h * 0.665)
          ..lineTo(w * 0.14, h * 0.665)
          ..lineTo(w * 0.13, h * 0.595)
          ..lineTo(w * 0.06, h * 0.595)
          ..close();
    canvas.drawPath(pedestalPath, Paint()..color = const Color(0xFF3A3A3A));

    // Small vase on side table
    _drawVase(
      canvas,
      Offset(w * 0.085, h * 0.57),
      w * 0.025,
      h * 0.05,
      const Color(0xFFE8E0D0),
    );

    // ── Large fiddle leaf fig (right) ──
    _drawFiddleLeafFig(canvas, Offset(w * 0.78, h * 0.30), w, h);
    // Basket planter
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.60, w * 0.14, h * 0.08),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF2A2A2A),
    );
    // Basket weave lines
    final weavePaint =
        Paint()
          ..color = const Color(0xFF3A3A3A)
          ..strokeWidth = 1;
    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(
        Offset(w * 0.72, h * 0.60 + h * 0.08 / 5 * i),
        Offset(w * 0.86, h * 0.60 + h * 0.08 / 5 * i),
        weavePaint,
      );
    }

    // ── Snake plant (smaller, right of sideboard) ──
    _drawSnakePlant(canvas, Offset(w * 0.78, h * 0.62), w, h);
  }

  void _drawHerringboneFloor(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final floorTop = h * 0.65;
    final floorHeight = h * 0.35;

    // Base floor color
    canvas.drawRect(
      Rect.fromLTWH(0, floorTop, w, floorHeight),
      Paint()..color = const Color(0xFFD4BC98),
    );

    // Herringbone planks
    final plankW = w * 0.06;
    final plankH = plankW * 2.5;
    final colors = [
      const Color(0xFFCAAE88),
      const Color(0xFFD4BC98),
      const Color(0xFFBCA070),
      const Color(0xFFD8C2A0),
    ];

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, floorTop, w, floorHeight));

    for (double row = floorTop - plankH; row < h + plankH; row += plankH) {
      for (double col = -plankH; col < w + plankH; col += plankH) {
        final colorIndex =
            ((row / plankH).floor() + (col / plankH).floor()).abs() %
            colors.length;
        final paint = Paint()..color = colors[colorIndex];
        final strokePaint =
            Paint()
              ..color = const Color(0xFFB09070).withOpacity(0.5)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.8;

        // Right-leaning plank
        canvas.save();
        canvas.translate(col, row);
        canvas.rotate(math.pi / 4);
        final rect1 = Rect.fromLTWH(-plankW / 2, -plankH / 2, plankW, plankH);
        canvas.drawRect(rect1, paint);
        canvas.drawRect(rect1, strokePaint);
        canvas.restore();

        // Left-leaning plank (offset)
        canvas.save();
        canvas.translate(col + plankH / 2, row + plankH / 2);
        canvas.rotate(-math.pi / 4);
        final rect2 = Rect.fromLTWH(-plankW / 2, -plankH / 2, plankW, plankH);
        canvas.drawRect(rect2, paint);
        canvas.drawRect(rect2, strokePaint);
        canvas.restore();
      }
    }

    canvas.restore();
  }

  void _drawArtFrame(Canvas canvas, Rect frame, Size size, bool isBotanical) {
    // Frame border
    canvas.drawRect(frame, Paint()..color = const Color(0xFF1A1A1A));
    // White mat inside
    final inner = Rect.fromLTRB(
      frame.left + 4,
      frame.top + 4,
      frame.right - 4,
      frame.bottom - 4,
    );
    canvas.drawRect(inner, Paint()..color = const Color(0xFFF5F5F0));

    if (isBotanical) {
      // Draw simple botanical line art
      final artPaint =
          Paint()
            ..color = const Color(0xFF1A1A1A)
            ..strokeWidth = 1.2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;
      final cx = inner.center.dx;
      final bottom = inner.bottom - 8;
      // Stem
      canvas.drawLine(Offset(cx, bottom), Offset(cx, inner.top + 20), artPaint);
      // Leaves
      for (int i = 0; i < 5; i++) {
        final y = bottom - (inner.height * 0.15 * i);
        final side = i.isEven ? 1.0 : -1.0;
        final path =
            Path()
              ..moveTo(cx, y)
              ..quadraticBezierTo(
                cx + side * inner.width * 0.3,
                y - inner.height * 0.06,
                cx + side * inner.width * 0.28,
                y - inner.height * 0.12,
              )
              ..quadraticBezierTo(
                cx + side * inner.width * 0.1,
                y - inner.height * 0.05,
                cx,
                y,
              );
        canvas.drawPath(path, artPaint);
      }
    } else {
      // Abstract circle/ring art
      final artPaint =
          Paint()
            ..color = const Color(0xFF1A1A1A)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
      final cx = inner.center.dx;
      final cy = inner.center.dy;
      canvas.drawCircle(Offset(cx - 10, cy), inner.width * 0.25, artPaint);
      canvas.drawCircle(Offset(cx + 10, cy + 5), inner.width * 0.2, artPaint);
      canvas.drawCircle(Offset(cx, cy - 10), inner.width * 0.15, artPaint);
    }
  }

  void _drawVase(
    Canvas canvas,
    Offset top,
    double width,
    double height,
    Color color,
  ) {
    final path =
        Path()
          ..moveTo(top.dx - width * 0.3, top.dy)
          ..quadraticBezierTo(
            top.dx - width * 0.5,
            top.dy + height * 0.3,
            top.dx - width * 0.4,
            top.dy + height * 0.7,
          )
          ..lineTo(top.dx - width * 0.5, top.dy + height)
          ..lineTo(top.dx + width * 0.5, top.dy + height)
          ..lineTo(top.dx + width * 0.4, top.dy + height * 0.7)
          ..quadraticBezierTo(
            top.dx + width * 0.5,
            top.dy + height * 0.3,
            top.dx + width * 0.3,
            top.dy,
          )
          ..close();
    canvas.drawPath(path, Paint()..color = color);
    // Neck rim
    canvas.drawRect(
      Rect.fromLTWH(top.dx - width * 0.35, top.dy, width * 0.7, height * 0.06),
      Paint()..color = color.withOpacity(0.7),
    );
  }

  void _drawFiddleLeafFig(Canvas canvas, Offset base, double w, double h) {
    final stemPaint =
        Paint()
          ..color = const Color(0xFF3A2A10)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    // Main trunk
    canvas.drawLine(base, Offset(base.dx, base.dy - h * 0.32), stemPaint);

    // Branches and leaves
    final leafPaint = Paint()..color = const Color(0xFF3D6E30);
    final leafDarkPaint = Paint()..color = const Color(0xFF2E5422);

    final branches = [
      [base.dx - w * 0.12, base.dy - h * 0.28, -0.5],
      [base.dx + w * 0.10, base.dy - h * 0.22, 0.4],
      [base.dx - w * 0.08, base.dy - h * 0.16, -0.3],
      [base.dx + w * 0.06, base.dy - h * 0.10, 0.5],
      [base.dx - w * 0.06, base.dy - h * 0.05, -0.4],
    ];

    for (final b in branches) {
      final bx = b[0];
      final by = b[1];
      final angle = b[2];
      canvas.drawLine(
        Offset(base.dx, by + h * 0.02),
        Offset(bx, by),
        stemPaint,
      );
      _drawFiddleLeaf(
        canvas,
        Offset(bx, by),
        angle,
        w * 0.08,
        leafPaint,
        leafDarkPaint,
      );
    }
  }

  void _drawFiddleLeaf(
    Canvas canvas,
    Offset tip,
    double angle,
    double size,
    Paint fill,
    Paint veinPaint,
  ) {
    final path =
        Path()
          ..moveTo(tip.dx, tip.dy)
          ..quadraticBezierTo(
            tip.dx + math.cos(angle) * size * 1.2,
            tip.dy - size * 0.5,
            tip.dx + math.cos(angle) * size * 0.8,
            tip.dy - size * 1.4,
          )
          ..quadraticBezierTo(
            tip.dx + math.cos(angle) * size * 0.2,
            tip.dy - size * 1.8,
            tip.dx,
            tip.dy - size * 1.6,
          )
          ..quadraticBezierTo(
            tip.dx - math.cos(angle) * size * 0.6,
            tip.dy - size * 1.2,
            tip.dx,
            tip.dy,
          )
          ..close();
    canvas.drawPath(path, fill);
    // Midrib vein
    final veinLinePaint =
        Paint()
          ..color = const Color(0xFF4A8040).withOpacity(0.6)
          ..strokeWidth = 1;
    canvas.drawLine(
      tip,
      Offset(tip.dx + math.cos(angle) * size * 0.4, tip.dy - size * 1.4),
      veinLinePaint,
    );
  }

  void _drawSnakePlant(Canvas canvas, Offset base, double w, double h) {
    final leafColors = [
      const Color(0xFF4A7A30),
      const Color(0xFF3A6A20),
      const Color(0xFF5A8A40),
    ];
    for (int i = 0; i < 3; i++) {
      final offsetX = w * 0.02 * (i - 1);
      final leafPath =
          Path()
            ..moveTo(base.dx + offsetX - w * 0.015, base.dy)
            ..lineTo(base.dx + offsetX - w * 0.008, base.dy - h * 0.12)
            ..lineTo(base.dx + offsetX + w * 0.008, base.dy - h * 0.12)
            ..lineTo(base.dx + offsetX + w * 0.015, base.dy)
            ..close();
      canvas.drawPath(
        leafPath,
        Paint()..color = leafColors[i % leafColors.length],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
