import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/features/style_transfer/presentation/style_transfer_screeen.dart';

class DreamOutputScreen extends StatefulWidget {
  const DreamOutputScreen({super.key});

  static const routeName = "/dream-output-screen";

  @override
  State<DreamOutputScreen> createState() => _DreamOutputScreenState();
}

class _DreamOutputScreenState extends State<DreamOutputScreen> {
  Map<String, dynamic> data = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, // white status bar icons over photo
        child: Scaffold(
        backgroundColor: const Color(0xFFF2EFEA),
        body: Column(
          children: [
            // ── Full-bleed photo section ───────────────────────────
            _PhotoSection(topPad: topPad, img: data["image"]),

            // ── Scrollable info cards ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(r.wp(context, 16), r.hp(context, 16), r.wp(context, 16), 0),
                child: Column(
                  children: [
                    // Building Type
                    _InfoTile(
                      iconWidget: const _BuildingIcon(),
                      label: 'Building Type',
                      value: data["spaceType"].toString().toTitleCase(),
                      trailing: null,
                    ),
                    SizedBox(height: r.hp(context, 10)),

                    // Design Aesthetic
                    _InfoTile(
                      iconWidget: Icon(
                        Icons.style_outlined,
                        size: r.wp(context, 24),
                        color: const Color(0xFF7A7A7A),
                      ),
                      label: 'Design Aesthetic',
                      value: data["designAsth"].toString().toTitleCase(),
                      trailing: null,
                    ),
                    SizedBox(height: r.hp(context, 10)),

                    // Color Palette
                    _InfoTile(
                      iconWidget: Icon(
                        Icons.palette_outlined,
                        size: r.wp(context, 24),
                        color: const Color(0xFF7A7A7A),
                      ),
                      label: 'Color Palette',
                      value: data["color"].toString().toTitleCase(),
                      trailing: const _ColorSwatches(),
                    ),
                    SizedBox(height: r.hp(context, 16)),
                  ],
                ),
              ),
            ),

            // ── Apply Style button ─────────────────────────────────
            _ApplyButton(
              botPad: botPad,
              imgUrl: data["image"]?.toString() ?? "",
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Photo section — full bleed with back button
// ─────────────────────────────────────────────────────────────────────────────
class _PhotoSection extends StatelessWidget {
  final double topPad;
  final String img;

  const _PhotoSection({required this.topPad, required this.img});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: r.hp(context, 300),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo (replace with Image.asset or Image.network)
          Image.network(
            img,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Container(
                  color: const Color(0xFF8AAAC8),
                  child: Center(
                    child: Icon(
                      Icons.location_city_outlined,
                      size: r.sp(context, 60),
                      color: Colors.white54,
                    ),
                  ),
                ),
          ),

          // Top gradient for back button legibility
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + r.hp(context, 64),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: topPad + r.hp(context, 10),
            left: r.wp(context, 16),
            child: GestureDetector(
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Icon(
                Icons.chevron_left_rounded,
                size: r.sp(context, 32),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info tile — white card with icon, label, value, optional trailing
// ─────────────────────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoTile({
    required this.iconWidget,
    required this.label,
    required this.value,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 16),
        vertical: r.hp(context, 14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 16, tablet: 20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: r.wp(context, 44),
            height: r.wp(context, 44),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          SizedBox(width: r.wp(context, 14)),

          // Label + value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: r.sp(context, 12.5),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7A7A7A),
                    height: 1.2,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: r.hp(context, 4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: r.sp(context, 15.5),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                    letterSpacing: -0.1,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Optional trailing widget
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Color swatches — overlapping circles for the palette
// ─────────────────────────────────────────────────────────────────────────────
class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  static const _colors = [
    Color(0xFFD8D0C8), // light warm grey
    Color(0xFF8A8880), // mid grey
    Color(0xFF3A3A3A), // dark charcoal
    Color(0xFF6A8EAA), // muted blue
  ];

  @override
  Widget build(BuildContext context) {
    final size = r.adaptiveValue(context, mobile: 28.0, tablet: 36.0);
    final overlap = r.adaptiveValue(context, mobile: 10.0, tablet: 12.0);

    return SizedBox(
      width: size + (_colors.length - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < _colors.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: _colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Building icon — custom painter for the house/city sketch icon
// ─────────────────────────────────────────────────────────────────────────────
class _BuildingIcon extends StatelessWidget {
  const _BuildingIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(r.sp(context, 30), r.sp(context, 30)),
      painter: _BuildingIconPainter(),
    );
  }
}

class _BuildingIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final scale = w / 30.0;

    final paint =
        Paint()
          ..color = const Color(0xFF5A6068)
          ..strokeWidth = 1.4 * scale
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

    // ── Small house (left) ─────────────────────────────────────────────
    // House body
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.44, w * 0.32, h * 0.46),
      paint,
    );
    // Roof
    final roofPath =
        Path()
          ..moveTo(w * 0.01, h * 0.44)
          ..lineTo(w * 0.20, h * 0.20)
          ..lineTo(w * 0.39, h * 0.44);
    canvas.drawPath(roofPath, paint);
    // Door
    canvas.drawRect(
      Rect.fromLTWH(w * 0.13, h * 0.66, w * 0.12, h * 0.24),
      paint,
    );
    // Window
    canvas.drawRect(
      Rect.fromLTWH(w * 0.06, h * 0.52, w * 0.09, h * 0.09),
      paint,
    );

    // ── Tall tower / building (right) ──────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, h * 0.10, w * 0.22, h * 0.80),
      paint,
    );
    // Tower windows (3 rows)
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 2; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            w * 0.53 + col * w * 0.10,
            h * 0.16 + row * h * 0.20,
            w * 0.07,
            h * 0.10,
          ),
          paint,
        );
      }
    }

    // ── Small building (far right) ─────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(w * 0.76, h * 0.34, w * 0.20, h * 0.56),
      paint,
    );
    // Windows
    for (int row = 0; row < 2; row++) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.79, h * 0.40 + row * h * 0.18, w * 0.06, h * 0.08),
        paint,
      );
    }

    // ── Ground line ────────────────────────────────────────────────────
    canvas.drawLine(Offset(0, h * 0.90), Offset(w, h * 0.90), paint);

    // ── Trees / bushes (between buildings) ────────────────────────────
    canvas.drawCircle(
      Offset(w * 0.44, h * 0.78),
      w * 0.06,
      Paint()
        ..color = const Color(0xFF7A8870)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(Offset(w * 0.44, h * 0.78), w * 0.06, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Apply Style button
// ─────────────────────────────────────────────────────────────────────────────
class _ApplyButton extends StatefulWidget {
  final double botPad;
  final String imgUrl;

  const _ApplyButton({required this.botPad, required this.imgUrl});

  @override
  State<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<_ApplyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 20),
        r.hp(context, 8),
        r.wp(context, 20),
        widget.botPad > 0 ? widget.botPad : r.hp(context, 24),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          Navigator.of(context).pushNamed(
            StyleTransferScreen.routeName,
            arguments: {"styleReference": widget.imgUrl},
          );
        },
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            width: double.infinity,
            height: r.hp(context, 60),
            decoration: BoxDecoration(
              color: const Color(0xFFDEB887),
              borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 34, tablet: 40)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDEB887).withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Apply Style',
              style: TextStyle(
                fontSize: r.sp(context, 19),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A3218),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
