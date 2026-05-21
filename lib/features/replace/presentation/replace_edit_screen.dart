import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'replace_describe_me.dart';

import '../../../widgets/custom_imageview.dart';
import '../../interior/presentation/interior_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

File? _pickedGlobal;

class ReplaceEditScreen extends StatefulWidget {
  const ReplaceEditScreen({super.key});

  static const routeName = '/replace-edit-screen';

  @override
  State<ReplaceEditScreen> createState() => _ReplaceEditScreenState();
}

class _ReplaceEditScreenState extends State<ReplaceEditScreen>
    with SingleTickerProviderStateMixin {
  int _selectedArea = 2;
  double _eraserSize = 0.45;
  double _brushSize = 0.72;
  bool _canUndo = true;
  bool _canRedo = false;
  File? _picked;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  static const _areas = [
    'Mirror', 'Wall', 'Sofa', 'Table', 'Plant', 'Cabinet',
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isTablet = r.isTablet(context);
    final isTwoCols = MediaQuery.of(context).size.width >= 1024;
    final double hPad = MediaQuery.of(context).size.width >= 1024 ? MediaQuery.of(context).size.width * 0.1 : (isTablet ? 32.0 : 20.0);
    final double contentMaxWidth = MediaQuery.of(context).size.width >= 1024 ? 900.0 : double.infinity;
    final double imageHeight = MediaQuery.of(context).size.width >= 1024 ? 440.0 : (isTablet ? 380.0 : 300.0);
    final double btnHeight = MediaQuery.of(context).size.width >= 1024 ? 64.0 : (isTablet ? 60.0 : 54.0);
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: isTwoCols
              ? _buildDesktopLayout(botPad)
              : _buildMobileLayout(topPad, botPad),
        ),
      ),
    );
  }

  // ── Desktop two-column layout ──────────────────────────────────────────────
  Widget _buildDesktopLayout(double botPad) {
    final isTablet = r.isTablet(context);
    final double hPad = MediaQuery.of(context).size.width >= 1024 ? MediaQuery.of(context).size.width * 0.1 : (isTablet ? 32.0 : 20.0);
    final double contentMaxWidth = MediaQuery.of(context).size.width >= 1024 ? 900.0 : double.infinity;

    return Column(
      children: [
        _buildAppBar(),
        _buildProgressBar(),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: upload card
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 28, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Upload a photo of your room'),
                            const SizedBox(height: 16),
                            _buildUploadCard(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Right: tools
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUndoRedoRow(),
                            const SizedBox(height: 20),
                            _buildBrushLabel(),
                            const SizedBox(height: 12),
                            _buildAreaChips(),
                            const SizedBox(height: 16),
                            _buildBrushSlider(),
                            const SizedBox(height: 32),
                            _buildNextButton(botPad),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobile / tablet single-column layout ──────────────────────────────────
  Widget _buildMobileLayout(double topPad, double botPad) {
    final isTablet = r.isTablet(context);
    final double hPad = isTablet ? 32.0 : 20.0;

    return Column(
      children: [
        _buildAppBar(),
        _buildProgressBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: hPad,
                right: hPad,
                top: 22,
                bottom: botPad + 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Upload a photo of your room'),
                  const SizedBox(height: 14),
                  _buildUploadCard(),
                  const SizedBox(height: 20),
                  _buildUndoRedoRow(),
                  const SizedBox(height: 16),
                  _buildBrushLabel(),
                  const SizedBox(height: 10),
                  _buildAreaChips(),
                  const SizedBox(height: 14),
                  _buildBrushSlider(),
                ],
              ),
            ),
          ),
        ),
        // Sticky bottom button
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3EF),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            hPad, 12, hPad, botPad + 12,
          ),
          child: _buildNextButton(0),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────
  Widget _buildAppBar() {
    final isTablet = r.isTablet(context);
    final double hPad = MediaQuery.of(context).size.width >= 1024 ? MediaQuery.of(context).size.width * 0.1 : (isTablet ? 32.0 : 20.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 0),
      child: Row(
        children: [
          // Back button
          _CircleButton(
            icon: Icons.arrow_back_ios_rounded,
            iconSize: 18,
            onTap: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Replace',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          // Coin badge
          _CoinBadge(amount: 200),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Progress bar
  // ─────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: 0.25,
          minHeight: 3,
          backgroundColor: const Color(0xFFE0DDD8),
          valueColor:
          const AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Section title
  // ─────────────────────────────────────────────
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: r.sp(context, 18),
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1C1C1C),
        letterSpacing: -0.2,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Upload card
  // ─────────────────────────────────────────────
  Widget _buildUploadCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image preview
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
              Positioned(
                top: 14,
                right: 14,
                child: _CircleButton(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF5A5754),
                  borderColor: const Color(0xFFD0CEC9),
                  onTap: () {},
                ),
              ),
              if (_picked != null)
                Positioned(
                  top: 14,
                  left: 14,
                  child: _CircleButton(
                    icon: Icons.close_rounded,
                    iconColor: const Color(0xFF5A5754),
                    borderColor: const Color(0xFFD0CEC9),
                    onTap: () => setState(() => _picked = null),
                  ),
                ),
            ],
          ),
          // Add photo button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: GestureDetector(
              onTap: () => _showMediaSourcePicker(),
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
                    Icon(Icons.add_a_photo_outlined,
                        size: 20, color: Color(0xFF5A4A3A)),
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
    );
  }

  // ─────────────────────────────────────────────
  // Undo / Redo row
  // ─────────────────────────────────────────────
  Widget _buildUndoRedoRow() {
    return Row(
      children: [
        // Undo + redo pill
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap:
                _canUndo ? () => setState(() => _canUndo = false) : null,
                child: Icon(Icons.undo_rounded,
                    size: 22,
                    color: _canUndo
                        ? const Color(0xFF5A5550)
                        : const Color(0xFFBBB8B4)),
              ),
              const SizedBox(width: 10),
              Container(
                  width: 1, height: 18, color: const Color(0xFFE0DDD8)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap:
                _canRedo ? () => setState(() => _canRedo = false) : null,
                child: Icon(Icons.redo_rounded,
                    size: 22,
                    color: _canRedo
                        ? const Color(0xFF5A5550)
                        : const Color(0xFFBBB8B4)),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Info button
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFD4A870), width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.info_outline_rounded,
                size: 20, color: Color(0xFFD4A870)),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Brush label
  // ─────────────────────────────────────────────
  Widget _buildBrushLabel() {
    return Text(
      'Brush over or pick an area to edit',
      style: TextStyle(
        fontSize: r.sp(context, 15),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF2A2520),
        letterSpacing: 0.1,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Area chips (wraps on tablet/desktop)
  // ─────────────────────────────────────────────
  Widget _buildAreaChips() {
    if (!r.isTablet(context)) {
      // Horizontal scroll on phones
      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _areas.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => _AreaChip(
            label: _areas[i],
            selected: _selectedArea == i,
            onTap: () => setState(() => _selectedArea = i),
          ),
        ),
      );
    }
    // Wrap on tablet/desktop
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        _areas.length,
        (i) => _AreaChip(
          label: _areas[i],
          selected: _selectedArea == i,
          onTap: () => setState(() => _selectedArea = i),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Dual brush slider
  // ─────────────────────────────────────────────
  Widget _buildBrushSlider() {
    final sliderTheme = SliderThemeData(
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      thumbColor: const Color(0xFF4A5A68),
      activeTrackColor: const Color(0xFF4A5A68),
      inactiveTrackColor: const Color(0xFFCCC8C2),
      overlayColor: const Color(0xFF4A5A68).withOpacity(0.15),
    );

    return Row(
      children: [
        const Text('🖌️', style: TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Expanded(
          child: SliderTheme(
            data: sliderTheme,
            child: Slider(
              value: _eraserSize,
              onChanged: (v) => setState(() => _eraserSize = v),
            ),
          ),
        ),
        Container(
          width: 3,
          height: 24,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF5A6570),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: sliderTheme,
            child: Slider(
              value: _brushSize,
              onChanged: (v) => setState(() => _brushSize = v),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Next button
  // ─────────────────────────────────────────────
  Widget _buildNextButton(double extraBottom) {
    final isTablet = r.isTablet(context);
    final double btnHeight = MediaQuery.of(context).size.width >= 1024 ? 64.0 : (isTablet ? 60.0 : 54.0);

    return SizedBox(
      width: double.infinity,
      height: btnHeight,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ReplaceDescribeVisionScreen.routeName);
        },
        child: Container(
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
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: r.sp(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A3E1B),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Media picker
  // ─────────────────────────────────────────────
  void _showMediaSourcePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => _MediaSourceSheet(
        onFilePicked: (file) => setState(() => _picked = file),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconSize = 18.0,
    this.iconColor = const Color(0xFF1A1A1A),
    this.borderColor = Colors.transparent,
    this.bgColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;
  final Color iconColor;
  final Color borderColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

class _CoinBadge extends StatelessWidget {
  const _CoinBadge({required this.amount});
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            '$amount',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 22,
            height: 22,
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
}

class _AreaChip extends StatelessWidget {
  const _AreaChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF5EDE0) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? const Color(0xFFD4A870)
                : const Color(0xFFE8E4DF),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight:
            selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? const Color(0xFF8A5A20)
                : const Color(0xFF3A3530),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Room placeholder using CustomPaint (no asset dependency)
// ─────────────────────────────────────────────────────────────────────────────

class _RoomPlaceholderPainter extends StatelessWidget {
  const _RoomPlaceholderPainter({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _IsometricRoomPainter(),
      ),
    );
  }
}

class _IsometricRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + size.height * 0.05;

    // Scale factor so it fills nicely
    final s = math.min(size.width / 320, size.height / 300) * 0.95;

    void drawPath(Path p, Color c) =>
        canvas.drawPath(p, Paint()..color = c);

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF8F6F2),
    );

    // Floor
    drawPath(
      Path()
        ..moveTo(cx, cy - 80 * s)
        ..lineTo(cx + 140 * s, cy - 10 * s)
        ..lineTo(cx, cy + 70 * s)
        ..lineTo(cx - 140 * s, cy - 10 * s)
        ..close(),
      const Color(0xFFD4B896),
    );

    // Floor planks
    final plank = Paint()
      ..color = const Color(0xFFC4A882)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (int i = -3; i <= 3; i++) {
      canvas.drawLine(
        Offset(cx + i * 35 * s - 10 * s, cy - 70 * s + i * 5 * s),
        Offset(cx + i * 35 * s + 50 * s, cy + 60 * s + i * 5 * s),
        plank,
      );
    }

    // Left wall
    drawPath(
      Path()
        ..moveTo(cx - 140 * s, cy - 10 * s)
        ..lineTo(cx, cy - 80 * s)
        ..lineTo(cx, cy - 160 * s)
        ..lineTo(cx - 140 * s, cy - 90 * s)
        ..close(),
      const Color(0xFFDDD5C8),
    );

    // Right wall
    drawPath(
      Path()
        ..moveTo(cx, cy - 80 * s)
        ..lineTo(cx + 140 * s, cy - 10 * s)
        ..lineTo(cx + 140 * s, cy - 90 * s)
        ..lineTo(cx, cy - 160 * s)
        ..close(),
      const Color(0xFFC8BFB0),
    );

    // Dark slat panel
    drawPath(
      Path()
        ..moveTo(cx - 140 * s, cy - 90 * s)
        ..lineTo(cx - 88 * s, cy - 118 * s)
        ..lineTo(cx - 88 * s, cy - 26 * s)
        ..lineTo(cx - 140 * s, cy - 10 * s)
        ..close(),
      const Color(0xFF3A2E24),
    );

    // Rug
    drawPath(
      Path()
        ..moveTo(cx, cy - 20 * s)
        ..lineTo(cx + 80 * s, cy + 20 * s)
        ..lineTo(cx, cy + 55 * s)
        ..lineTo(cx - 80 * s, cy + 20 * s)
        ..close(),
      const Color(0xFFE8DFD0),
    );

    // Sofa body
    drawPath(
      Path()
        ..moveTo(cx - 72 * s, cy - 30 * s)
        ..lineTo(cx + 30 * s, cy + 28 * s)
        ..lineTo(cx + 20 * s, cy + 50 * s)
        ..lineTo(cx - 82 * s, cy - 8 * s)
        ..close(),
      const Color(0xFFEFEAE2),
    );

    // Sofa back
    drawPath(
      Path()
        ..moveTo(cx - 82 * s, cy - 8 * s)
        ..lineTo(cx - 72 * s, cy - 30 * s)
        ..lineTo(cx - 64 * s, cy - 56 * s)
        ..lineTo(cx - 74 * s, cy - 34 * s)
        ..close(),
      const Color(0xFFE0D8CC),
    );

    // Cushions
    final cushion = Paint()..color = const Color(0xFFD4A830);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - 20 * s, cy - 8 * s),
          width: 28 * s,
          height: 18 * s),
      cushion,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + 5 * s, cy + 8 * s),
          width: 26 * s,
          height: 16 * s),
      cushion,
    );

    // Coffee table
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + 20 * s, cy + 22 * s),
          width: 46 * s,
          height: 28 * s),
      Paint()..color = const Color(0xFF8EAAA0),
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + 20 * s, cy + 22 * s),
          width: 38 * s,
          height: 22 * s),
      Paint()..color = const Color(0xFFA8C4BC),
    );

    // Front sofa
    drawPath(
      Path()
        ..moveTo(cx - 30 * s, cy + 52 * s)
        ..lineTo(cx + 60 * s, cy + 10 * s)
        ..lineTo(cx + 68 * s, cy + 28 * s)
        ..lineTo(cx - 22 * s, cy + 70 * s)
        ..close(),
      const Color(0xFFEFEAE2),
    );

    // TV console
    drawPath(
      Path()
        ..moveTo(cx + 80 * s, cy - 8 * s)
        ..lineTo(cx + 135 * s, cy + 24 * s)
        ..lineTo(cx + 128 * s, cy + 36 * s)
        ..lineTo(cx + 73 * s, cy + 4 * s)
        ..close(),
      const Color(0xFF2E2822),
    );

    // Wall art
    final frame = Paint()..color = const Color(0xFF2E2822);
    for (int i = 0; i < 3; i++) {
      final fx = cx - 60 * s + i * 34 * s;
      final fy = cy - 148 * s;
      canvas.drawRect(
          Rect.fromLTWH(fx, fy, 28 * s, 36 * s), frame);
      canvas.drawRect(
        Rect.fromLTWH(fx + 2 * s, fy + 2 * s, 24 * s, 32 * s),
        Paint()
          ..color = [
            const Color(0xFF4A7A40),
            const Color(0xFF3D6A34),
            const Color(0xFF4E8040)
          ][i],
      );
    }

    // Curtain
    final curtainPaint = Paint()..color = const Color(0xFFB8C4B0);
    for (int i = 0; i < 4; i++) {
      final x = cx + 60 * s + i * 16 * s;
      canvas.drawRect(
          Rect.fromLTWH(x, cy - 88 * s, 12 * s, 70 * s), curtainPaint);
    }

    // Plant
    canvas.drawRect(
      Rect.fromLTWH(cx + 118 * s, cy - 20 * s, 14 * s, 20 * s),
      Paint()..color = const Color(0xFF5A3E24),
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + 125 * s, cy - 28 * s),
          width: 24 * s,
          height: 28 * s),
      Paint()..color = const Color(0xFF5A8050),
    );

    // Wall lamp
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - 86 * s, cy - 80 * s),
          width: 16 * s,
          height: 16 * s),
      Paint()..color = const Color(0xFFE8D090),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Media source picker
// ─────────────────────────────────────────────────────────────────────────────

class _MediaSourceSheet extends StatelessWidget {
  const _MediaSourceSheet({required this.onFilePicked});
  final void Function(File) onFilePicked;

  Future<void> _takePhoto(BuildContext ctx) async {
    Navigator.of(ctx).pop();
    final x = await ImagePicker().pickImage(source: ImageSource.camera);
    if (x != null) onFilePicked(File(x.path));
  }

  Future<void> _fromGallery(BuildContext ctx) async {
    Navigator.of(ctx).pop();
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) onFilePicked(File(x.path));
  }

  Future<void> _browseFiles(BuildContext ctx) async {
    Navigator.of(ctx).pop();
    final r = await FilePicker.pickFiles();
    if (r != null && r.files.single.path != null) {
      onFilePicked(File(r.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text(
        'Choose a Media Source',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.secondaryLabel,
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => _takePhoto(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.camera, size: 22),
              SizedBox(width: 10),
              Text('Take Photo', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () => _fromGallery(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [
                    Color(0xFFFF2D55), Color(0xFFFF9500),
                    Color(0xFFFFCC00), Color(0xFF34C759),
                    Color(0xFF007AFF), Color(0xFF5856D6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(b),
                child: const Icon(CupertinoIcons.photo,
                    size: 22, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text('Choose From Photos',
                  style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () => _browseFiles(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.folder,
                  size: 22, color: Color(0xFF007AFF)),
              SizedBox(width: 10),
              Text('Browse Files', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}