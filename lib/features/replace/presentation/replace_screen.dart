import 'package:flutter/material.dart';

class ReplaceScreen extends StatefulWidget {
  const ReplaceScreen({super.key});

  @override
  State<ReplaceScreen> createState() => _ReplaceScreenState();
}

class _ReplaceScreenState extends State<ReplaceScreen> {
  int _selectedTemplate = -1;

  // Template accent colors (simulate photo thumbnails)
  final List<_TemplateItem> _templates = const [
    _TemplateItem(Color(0xFFD4A870), Color(0xFFE8D0A8), Icons.weekend_outlined),
    _TemplateItem(Color(0xFFB8C4A8), Color(0xFFD8E0C8), Icons.dinner_dining_outlined),
    _TemplateItem(Color(0xFFD4C0A0), Color(0xFFECDEC8), Icons.weekend_outlined),
    _TemplateItem(Color(0xFF5A5A6A), Color(0xFF8A8A9A), Icons.bed_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPad),
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionLabel('Upload a photo you want to edit'),
                  const SizedBox(height: 14),
                  _buildUploadCard(),
                  const SizedBox(height: 18),
                  _buildOrDivider(),
                  const SizedBox(height: 18),
                  _buildSectionLabel('Choose from Template'),
                  const SizedBox(height: 14),
                  _buildTemplateRow(),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          _buildNextButton(botPad),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // App bar
  // ───────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.chevron_left_rounded,
                size: 30,
                color: Color(0xFF1C1A18),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Replace',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1A18),
                fontFamily: 'Georgia',
                letterSpacing: 0.2,
              ),
            ),
          ),
          _buildCoinBadge(),
        ],
      ),
    );
  }

  Widget _buildCoinBadge() {
    return Container(
      height: 34,
      padding: const EdgeInsets.only(left: 12, right: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A040),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '200',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFD4720A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.diamond, size: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Section label
  // ───────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C1A18),
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Upload card with isometric room
  // ───────────────────────────────────────────────
  Widget _buildUploadCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Room preview
            SizedBox(
              height: 260,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: CustomPaint(
                  painter: _IsoRoomPainter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // Add Photo pill
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDD9B8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_a_photo_outlined,
                          size: 20, color: Color(0xFF5A3E18)),
                      SizedBox(width: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A3E18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // OR divider
  // ───────────────────────────────────────────────
  Widget _buildOrDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: Container(height: 1, color: const Color(0xFFE0D8D0))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB0A898),
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
              child: Container(height: 1, color: const Color(0xFFE0D8D0))),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Template row
  // ───────────────────────────────────────────────
  Widget _buildTemplateRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final t = _templates[i];
          final selected = _selectedTemplate == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTemplate = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF3A7D7B)
                      : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(selected ? 0.12 : 0.07),
                    blurRadius: selected ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient fill simulating photo
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [t.lightColor, t.accentColor],
                        ),
                      ),
                    ),
                    // Room icon
                    Center(
                      child: Icon(t.icon,
                          size: 34,
                          color: Colors.white.withOpacity(0.80)),
                    ),
                    // Selected checkmark
                    if (selected)
                      Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A7D7B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 13, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Next button
  // ───────────────────────────────────────────────
  Widget _buildNextButton(double botPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, botPad > 0 ? botPad : 20),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFDDD8D0),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5A5550),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Isometric room painter — matches screenshot's light grey minimal room
// ─────────────────────────────────────────────────────────────────────────────
class _IsoRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 8;

    // ── Floor ──────────────────────────────────────────────────────────
    final floorPath = Path()
      ..moveTo(cx, cy - 70)
      ..lineTo(cx + 145, cy + 2)
      ..lineTo(cx, cy + 74)
      ..lineTo(cx - 145, cy + 2)
      ..close();
    canvas.drawPath(floorPath, Paint()..color = const Color(0xFFE8E8E8));

    // Floor planks
    final plankPaint = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (int i = -4; i <= 4; i++) {
      canvas.drawLine(
        Offset(cx + i * 32, cy - 66 + i.abs() * 2),
        Offset(cx + i * 32 + 56, cy + 66 + i.abs() * 2),
        plankPaint,
      );
    }

    // ── Left wall ─────────────────────────────────────────────────────
    final leftWall = Path()
      ..moveTo(cx - 145, cy + 2)
      ..lineTo(cx, cy - 70)
      ..lineTo(cx, cy - 148)
      ..lineTo(cx - 145, cy - 76)
      ..close();
    canvas.drawPath(leftWall, Paint()..color = const Color(0xFFE2E2E2));

    // ── Right wall ─────────────────────────────────────────────────────
    final rightWall = Path()
      ..moveTo(cx, cy - 70)
      ..lineTo(cx + 145, cy + 2)
      ..lineTo(cx + 145, cy - 76)
      ..lineTo(cx, cy - 148)
      ..close();
    canvas.drawPath(rightWall, Paint()..color = const Color(0xFFD8D8D8));

    // ── Wall edge lines ────────────────────────────────────────────────
    final edgePaint = Paint()
      ..color = const Color(0xFFC8C8C8)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(cx, cy - 70), Offset(cx, cy - 148), edgePaint);
    canvas.drawLine(
        Offset(cx - 145, cy + 2), Offset(cx - 145, cy - 76), edgePaint);
    canvas.drawLine(
        Offset(cx + 145, cy + 2), Offset(cx + 145, cy - 76), edgePaint);

    // ── Right wall window / blinds ─────────────────────────────────────
    final blindBg = Paint()..color = const Color(0xFFB8C8D4);
    final blindPath = Path()
      ..moveTo(cx + 40, cy - 92)
      ..lineTo(cx + 130, cy - 48)
      ..lineTo(cx + 130, cy - 14)
      ..lineTo(cx + 40, cy - 58)
      ..close();
    canvas.drawPath(blindPath, blindBg);
    // Blind slats
    final slatPaint = Paint()
      ..color = const Color(0xFF9AAAB8)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 6; i++) {
      final t = i / 6;
      canvas.drawLine(
        Offset(cx + 40, cy - 92 + t * 34 + 4),
        Offset(cx + 130, cy - 48 + t * 34 + 4),
        slatPaint,
      );
    }
    // Window frame
    canvas.drawPath(
      blindPath,
      Paint()
        ..color = const Color(0xFFAAAAAA)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── Wall frames (left wall) ────────────────────────────────────────
    final framePaint = Paint()..color = const Color(0xFFAAAAAA);
    // Frame 1
    canvas.drawRect(Rect.fromLTWH(cx - 130, cy - 132, 30, 22), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 128, cy - 130, 26, 18),
      Paint()..color = const Color(0xFFBBBBBB),
    );
    // Frame 2
    canvas.drawRect(Rect.fromLTWH(cx - 94, cy - 136, 30, 22), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 92, cy - 134, 26, 18),
      Paint()..color = const Color(0xFFBBBBBB),
    );
    // Frame 3 (landscape, lower)
    canvas.drawRect(Rect.fromLTWH(cx - 130, cy - 106, 62, 20), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 128, cy - 104, 58, 16),
      Paint()..color = const Color(0xFFBBBBBB),
    );

    // ── Rug ───────────────────────────────────────────────────────────
    final rugPath = Path()
      ..moveTo(cx, cy - 4)
      ..lineTo(cx + 90, cy + 42)
      ..lineTo(cx, cy + 68)
      ..lineTo(cx - 90, cy + 22)
      ..close();
    canvas.drawPath(rugPath, Paint()..color = const Color(0xFFDFDFDF));

    // ── L-sofa ────────────────────────────────────────────────────────
    // Seat
    final sofaSeat = Path()
      ..moveTo(cx - 90, cy - 14)
      ..lineTo(cx + 20, cy + 46)
      ..lineTo(cx + 12, cy + 64)
      ..lineTo(cx - 98, cy + 4)
      ..close();
    canvas.drawPath(sofaSeat, Paint()..color = const Color(0xFFD8D8D8));
    // Back
    final sofaBack = Path()
      ..moveTo(cx - 98, cy + 4)
      ..lineTo(cx - 90, cy - 14)
      ..lineTo(cx - 82, cy - 46)
      ..lineTo(cx - 90, cy - 28)
      ..close();
    canvas.drawPath(sofaBack, Paint()..color = const Color(0xFFC8C8C8));
    // Back rest top
    final sofaBackTop = Path()
      ..moveTo(cx - 90, cy - 14)
      ..lineTo(cx + 20, cy + 46)
      ..lineTo(cx + 14, cy + 32)
      ..lineTo(cx - 82, cy - 28)
      ..close();
    canvas.drawPath(sofaBackTop, Paint()..color = const Color(0xFFCCCCCC));

    // Blue/striped cushions
    final cushionPaint = Paint()..color = const Color(0xFF7A9EC0);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - 30, cy + 20), width: 28, height: 16),
      cushionPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 8, cy + 34), width: 26, height: 14),
      Paint()..color = const Color(0xFF6A8EB0),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 54, cy + 8), width: 26, height: 14),
      cushionPaint,
    );

    // ── Coffee table ──────────────────────────────────────────────────
    // Table top
    final tableTop = Path()
      ..moveTo(cx - 10, cy + 30)
      ..lineTo(cx + 52, cy + 62)
      ..lineTo(cx + 40, cy + 76)
      ..lineTo(cx - 22, cy + 44)
      ..close();
    canvas.drawPath(tableTop, Paint()..color = const Color(0xFFE8E8E0));
    // Table legs
    canvas.drawLine(
      Offset(cx - 10, cy + 32),
      Offset(cx - 12, cy + 44),
      Paint()
        ..color = const Color(0xFF888888)
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(cx + 52, cy + 64),
      Offset(cx + 50, cy + 76),
      Paint()
        ..color = const Color(0xFF888888)
        ..strokeWidth = 2,
    );

    // Items on table
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + 18, cy + 52), width: 16, height: 9),
      Paint()..color = const Color(0xFFCCCCCC),
    );

    // ── Floor lamp ────────────────────────────────────────────────────
    canvas.drawLine(
      Offset(cx + 28, cy - 10),
      Offset(cx + 30, cy + 40),
      Paint()
        ..color = const Color(0xFF888888)
        ..strokeWidth = 2,
    );
    // Lamp shade
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 26, cy - 16), width: 20, height: 12),
      Paint()..color = const Color(0xFFE8E0D0),
    );

    // ── Plant (right side) ────────────────────────────────────────────
    // Pot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 94, cy - 8, 20, 24),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF9A9A8A),
    );
    // Leaves
    final leafPaint = Paint()..color = const Color(0xFF5A8A50);
    for (int i = 0; i < 5; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + 100 + (i - 2) * 10.0, cy - 18 - i * 8.0),
          width: 18,
          height: 32,
        ),
        leafPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TemplateItem {
  final Color accentColor;
  final Color lightColor;
  final IconData icon;
  const _TemplateItem(this.accentColor, this.lightColor, this.icon);
}