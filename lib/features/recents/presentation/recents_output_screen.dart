import 'package:ai_interior/bloc/delete_record/delete_record_bloc.dart';
import 'package:ai_interior/bloc/publish_record/publish_record_bloc.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentOutputScreen extends StatefulWidget {
  const RecentOutputScreen({super.key});

  static const routeName = "/resents-output-screen";

  @override
  State<RecentOutputScreen> createState() => _RecentOutputScreenState();
}

class _RecentOutputScreenState extends State<RecentOutputScreen> {
  final PublishRecordBloc _publishRecordBloc = PublishRecordBloc();
  final DeleteRecordBloc _deleteRecordBloc = DeleteRecordBloc();

  Map<String, dynamic> data = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print("IMAGE : ${data["image"]}");
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<PublishRecordBloc, PublishRecordState>(
        bloc: _publishRecordBloc,
        listener: (context, state) {
          if (state is PublishRecordSuccessState) {
          } else if (state is PublishRecordFailureState ||
              state is PublishRecordExceptionState) {}
        },
        builder: (context, state) {
          return BlocConsumer<DeleteRecordBloc, DeleteRecordState>(
            bloc: _deleteRecordBloc,
            listener: (context, state) {
              if (state is DeleteRecordSuccessState) {
              } else if (state is DeleteRecordExceptionState ||
                  state is DeleteRecordFailureState) {}
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: const Color(0xFFF2EFEA),
                body:
                    state is PublishRecordLoadingState
                        ? Center(child: CupertinoActivityIndicator())
                        : Column(
                          children: [
                            _PhotoSection(topPad: topPad, img: data["image"]),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  0,
                                ),
                                child: Column(
                                  children: [
                                    _InfoTile(
                                      iconWidget: const _BuildingIcon(),
                                      label: 'Building Type',
                                      value:
                                          data["spaceType"]
                                              .toString()
                                              .toUpperCase(),
                                      trailing: null,
                                    ),
                                    const SizedBox(height: 10),
                                    _InfoTile(
                                      iconWidget: const Icon(
                                        Icons.style_outlined,
                                        size: 26,
                                        color: Color(0xFF5A5550),
                                      ),
                                      label: 'Design Aesthetic',
                                      value:
                                          data["designAsth"]
                                              .toString()
                                              .toUpperCase(),
                                      trailing: null,
                                    ),
                                    const SizedBox(height: 10),
                                    _InfoTile(
                                      iconWidget: const Icon(
                                        Icons.palette_outlined,
                                        size: 26,
                                        color: Color(0xFF5A5550),
                                      ),
                                      label: 'Color Palette',
                                      value:
                                          data["color"]
                                              .toString()
                                              .toUpperCase(),
                                      trailing: const _ColorSwatches(),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                bottomNavigationBar: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showRegenerateAlert(context);
                        },
                        child: Column(
                          children: [
                            CustomImageview(
                              imagePath: "assets/images/output_1.png",
                              height: 45,
                              width: 45,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Regenerate",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CustomImageview(
                            imagePath: "assets/images/output_2.png",
                            height: 45,
                            width: 45,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(46, 46, 46, 1),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showPublishSheet(context);
                        },
                        child: Column(
                          children: [
                            CustomImageview(
                              imagePath: "assets/images/output_3.png",
                              height: 45,
                              width: 45,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Publish",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.share("text");
                        },
                        child: Column(
                          children: [
                            CustomImageview(
                              imagePath: "assets/images/output_4.png",
                              height: 45,
                              width: 45,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Share",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDeleteAlert(context);
                        },
                        child: Column(
                          children: [
                            CustomImageview(
                              imagePath: "assets/images/output_5.png",
                              height: 45,
                              width: 45,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showPublishSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => publishBottomSheet(context),
    );
  }

  void _showDeleteAlert(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Delete This Design?'),
            content: const Text(
              'This action cannot be undone. Are you sure you want to permanently remove this design?',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {

                  Navigator.of(context).pop();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String userId = preferences.getString('user_id') ?? "";

                  final publishData = {
                    "user_id": userId,
                    "module_id": 1,
                    "id": data["id"],
                  };

                  debugPrint("Publish Record DataEvent payload: $publishData");

                  debugPrint("user_id: $userId");
                  debugPrint("module_id: 1");
                  debugPrint("id: ${data["id"]}");

                  _publishRecordBloc.add(
                    PublishRecordDataEvent(login: publishData),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showRegenerateAlert(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Regenerate Design?'),
            content: const Text(
              'This action will use 10 credits to generate a new design. Do you want to proceed?',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: handle regenerate
                },
                child: const Text('Regenerate'),
              ),
            ],
          ),
    );
  }

  Widget publishBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),

          // Avatar circle
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFE8D5BC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.group, size: 36, color: Color(0xFF3D3229)),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            'Publish Your Design',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'Share your design on the Explore page for\nothers to discover',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF8A8A8A),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Publish button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                String userId = preferences.getString('user_id') ?? "";

                final publishData = {
                  "user_id": userId,
                  "module_id": 1,
                  "id": data["id"],
                };

                debugPrint("PublishRecordDataEvent payload: $publishData");

                debugPrint("user_id: $userId");
                debugPrint("module_id: 1");
                debugPrint("id: ${data["id"]}");

                _publishRecordBloc.add(
                  PublishRecordDataEvent(login: publishData),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8D5BC),
                foregroundColor: const Color(0xFF3D3229),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Publish'),
            ),
          ),
          const SizedBox(height: 4),

          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final double topPad;
  final String img;

  const _PhotoSection({required this.topPad, required this.img});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            img,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Container(
                  color: const Color(0xFF8AAAC8),
                  child: const Center(
                    child: Icon(
                      Icons.location_city_outlined,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + 64,
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
            top: topPad + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF2EFEA),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9C9690),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1816),
                    letterSpacing: -0.2,
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
    const size = 28.0;
    const overlap = 10.0;

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
      size: const Size(30, 30),
      painter: _BuildingIconPainter(),
    );
  }
}

class _BuildingIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint =
        Paint()
          ..color = const Color(0xFF5A6068)
          ..strokeWidth = 1.4
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

  const _ApplyButton({required this.botPad});

  @override
  State<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<_ApplyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        widget.botPad > 0 ? widget.botPad : 24,
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {},
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFDEB887),
              borderRadius: BorderRadius.circular(34),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDEB887).withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Apply Style',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3218),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
