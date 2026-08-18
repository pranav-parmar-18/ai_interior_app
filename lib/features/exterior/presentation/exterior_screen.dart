import '../../credit/presentataion/credit_screen.dart';
import '../../../services/subscription_manager.dart';
import '../../../services/user_credit_service.dart';
import 'dart:io';

import 'package:ai_interior/features/snap_trip/presentation/snap_trip_screen.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home/presentation/home_screen.dart';
import '../../main/presentaion/main_screen.dart';
import 'exterior_list_screen.dart';

import 'package:image_picker/image_picker.dart';
File? extpicked;
int extSelectedTemplate = -1;

class ExteriorDesignScreen extends StatefulWidget {
  const ExteriorDesignScreen({super.key});

  static const routeName = "/exterior-design-screen";

  @override
  State<ExteriorDesignScreen> createState() => _ExteriorDesignScreenState();
}

class _ExteriorDesignScreenState extends State<ExteriorDesignScreen> {
  int _selectedTemplate = -1;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      body: Column(
        children: [
          // ── Status bar spacer + AppBar ──────────────────────────────
          SizedBox(height: topPadding),
          _buildAppBar(),

          // ── Progress bar ────────────────────────────────────────────
          _buildProgressBar(),

          // ── Scrollable content ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: r.hp(context, 24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.hp(context, 22)),
                  _buildSectionTitle('Upload a photo of your house'),
                  SizedBox(height: r.hp(context, 14)),
                  _buildUploadCard(),
                  SizedBox(height: r.hp(context, 20)),
                  _buildOrDivider(),
                  SizedBox(height: r.hp(context, 20)),
                  _buildSectionTitle('Choose from Template'),
                  SizedBox(height: r.hp(context, 14)),
                  _buildTemplateGrid(),
                ],
              ),
            ),
          ),

          // ── Next button ─────────────────────────────────────────────
          _buildNextButton(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final hPad = r.wp(context, 16);
    final titleFontSize = r.sp(context, 24);
    final iconSize = r.adaptiveValue(context, mobile: 25, tablet: 35);
    final backBtnSize = r.adaptiveValue(context, mobile: 36, tablet: 48);
    final backIconSize = r.adaptiveValue(context, mobile: 20, tablet: 28);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, r.hp(context, 8), hPad, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: backBtnSize,
              height: backBtnSize,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: backIconSize,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Exterior Design',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Coin badge
          GestureDetector(
            onTap: () async {
              await SubscriptionScreenManager.openCreditOrSubscriptionScreen(context);
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
                    builder: (context, val, child) {
                      return Text(
                        creditsNotifier.value.toString(),
                        style: TextStyle(
                          fontSize: r.sp(context, 14),
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
        ],
      ),
    );
  }

  Widget _buildCoinBadge() {
    final badgeHeight = r.hp(context, 34);
    final hPad = r.wp(context, 10);
    final fontSize = r.sp(context, 15);
    final dotSize = r.wp(context, 20);
    final iconSize = r.wp(context, 13);

    return Container(
      height: badgeHeight,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A05A),
        borderRadius: BorderRadius.circular(r.wp(context, 20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: creditsNotifier,
            builder: (context, val, child) {
              return Text(
                creditsNotifier.value.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          SizedBox(width: r.wp(context, 5)),
          Container(
            width: dotSize,
            height: dotSize,
            decoration: const BoxDecoration(
              color: Color(0xFFD4721A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.diamond_outlined,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Progress bar
  // ─────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 10),
        vertical: r.hp(context, 6),
      ),
      child: LinearProgressIndicator(
        value: 0.25,
        minHeight: r.hp(context, 3).clamp(2, 5),
        backgroundColor: const Color(0xFFE0DDD8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: r.horizontalPadding(context),
      child: Text(
        text,
        style: TextStyle(
          fontSize: r.sp(context, 18),
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1C1C),
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    final uploadImageHeight = r.clampedHeight(
      context,
      percent: 40,
      minHeight: 220,
      maxHeight: 500,
    );
    final borderRadius = r.wp(context, 20);
    final buttonHeight = r.adaptiveValue(context, mobile: 48, tablet: 58);
    final buttonFontSize = r.sp(context, 16);
    final iconSize = r.adaptiveValue(context, mobile: 20, tablet: 26);
    final infoBtnSize = r.adaptiveValue(context, mobile: 32, tablet: 42);
    final infoIconSize = r.adaptiveValue(context, mobile: 18, tablet: 24);

    return Padding(
      padding: r.horizontalPadding(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Room preview area
            Stack(
              children: [
                extpicked != null
                    ? CustomImageview(imagePath: extpicked!.path)
                    : _selectedTemplate != -1
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(borderRadius),
                            ),
                            child: CustomImageview(
                              imagePath:
                                  "assets/images/exterior/exterior_${_selectedTemplate + 1}.png",
                              width: double.infinity,
                              height: uploadImageHeight,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(borderRadius),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: uploadImageHeight,
                              color: const Color(0xFFF8F6F2),
                              child: CustomImageview(
                                imagePath:
                                    "assets/images/exterior/exterior_home.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                Positioned(
                  top: r.hp(context, 14),
                  right: r.wp(context, 14),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SnapTipsScreen.routeName);
                    },
                    child: Container(
                      width: infoBtnSize,
                      height: infoBtnSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD0CEC9),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: infoIconSize,
                        color: Color(0xFF5A5754),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Add Photo button
            Padding(
              padding: EdgeInsets.symmetric(vertical: r.hp(context, 18)),
              child: GestureDetector(
                onTap: () => showMediaSourcePicker(
                  context,
                  onFilePicked: (file) => setState(() {
                    extpicked = file;
                    _selectedTemplate = -1;
                    extSelectedTemplate = -1;
                  }),
                ),
                child: Container(
                  height: buttonHeight,
                  padding: EdgeInsets.symmetric(horizontal: r.wp(context, 32)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E8DA),
                    borderRadius: BorderRadius.circular(r.wp(context, 30)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: iconSize,
                        color: Color(0xFF5A4A3A),
                      ),
                      SizedBox(width: r.wp(context, 8)),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A4A3A),
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

  void showMediaSourcePicker(
    BuildContext context, {
    required void Function(File file) onFilePicked,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext ctx) => _MediaSourceSheet(onFilePicked: onFilePicked),
    );
  }

  // ─────────────────────────────────────────────
  // OR Divider
  // ─────────────────────────────────────────────
  Widget _buildOrDivider() {
    return Padding(
      padding: r.horizontalPadding(context),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFFD8D4CE))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.wp(context, 14)),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: r.sp(context, 12),
                fontWeight: FontWeight.w600,
                color: Color(0xFFAEA9A3),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: const Color(0xFFD8D4CE))),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Template horizontal list
  // ─────────────────────────────────────────────
  Widget _buildTemplateGrid() {
    final listHeight = r.adaptiveValue(context, mobile: 128, tablet: 170);
    final itemWidth = r.adaptiveValue(context, mobile: 108, tablet: 150);
    final checkSize = r.adaptiveValue(context, mobile: 22, tablet: 30);
    final checkIconSize = r.adaptiveValue(context, mobile: 14, tablet: 20);

    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: r.horizontalPadding(context),
        itemCount: 8,
        separatorBuilder: (_, __) => SizedBox(width: r.wp(context, 12)),
        itemBuilder: (context, i) {
          final selected = _selectedTemplate == i;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedTemplate = i;
              extSelectedTemplate = i;
              extpicked = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r.wp(context, 16)),
                border: Border.all(
                  color:
                      selected ? const Color(0xFF3A7D7B) : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(selected ? 0.12 : 0.06),
                    blurRadius: selected ? 14 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r.wp(context, 14)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background mimicking photo
                    CustomImageview(
                      imagePath: "assets/images/exterior/exterior_${i + 1}.png",
                    ),
                    if (selected)
                      Positioned(
                        top: r.hp(context, 8),
                        right: r.wp(context, 8),
                        child: Container(
                          width: checkSize,
                          height: checkSize,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A7D7B),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: checkIconSize,
                            color: Colors.white,
                          ),
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

  // ─────────────────────────────────────────────
  // Next button
  // ─────────────────────────────────────────────
  Widget _buildNextButton() {
    final buttonHeight = r.adaptiveValue(context, mobile: 58, tablet: 70);
    final buttonFontSize = r.sp(context, 18);
    final buttonRadius = r.wp(context, 32);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 20),
        vertical: r.hp(context, 12),
      ),
      child: GestureDetector(
        onTap: () {
          if (extpicked == null && _selectedTemplate == -1) {
            showSnackError(context, 'Please upload a photo or choose a template');
            return;
          }
          Navigator.of(
            context,
          ).pushNamed(ExteriorRoomSelectionScreen.routeName);
        },
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFE8C9A0),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8C9A0).withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5A3E1B),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _MediaSourceSheet extends StatelessWidget {
  const _MediaSourceSheet({required this.onFilePicked});

  final void Function(File file) onFilePicked;

  Future<void> _takePhoto(BuildContext context) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) onFilePicked(File(photo.path));
  }

  Future<void> _chooseFromPhotos(BuildContext context) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) onFilePicked(File(image.path));
  }

  Future<void> _browseFiles(BuildContext context) async {
    Navigator.of(context).pop();
    final result = await FilePicker.pickFiles();
    if (result != null && result.files.single.path != null) {
      onFilePicked(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Action sheet ──────────────────────────────────────────────────
        CupertinoActionSheet(
          title: const Text(
            'Choose a Media Source',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          actions: [
            // Take Photo
            CupertinoActionSheetAction(
              onPressed: () => _takePhoto(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.camera, size: 22),
                  SizedBox(width: 10),
                  Text('Take Photo', style: TextStyle(fontSize: 17)),
                ],
              ),
            ),

            // Choose From Photos
            CupertinoActionSheetAction(
              onPressed: () => _chooseFromPhotos(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Multicolor Photos-app icon approximation
                  ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFF2D55),
                            Color(0xFFFF9500),
                            Color(0xFFFFCC00),
                            Color(0xFF34C759),
                            Color(0xFF007AFF),
                            Color(0xFF5856D6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                    child: const Icon(
                      CupertinoIcons.photo,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Choose From Photos',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),

            // Browse Files
            CupertinoActionSheetAction(
              onPressed: () => _browseFiles(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    CupertinoIcons.folder,
                    size: 22,
                    color: Color(0xFF007AFF),
                  ),
                  SizedBox(width: 10),
                  Text('Browse Files', style: TextStyle(fontSize: 17)),
                ],
              ),
            ),
          ],

          // Cancel button
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _TemplateData {
  final String label;
  final Color accentColor;
  final Color lightColor;

  const _TemplateData(this.label, this.accentColor, this.lightColor);
}

// ─────────────────────────────────────────────────────────────────────────────
// Isometric room custom painter
// Draws a simplified top-down isometric living room to match the screenshot.
// ─────────────────────────────────────────────────────────────────────────────
class _IsometricRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    // ── Floor ──────────────────────────────────────────────────────────
    final floorPath =
        Path()
          ..moveTo(cx, cy - 80)
          ..lineTo(cx + 140, cy - 10)
          ..lineTo(cx, cy + 70)
          ..lineTo(cx - 140, cy - 10)
          ..close();
    canvas.drawPath(floorPath, Paint()..color = const Color(0xFFD4B896));

    // Floor planks (subtle lines)
    final plankPaint =
        Paint()
          ..color = const Color(0xFFC4A882)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
    for (int i = -3; i <= 3; i++) {
      canvas.drawLine(
        Offset(cx + i * 35 - 10, cy - 70 + i * 5),
        Offset(cx + i * 35 + 50, cy + 60 + i * 5),
        plankPaint,
      );
    }

    // ── Left wall ─────────────────────────────────────────────────────
    final leftWall =
        Path()
          ..moveTo(cx - 140, cy - 10)
          ..lineTo(cx, cy - 80)
          ..lineTo(cx, cy - 160)
          ..lineTo(cx - 140, cy - 90)
          ..close();
    canvas.drawPath(leftWall, Paint()..color = const Color(0xFFDDD5C8));

    // ── Right wall ────────────────────────────────────────────────────
    final rightWall =
        Path()
          ..moveTo(cx, cy - 80)
          ..lineTo(cx + 140, cy - 10)
          ..lineTo(cx + 140, cy - 90)
          ..lineTo(cx, cy - 160)
          ..close();
    canvas.drawPath(rightWall, Paint()..color = const Color(0xFFC8BFB0));

    // ── Dark slat panel on left wall ──────────────────────────────────
    final slatPath =
        Path()
          ..moveTo(cx - 140, cy - 90)
          ..lineTo(cx - 88, cy - 118)
          ..lineTo(cx - 88, cy - 26)
          ..lineTo(cx - 140, cy - 10)
          ..close();
    canvas.drawPath(slatPath, Paint()..color = const Color(0xFF3A2E24));

    // ── Rug ───────────────────────────────────────────────────────────
    final rugPath =
        Path()
          ..moveTo(cx, cy - 20)
          ..lineTo(cx + 80, cy + 20)
          ..lineTo(cx, cy + 55)
          ..lineTo(cx - 80, cy + 20)
          ..close();
    canvas.drawPath(rugPath, Paint()..color = const Color(0xFFE8DFD0));

    // ── L-shaped sofa ─────────────────────────────────────────────────
    // Main sofa body
    final sofaBody =
        Path()
          ..moveTo(cx - 72, cy - 30)
          ..lineTo(cx + 30, cy + 28)
          ..lineTo(cx + 20, cy + 50)
          ..lineTo(cx - 82, cy - 8)
          ..close();
    canvas.drawPath(sofaBody, Paint()..color = const Color(0xFFEFEAE2));

    // Sofa back
    final sofaBack =
        Path()
          ..moveTo(cx - 82, cy - 8)
          ..lineTo(cx - 72, cy - 30)
          ..lineTo(cx - 64, cy - 56)
          ..lineTo(cx - 74, cy - 34)
          ..close();
    canvas.drawPath(sofaBack, Paint()..color = const Color(0xFFE0D8CC));

    // Cushions (yellow)
    final cushionPaint = Paint()..color = const Color(0xFFD4A830);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 20, cy - 8), width: 28, height: 18),
      cushionPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 5, cy + 8), width: 26, height: 16),
      cushionPaint,
    );

    // ── Coffee table ──────────────────────────────────────────────────
    final tablePaint =
        Paint()
          ..color = const Color(0xFF8EAAA0)
          ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 20, cy + 22), width: 46, height: 28),
      tablePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 20, cy + 22), width: 38, height: 22),
      Paint()..color = const Color(0xFFA8C4BC),
    );

    // ── Small sofa (front) ────────────────────────────────────────────
    final sofaFront =
        Path()
          ..moveTo(cx - 30, cy + 52)
          ..lineTo(cx + 60, cy + 10)
          ..lineTo(cx + 68, cy + 28)
          ..lineTo(cx - 22, cy + 70)
          ..close();
    canvas.drawPath(sofaFront, Paint()..color = const Color(0xFFEFEAE2));

    // ── TV / dark console ─────────────────────────────────────────────
    final consolePath =
        Path()
          ..moveTo(cx + 80, cy - 8)
          ..lineTo(cx + 135, cy + 24)
          ..lineTo(cx + 128, cy + 36)
          ..lineTo(cx + 73, cy + 4)
          ..close();
    canvas.drawPath(consolePath, Paint()..color = const Color(0xFF2E2822));

    // ── Wall art frames ───────────────────────────────────────────────
    final framePaint = Paint()..color = const Color(0xFF2E2822);
    // Frame 1
    canvas.drawRect(Rect.fromLTWH(cx - 60, cy - 148, 28, 36), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 58, cy - 146, 24, 32),
      Paint()..color = const Color(0xFF4A7A40),
    );
    // Frame 2
    canvas.drawRect(Rect.fromLTWH(cx - 26, cy - 152, 28, 38), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 24, cy - 150, 24, 34),
      Paint()..color = const Color(0xFF3D6A34),
    );
    // Frame 3
    canvas.drawRect(Rect.fromLTWH(cx + 8, cy - 148, 26, 36), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx + 10, cy - 146, 22, 32),
      Paint()..color = const Color(0xFF4E8040),
    );

    // ── Right-wall curtain ────────────────────────────────────────────
    final curtainPaint = Paint()..color = const Color(0xFFB8C4B0);
    for (int i = 0; i < 4; i++) {
      final x = cx + 60.0 + i * 16;
      canvas.drawRect(Rect.fromLTWH(x, cy - 88, 12, 70), curtainPaint);
    }

    // ── Plant ─────────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(cx + 118, cy - 20, 14, 20),
      Paint()..color = const Color(0xFF5A3E24),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 125, cy - 28), width: 24, height: 28),
      Paint()..color = const Color(0xFF5A8050),
    );

    // ── Wall lamp ─────────────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 86, cy - 80), width: 16, height: 16),
      Paint()..color = const Color(0xFFE8D090),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
