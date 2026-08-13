import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import '../../credit/presentataion/credit_screen.dart';
import '../../home/presentation/home_screen.dart';
import 'replace_describe_me.dart';

import '../../../widgets/custom_imageview.dart';

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
    with TickerProviderStateMixin {
  int _selectedArea = 2;
  double _brushSize = 0.72;

  final List<BrushStroke> _strokes = [];
  final List<BrushStroke> _undoStrokes = [];
  Offset? _currentTouchPoint;

  bool _canUndo = false;
  bool _canRedo = false;
  File? _picked;

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _undoStrokes.add(_strokes.removeLast());
        _canUndo = _strokes.isNotEmpty;
        _canRedo = _undoStrokes.isNotEmpty;
      });
    }
  }

  void _redo() {
    if (_undoStrokes.isNotEmpty) {
      setState(() {
        _strokes.add(_undoStrokes.removeLast());
        _canUndo = _strokes.isNotEmpty;
        _canRedo = _undoStrokes.isNotEmpty;
      });
    }
  }


  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final AnimationController _scanCtrl;

  File? _passedPicked;
  int _passedTemplateIndex = -1;
  bool _initializedArgs = false;
  bool _detectingObjects = true;
  List<String> _detectedObjects = [];
  int _selectedAreaIndex = 0;

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

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _passedPicked = args['picked'] as File?;
        _passedTemplateIndex = args['templateIndex'] as int? ?? -1;
      }
      _initializedArgs = true;

      // Start simulated scan delay
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) {
          setState(() {
            _detectingObjects = false;
            if (_passedTemplateIndex == 0) {
              _detectedObjects = ['Sofa', 'Table', 'Plant', 'Wall', 'Rug'];
            } else if (_passedTemplateIndex == 1) {
              _detectedObjects = ['Bed', 'Pillow', 'Wall', 'Nightstand', 'Lamp'];
            } else if (_passedTemplateIndex == 2) {
              _detectedObjects = ['Bathtub', 'Mirror', 'Wall', 'Sink', 'Cabinet'];
            } else if (_passedTemplateIndex == 3) {
              _detectedObjects = ['Dining Table', 'Chair', 'Wall', 'Chandelier', 'Plant'];
            } else if (_passedTemplateIndex == 4) {
              _detectedObjects = ['Sofa', 'Table', 'Wall', 'Rug', 'Painting'];
            } else if (_passedTemplateIndex == 5) {
              _detectedObjects = ['Bed', 'Wall', 'Wardrobe', 'Carpet'];
            } else if (_passedTemplateIndex == 6) {
              _detectedObjects = ['Bathtub', 'Wall', 'Shower', 'Mirror'];
            } else if (_passedTemplateIndex == 7) {
              _detectedObjects = ['Dining Table', 'Chair', 'Wall', 'Rug'];
            } else {
              _detectedObjects = ['Sofa', 'Wall', 'Table', 'Chair', 'Plant', 'Light'];
            }
            _selectedAreaIndex = 0;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isTwoCols = MediaQuery.of(context).size.width >= 1024;
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
    final hPad = r.wp(context, 16);
    final backBtnSize = r.adaptiveValue(context, mobile: 36, tablet: 48);
    final backIconSize = r.adaptiveValue(context, mobile: 20, tablet: 28);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, r.hp(context, 8), hPad, 0),
      child: Row(
        children: [
          // Back button
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
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(width: r.wp(context, 8)),
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Replace',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
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
                  width: r.wp(context, 1),
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
                          fontSize: r.sp(context, 16),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      );
                    },
                  ),
                  r.horizontalSpace(context, 4),
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
    final hasImage = _passedPicked != null || _passedTemplateIndex != -1 || _picked != null;
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
          // Image preview & Touch Brushing Canvas (clipped strictly to image area)
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: Radius.circular(!hasImage ? 0 : 20),
            ),
            child: GestureDetector(
              onPanStart: (details) {
                if (_detectingObjects) return;
                final strokeWidth = 8.0 + _brushSize * 40.0;
                setState(() {
                  _selectedAreaIndex = -1;
                  _selectedArea = -1;
                  _strokes.add(BrushStroke(
                    points: [details.localPosition],
                    strokeWidth: strokeWidth,
                  ));
                  _undoStrokes.clear();
                  _canUndo = true;
                  _canRedo = false;
                  _currentTouchPoint = details.localPosition;
                });
              },
              onPanUpdate: (details) {
                if (_detectingObjects || _strokes.isEmpty) return;
                setState(() {
                  _strokes.last.points.add(details.localPosition);
                  _currentTouchPoint = details.localPosition;
                });
              },
              onPanEnd: (_) {
                if (_detectingObjects) return;
                setState(() {
                  _currentTouchPoint = null;
                });
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 330,
                    color: const Color(0xFFF8F6F2),
                    child: _passedPicked != null
                        ? CustomImageview(
                            imagePath: _passedPicked!.path,
                            fit: BoxFit.cover,
                          )
                        : _passedTemplateIndex != -1
                            ? CustomImageview(
                                imagePath: "assets/images/interior/interior_${_passedTemplateIndex + 1}.jpg",
                                fit: BoxFit.cover,
                              )
                            : _picked != null
                                ? CustomImageview(
                                    imagePath: _picked!.path,
                                    fit: BoxFit.cover,
                                  )
                                : CustomImageview(
                                    imagePath: "assets/images/replace_home.png",
                                    fit: BoxFit.contain,
                                  ),
                  ),
                  
                  // Highlight Overlay (only when no manual brush strokes exist and an area chip is selected)
                  if (!_detectingObjects && _strokes.isEmpty && _selectedAreaIndex >= 0 && _selectedAreaIndex < _detectedObjects.length)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _ObjectHighlightPainter(
                            selectedObject: _detectedObjects[_selectedAreaIndex],
                            templateIndex: _passedTemplateIndex,
                            isCustomImage: _passedPicked != null || _picked != null,
                            brushSize: _brushSize,
                          ),
                        ),
                      ),
                    ),

                  // Freehand iOS Brushing Overlay & Live Touch Cursor
                  if (!_detectingObjects)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _FreehandBrushPainter(
                            strokes: _strokes,
                            currentPoint: _currentTouchPoint,
                            currentBrushSize: _brushSize,
                          ),
                        ),
                      ),
                    ),

                  // AI Scan Animation overlay
                  if (_detectingObjects && hasImage)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _scanCtrl,
                        builder: (context, child) {
                          final progress = _scanCtrl.value;
                          return Stack(
                            children: [
                              // Dark tint
                              Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                              // Moving scan line
                              Positioned(
                                top: progress * 330,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3A7D7B).withOpacity(0.8),
                                        blurRadius: 12,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                    color: const Color(0xFF3A7D7B),
                                  ),
                                ),
                              ),
                              // Status panel
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'AI Detecting Objects...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
            ),
          ),

          
          if (!hasImage)
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
                onTap: _canUndo ? _undo : null,
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
                onTap: _canRedo ? _redo : null,
                child: Icon(Icons.redo_rounded,
                    size: 22,
                    color: _canRedo
                        ? const Color(0xFF5A5550)
                        : const Color(0xFFBBB8B4)),
              ),
              if (_strokes.isNotEmpty || _selectedAreaIndex != -1 || _selectedArea != -1) ...[
                const SizedBox(width: 10),
                Container(width: 1, height: 18, color: const Color(0xFFE0DDD8)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _strokes.clear();
                      _undoStrokes.clear();
                      _selectedAreaIndex = -1;
                      _selectedArea = -1;
                      _canUndo = false;
                      _canRedo = false;
                    });
                  },
                  child: const Icon(Icons.delete_outline_rounded,
                      size: 20, color: Color(0xFFD9534F)),
                ),
              ],

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
    final activeAreas = _detectedObjects.isNotEmpty ? _detectedObjects : _areas;
    final selectedIndex = _detectedObjects.isNotEmpty ? _selectedAreaIndex : _selectedArea;

    if (!r.isTablet(context)) {
      // Horizontal scroll on phones
      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: activeAreas.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => _AreaChip(
            label: activeAreas[i],
            selected: selectedIndex == i,
            onTap: () => setState(() {
              _strokes.clear();
              _undoStrokes.clear();
              _canUndo = false;
              _canRedo = false;
              if (_detectedObjects.isNotEmpty) {
                _selectedAreaIndex = (_selectedAreaIndex == i) ? -1 : i;
              } else {
                _selectedArea = (_selectedArea == i) ? -1 : i;
              }
            }),
          ),
        ),
      );
    }
    // Wrap on tablet/desktop
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        activeAreas.length,
        (i) => _AreaChip(
          label: activeAreas[i],
          selected: selectedIndex == i,
          onTap: () => setState(() {
            _strokes.clear();
            _undoStrokes.clear();
            _canUndo = false;
            _canRedo = false;
            if (_detectedObjects.isNotEmpty) {
              _selectedAreaIndex = (_selectedAreaIndex == i) ? -1 : i;
            } else {
              _selectedArea = (_selectedArea == i) ? -1 : i;
            }
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Single Brush Size Slider
  // ─────────────────────────────────────────────
  Widget _buildBrushSlider() {
    final sizePx = (8 + _brushSize * 40).round();

    final sliderTheme = SliderThemeData(
      trackHeight: 6,
      activeTrackColor: const Color(0xFF4A5A68),
      inactiveTrackColor: const Color(0xFFE2DFD9),
      thumbColor: const Color(0xFF4A5A68),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 3),
      overlayColor: const Color(0xFF4A5A68).withOpacity(0.12),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E5DF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Paintbrush icon container
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F1EA),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🖌️', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 8),

          // Single Brush Size Slider
          Expanded(
            child: SliderTheme(
              data: sliderTheme,
              child: Slider(
                value: _brushSize.clamp(0.0, 1.0),
                min: 0.0,
                max: 1.0,
                onChanged: (v) => setState(() => _brushSize = v),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Live Size Badge with dynamic preview dot
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECE3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFDDD8CD)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: math.max(6.0, math.min(16.0, 4.0 + _brushSize * 12.0)),
                  height: math.max(6.0, math.min(16.0, 4.0 + _brushSize * 12.0)),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A5A68),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$sizePx px',
                  style: TextStyle(
                    fontSize: r.sp(context, 12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3A3632),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          final activeAreas = _detectedObjects.isNotEmpty ? _detectedObjects : _areas;
          final selectedIndex = _detectedObjects.isNotEmpty ? _selectedAreaIndex : _selectedArea;
          final selectedObject = (selectedIndex >= 0 && selectedIndex < activeAreas.length)
              ? activeAreas[selectedIndex]
              : 'custom area';

          Navigator.of(context).pushNamed(
            ReplaceDescribeVisionScreen.routeName,
            arguments: {
              "picked": _passedPicked ?? _picked,
              "templateIndex": _passedTemplateIndex,
              "selectedObject": selectedObject,
              "strokes": List<BrushStroke>.from(_strokes),
              "brushSize": _brushSize,
            },
          );
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
class _ObjectHighlightPainter extends CustomPainter {
  _ObjectHighlightPainter({
    required this.selectedObject,
    required this.templateIndex,
    required this.isCustomImage,
    this.brushSize = 0.5,
  });

  final String selectedObject;
  final int templateIndex;
  final bool isCustomImage;
  final double brushSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    final maskPaint = Paint()
      ..color = const Color(0xFF5CA39E).withOpacity(0.65)
      ..style = PaintingStyle.fill;

    void highlightPath(Path path) {
      canvas.drawPath(path, maskPaint);
    }

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
        highlightPath(bedPath);
      } else if (obj.contains('pillow')) {
        final pillowPath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.50, size.height * 0.42, size.width * 0.92, size.height * 0.58));
        highlightPath(pillowPath);
      } else if (obj.contains('wall')) {
        final wallPath = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.45)
          ..lineTo(0, size.height * 0.45)
          ..close();
        highlightPath(wallPath);
      } else if (obj.contains('nightstand')) {
        final nightstandPath = Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(size.width * 0.05, size.height * 0.55, size.width * 0.28, size.height * 0.78),
            const Radius.circular(8),
          ));
        highlightPath(nightstandPath);
      } else if (obj.contains('lamp')) {
        final lampPath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.82, size.height * 0.25, size.width * 0.95, size.height * 0.45));
        highlightPath(lampPath);
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
        highlightPath(defaultPath);
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
        highlightPath(sofaPath);
      } else if (obj.contains('table')) {
        final tablePath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.28, size.height * 0.62, size.width * 0.82, size.height * 0.88));
        highlightPath(tablePath);
      } else if (obj.contains('rug')) {
        final rugPath = Path()
          ..moveTo(0, size.height * 0.68)
          ..lineTo(size.width, size.height * 0.68)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        highlightPath(rugPath);
      } else if (obj.contains('plant')) {
        final plantPath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.72, size.height * 0.38, size.width * 0.95, size.height * 0.82));
        highlightPath(plantPath);
      } else if (obj.contains('wall')) {
        final wallPath = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.48)
          ..lineTo(0, size.height * 0.48)
          ..close();
        highlightPath(wallPath);
      } else {
        final sofaPath = Path()
          ..moveTo(0, size.height * 0.48)
          ..lineTo(size.width * 0.78, size.height * 0.48)
          ..lineTo(size.width * 0.75, size.height * 0.88)
          ..lineTo(0, size.height * 0.88)
          ..close();
        highlightPath(sofaPath);
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
        highlightPath(bedPath);
      } else if (obj.contains('table') || obj.contains('desk')) {
        final tablePath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.25, size.height * 0.55, size.width * 0.82, size.height * 0.85));
        highlightPath(tablePath);
      } else if (obj.contains('wall') || obj.contains('ceiling')) {
        final wallPath = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.45)
          ..lineTo(0, size.height * 0.45)
          ..close();
        highlightPath(wallPath);
      } else if (obj.contains('pillow') || obj.contains('cushion')) {
        final pillowPath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.45, size.height * 0.45, size.width * 0.85, size.height * 0.65));
        highlightPath(pillowPath);
      } else if (obj.contains('mirror') || obj.contains('painting') || obj.contains('window')) {
        final mirrorPath = Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromLTRB(size.width * 0.2, size.height * 0.15, size.width * 0.6, size.height * 0.45),
            const Radius.circular(12),
          ));
        highlightPath(mirrorPath);
      } else if (obj.contains('plant') || obj.contains('lamp') || obj.contains('sink')) {
        final plantPath = Path()
          ..addOval(Rect.fromLTRB(size.width * 0.7, size.height * 0.35, size.width * 0.92, size.height * 0.78));
        highlightPath(plantPath);
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
        highlightPath(defaultPath);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ObjectHighlightPainter oldDelegate) {
    return oldDelegate.selectedObject != selectedObject ||
        oldDelegate.templateIndex != templateIndex ||
        oldDelegate.isCustomImage != isCustomImage ||
        oldDelegate.brushSize != brushSize;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Brush Stroke Model & iOS-inspired Freehand Brush Painter
// ─────────────────────────────────────────────────────────────────────────────
class BrushStroke {
  final List<Offset> points;
  final double strokeWidth;

  BrushStroke({
    required this.points,
    required this.strokeWidth,
  });
}

class _FreehandBrushPainter extends CustomPainter {
  final List<BrushStroke> strokes;
  final Offset? currentPoint;
  final double currentBrushSize;

  _FreehandBrushPainter({
    required this.strokes,
    this.currentPoint,
    required this.currentBrushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      // Cutout paint (removes/erases object image content underneath stroke)
      final cutoutFillPaint = Paint()
        ..color = const Color(0xFFF0ECE3)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      // Glow paint (outer soft mask border)
      final glowPaint = Paint()
        ..color = const Color(0xFF3A7D7B).withOpacity(0.35)
        ..strokeWidth = stroke.strokeWidth + 6.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      // Core mask paint
      final corePaint = Paint()
        ..color = const Color(0xFF3A7D7B).withOpacity(0.6)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, cutoutFillPaint);
        canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, corePaint);
      } else {
        final path = Path();
        path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
        for (int i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }
        canvas.drawPath(path, cutoutFillPaint);
        canvas.drawPath(path, glowPaint);
        canvas.drawPath(path, corePaint);
      }
    }

    // Live iOS touch cursor ring when dragging finger
    if (currentPoint != null) {
      final radius = (8.0 + currentBrushSize * 40.0) / 2.0;

      final cursorBg = Paint()
        ..color = const Color(0xFF3A7D7B).withOpacity(0.35)
        ..style = PaintingStyle.fill;

      final cursorOuterRing = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke;

      final cursorRing = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(currentPoint!, radius, cursorBg);
      canvas.drawCircle(currentPoint!, radius, cursorOuterRing);
      canvas.drawCircle(currentPoint!, radius, cursorRing);
    }
  }

  @override
  bool shouldRepaint(covariant _FreehandBrushPainter oldDelegate) => true;
}

