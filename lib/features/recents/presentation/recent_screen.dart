import 'dart:math' as math;
import 'package:ai_interior/bloc/recent_list/recent_list_bloc.dart';
import 'package:ai_interior/features/recents/presentation/recents_output_screen.dart';
import 'package:ai_interior/models/recents_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import '../../../widgets/custom_imageview.dart';
import '../../credit/presentataion/credit_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../main/presentaion/main_screen.dart';
import '../../setting/presentation/setting_screens.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  final RecentListBloc _recentListBloc = RecentListBloc();
  RecentListModelResponse? recentListModelResponse;
  int _navIdx = 2;

  @override
  void initState() {
    super.initState();
    _recentListBloc.add(RecentListDataEvent(data: {"user_id": 2}));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocConsumer<RecentListBloc, RecentListState>(
        bloc: _recentListBloc,
        listener: (context, state) {
          if (state is RecentListSuccessState) {
            recentListModelResponse = state.exploreSongResponse;
          } else if (state is RecentListExceptionState ||
              state is RecentListFailureState) {}
        },
        builder: (context, state) {
          return Scaffold(
            appBar: TopBarAppBar(),
            backgroundColor: const Color(0xFFF2EFEA),
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child:
                        recentListModelResponse?.data?.data != null
                            ? _buildGrid()
                            : _buildEmptyState(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    final items = recentListModelResponse?.data?.data ?? [];

    if (items.isEmpty) {
      return Center(
        child: Text(
          "No recent items found",
          style: TextStyle(
            color: Colors.grey,
            fontSize: r.sp(context, 16),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 14),
        vertical: r.hp(context, 10),
      ),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.gridColumns(context),
        crossAxisSpacing: r.wp(context, 10),
        mainAxisSpacing: r.hp(context, 10),
        childAspectRatio: r.gridAspectRatio(context, mobile: 0.75, tablet: 0.8),
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return InkWell(
          borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 15, tablet: 22)),
          onTap: () {
            Navigator.of(context).pushNamed(
              RecentOutputScreen.routeName,
              arguments: {
                "image": item.outputImage ?? "",
                "prompt": item.prompt ?? "",
                "spaceType": item.spaceType ?? "",
                "color": item.colors ?? "",
                "designAsth": item.designAsthetic ?? "",
                "id": item.id ?? "",
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 15, tablet: 22)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// Image
                CustomImageview(imagePath: item.outputImage, fit: BoxFit.cover),

                /// Gradient overlay for text readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: r.adaptiveValue(context, mobile: 60, tablet: 80),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ),
                item.spaceType == null
                    ? const SizedBox.shrink()
                    : Positioned(
                      bottom: r.adaptiveValue(context, mobile: 10, tablet: 15),
                      left: r.adaptiveValue(context, mobile: 10, tablet: 15),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.wp(context, 10),
                          vertical: r.hp(context, 5),
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.5),
                          borderRadius: BorderRadius.circular(r.wp(context, 50)),
                        ),
                        child: Text(
                          item.spaceType ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: r.sp(context, 12),
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Illustrated open box with floating item
        CustomImageview(
          imagePath: "assets/images/no_recents.png",
          height: r.adaptiveValue(context, mobile: 180, tablet: 260),
          width: r.adaptiveValue(context, mobile: 180, tablet: 260),
        ),
        SizedBox(height: r.hp(context, 3.5)),

        // Title
        Text(
          'Your Designs Will Appear Here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.sp(context, 22),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1C1A18),
            letterSpacing: -0.3,
            height: 1.25,
            fontFamily: 'Georgia',
          ),
        ),
        SizedBox(height: r.hp(context, 1.5)),

        // Subtitle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(context, 32)),
          child: Text(
            'Upload a photo, try a style, and watch AI do the magic!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.sp(context, 15),
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8A8480),
              height: 1.5,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(double botPad) {
    return Container(
      color: const Color(0xFFF2EFEA),
      padding: EdgeInsets.only(top: 10, bottom: botPad > 0 ? botPad : 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBtn(
            icon: Icons.home_filled,
            label: 'Home',
            idx: 0,
            current: _navIdx,
            onTap: (v) => setState(() => _navIdx = v),
          ),
          _CompassNavBtn(
            label: 'Explore',
            idx: 1,
            current: _navIdx,
            onTap: (v) => setState(() => _navIdx = v),
          ),
          _RecentsNavBtn(
            label: 'Recents',
            idx: 2,
            current: _navIdx,
            onTap: (v) => setState(() => _navIdx = v),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Open box illustration painter
// Matches the screenshot: cardboard box open top, teal interior,
// floating bean/item with dashed arc trail
// ─────────────────────────────────────────────────────────────────────────────
class _OpenBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Colors ────────────────────────────────────────────────────────
    const cardboard = Color(0xFFD4B896);
    const cardboardDark = Color(0xFFC4A882);
    const cardboardFold = Color(0xFFEAD8C0);
    const teal = Color(0xFF7A9E8E);
    const tealDark = Color(0xFF6A8E7E);
    const dashColor = Color(0xFF5A6E78);
    const beanColor = Color(0xFFD4A878);

    // ── Box geometry ──────────────────────────────────────────────────
    // Box body: trapezoidal perspective box
    final boxLeft = w * 0.18;
    final boxRight = w * 0.82;
    final boxTop = h * 0.42;
    final boxBottom = h * 0.86;
    final boxMidX = w * 0.50;

    // ── Front face of box ─────────────────────────────────────────────
    final frontFace =
        Path()
          ..moveTo(boxLeft, boxTop + h * 0.08)
          ..lineTo(boxRight, boxTop + h * 0.08)
          ..lineTo(boxRight, boxBottom)
          ..lineTo(boxLeft, boxBottom)
          ..close();
    canvas.drawPath(frontFace, Paint()..color = cardboard);

    // ── Right side face (perspective) ─────────────────────────────────
    // We keep the box rectangular for this flat illustration style

    // ── Teal interior of box (visible from open top) ──────────────────
    // Interior is a trapezoid showing the inside bottom
    final interiorPath =
        Path()
          ..moveTo(boxLeft + w * 0.04, boxTop + h * 0.08)
          ..lineTo(boxRight - w * 0.04, boxTop + h * 0.08)
          ..lineTo(boxMidX + w * 0.20, boxTop + h * 0.22)
          ..lineTo(boxMidX - w * 0.24, boxTop + h * 0.22)
          ..close();
    canvas.drawPath(interiorPath, Paint()..color = teal);

    // Interior depth shading
    final interiorSide =
        Path()
          ..moveTo(boxLeft + w * 0.04, boxTop + h * 0.08)
          ..lineTo(boxMidX - w * 0.24, boxTop + h * 0.22)
          ..lineTo(boxLeft, boxTop + h * 0.20)
          ..close();
    canvas.drawPath(interiorSide, Paint()..color = tealDark);

    // ── Box front dividing crease (center vertical line) ──────────────
    canvas.drawLine(
      Offset(boxMidX, boxTop + h * 0.08),
      Offset(boxMidX, boxBottom),
      Paint()
        ..color = cardboardDark
        ..strokeWidth = 1.2,
    );

    // ── Left flap (open, folded back-left) ────────────────────────────
    final leftFlap =
        Path()
          ..moveTo(boxLeft, boxTop + h * 0.08)
          ..lineTo(boxMidX - w * 0.02, boxTop + h * 0.08)
          ..lineTo(boxMidX - w * 0.10, boxTop - h * 0.10)
          ..lineTo(boxLeft - w * 0.04, boxTop - h * 0.06)
          ..close();
    canvas.drawPath(leftFlap, Paint()..color = cardboardFold);
    canvas.drawPath(
      leftFlap,
      Paint()
        ..color = cardboardDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // ── Right flap (open, folded back-right) ──────────────────────────
    final rightFlap =
        Path()
          ..moveTo(boxMidX + w * 0.02, boxTop + h * 0.08)
          ..lineTo(boxRight, boxTop + h * 0.08)
          ..lineTo(boxRight + w * 0.04, boxTop - h * 0.06)
          ..lineTo(boxMidX + w * 0.10, boxTop - h * 0.10)
          ..close();
    canvas.drawPath(rightFlap, Paint()..color = cardboardFold);
    canvas.drawPath(
      rightFlap,
      Paint()
        ..color = cardboardDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // ── Box outline ───────────────────────────────────────────────────
    canvas.drawPath(
      frontFace,
      Paint()
        ..color = cardboardDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ── Floating bean / item (top right of box) ───────────────────────
    // Organic blob shape
    final beanCx = w * 0.60;
    final beanCy = h * 0.20;
    final beanPath = Path();
    // Draw a kidney/bean shape using arcs
    beanPath.moveTo(beanCx - 12, beanCy);
    beanPath.cubicTo(
      beanCx - 18,
      beanCy - 16,
      beanCx + 4,
      beanCy - 22,
      beanCx + 14,
      beanCy - 8,
    );
    beanPath.cubicTo(
      beanCx + 22,
      beanCy + 4,
      beanCx + 8,
      beanCy + 18,
      beanCx - 4,
      beanCy + 14,
    );
    beanPath.cubicTo(
      beanCx - 16,
      beanCy + 10,
      beanCx - 6,
      beanCy + 14,
      beanCx - 12,
      beanCy,
    );
    beanPath.close();
    canvas.drawPath(beanPath, Paint()..color = beanColor);

    // Bean highlight
    canvas.drawPath(
      beanPath,
      Paint()
        ..color = const Color(0xFFDFBE9A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── Dashed arc from box to bean ───────────────────────────────────
    _drawDashedArc(
      canvas,
      center: Offset(w * 0.42, h * 0.38),
      radius: w * 0.22,
      startAngle: -math.pi * 0.85,
      sweepAngle: math.pi * 0.70,
      dashLength: 8.0,
      gapLength: 6.0,
      paint:
          Paint()
            ..color = dashColor
            ..strokeWidth = 3.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
    );
  }

  /// Draws a dashed arc on the canvas.
  void _drawDashedArc(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required double dashLength,
    required double gapLength,
    required Paint paint,
  }) {
    final circumference = radius * sweepAngle.abs();
    final dashCount = (circumference / (dashLength + gapLength)).floor();
    final anglePerUnit = sweepAngle / circumference;

    double currentAngle = startAngle;
    for (int i = 0; i < dashCount; i++) {
      final dashAngle = dashLength * anglePerUnit;
      final gapAngle = gapLength * anglePerUnit;

      final startPt = Offset(
        center.dx + radius * math.cos(currentAngle),
        center.dy + radius * math.sin(currentAngle),
      );
      final endPt = Offset(
        center.dx + radius * math.cos(currentAngle + dashAngle),
        center.dy + radius * math.sin(currentAngle + dashAngle),
      );

      canvas.drawLine(startPt, endPt, paint);
      currentAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Suppress unused variable

// ─────────────────────────────────────────────────────────────────────────────
// Coin badge
// ─────────────────────────────────────────────────────────────────────────────
class _CoinBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
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
          const SizedBox(width: 6),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFD4720A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.diamond, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom nav — standard icon button
// ─────────────────────────────────────────────────────────────────────────────
class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final int idx, current;
  final ValueChanged<int> onTap;

  const _NavBtn({
    required this.icon,
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(
        top: topPad + r.hp(context, 6),
        left: r.wp(context, 16),
        right: r.wp(context, 16),
        bottom: r.hp(context, 4),
      ),
      child: Row(
        children: [
          // Title
          Text(
            'AI Interior Design',
            style: TextStyle(
              fontSize: r.sp(context, 30),
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(135, 63, 0, 1),
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          // Coin balance
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CreditsScreen.routeName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.wp(context, 10),
                vertical: r.hp(context, 5),
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
                          fontSize: isIPad(context) ? r.sp(context, 50) : r.sp(context, 16),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: r.wp(context, 4)),
                  CustomImageview(
                    imagePath: "assets/images/credit.png",
                    height: r.wp(context, 25),
                    width: r.wp(context, 25),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: r.wp(context, 8)),
          // Settings
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
            child: CustomImageview(
              imagePath: "assets/images/setting.png",
              height: r.wp(context, 25),
              width: r.wp(context, 25),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Compass nav button for "Explore"
// ─────────────────────────────────────────────────────────────────────────────
class _CompassNavBtn extends StatelessWidget {
  final String label;
  final int idx, current;
  final ValueChanged<int> onTap;

  const _CompassNavBtn({
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(28, 28),
              painter: _CompassPainter(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recents nav button — clock/circle with dashed ring
// ─────────────────────────────────────────────────────────────────────────────
class _RecentsNavBtn extends StatelessWidget {
  final String label;
  final int idx, current;
  final ValueChanged<int> onTap;

  const _RecentsNavBtn({
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(30, 30),
              painter: _RecentsPainter(color: color, selected: sel),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recents icon painter — clock face with dashed outer ring
// ─────────────────────────────────────────────────────────────────────────────
class _RecentsPainter extends CustomPainter {
  final Color color;
  final bool selected;

  const _RecentsPainter({required this.color, required this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 1;

    final solidPaint =
        Paint()
          ..color = color
          ..strokeWidth = selected ? 2.0 : 1.6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // ── Dashed outer ring ──────────────────────────────────────────────
    final dashCount = 16;
    final dashAngle = (2 * math.pi) / dashCount;
    final dashLen = dashAngle * 0.55;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle - math.pi / 2;
      final endAngle = startAngle + dashLen;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        dashLen,
        false,
        solidPaint,
      );
    }

    // ── Inner filled circle ────────────────────────────────────────────
    final innerR = r * 0.62;
    canvas.drawCircle(Offset(cx, cy), innerR, Paint()..color = color);

    // ── Clock hands (white) ───────────────────────────────────────────
    final handPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    // Hour hand (pointing ~10 o'clock)
    canvas.drawLine(
      Offset(cx, cy),
      Offset(
        cx + innerR * 0.45 * math.cos(-math.pi * 0.75),
        cy + innerR * 0.45 * math.sin(-math.pi * 0.75),
      ),
      handPaint,
    );

    // Minute hand (pointing ~12 o'clock)
    canvas.drawLine(Offset(cx, cy), Offset(cx, cy - innerR * 0.60), handPaint);

    // Center dot
    canvas.drawCircle(Offset(cx, cy), 1.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _RecentsPainter old) =>
      old.color != color || old.selected != selected;
}

// ─────────────────────────────────────────────────────────────────────────────
// Compass rose painter (8-point star)
// ─────────────────────────────────────────────────────────────────────────────
class _CompassPainter extends CustomPainter {
  final Color color;

  const _CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        Offset(cx + 4 * math.cos(angle), cy + 4 * math.sin(angle)),
        Offset(cx + 12 * math.cos(angle), cy + 12 * math.sin(angle)),
        paint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) => old.color != color;
}
