import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _CardData {
  final Color bg;
  final Color accent;
  final Color secondary;
  final String style;
  const _CardData(this.bg, this.accent, this.secondary, this.style);
}

// Left col (3 cards) + Right col (4 cards)
const _leftCards = [
  _CardData(Color(0xFFCEC8BC), Color(0xFF7A9068), Color(0xFFD4A870), 'minimal'),
  _CardData(Color(0xFF3C3428), Color(0xFF6A7A8A), Color(0xFFD4A060), 'dark'),
  _CardData(Color(0xFFEDE8E0), Color(0xFFD4B870), Color(0xFFD8C8A8), 'boho'),
];

const _rightCards = [
  _CardData(Color(0xFF3A4A5A), Color(0xFFD4A870), Color(0xFFC8B8A0), 'modern'),
  _CardData(Color(0xFF2A2018), Color(0xFFD4A040), Color(0xFF8A6A40), 'entry'),
  _CardData(Color(0xFF8A8A78), Color(0xFFD4A850), Color(0xFF6A7A5A), 'sage'),
  _CardData(Color(0xFF3A4A30), Color(0xFF8A9870), Color(0xFFD4C0A0), 'forest'),
];

const _leftHeights  = [370.0, 390.0, 200.0];
const _rightHeights = [244.0, 268.0, 290.0, 210.0];

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _mainTab = 0;   // 0=Interior  1=Exterior
  int _catIdx  = 0;   // filter chip
  int _navIdx  = 1;   // bottom nav

  final _cats = const ['All', 'Living Room', 'Bedroom', 'Kitchen', 'Dining'];

  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F2EE),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topPad),
            _header(),
            const SizedBox(height: 18),
            _mainTabs(),
            const SizedBox(height: 16),
            _categoryChips(),
            const SizedBox(height: 14),
            Expanded(child: _grid()),
          ],
        ),
        // bottomNavigationBar: _bottomNav(botPad),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────
  Widget _header() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'AI Interior Design',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: Color(0xFFB86820),
              fontFamily: 'Georgia',
              letterSpacing: -0.4,
            ),
          ),
        ),
        _CoinBadge(),
        const SizedBox(width: 10),
        const Icon(Icons.settings_outlined, size: 26, color: Color(0xFF3A7D8A)),
      ],
    ),
  );

  // ── Interior / Exterior toggle ──────────────────────────────────────
  Widget _mainTabs() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFECE8E0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _TabPill('Interior', 0),
          _TabPill('Exterior', 1),
        ],
      ),
    ),
  );

  Widget _TabPill(String label, int idx) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _mainTab = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _mainTab == idx ? const Color(0xFFE8C898) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: _mainTab == idx
              ? [BoxShadow(color: Colors.black.withOpacity(0.09),
              blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _mainTab == idx ? const Color(0xFF5A3E18) : const Color(0xFF7A7068),
            fontFamily: 'Georgia',
          ),
        ),
      ),
    ),
  );

  // ── Category chips ──────────────────────────────────────────────────
  Widget _categoryChips() => SizedBox(
    height: 38,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _cats.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final sel = _catIdx == i;
        return GestureDetector(
          onTap: () => setState(() => _catIdx = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFF4A6A70) : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5, offset: const Offset(0, 2),
              )],
            ),
            alignment: Alignment.center,
            child: Text(_cats[i],
              style: TextStyle(
                fontSize: 14,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                color: sel ? Colors.white : const Color(0xFF3A3530),
              ),
            ),
          ),
        );
      },
    ),
  );

  // ── Masonry grid ────────────────────────────────────────────────────
  Widget _grid() => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(children: [
            for (int i = 0; i < _leftCards.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RoomCard(card: _leftCards[i], height: _leftHeights[i]),
              ),
          ]),
        ),
        const SizedBox(width: 10),
        // Right column
        Expanded(
          child: Column(children: [
            for (int i = 0; i < _rightCards.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RoomCard(card: _rightCards[i], height: _rightHeights[i]),
              ),
          ]),
        ),
      ],
    ),
  );

  // ── Bottom nav ──────────────────────────────────────────────────────
  Widget _bottomNav(double botPad) => Container(
    color: const Color(0xFFF5F2EE),
    padding: EdgeInsets.only(top: 10, bottom: botPad > 0 ? botPad : 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _NavBtn(icon: Icons.home_filled,       label: 'Home',    idx: 0, current: _navIdx, onTap: (v) => setState(() => _navIdx = v)),
        _CompassNavBtn(                         label: 'Explore', idx: 1, current: _navIdx, onTap: (v) => setState(() => _navIdx = v)),
        _NavBtn(icon: Icons.access_time_rounded,label: 'Recents', idx: 2, current: _navIdx, onTap: (v) => setState(() => _navIdx = v)),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Coin badge
// ─────────────────────────────────────────────────────────────────────────────
class _CoinBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 36,
    padding: const EdgeInsets.only(left: 12, right: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFF5A040),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('200', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(width: 6),
      Container(
        width: 24, height: 24,
        decoration: const BoxDecoration(color: Color(0xFFD4720A), shape: BoxShape.circle),
        child: const Icon(Icons.diamond, size: 14, color: Colors.white),
      ),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Room card with custom painted scene
// ─────────────────────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final _CardData card;
  final double height;
  const _RoomCard({required this.card, required this.height, super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {},
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: height,
        child: Stack(fit: StackFit.expand, children: [
          CustomPaint(painter: _ScenePainter(card)),
          // Bottom vignette
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: height * 0.3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.30), Colors.transparent],
                ),
              ),
            ),
          ),
        ]),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Scene painter — one painter handles all 7 room styles
// ─────────────────────────────────────────────────────────────────────────────
class _ScenePainter extends CustomPainter {
  final _CardData card;
  const _ScenePainter(this.card);

  @override
  void paint(Canvas canvas, Size sz) {
    final w = sz.width;
    final h = sz.height;

    // ── Background ────────────────────────────────────────────────────
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = card.bg);
    // Ceiling strip
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.10),
        Paint()..color = Color.lerp(card.bg, Colors.white, 0.15)!);
    // Floor strip
    canvas.drawRect(Rect.fromLTWH(0, h * 0.72, w, h * 0.28),
        Paint()..color = Color.lerp(card.bg, Colors.black, 0.18)!);
    // Floor-wall seam
    canvas.drawLine(Offset(0, h * 0.72), Offset(w, h * 0.72),
        Paint()..color = Colors.black.withOpacity(0.15)..strokeWidth = 1);

    switch (card.style) {
      case 'minimal': _minimal(canvas, w, h); break;
      case 'dark':    _dark(canvas, w, h);    break;
      case 'boho':    _boho(canvas, w, h);    break;
      case 'modern':  _modern(canvas, w, h);  break;
      case 'entry':   _entry(canvas, w, h);   break;
      case 'sage':    _sage(canvas, w, h);    break;
      case 'forest':  _forest(canvas, w, h);  break;
    }
  }

  // ── 1. Minimal staircase room ───────────────────────────────────────
  void _minimal(Canvas canvas, double w, double h) {
    // Large white frame/mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.28, h*0.07, w*0.44, h*0.62), const Radius.circular(4)),
      Paint()..color = Colors.white.withOpacity(0.88),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.28, h*0.07, w*0.44, h*0.62), const Radius.circular(4)),
      Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    // Stair steps inside
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(w*0.30 + i*w*0.05, h*0.42 + i*h*0.07, w*0.40 - i*w*0.06, h*0.065),
        Paint()..color = const Color(0xFFCCC4B4),
      );
    }
    // Green branches (left)
    _branch(canvas, Offset(w*0.06, h*0.14), h*0.52, const Color(0xFF6A8060));
    // Armchair
    _chair(canvas, Rect.fromLTWH(w*0.30, h*0.67, w*0.36, h*0.12),
        card.accent, card.secondary);
  }

  // ── 2. Dark living room ─────────────────────────────────────────────
  void _dark(Canvas canvas, double w, double h) {
    // Big window with blue sky
    canvas.drawRect(Rect.fromLTWH(w*0.04, h*0.10, w*0.56, h*0.44),
        Paint()..color = const Color(0xFF7A9ABE));
    // Window mullions
    final mp = Paint()..color = Colors.black.withOpacity(0.25)..strokeWidth = 1.5;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(Offset(w*0.04 + i*w*0.56/3, h*0.10), Offset(w*0.04 + i*w*0.56/3, h*0.54), mp);
    }
    canvas.drawLine(Offset(w*0.04, h*0.33), Offset(w*0.60, h*0.33), mp);
    // Wall art (rust)
    canvas.drawRect(Rect.fromLTWH(w*0.04, h*0.57, w*0.90, h*0.09),
        Paint()..color = const Color(0xFF8A5030));
    canvas.drawRect(Rect.fromLTWH(w*0.04, h*0.57, w*0.42, h*0.09),
        Paint()..color = const Color(0xFF6A3A20));
    // Sofa
    _sofa(canvas, Rect.fromLTWH(w*0.04, h*0.69, w*0.92, h*0.14), const Color(0xFFB8A880));
    // Floor lamps
    _lamp(canvas, Offset(w*0.80, h*0.57), h*0.28, card.secondary);
    _lamp(canvas, Offset(w*0.90, h*0.58), h*0.26, card.secondary);
    // Coffee table
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.24, h*0.80, w*0.44, h*0.07), const Radius.circular(4)),
      Paint()..color = const Color(0xFF5A3A20),
    );
  }

  // ── 3. Boho wall decor ──────────────────────────────────────────────
  void _boho(Canvas canvas, double w, double h) {
    // Circular woven wall art
    _weavedCircle(canvas, Offset(w*0.30, h*0.32), 30.0, card.accent);
    _weavedCircle(canvas, Offset(w*0.66, h*0.44), 22.0, card.secondary);
    // Dried pampas grass
    for (int i = 0; i < 7; i++) {
      canvas.drawLine(
        Offset(w*0.60 + i*4, h*0.72),
        Offset(w*0.56 + i*5.0 - i*1.5, h*0.42),
        Paint()..color = const Color(0xFFD4B870)..strokeWidth = 1.8,
      );
      // Fluffy head
      canvas.drawCircle(Offset(w*0.56 + i*5.0 - i*1.5, h*0.42), 5,
          Paint()..color = const Color(0xFFE0C888).withOpacity(0.7));
    }
    // Small plant left
    _plant(canvas, Offset(w*0.08, h*0.56), h*0.22, const Color(0xFF6A8860));
  }

  // ── 4. Modern open plan ─────────────────────────────────────────────
  void _modern(Canvas canvas, double w, double h) {
    // Dark left bookshelf wall
    canvas.drawRect(Rect.fromLTWH(0, 0, w*0.22, h),
        Paint()..color = const Color(0xFF22303C));
    // Shelf lines
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(Offset(0, h*0.12 + i*h*0.14), Offset(w*0.22, h*0.12 + i*h*0.14),
          Paint()..color = const Color(0xFF2E3E4A)..strokeWidth = 2);
    }
    // Large window
    canvas.drawRect(Rect.fromLTWH(w*0.22, h*0.07, w*0.78, h*0.55),
        Paint()..color = const Color(0xFF8AAAC8));
    // Tree outside window
    canvas.drawOval(Rect.fromCenter(center: Offset(w*0.72, h*0.24), width: 60, height: 80),
        Paint()..color = const Color(0xFF5A8848).withOpacity(0.7));
    // Yellow pendant lights
    for (int i = 0; i < 3; i++) {
      _pendantLight(canvas, Offset(w*0.36 + i*w*0.20, h*0.18), card.secondary);
    }
    // Sofa
    _sofa(canvas, Rect.fromLTWH(w*0.22, h*0.67, w*0.72, h*0.14), const Color(0xFFB8A888));
    // Pouf / ottoman
    canvas.drawOval(Rect.fromCenter(center: Offset(w*0.82, h*0.78), width: 30, height: 18),
        Paint()..color = const Color(0xFFD4B88A));
  }

  // ── 5. Entry / hallway ──────────────────────────────────────────────
  void _entry(Canvas canvas, double w, double h) {
    // Round mirror
    final mirrorC = Offset(w*0.50, h*0.26);
    canvas.drawCircle(mirrorC, w*0.30, Paint()..color = Colors.white.withOpacity(0.12));
    canvas.drawCircle(mirrorC, w*0.30,
        Paint()..color = const Color(0xFFD4A850)..style = PaintingStyle.stroke..strokeWidth = 4);
    canvas.drawCircle(mirrorC, w*0.26, Paint()..color = Colors.white.withOpacity(0.06));
    // Console shelf
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.08, h*0.55, w*0.62, h*0.09), const Radius.circular(4)),
      Paint()..color = const Color(0xFF8A5A30),
    );
    // Orange cushion
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.18, h*0.51, w*0.26, h*0.055), const Radius.circular(6)),
      Paint()..color = const Color(0xFFD47030),
    );
    // Green cushion
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.10, h*0.52, w*0.09, h*0.055), const Radius.circular(6)),
      Paint()..color = const Color(0xFF4A6A40),
    );
    // Tall dark vase
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.10, h*0.36, w*0.13, h*0.20), const Radius.circular(4)),
      Paint()..color = const Color(0xFF181414),
    );
    // Pampas in vase
    for (int i = 0; i < 7; i++) {
      final tx = w*0.13 + (i - 3) * 5.0;
      canvas.drawLine(Offset(w*0.165, h*0.36), Offset(tx, h*0.18),
          Paint()..color = const Color(0xFFD4C090)..strokeWidth = 1.5);
      canvas.drawCircle(Offset(tx, h*0.18), 5,
          Paint()..color = const Color(0xFFE0CC90).withOpacity(0.7));
    }
    // Yellow jacket on hook
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.72, h*0.47, w*0.14, h*0.17), const Radius.circular(8)),
      Paint()..color = const Color(0xFFE8C020),
    );
    // Green boots
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.76, h*0.67, w*0.10, h*0.09), const Radius.circular(4)),
      Paint()..color = const Color(0xFF2A4A28),
    );
    // Pink rug
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h*0.80, w, h*0.12), const Radius.circular(4)),
      Paint()..color = const Color(0xFFD4A898).withOpacity(0.55),
    );
  }

  // ── 6. Sage living room ─────────────────────────────────────────────
  void _sage(Canvas canvas, double w, double h) {
    // Sheer curtain left
    canvas.drawRect(Rect.fromLTWH(0, 0, w*0.11, h*0.78),
        Paint()..color = Colors.white.withOpacity(0.55));
    // Three rattan pendant lights
    for (int i = 0; i < 3; i++) {
      _rattanLight(canvas, Offset(w*0.24 + i*w*0.26, h*0.11));
    }
    // Gallery frames
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(Rect.fromLTWH(w*0.20 + i*w*0.22, h*0.28, w*0.18, h*0.13),
          Paint()..color = Colors.white.withOpacity(0.45));
      canvas.drawRect(Rect.fromLTWH(w*0.20 + i*w*0.22, h*0.28, w*0.18, h*0.13),
          Paint()..color = Colors.white.withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
    // Sofa
    _sofa(canvas, Rect.fromLTWH(w*0.07, h*0.60, w*0.86, h*0.14), const Color(0xFFA0A8A0));
    // Ottoman
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w*0.14, h*0.74, w*0.28, h*0.09), const Radius.circular(6)),
      Paint()..color = card.secondary,
    );
    // Round coffee table
    canvas.drawOval(Rect.fromCenter(center: Offset(w*0.60, h*0.78), width: w*0.40, height: h*0.07),
        Paint()..color = Colors.white.withOpacity(0.78));
    // Plants
    _plant(canvas, Offset(w*0.03, h*0.48), h*0.28, const Color(0xFF5A7850));
    _plant(canvas, Offset(w*0.83, h*0.52), h*0.22, const Color(0xFF4A6840));
  }

  // ── 7. Forest / dark green ──────────────────────────────────────────
  void _forest(Canvas canvas, double w, double h) {
    // Dark green accent wall (left third)
    canvas.drawRect(Rect.fromLTWH(0, 0, w*0.34, h),
        Paint()..color = const Color(0xFF263A24));
    // Floating shelf on green wall
    canvas.drawRect(Rect.fromLTWH(w*0.03, h*0.32, w*0.26, h*0.025),
        Paint()..color = const Color(0xFF6A8858));
    // Plant on shelf
    _plant(canvas, Offset(w*0.08, h*0.22), h*0.11, const Color(0xFF5A8848));
    // Large window (right side)
    canvas.drawRect(Rect.fromLTWH(w*0.34, h*0.06, w*0.66, h*0.56),
        Paint()..color = const Color(0xFF7A9A80));
    // Trees outside
    canvas.drawOval(Rect.fromCenter(center: Offset(w*0.60, h*0.20), width: 50, height: 80),
        Paint()..color = const Color(0xFF4A7840).withOpacity(0.7));
    canvas.drawOval(Rect.fromCenter(center: Offset(w*0.80, h*0.25), width: 40, height: 70),
        Paint()..color = const Color(0xFF3A6830).withOpacity(0.6));
    // Sofa
    _sofa(canvas, Rect.fromLTWH(w*0.34, h*0.65, w*0.60, h*0.13), const Color(0xFFA0A890));
  }

  // ── Shared helpers ──────────────────────────────────────────────────
  void _sofa(Canvas canvas, Rect r, Color color) {
    final dark = Color.lerp(color, Colors.black, 0.12)!;
    // Seat
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)),
        Paint()..color = color);
    // Back rest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left, r.top - r.height * 0.52, r.width, r.height * 0.55),
        const Radius.circular(8),
      ),
      Paint()..color = dark,
    );
    // Armrests
    for (final dx in [0.0, r.width * 0.92]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(r.left + dx, r.top - r.height * 0.30, r.width * 0.08, r.height * 0.80),
          const Radius.circular(6),
        ),
        Paint()..color = Color.lerp(color, Colors.black, 0.18)!,
      );
    }
  }

  void _chair(Canvas canvas, Rect r, Color seat, Color cushion) {
    final dark = Color.lerp(seat, Colors.black, 0.10)!;
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(10)),
        Paint()..color = seat);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left, r.top - r.height * 0.60, r.width, r.height * 0.62),
        const Radius.circular(10),
      ),
      Paint()..color = dark,
    );
    // Cushion
    canvas.drawOval(
      Rect.fromCenter(center: Offset(r.left + r.width*0.5, r.top + r.height*0.3),
          width: r.width*0.5, height: r.height*0.45),
      Paint()..color = cushion,
    );
  }

  void _lamp(Canvas canvas, Offset base, double height, Color color) {
    canvas.drawLine(base, Offset(base.dx, base.dy - height),
        Paint()..color = color..strokeWidth = 2);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(base.dx, base.dy - height), width: 22, height: 13),
      Paint()..color = const Color(0xFFE8D890),
    );
  }

  void _pendantLight(Canvas canvas, Offset pos, Color color) {
    canvas.drawLine(Offset(pos.dx, 0), pos,
        Paint()..color = Colors.black.withOpacity(0.3)..strokeWidth = 1);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 24, height: 28),
        Paint()..color = color);
    // Shine
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx - 4, pos.dy - 5), width: 7, height: 5),
      Paint()..color = Colors.white.withOpacity(0.30),
    );
  }

  void _rattanLight(Canvas canvas, Offset pos) {
    canvas.drawLine(Offset(pos.dx, 0), pos,
        Paint()..color = Colors.black.withOpacity(0.25)..strokeWidth = 1);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 30, height: 34),
        Paint()..color = const Color(0xFFD4A850));
    // Weave lines
    final p = Paint()..color = const Color(0xFFA87830)..strokeWidth = 1;
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(Offset(pos.dx - 14, pos.dy + i * 6), Offset(pos.dx + 14, pos.dy + i * 6), p);
    }
  }

  void _plant(Canvas canvas, Offset pos, double h, Color color) {
    // Pot
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(pos.dx - 9, pos.dy + h*0.80, 18, h*0.20), const Radius.circular(3)),
      Paint()..color = const Color(0xFF9A8870),
    );
    // Leaves
    for (int i = 0; i < 5; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(pos.dx + (i - 2) * 8.0, pos.dy + h*0.50 - i*10.0),
          width: 16, height: 30,
        ),
        Paint()..color = color,
      );
    }
  }

  void _branch(Canvas canvas, Offset origin, double len, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.8..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(origin.dx, origin.dy + len)
      ..cubicTo(origin.dx - 18, origin.dy + len*0.6,
          origin.dx + 8, origin.dy + len*0.3,
          origin.dx - 4, origin.dy);
    canvas.drawPath(path, paint);
    for (int i = 0; i < 5; i++) {
      final t = 0.25 + i * 0.16;
      final px = origin.dx + (i.isEven ? -20.0 : 16.0);
      final py = origin.dy + len * (1 - t);
      canvas.drawLine(Offset(origin.dx - 3*t, origin.dy + len*(1-t)), Offset(px, py), paint);
    }
  }

  void _weavedCircle(Canvas canvas, Offset c, double r, Color color) {
    final p = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawCircle(c, r, p);
    canvas.drawCircle(c, r * 0.65, p..strokeWidth = 1.8);
    canvas.drawCircle(c, r * 0.30, p..strokeWidth = 1.2);
    canvas.drawCircle(c, 4, Paint()..color = color);
    // Spokes
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        Offset(c.dx + r*0.30*math.cos(angle), c.dy + r*0.30*math.sin(angle)),
        Offset(c.dx + r*math.cos(angle), c.dy + r*math.sin(angle)),
        Paint()..color = color.withOpacity(0.6)..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav items
// ─────────────────────────────────────────────────────────────────────────────
class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final int idx, current;
  final ValueChanged<int> onTap;
  const _NavBtn({required this.icon, required this.label,
    required this.idx, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 80, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 26, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w400, color: color)),
      ])),
    );
  }
}

class _CompassNavBtn extends StatelessWidget {
  final String label;
  final int idx, current;
  final ValueChanged<int> onTap;
  const _CompassNavBtn({required this.label,
    required this.idx, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 80, child: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomPaint(size: const Size(28, 28), painter: _CompassPainter(color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w400, color: color)),
      ])),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final Color color;
  const _CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()..color = color..strokeWidth = 2.0..style = PaintingStyle.stroke;
    // 8-point star (compass rose)
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        Offset(cx + 4 * math.cos(angle), cy + 4 * math.sin(angle)),
        Offset(cx + 12 * math.cos(angle), cy + 12 * math.sin(angle)),
        paint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) => old.color != color;
}