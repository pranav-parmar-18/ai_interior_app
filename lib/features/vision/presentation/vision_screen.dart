import 'package:flutter/material.dart';

class DescribeVisionScreen extends StatefulWidget {
  const DescribeVisionScreen({super.key});

  @override
  State<DescribeVisionScreen> createState() => _DescribeVisionScreenState();
}

class _DescribeVisionScreenState extends State<DescribeVisionScreen> {

  final TextEditingController _controller = TextEditingController(
    text: 'Replace with a sleek modern sofa in neutral tones.',
  );

  final Set<String> _selected = {};

  final List<String> _suggestions = [
    'Modern Sofa',
    'Modern Pendant Light',
    'Large Wall Art',
    'Wall Sconces',
    'Sleek Decorative Mirror',
    'Bonsai Tree',
    'Retro Mini Fridge',
    'Gold Chandelier',
    'Glass Coffee Table',
    'Kitchen Island',
    'Metal Bar Stools',
    'Wood Cabinetry',
    '3D Wall Tiles',
    'Frameless Mirror',
    'Faux Fur Rug',
    'Faux Fur Rug',
    'Contemporary Wine Rack',
    'Bed Lamp',
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

    return Scaffold(
      // No scaffold background — we paint our own gradient
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Full-screen warm blurred gradient bg ──────────────────
          Positioned.fill(child: _BackgroundGradient()),

          // ── Content ───────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button row
                _buildTopBar(),

                // Title block
                _buildTitle(),

                const SizedBox(height: 20),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text field
                        _buildTextField(),
                        const SizedBox(height: 22),

                        // Suggestion chips
                        _buildChipsWrap(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Generate button
                _buildGenerateButton(botPad),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Top bar (close ×)
  // ───────────────────────────────────────────────
  Widget _buildTopBar() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 22, top: 10, bottom: 4),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(
            Icons.close_rounded,
            size: 26,
            color: Color(0xFFC0998A),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Title
  // ───────────────────────────────────────────────
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Describe Your Vision" — mixed weight italic serif feel
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Describe ',
                  style: _titleStyle(italic: false),
                ),
                TextSpan(
                  text: 'Your ',
                  style: _titleStyle(italic: true),
                ),
                TextSpan(
                  text: 'Vision',
                  style: _titleStyle(italic: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tell AI what to replace',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A7A6A),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _titleStyle({required bool italic}) {
    return TextStyle(
      fontFamily: 'Georgia',
      fontSize: 30,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF3A3060),
      letterSpacing: -0.3,
      height: 1.15,
    );
  }

  // ───────────────────────────────────────────────
  // Text field
  // ───────────────────────────────────────────────
  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        minLines: 3,
        style: const TextStyle(
          fontSize: 15.5,
          color: Color(0xFF6A5A80),
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: 'Describe what you want to change...',
          hintStyle: TextStyle(color: Color(0xFFB0A0B8)),
        ),
        cursorColor: const Color(0xFF6A5A80),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // Chips
  // ───────────────────────────────────────────────
  Widget _buildChipsWrap() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _suggestions.asMap().entries.map((entry) {
        final idx = entry.key;
        final label = entry.value;
        final key = '$idx:$label';
        final isSelected = _selected.contains(key);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selected.remove(key);
              } else {
                _selected.add(key);
                // Also append to text field
                final current = _controller.text.trim();
                _controller.text =
                current.isEmpty ? label : '$current $label,';
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3A3060).withOpacity(0.12)
                  : Colors.white.withOpacity(0.60),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3A3060).withOpacity(0.35)
                    : Colors.white.withOpacity(0.7),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_rounded : Icons.add_rounded,
                  size: 16,
                  color: isSelected
                      ? const Color(0xFF3A3060)
                      : const Color(0xFF6A5A70),
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF3A3060)
                        : const Color(0xFF4A3A58),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ───────────────────────────────────────────────
  // Generate button
  // ───────────────────────────────────────────────
  Widget _buildGenerateButton(double botPad) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 12, 20, botPad > 0 ? botPad : 20),
      // Subtle frosted top edge
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1A2E),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A2E).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Generate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4A870),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Background: warm blurred gradient (beige → sage → warm grey)
// matching the soft bokeh look in the screenshot
// ─────────────────────────────────────────────────────────────────────────────
class _BackgroundGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFE8DC), // warm cream top-left
            Color(0xFFDDD5C8), // beige mid
            Color(0xFFC8CCBE), // sage-grey bottom-right
            Color(0xFFBFC3B5), // cool sage bottom
          ],
          stops: [0.0, 0.35, 0.70, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Soft blurred circle accents (simulate bokeh)
          Positioned(
            top: -60,
            right: -40,
            child: _BokehCircle(
                size: 220, color: const Color(0xFFD4C8B0).withOpacity(0.5)),
          ),
          Positioned(
            top: 180,
            left: -60,
            child: _BokehCircle(
                size: 180, color: const Color(0xFFC8D0C0).withOpacity(0.4)),
          ),
          Positioned(
            bottom: 100,
            right: -30,
            child: _BokehCircle(
                size: 160, color: const Color(0xFFB8C0B0).withOpacity(0.35)),
          ),
          Positioned(
            bottom: -40,
            left: 40,
            child: _BokehCircle(
                size: 200, color: const Color(0xFFD0CCBC).withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}

class _BokehCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _BokehCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}