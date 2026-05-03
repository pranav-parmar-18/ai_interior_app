import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'exterior_plaate.dart';

class ExteriorDescribeVisionScreen extends StatefulWidget {
  const ExteriorDescribeVisionScreen({super.key});

  static const routeName = "/ext-describe-vision";

  @override
  State<ExteriorDescribeVisionScreen> createState() =>
      _ExteriorDescribeVisionScreenState();
}

class _ExteriorDescribeVisionScreenState
    extends State<ExteriorDescribeVisionScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'Transform my living room into a cozy aesthetic.',
  );

  final Set<int> _selected = {};

  final List<String> _chips = [
    'Maximalist',
    'Monochrome',
    'Soft',
    'Cinematic Photo',
    'Avant-Garde',
    'Colorful',
    'Eclectic',
    'High Quality',
    'Ultrarealistic',
    'Hollywood Glam',
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        // Scaffold bg transparent so our gradient Container fills everything
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // ── Exact 3-stop gradient from spec ───────────────────────────
          // rgba(248, 246, 244, 1)   → #F8F6F4   fully opaque
          // rgba(202, 184, 158, 0.75)→ #CAB89E at 75% → blended on white: #D5C9B7 approx
          // rgba(90,  106, 117, 0.85)→ #5A6A75 at 85% → blended on white: #748490 approx
          //
          // Because Flutter gradient colors are composited over the scaffold
          // (which is transparent → black by default), we need to bake the
          // alpha directly into the color values, blending against white:
          //   result = alpha * fg + (1-alpha) * white
          // Stop 1: fully opaque  → Color(0xFFF8F6F4)
          // Stop 2: 0.75 on white → 0.75*(202,184,158) + 0.25*(255,255,255) = (215,201,182) = #D7C9B6
          // Stop 3: 0.85 on white → 0.85*(90,106,117)  + 0.15*(255,255,255) = (115,128,138) = #73808A
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F6F4), // rgba(248, 246, 244, 1.00) — spec stop 1
                Color(0xFFD7C9B6), // rgba(202, 184, 158, 0.75) — spec stop 2
                Color(0xFF73808A), // rgba(90,  106, 117, 0.85) — spec stop 3
              ],
              stops: [0.0, 0.48, 1.0],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: topPad),

              // ── ✕ Close ─────────────────────────────────────────────
              _buildCloseRow(),

              // ── Scrollable body ──────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      _buildTitle(),
                      const SizedBox(height: 20),
                      _buildTextField(),
                      const SizedBox(height: 24),
                      _buildChipsWrap(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Save button ──────────────────────────────────────────
              _buildSaveButton(botPad),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Close button row ─────────────────────────────────────────────────
  Widget _buildCloseRow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 22, top: 14, bottom: 4),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(
            Icons.close_rounded,
            size: 24,
            color: Color(0xFFB89A7A),
          ),
        ),
      ),
    );
  }

  // ─── Title ────────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mixed-style rich text: "Describe " normal | "Your Vision" italic
        RichText(
          text: TextSpan(
            children: [
              _span('Describe ', italic: false, color: const Color(0xFF2E2C5A)),
              _span('Your ', italic: true, color: const Color(0xFF2E2C5A)),
              _span('Vision', italic: true, color: const Color(0xFFB8864A)),
            ],
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Tell AI what your preferred design aesthetic',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6A6058),
            height: 1.45,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  TextSpan _span(String text, {required bool italic, required Color color}) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 30,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
        height: 1.15,
      ),
    );
  }

  // ─── Text field ───────────────────────────────────────────────────────
  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.58), width: 1),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        minLines: 3,
        style: const TextStyle(
          fontSize: 15.5,
          color: Color(0xFF5A4A68),
          height: 1.55,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: 'Describe your vision...',
          hintStyle: TextStyle(color: Color(0xFFB0A8B8)),
        ),
        cursorColor: const Color(0xFF5A4A68),
      ),
    );
  }

  // ─── Suggestion chips ─────────────────────────────────────────────────
  Widget _buildChipsWrap() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_chips.length, (i) {
        final sel = _selected.contains(i);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (sel) {
                _selected.remove(i);
              } else {
                _selected.add(i);
                final cur = _controller.text.trim();
                final label = _chips[i];
                if (!cur.contains(label)) {
                  _controller.text = cur.isEmpty ? label : '$cur $label,';
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                }
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color:
                  sel
                      ? Colors.white.withOpacity(0.78)
                      : Colors.white.withOpacity(0.58),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withOpacity(sel ? 0.92 : 0.68),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  sel ? Icons.check_rounded : Icons.add_rounded,
                  size: 15,
                  color:
                      sel ? const Color(0xFF2E2C5A) : const Color(0xFF5A5060),
                ),
                const SizedBox(width: 5),
                Text(
                  _chips[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        sel ? const Color(0xFF2E2C5A) : const Color(0xFF4A3A50),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─── Save button ──────────────────────────────────────────────────────
  Widget _buildSaveButton(double botPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 8, 22, botPad > 0 ? botPad : 22),
      child: GestureDetector(
        onTap: () async {
          await Future.delayed(Duration(seconds: 1));
          Navigator.of(context).pushNamed(ExteriorColorPaletteScreen.routeName);
        },
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: Color.fromRGBO(36, 36, 36, 1),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(36, 36, 36, 1).withOpacity(0.40),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4A870),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
