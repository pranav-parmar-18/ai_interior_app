import 'dart:io';

import 'package:ai_interior/bloc/interoir_design_create/interior_design_create_bloc.dart';
import 'package:ai_interior/features/dream/presentation/dream_ash_list_screen.dart';
import 'package:ai_interior/features/dream/presentation/dream_screen.dart';
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ai_interior/utils/responsive_utils.dart';

import '../../../models/interior_design_create_model_response.dart';
import '../../../theme/app_colors.dart';
import '../../exterior/presentation/exterior_screen.dart';
import '../../home/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dream_output_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../subscription/presentation/subscription_screen_two.dart';
import '../../subscription/presentation/subscription_screen_three.dart';
import '../../../services/subscription_manager.dart';

class ColorPalette {
  final String name;
  final List<Color> colors;
  final bool isSmart;

  const ColorPalette({
    required this.name,
    required this.colors,
    this.isSmart = false,
  });
}

final List<ColorPalette> palettes = [
  const ColorPalette(name: 'Smart Tones', colors: [], isSmart: true),
  const ColorPalette(
    name: 'Modern Neutrals',
    colors: [
      Color(0xFFF0EDE8),
      Color(0xFFD4C4B0),
      Color(0xFF8A8078),
      Color(0xFF3D3530),
    ],
  ),
  const ColorPalette(
    name: 'Classic Monochrome',
    colors: [
      Color(0xFFE8E8E8),
      Color(0xFFAAAAAA),
      Color(0xFF444444),
      Color(0xFFB0B0B0),
    ],
  ),
  const ColorPalette(
    name: 'Earthy Bohemian',
    colors: [
      Color(0xFFE8D5B0),
      Color(0xFFCC7A3A),
      Color(0xFF6B8C5A),
      Color(0xFF8B5A2B),
    ],
  ),
  const ColorPalette(
    name: 'Vintage Retro',
    colors: [
      Color(0xFFE8B830),
      Color(0xFFCC4A2A),
      Color(0xFF4A7A3A),
      Color(0xFF8B2030),
      Color(0xFF3A6A8A),
    ],
  ),
  const ColorPalette(
    name: 'Scandinavian Cool',
    colors: [
      Color(0xFFECECEC),
      Color(0xFFD0D8E0),
      Color(0xFFB0BCC8),
      Color(0xFF8899A8),
    ],
  ),
  const ColorPalette(
    name: 'Soft Pastels',
    colors: [
      Color(0xFFF5EAE8),
      Color(0xFFE8C4BC),
      Color(0xFFBDD4C8),
      Color(0xFFCCDDEE),
    ],
  ),
  const ColorPalette(
    name: 'Rustic Farmhouse',
    colors: [
      Color(0xFFF0E8DC),
      Color(0xFFC09070),
      Color(0xFF7A8C70),
      Color(0xFF5A6050),
    ],
  ),
  const ColorPalette(
    name: 'Luxe Modern',
    colors: [
      Color(0xFFEADDB8),
      Color(0xFFB8A888),
      Color(0xFF2A2A2A),
      Color(0xFF1A1A1A),
    ],
  ),
  const ColorPalette(
    name: 'Modern Chic',
    colors: [
      Color(0xFFE8E4E0),
      Color(0xFF8A8A8A),
      Color(0xFF3A3A3A),
      Color(0xFF1A1A1A),
    ],
  ),
  const ColorPalette(
    name: 'Industrial Chic',
    colors: [
      Color(0xFFD8D8D4),
      Color(0xFF8A9AA8),
      Color(0xFF3A4A58),
      Color(0xFFB07050),
    ],
  ),
  const ColorPalette(
    name: 'Warm Earth Tones',
    colors: [
      Color(0xFFE8C898),
      Color(0xFFC87840),
      Color(0xFF8A6040),
      Color(0xFFB85030),
    ],
  ),
  const ColorPalette(
    name: 'Luxe & Glam',
    colors: [
      Color(0xFFF5E8DC),
      Color(0xFFC89898),
      Color(0xFF6A3A78),
      Color(0xFF1A2840),
      Color(0xFF0A0A0A),
    ],
  ),
  const ColorPalette(
    name: 'Coastal Breeze',
    colors: [
      Color(0xFFF2ECD8),
      Color(0xFF90D4D0),
      Color(0xFF4A9CC0),
      Color(0xFFA8B8B0),
    ],
  ),
  const ColorPalette(
    name: 'Nature Harmony',
    colors: [
      Color(0xFF9AB898),
      Color(0xFFB89070),
      Color(0xFF8A9878),
      Color(0xFF607868),
    ],
  ),
  const ColorPalette(
    name: 'Coastal Serenity',
    colors: [
      Color(0xFFF4EDE0),
      Color(0xFFB8D4E4),
      Color(0xFF5890B0),
      Color(0xFF2A5878),
    ],
  ),
  const ColorPalette(
    name: 'Earth & Sky',
    colors: [
      Color(0xFFF0E0D0),
      Color(0xFFD0B898),
      Color(0xFF78A060),
      Color(0xFF90B8C8),
      Color(0xFF2A4A68),
    ],
  ),
  const ColorPalette(
    name: 'Futuristic Minimalism',
    colors: [
      Color(0xFFE0E4E8),
      Color(0xFF2A88C8),
      Color(0xFF0A0A0A),
      Color(0xFF00C8A8),
    ],
  ),
  const ColorPalette(
    name: 'Vintage Retro',
    colors: [
      Color(0xFFE8B830),
      Color(0xFFCC4A2A),
      Color(0xFF4A7A3A),
      Color(0xFF8B2030),
    ],
  ),
  const ColorPalette(
    name: 'Dark Academia',
    colors: [
      Color(0xFFE8D8C0),
      Color(0xFF9A6840),
      Color(0xFF2A4028),
      Color(0xFF180808),
    ],
  ),
  const ColorPalette(
    name: 'Japandi Serenity',
    colors: [
      Color(0xFFF0E8DC),
      Color(0xFFD8C0A8),
      Color(0xFF8A7868),
      Color(0xFF504030),
    ],
  ),
];

class DreamColorPaletteScreen extends StatefulWidget {
  const DreamColorPaletteScreen({super.key});

  static const routeName = "/dream-color-palette-screen";

  @override
  State<DreamColorPaletteScreen> createState() =>
      _DreamColorPaletteScreenState();
}

class _DreamColorPaletteScreenState
    extends State<DreamColorPaletteScreen> {
  bool? isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscriptionActive();
  }

  Future<bool> openSubscriptionScreen(BuildContext context) async {
    final subscribed = await SubscriptionScreenManager.openSubscriptionScreen(context);
    if (mounted) {
      setState(() {
        isSubscribed = subscribed;
      });
    }
    return subscribed;
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

  final InteriorDeignCreateBloc _interiorDeignCreateBloc =
      InteriorDeignCreateBloc();
  InteriorDesignCreateModelResponse? interiorDesignCreateModelResponse;
  String? _selectedPalette;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InteriorDeignCreateBloc, InteriorDeignCreateState>(
      bloc: _interiorDeignCreateBloc,
      listener: (context, state) {
        if (state is InteriorDeignCreateSuccessState) {
          interiorDesignCreateModelResponse = state.login;
          int currentCredits = int.tryParse(creditsNotifier.value) ?? 0;
          final newCredits = (currentCredits - 50).clamp(0, 999999).toString();
          creditsNotifier.value = newCredits;
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('credits', newCredits);
          });
          Navigator.of(context).pushNamed(
            DreamOutputScreen.routeName,
            arguments: {
              "image":
                  interiorDesignCreateModelResponse?.data?.outputImage ?? "",
              "prompt": interiorDesignCreateModelResponse?.data?.prompt ?? "",
              "spaceType":
                  interiorDesignCreateModelResponse?.data?.spaceType ?? "",
              "color": interiorDesignCreateModelResponse?.data?.colors ?? "",
              "designAsth":
                  interiorDesignCreateModelResponse?.data?.designAsthetic ?? "",
              "id": interiorDesignCreateModelResponse?.data?.id ?? "",
              "module_id": 1,
            },
          );
        } else if (state is InteriorDeignCreateFailureState) {
          showSnackError(
            context,
            state.message.isNotEmpty ? state.message : "Please try once again",
          );
        } else if (state is InteriorDeignCreateExceptionState) {
          showSnackError(context, "Please try once again");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F3EF),
          body:
              state is InteriorDeignCreateLoadingState
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(
                          "assets/gifs/loading.gif",
                          height: r.adaptiveValue(context, mobile: 250, tablet: 350),
                        ),
                        SizedBox(height: r.hp(context, 10)),
                        Text(
                          "Bringing your vision to life...",
                          style: TextStyle(
                            fontSize: r.sp(context, 16),
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(90, 106, 117, 1),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.wp(context, 30.0)),
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
                        SizedBox(height: r.hp(context, 40)),
                      ],
                    )
                  : SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppBar(),
                          _buildProgressBar(),
                          _buildTitle(),
                          Expanded(child: _buildList()),
                          _buildGenerateButton(),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────


  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 10), vertical: r.hp(context, 6)),
      child: LinearProgressIndicator(
        value: 1,
        minHeight: r.hp(context, 3),
        backgroundColor: const Color(0xFFE0DDD8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.wp(context, 16), r.hp(context, 8), r.wp(context, 16), 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: r.adaptiveValue(context, mobile: 36, tablet: 44),
              height: r.adaptiveValue(context, mobile: 36, tablet: 44),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: r.sp(context, 20),
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Create Space',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: r.sp(context, 24),
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Coin badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: r.wp(context, 10), vertical: r.hp(context, 5)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 20, tablet: 24)),
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
                  height: r.adaptiveValue(context, mobile: 25, tablet: 32),
                  width: r.adaptiveValue(context, mobile: 25, tablet: 32),
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Title ─────────────────────────────────────────────────────────────────

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.wp(context, 16), r.hp(context, 10), r.wp(context, 16), r.hp(context, 8)),
      child: Text(
        'Choose colors for your room',
        style: TextStyle(
          fontSize: r.sp(context, 20),
          fontWeight: FontWeight.w600,
          color: AppColors.fontColor,
          letterSpacing: -0.4,
          height: 1.2,
        ),
      ),
    );
  }

  // ── Scrollable list ───────────────────────────────────────────────────────

  Widget _buildList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 12), vertical: r.hp(context, 4)),
      itemCount: palettes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final palette = palettes[index];
        final isSelected = _selectedPalette == palette.name + index.toString();
        return _buildPaletteRow(palette, isSelected, index);
      },
    );
  }

  // ── Palette row ───────────────────────────────────────────────────────────

  Widget _buildPaletteRow(ColorPalette palette, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPalette = palette.name + index.toString();
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: r.hp(context, 3)),
        padding: EdgeInsets.symmetric(horizontal: r.wp(context, 14), vertical: r.hp(context, 10)),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDE8E0) : const Color(0xFFFAF8F5),
          borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 14, tablet: 18)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE8873A).withOpacity(0.6)
                : const Color(0xFFE8E2D8),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE8873A).withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Name
            Expanded(
              child: Text(
                palette.name,
                style: TextStyle(
                  fontSize: r.sp(context, 14.5),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF2A2420),
                  letterSpacing: -0.1,
                ),
              ),
            ),
            SizedBox(width: r.wp(context, 8)),
            // Color swatches / smart icon
            palette.isSmart
                ? _buildSmartIcon()
                : _buildSwatches(palette.colors),
          ],
        ),
      ),
    );
  }

  // ── Smart Tones AI icon ───────────────────────────────────────────────────

  Widget _buildSmartIcon() {
    final double iconSize = r.adaptiveValue(context, mobile: 24, tablet: 30);
    return Container(
      width: r.adaptiveValue(context, mobile: 42, tablet: 52),
      height: r.adaptiveValue(context, mobile: 42, tablet: 52),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1A4A), Color(0xFF1A1A2A)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Colourful cube icon approximation using overlapping shapes
          CustomPaint(size: Size(iconSize, iconSize), painter: _CubePainter()),
        ],
      ),
    );
  }

  // ── Color swatches row ────────────────────────────────────────────────────

  Widget _buildSwatches(List<Color> colors) {
    // Circles overlap by 10 px
    final double size = r.adaptiveValue(context, mobile: 34.0, tablet: 42.0);
    final double overlap = r.adaptiveValue(context, mobile: 10.0, tablet: 12.0);

    final totalWidth = size + (colors.length - 1) * (size - overlap);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: List.generate(colors.length, (i) {
          return Positioned(
            left: i * (size - overlap),
            child: _ColorCircle(color: colors[i], size: size),
          );
        }),
      ),
    );
  }

  // ── Generate button ───────────────────────────────────────────────────────
  Future<File> assetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');

    await file.writeAsBytes(bytes);
    return file;
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20), vertical: r.hp(context, 12)),
      child: GestureDetector(
        onTap: () async {
          if (_selectedPalette == null || _selectedPalette!.isEmpty) {
            showSnackError(context, 'Please select a color palette');
            return;
          }
          bool active = await isSubscriptionActive();
          if (!active) {
            final purchased = await openSubscriptionScreen(context);
            if (!purchased) {
              return;
            }
          }
          final imageFile = await assetToFile(
            'assets/images/interior/interior_home.png',
          );
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('user_id') ?? '0';

          _interiorDeignCreateBloc.add(
            InteriorDeignCreateDataEvent(
              login: {
                "user_id": int.tryParse(userId) ?? 0,
                "colors": "retro",
                "design_asthetic": dreamASH,
                "space_type": dreamSpaceType,
              },
              image: extpicked != null ? extpicked ?? File("") : imageFile,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: r.hp(context, 58),
          decoration: BoxDecoration(
            color: const Color(0xFFE8C9A0),
            borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 32, tablet: 40)),
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
            'Generate',
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
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _ColorCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _CubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 24.0;

    // Top face – purple/pink
    final topPath =
        Path()
          ..moveTo(cx, cy - 8 * scale)
          ..lineTo(cx + 9 * scale, cy - 3 * scale)
          ..lineTo(cx, cy + 2 * scale)
          ..lineTo(cx - 9 * scale, cy - 3 * scale)
          ..close();
    canvas.drawPath(topPath, Paint()..color = const Color(0xFFCC44CC));

    // Left face – blue
    final leftPath =
        Path()
          ..moveTo(cx - 9 * scale, cy - 3 * scale)
          ..lineTo(cx, cy + 2 * scale)
          ..lineTo(cx, cy + 10 * scale)
          ..lineTo(cx - 9 * scale, cy + 5 * scale)
          ..close();
    canvas.drawPath(leftPath, Paint()..color = const Color(0xFF4488FF));

    // Right face – orange/yellow
    final rightPath =
        Path()
          ..moveTo(cx, cy + 2 * scale)
          ..lineTo(cx + 9 * scale, cy - 3 * scale)
          ..lineTo(cx + 9 * scale, cy + 5 * scale)
          ..lineTo(cx, cy + 10 * scale)
          ..close();
    canvas.drawPath(rightPath, Paint()..color = const Color(0xFFFF8833));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
