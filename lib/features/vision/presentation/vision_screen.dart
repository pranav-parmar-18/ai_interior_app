import 'package:flutter/material.dart';
import 'package:ai_interior/utils/responsive_utils.dart';

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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(child: _BackgroundGradient()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button row
                _buildTopBar(),

                // Title block
                _buildTitle(),

                r.verticalSpace(context, 20),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text field
                        _buildTextField(),
                        r.verticalSpace(context, 22),

                        // Suggestion chips
                        _buildChipsWrap(),
                        r.verticalSpace(context, 24),
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
        padding: EdgeInsets.only(
          right: r.wp(context, 22),
          top: r.hp(context, 10),
          bottom: r.hp(context, 4),
        ),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Icon(
            Icons.close_rounded,
            size: r.adaptiveValue(context, mobile: 26, tablet: 34),
            color: const Color(0xFFC0998A),
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
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 22)),
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
          r.verticalSpace(context, 6),
          Text(
            'Tell AI what to replace',
            style: TextStyle(
              fontSize: r.sp(context, 14),
              color: const Color(0xFF8A7A6A),
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
      fontSize: r.sp(context, 30),
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
        borderRadius: BorderRadius.circular(r.wp(context, 16)),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        minLines: 3,
        style: TextStyle(
          fontSize: r.sp(context, 15.5),
          color: const Color(0xFF6A5A80),
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: r.wp(context, 16),
            vertical: r.hp(context, 14),
          ),
          border: InputBorder.none,
          hintText: 'Describe what you want to change...',
          hintStyle: const TextStyle(color: Color(0xFFB0A0B8)),
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
      spacing: r.wp(context, 10),
      runSpacing: r.hp(context, 10),
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
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(context, 14),
              vertical: r.hp(context, 10),
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3A3060).withOpacity(0.12)
                  : Colors.white.withOpacity(0.60),
              borderRadius: BorderRadius.circular(r.wp(context, 50)),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3A3060).withOpacity(0.35)
                    : Colors.white.withOpacity(0.7),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: r.wp(context, 6),
                  offset: Offset(0, r.hp(context, 2)),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_rounded : Icons.add_rounded,
                  size: r.wp(context, 16),
                  color: isSelected
                      ? const Color(0xFF3A3060)
                      : const Color(0xFF6A5A70),
                ),
                r.horizontalSpace(context, 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: r.sp(context, 14),
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
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 20),
        r.hp(context, 12),
        r.wp(context, 20),
        botPad > 0 ? botPad : r.hp(context, 20),
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: r.adaptiveValue(context, mobile: 58, tablet: 68),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1A2E),
            borderRadius: BorderRadius.circular(r.wp(context, 32)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A2E).withOpacity(0.35),
                blurRadius: r.wp(context, 20),
                offset: Offset(0, r.hp(context, 8)),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Generate',
            style: TextStyle(
              fontSize: r.sp(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD4A870),
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
      width: r.wp(context, size),
      height: r.wp(context, size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}