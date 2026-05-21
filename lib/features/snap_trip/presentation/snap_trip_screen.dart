import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_interior/utils/responsive_utils.dart';

class SnapTipsScreen extends StatefulWidget {
  const SnapTipsScreen({super.key});

  static const routeName = "/snap-trip";
  static const List<String> _tips = [
    'Use natural light for best results.',
    'Take a clear, front-facing photo of the room.',
    'Avoid clutter for better AI recognition.',
    'Capture the entire space, including floors and ceilings.',
    'Use a steady hand or tripod to prevent blur.',
  ];

  static const List<String> _goodPhotos = [
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=600&q=80',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&q=80',
  ];

  static const List<String> _badPhotos = [
    'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=600&q=80',
    'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?w=600&q=80',
  ];

  @override
  State<SnapTipsScreen> createState() => _SnapTipsScreenState();
}

class _SnapTipsScreenState extends State<SnapTipsScreen> {
  @override
  Widget build(BuildContext context) {
    
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? r.wp(context, 3) : 0,
            ),
            child: isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Close button, Header, and Tips Card
                      Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCloseButton(),
                            _buildHeader(),
                            SizedBox(height: r.hp(context, 2.5)),
                            _buildTipsCard(),
                            SizedBox(height: r.hp(context, 4)),
                          ],
                        ),
                      ),
                      // Horizontal divider space
                      SizedBox(width: r.wp(context, 4)),
                      // Right Column: Good / Bad Photo Sections
                      Expanded(
                        flex: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: r.hp(context, 8)), // offset to align with header height nicely
                            _buildPhotoSection(
                              label: 'Good Photo Examples',
                              isGood: true,
                              imageUrls: SnapTipsScreen._goodPhotos,
                            ),
                            SizedBox(height: r.hp(context, 3.5)),
                            _buildPhotoSection(
                              label: 'Bad Photos Examples',
                              isGood: false,
                              imageUrls: SnapTipsScreen._badPhotos,
                            ),
                            SizedBox(height: r.hp(context, 4)),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCloseButton(),
                      _buildHeader(),
                      SizedBox(height: r.hp(context, 2.5)),
                      _buildTipsCard(),
                      SizedBox(height: r.hp(context, 3.5)),
                      _buildPhotoSection(
                        label: 'Good Photo Examples',
                        isGood: true,
                        imageUrls: SnapTipsScreen._goodPhotos,
                      ),
                      SizedBox(height: r.hp(context, 3.5)),
                      _buildPhotoSection(
                        label: 'Bad Photos Examples',
                        isGood: false,
                        imageUrls: SnapTipsScreen._badPhotos,
                      ),
                      SizedBox(height: r.hp(context, 4)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ── Close button ────────────────────────────────────────────────────────────
  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, r.hp(context, 1.5), r.wp(context, 4), 0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.close,
            size: r.adaptiveValue(context, mobile: 26.0, tablet: 32.0),
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

  // ── Header row: icon + title ─────────────────────────────────────────────
  Widget _buildHeader() {
    final double avatarSize = r.adaptiveValue(context, mobile: 64.0, tablet: 80.0);
    return Padding(
      padding: EdgeInsets.fromLTRB(r.wp(context, 5), r.hp(context, 1), r.wp(context, 5), 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Camera icon in rounded square container
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 18.0, tablet: 22.0)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: r.adaptiveValue(context, mobile: 34.0, tablet: 42.0),
                  color: const Color(0xFF2A2A2A),
                ),
                // Small yellow star/sparkle badge
                Positioned(
                  bottom: r.adaptiveValue(context, mobile: 10.0, tablet: 12.0),
                  right: r.adaptiveValue(context, mobile: 10.0, tablet: 12.0),
                  child: Container(
                    width: r.adaptiveValue(context, mobile: 16.0, tablet: 20.0),
                    height: r.adaptiveValue(context, mobile: 16.0, tablet: 20.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCC00),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: r.adaptiveValue(context, mobile: 10.0, tablet: 12.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.wp(context, 4)),
          // Title
          Expanded(
            child: Text(
              'Snap Tips for Best Results',
              style: TextStyle(
                fontSize: r.adaptiveValue(context, mobile: 24.0, tablet: 30.0),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0A0A0A),
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tips card ────────────────────────────────────────────────────────────
  Widget _buildTipsCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 4)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(r.wp(context, 5), r.hp(context, 2.2), r.wp(context, 5), r.hp(context, 2.5)),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 18.0, tablet: 22.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              SnapTipsScreen._tips.map((tip) => _buildTipItem(tip)).toList(),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: r.hp(context, 1.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet dot
          Padding(
            padding: EdgeInsets.only(top: r.hp(context, 0.8), right: r.wp(context, 2.5)),
            child: Container(
              width: r.adaptiveValue(context, mobile: 6.0, tablet: 8.0),
              height: r.adaptiveValue(context, mobile: 6.0, tablet: 8.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: r.adaptiveValue(context, mobile: 15.0, tablet: 18.0),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1A1A1A),
                height: 1.45,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Photo example section (Good / Bad) ───────────────────────────────────
  Widget _buildPhotoSection({
    required String label,
    required bool isGood,
    required List<String> imageUrls,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 4)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Photo grid — has extra top padding for the floating label
          Padding(
            padding: EdgeInsets.only(top: r.hp(context, 2.2)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(r.adaptiveValue(context, mobile: 18.0, tablet: 22.0)),
              child: Row(
                children:
                    imageUrls.map((url) {
                      return Expanded(child: _NetworkImageTile(url: url));
                    }).toList(),
              ),
            ),
          ),

          // Floating pill label centred at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.wp(context, 3.5),
                  vertical: r.hp(context, 1),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Coloured icon circle
                    Container(
                      width: r.adaptiveValue(context, mobile: 22.0, tablet: 28.0),
                      height: r.adaptiveValue(context, mobile: 22.0, tablet: 28.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isGood
                                ? const Color(0xFF34C759)
                                : const Color(0xFFFF3B30),
                      ),
                      child: Icon(
                        isGood ? Icons.check_rounded : Icons.close_rounded,
                        size: r.adaptiveValue(context, mobile: 14.0, tablet: 18.0),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: r.wp(context, 2)),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: r.adaptiveValue(context, mobile: 13.5, tablet: 16.5),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: -0.1,
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
}

// ─── Network image tile with loading / error states ───────────────────────────

class _NetworkImageTile extends StatelessWidget {
  final String url;

  const _NetworkImageTile({required this.url});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFE8E8E8),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            ),
          );
        },
        errorBuilder:
            (context, error, stack) => Container(
              color: const Color(0xFFDDDDDD),
              child: Icon(
                Icons.image_not_supported_rounded,
                color: const Color(0xFFAAAAAA),
                size: r.adaptiveValue(context, mobile: 32.0, tablet: 40.0),
              ),
            ),
      ),
    );
  }
}
