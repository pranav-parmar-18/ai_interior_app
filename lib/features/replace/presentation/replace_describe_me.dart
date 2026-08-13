import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ai_interior/bloc/smart_replace_create/smart_replace_create_bloc.dart';
import 'package:ai_interior/features/replace/presentation/replace_output_screen.dart';
import 'replace_edit_screen.dart';
import '../../main/presentaion/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_interior/utils/responsive_utils.dart';

import '../../../services/subscription_manager.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../subscription/presentation/subscription_screen_three.dart';
import '../../subscription/presentation/subscription_screen_two.dart';
import '../../home/presentation/home_screen.dart';


class ReplaceDescribeVisionScreen extends StatefulWidget {
  const ReplaceDescribeVisionScreen({super.key});

  static const routeName = "/replace-describe-vision";

  @override
  State<ReplaceDescribeVisionScreen> createState() =>
      _ReplaceDescribeVisionScreenState();
}

class _ReplaceDescribeVisionScreenState
    extends State<ReplaceDescribeVisionScreen> {
  Map<String, dynamic> data = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {};
  }
  final SmartReplaceCreateBloc _smartReplaceCreateBloc =
      SmartReplaceCreateBloc();
  final TextEditingController _controller = TextEditingController(
    text: 'Transform my living room into a cozy aesthetic.',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSubscriptionActive();
  }

  bool? isSubscribed = false;

  void openSubscriptionScreen(BuildContext context) {
    final nextIndex = SubscriptionScreenManager().getNextIndex();

    final screens = [
      SubscriptionScreen(),
      SubscriptionScreenTwo(),
      SubscriptionScreenThree(),
    ];

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => screens[nextIndex]),
    );
  }

  Future<bool> isSubscriptionActive() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final active = preferences.getBool('is_subscribed') ?? false;
    if (mounted) {
      setState(() {
        isSubscribed = active;
      });
    }
    return active;
  }

  final Set<int> _selected = {};

  final List<String> _chips = [
    'Maximalist',
    'Monochrome',
    'Soft',
    'Cinematic Photo',
    'Avant-Garde',
    'Colorful',
    'Eclectic',
    'High Quality',
    'Ultrarealistic',
    'Hollywood Glam',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocConsumer<SmartReplaceCreateBloc, SmartReplaceCreateState>(
        bloc: _smartReplaceCreateBloc,
        listener: (context, state) {
          if (state is SmartReplaceCreateSuccessState) {
            int currentCredits = int.tryParse(creditsNotifier.value) ?? 0;
            final newCredits = (currentCredits - 50).clamp(0, 999999).toString();
            creditsNotifier.value = newCredits;
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('credits', newCredits);
            });
            String imageVal = "assets/images/replace_home.png";
            if (data["picked"] != null) {
              imageVal = data["picked"] is File ? (data["picked"] as File).path : data["picked"].toString();
            } else if (data["templateIndex"] != null && data["templateIndex"] is int && (data["templateIndex"] as int) >= 0) {
              imageVal = "assets/images/interior/interior_${(data["templateIndex"] as int) + 1}.jpg";
            }

            final outputUrl = state.login?.data?.outputImage ?? "";
            Navigator.of(context).pushNamed(
              ReplaceOutputScreen.routeName,
              arguments: {
                "image": outputUrl.isNotEmpty ? outputUrl : imageVal,
                "prompt": _controller.text,
                "spaceType": "Living Room",
                "color": "Nature's Harmony",
                "designAsth": "Modern",
                "id": state.login?.data?.id ?? "",
                "module_id": 5,
              },
            );
          } else if (state is SmartReplaceCreateFailureState) {
            showSnackError(
              context,
              state.message.isNotEmpty ? state.message : "Please try once again",
            );
          } else if (state is SmartReplaceCreateExceptionState) {
            showSnackError(context, "Please try once again");
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body:
                state is SmartReplaceCreateLoadingState
                    ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8F6F4),
                            // rgba(248, 246, 244, 1.00) — spec stop 1
                            Color(0xFFD7C9B6),
                            // rgba(202, 184, 158, 0.75) — spec stop 2
                            Color(0xFF73808A),
                            // rgba(90,  106, 117, 0.85) — spec stop 3
                          ],
                          stops: [0.0, 0.48, 1.0],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 1),
                            Image.asset(
                              "assets/gifs/loading.gif",
                              height: r.adaptiveValue(context, mobile: 320, tablet: 420),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Bringing your vision to life...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: r.sp(context, 17),
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(90, 106, 117, 1),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const Spacer(flex: 3),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.wp(context, 30.0),
                              ),
                              child: Text(
                                "Keep the app open & don’t lock your device. This may take around 10 seconds.",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: r.sp(context, 14),
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(90, 106, 117, 1),
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    )
                    : Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8F6F4),
                            // rgba(248, 246, 244, 1.00) — spec stop 1
                            Color(0xFFD7C9B6),
                            // rgba(202, 184, 158, 0.75) — spec stop 2
                            Color(0xFF73808A),
                            // rgba(90,  106, 117, 0.85) — spec stop 3
                          ],
                          stops: [0.0, 0.48, 1.0],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: topPad),

                          // ── ✕ Close ─────────────────────────────────────────────
                          _buildCloseRow(),

                          // ── Scrollable body ──────────────────────────────────────
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: r.wp(context, 22),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  r.verticalSpace(context, 2),
                                  _buildTitle(),
                                  r.verticalSpace(context, 20),
                                  _buildTextField(),
                                  r.verticalSpace(context, 24),
                                  _buildChipsWrap(),
                                  r.verticalSpace(context, 32),
                                ],
                              ),
                            ),
                          ),

                          // ── Save button ──────────────────────────────────────────
                          _buildSaveButton(botPad),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }

  // ─── Close button row ─────────────────────────────────────────────────
  Widget _buildCloseRow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: r.wp(context, 22), top: r.hp(context, 14), bottom: r.hp(context, 4)),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Icon(
            Icons.close_rounded,
            size: r.wp(context, 24),
            color: const Color(0xFFB89A7A),
          ),
        ),
      ),
    );
  }

  // ─── Title ────────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mixed-style rich text: "Describe " normal | "Your Vision" italic
        RichText(
          text: TextSpan(
            children: [
              _span('Describe ', italic: false, color: const Color(0xFF2E2C5A)),
              _span('Your ', italic: true, color: const Color(0xFF2E2C5A)),
              _span('Vision', italic: true, color: const Color(0xFFB8864A)),
            ],
          ),
        ),
        r.verticalSpace(context, 7),
        Text(
          'Tell AI what your preferred design aesthetic',
          style: TextStyle(
            fontSize: r.sp(context, 14),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6A6058),
            height: 1.45,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  TextSpan _span(String text, {required bool italic, required Color color}) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: r.sp(context, 30),
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
        height: 1.15,
      ),
    );
  }

  // ─── Text field ───────────────────────────────────────────────────────
  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.50),
        borderRadius: BorderRadius.circular(r.wp(context, 16)),
        border: Border.all(color: Colors.white.withOpacity(0.58), width: r.wp(context, 1)),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        minLines: 3,
        style: TextStyle(
          fontSize: r.sp(context, 15.5),
          color: const Color(0xFF5A4A68),
          height: 1.55,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: r.wp(context, 16), vertical: r.hp(context, 14)),
          border: InputBorder.none,
          hintText: 'Describe your vision...',
          hintStyle: const TextStyle(color: Color(0xFFB0A8B8)),
        ),
        cursorColor: const Color(0xFF5A4A68),
      ),
    );
  }

  // ─── Suggestion chips ─────────────────────────────────────────────────
  Widget _buildChipsWrap() {
    return Wrap(
      spacing: r.wp(context, 10),
      runSpacing: r.hp(context, 10),
      children: List.generate(_chips.length, (i) {
        final sel = _selected.contains(i);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (sel) {
                _selected.remove(i);
              } else {
                _selected.add(i);
                final cur = _controller.text.trim();
                final label = _chips[i];
                if (!cur.contains(label)) {
                  _controller.text = cur.isEmpty ? label : '$cur $label,';
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                }
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.symmetric(horizontal: r.wp(context, 15), vertical: r.hp(context, 10)),
            decoration: BoxDecoration(
              color:
                  sel
                      ? Colors.white.withOpacity(0.78)
                      : Colors.white.withOpacity(0.58),
              borderRadius: BorderRadius.circular(r.wp(context, 50)),
              border: Border.all(
                color: Colors.white.withOpacity(sel ? 0.92 : 0.68),
                width: r.wp(context, 1.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: r.wp(context, 5),
                  offset: Offset(0, r.hp(context, 2)),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  sel ? Icons.check_rounded : Icons.add_rounded,
                  size: r.wp(context, 15),
                  color:
                      sel ? const Color(0xFF2E2C5A) : const Color(0xFF5A5060),
                ),
                r.horizontalSpace(context, 5),
                Text(
                  _chips[i],
                  style: TextStyle(
                    fontSize: r.sp(context, 14),
                    fontWeight: FontWeight.w500,
                    color:
                        sel ? const Color(0xFF2E2C5A) : const Color(0xFF4A3A50),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<File> assetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');

    await file.writeAsBytes(bytes);
    return file;
  }

  Future<ui.Size> getImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return ui.Size(frameInfo.image.width.toDouble(), frameInfo.image.height.toDouble());
  }

  Future<ui.Size> getAssetImageSize(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return ui.Size(frameInfo.image.width.toDouble(), frameInfo.image.height.toDouble());
  }

  Future<File> generateMaskFile({
    required File? pickedFile,
    required int templateIndex,
    required String selectedObject,
    List<BrushStroke>? strokes,
    double brushSize = 0.5,
  }) async {
    ui.Size size;
    if (pickedFile != null) {
      size = await getImageSize(pickedFile);
    } else if (templateIndex != -1) {
      size = await getAssetImageSize("assets/images/interior/interior_${templateIndex + 1}.jpg");
    } else {
      size = const ui.Size(512, 512);
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));

    // Fill background with black
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.black);

    // Draw mask in white
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    void drawPath(Path path) {
      canvas.drawPath(path, paint);
    }

    if (strokes != null && strokes.isNotEmpty) {
      final ratioX = size.width / 350.0;
      final ratioY = size.height / 330.0;

      for (final stroke in strokes) {
        if (stroke.points.isEmpty) continue;
        final strokePaint = Paint()
          ..color = Colors.white
          ..strokeWidth = (stroke.strokeWidth * ratioX).clamp(10.0, 120.0)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

        final strokePath = Path();
        strokePath.moveTo(
          stroke.points.first.dx * ratioX,
          stroke.points.first.dy * ratioY,
        );
        for (int i = 1; i < stroke.points.length; i++) {
          strokePath.lineTo(
            stroke.points[i].dx * ratioX,
            stroke.points[i].dy * ratioY,
          );
        }
        canvas.drawPath(strokePath, strokePaint);
      }
    } else {
      final obj = selectedObject.toLowerCase();

      if (templateIndex == 1) {
        // Bedroom template (Image 2)
        if (obj.contains('bed')) {
          final bedPath = Path()
            ..moveTo(0, size.height * 0.92)
            ..cubicTo(
              size.width * 0.25, size.height * 0.48,
              size.width * 0.65, size.height * 0.42,
              size.width, size.height * 0.48,
            )
            ..lineTo(size.width, size.height)
            ..lineTo(0, size.height)
            ..close();
          drawPath(bedPath);
        } else if (obj.contains('pillow')) {
          final pillowPath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.50, size.height * 0.42, size.width * 0.92, size.height * 0.58));
          drawPath(pillowPath);
        } else if (obj.contains('wall')) {
          final wallPath = Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, 0)
            ..lineTo(size.width, size.height * 0.45)
            ..lineTo(0, size.height * 0.45)
            ..close();
          drawPath(wallPath);
        } else if (obj.contains('nightstand')) {
          final nightstandPath = Path()
            ..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTRB(size.width * 0.05, size.height * 0.55, size.width * 0.28, size.height * 0.78),
              const Radius.circular(8),
            ));
          drawPath(nightstandPath);
        } else if (obj.contains('lamp')) {
          final lampPath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.82, size.height * 0.25, size.width * 0.95, size.height * 0.45));
          drawPath(lampPath);
        } else {
          final defaultPath = Path()
            ..moveTo(0, size.height * 0.92)
            ..cubicTo(
              size.width * 0.25, size.height * 0.48,
              size.width * 0.65, size.height * 0.42,
              size.width, size.height * 0.48,
            )
            ..lineTo(size.width, size.height)
            ..lineTo(0, size.height)
            ..close();
          drawPath(defaultPath);
        }
      } else if (templateIndex == 0 || templateIndex == 4) {
        // Living Room sofa / table templates
        if (obj.contains('sofa')) {
          final sofaPath = Path()
            ..moveTo(0, size.height * 0.48)
            ..lineTo(size.width * 0.78, size.height * 0.48)
            ..lineTo(size.width * 0.75, size.height * 0.88)
            ..lineTo(0, size.height * 0.88)
            ..close();
          drawPath(sofaPath);
        } else if (obj.contains('table')) {
          final tablePath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.28, size.height * 0.62, size.width * 0.82, size.height * 0.88));
          drawPath(tablePath);
        } else if (obj.contains('rug')) {
          final rugPath = Path()
            ..moveTo(0, size.height * 0.68)
            ..lineTo(size.width, size.height * 0.68)
            ..lineTo(size.width, size.height)
            ..lineTo(0, size.height)
            ..close();
          drawPath(rugPath);
        } else if (obj.contains('plant')) {
          final plantPath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.72, size.height * 0.38, size.width * 0.95, size.height * 0.82));
          drawPath(plantPath);
        } else if (obj.contains('wall')) {
          final wallPath = Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, 0)
            ..lineTo(size.width, size.height * 0.48)
            ..lineTo(0, size.height * 0.48)
            ..close();
          drawPath(wallPath);
        } else {
          final sofaPath = Path()
            ..moveTo(0, size.height * 0.48)
            ..lineTo(size.width * 0.78, size.height * 0.48)
            ..lineTo(size.width * 0.75, size.height * 0.88)
            ..lineTo(0, size.height * 0.88)
            ..close();
          drawPath(sofaPath);
        }
      } else {
        // General / custom images
        if (obj.contains('bed') || obj.contains('sofa')) {
          final bedPath = Path()
            ..moveTo(0, size.height * 0.90)
            ..cubicTo(
              size.width * 0.25, size.height * 0.48,
              size.width * 0.65, size.height * 0.42,
              size.width, size.height * 0.48,
            )
            ..lineTo(size.width, size.height)
            ..lineTo(0, size.height)
            ..close();
          drawPath(bedPath);
        } else if (obj.contains('table') || obj.contains('desk')) {
          final tablePath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.25, size.height * 0.55, size.width * 0.82, size.height * 0.85));
          drawPath(tablePath);
        } else if (obj.contains('wall') || obj.contains('ceiling')) {
          final wallPath = Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, 0)
            ..lineTo(size.width, size.height * 0.45)
            ..lineTo(0, size.height * 0.45)
            ..close();
          drawPath(wallPath);
        } else if (obj.contains('pillow') || obj.contains('cushion')) {
          final pillowPath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.45, size.height * 0.45, size.width * 0.85, size.height * 0.65));
          drawPath(pillowPath);
        } else if (obj.contains('mirror') || obj.contains('painting') || obj.contains('window')) {
          final mirrorPath = Path()
            ..addRRect(RRect.fromRectAndRadius(
              Rect.fromLTRB(size.width * 0.2, size.height * 0.15, size.width * 0.6, size.height * 0.45),
              const Radius.circular(12),
            ));
          drawPath(mirrorPath);
        } else if (obj.contains('plant') || obj.contains('lamp') || obj.contains('sink')) {
          final plantPath = Path()
            ..addOval(Rect.fromLTRB(size.width * 0.7, size.height * 0.35, size.width * 0.92, size.height * 0.78));
          drawPath(plantPath);
        } else {
          final defaultPath = Path()
            ..moveTo(0, size.height * 0.90)
            ..cubicTo(
              size.width * 0.25, size.height * 0.48,
              size.width * 0.65, size.height * 0.42,
              size.width, size.height * 0.48,
            )
            ..lineTo(size.width, size.height)
            ..lineTo(0, size.height)
            ..close();
          drawPath(defaultPath);
        }
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/mask_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(buffer);
    return file;
  }

  // ─── Save button ──────────────────────────────────────────────────────
  Widget _buildSaveButton(double botPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.wp(context, 22), r.hp(context, 8), r.wp(context, 22), botPad > 0 ? botPad : r.hp(context, 22)),
      child: GestureDetector(
        onTap: () async {
          if (_controller.text.trim().isEmpty) {
            showSnackError(context, 'Please enter your vision description');
            return;
          }
          if (isSubscribed == true) {
            final prefs = await SharedPreferences.getInstance();
            final userId = prefs.getString('user_id') ?? '0';

            // Get original image file
            File imageFile;
            final picked = data["picked"];
            final templateIndex = data["templateIndex"] as int? ?? -1;

            if (picked != null) {
              imageFile = picked is File ? picked : File(picked.toString());
            } else if (templateIndex != -1) {
              imageFile = await assetToFile("assets/images/interior/interior_${templateIndex + 1}.jpg");
            } else {
              showSnackError(context, 'No image found');
              return;
            }

            // Generate mask file
            final selectedObject = data["selectedObject"] as String? ?? "sofa";
            final strokes = data["strokes"] as List<BrushStroke>?;
            final brushSize = data["brushSize"] as double? ?? 0.5;

            final maskFile = await generateMaskFile(
              pickedFile: picked != null ? imageFile : null,
              templateIndex: templateIndex,
              selectedObject: selectedObject,
              strokes: strokes,
              brushSize: brushSize,
            );

            _smartReplaceCreateBloc.add(
              SmartReplaceCreateDataEvent(
                login: {
                  "user_id": int.tryParse(userId) ?? 0,
                  "prompt": _controller.text,
                },
                image: imageFile,
                mask: maskFile,
              ),
            );
          } else {
            openSubscriptionScreen(context);
          }
        },
        child: Container(
          width: double.infinity,
          height: r.hp(context, 58),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(36, 36, 36, 1),
            borderRadius: BorderRadius.circular(r.wp(context, 32)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(36, 36, 36, 1).withOpacity(0.40),
                blurRadius: r.wp(context, 22),
                offset: Offset(0, r.hp(context, 9)),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: r.sp(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD4A870),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
