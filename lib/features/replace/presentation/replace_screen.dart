import 'dart:io';

import 'package:ai_interior/features/snap_trip/presentation/snap_trip_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

File? picked;

class ReplaceScreen extends StatefulWidget {
  const ReplaceScreen({super.key});

  static const routeName = "/replace-screen";

  @override
  State<ReplaceScreen> createState() => _ReplaceScreenState();
}

class _ReplaceScreenState extends State<ReplaceScreen> {
  int _selectedTemplate = -1;

  final List<String> _templateColors = [
    '#E8D5C4', // Living room warm
    '#C8D8E8', // Bedroom cool
    '#8FB5A8', // Bathroom green
    '#5C6B4E', // Dark dining
  ];

  // Template placeholder colors (replace with real AssetImage in a real project)
  final List<Color> _templateSwatches = [
    const Color(0xFFE07B54), // warm orange living
    const Color(0xFFB8C8D8), // cool blue bedroom
    const Color(0xFF6B9E8F), // teal bathroom
    const Color(0xFF4A5E3A), // dark green dining
  ];

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
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  _buildSectionTitle('Upload a photo of your room'),
                  const SizedBox(height: 14),
                  _buildUploadCard(),
                  const SizedBox(height: 20),
                  _buildOrDivider(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Choose from Template'),
                  const SizedBox(height: 14),
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

  // ─────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Replace',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Coin badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE8873A).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '200',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 4),
                CustomImageview(
                  imagePath: "assets/images/credit.png",
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinBadge() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A05A),
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
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFD4721A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.diamond_outlined,
              size: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: LinearProgressIndicator(
        value: 0.25,
        minHeight: 3,
        backgroundColor: const Color(0xFFE0DDD8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Section title
  // ─────────────────────────────────────────────
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1C1C),
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Upload Card
  // ─────────────────────────────────────────────
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
                picked != null
                    ? CustomImageview(imagePath: picked!.path)
                    : ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 330,
                        color: const Color(0xFFF8F6F2),

                        child: CustomImageview(
                          imagePath: "assets/images/replace_home.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(SnapTipsScreen.routeName);
                  },
                  child: Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD0CEC9),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: Color(0xFF5A5754),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Add Photo button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: GestureDetector(
                onTap:
                    () => showMediaSourcePicker(
                      context,
                      onFilePicked: (file) => setState(() => picked = file),
                    ),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E8DA),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 20,
                        color: Color(0xFF5A4A3A),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          fontSize: 16,
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

  /// A simple painter that mimics the isometric room illustration.
  Widget _buildIsometricRoomPlaceholder() {
    return CustomPaint(
      painter: _IsometricRoomPainter(),
      child: const SizedBox.expand(),
    );
  }

  // ─────────────────────────────────────────────
  // OR Divider
  // ─────────────────────────────────────────────
  Widget _buildOrDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFFD8D4CE))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 12,
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
    // Template data: label + accent color pairs
    final templates = [
      _TemplateData(
        'Living Room',
        const Color(0xFFE07B54),
        const Color(0xFFF5E8DF),
      ),
      _TemplateData(
        'Bedroom',
        const Color(0xFF7A9DBF),
        const Color(0xFFE0EAF4),
      ),
      _TemplateData(
        'Bathroom',
        const Color(0xFF6B9E8F),
        const Color(0xFFD5EAE5),
      ),
      _TemplateData('Dining', const Color(0xFF5C7A5A), const Color(0xFFD5E5D3)),
    ];

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final selected = _selectedTemplate == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTemplate = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 108,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background mimicking photo
                    CustomImageview(
                      imagePath: "assets/images/interior/interior_${i + 1}.jpg",
                    ),
                    if (selected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A7D7B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
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

  IconData _roomIcon(int i) {
    switch (i) {
      case 0:
        return Icons.weekend_outlined;
      case 1:
        return Icons.bed_outlined;
      case 2:
        return Icons.bathtub_outlined;
      case 3:
        return Icons.dinner_dining_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  // ─────────────────────────────────────────────
  // Next button
  // ─────────────────────────────────────────────
  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: GestureDetector(
        onTap: () {
          // Navigator.of(
          //   context,
          // ).pushNamed(InteriorRoomSelectionScreen.routeName);
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
