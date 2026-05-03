import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCloseButton(),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildTipsCard(),
              const SizedBox(height: 28),
              _buildPhotoSection(
                label: 'Good Photo Examples',
                isGood: true,
                imageUrls: SnapTipsScreen._goodPhotos,
              ),
              const SizedBox(height: 20),
              _buildPhotoSection(
                label: 'Bad Photos Examples',
                isGood: false,
                imageUrls: SnapTipsScreen._badPhotos,
              ),
              const SizedBox(height: 32),
            ],
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
        padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close, size: 26, color: Color(0xFF1A1A1A)),
        ),
      ),
    );
  }

  // ── Header row: icon + title ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Camera icon in rounded square container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_rounded,
                  size: 34,
                  color: Color(0xFF2A2A2A),
                ),
                // Small yellow star/sparkle badge
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCC00),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Title
          const Expanded(
            child: Text(
              'Snap Tips for Best Results',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A0A0A),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(18),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet dot
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1A1A),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Photo grid — has extra top padding for the floating label
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
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
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isGood
                                ? const Color(0xFF34C759)
                                : const Color(0xFFFF3B30),
                      ),
                      child: Icon(
                        isGood ? Icons.check_rounded : Icons.close_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
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
              child: const Icon(
                Icons.image_not_supported_rounded,
                color: Color(0xFFAAAAAA),
                size: 32,
              ),
            ),
      ),
    );
  }
}
