import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main/presentaion/main_screen.dart';

import '../../../utils/responsive_utils.dart';
import 'interior_ash_list_screen.dart';
import 'interior_plaate.dart';

class InteriorDescribeVisionScreen extends StatefulWidget {
  const InteriorDescribeVisionScreen({super.key});

  static const routeName = "/intr-describe-vision";

  @override
  State<InteriorDescribeVisionScreen> createState() =>
      _InteriorDescribeVisionScreenState();
}

class _InteriorDescribeVisionScreenState
    extends State<InteriorDescribeVisionScreen> {
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
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
                  padding: EdgeInsets.symmetric(horizontal: r.wp(context, 22)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: r.hp(context, 2)),
                      _buildTitle(),
                      SizedBox(height: r.hp(context, 20)),
                      _buildTextField(),
                      SizedBox(height: r.hp(context, 24)),
                      _buildChipsWrap(),
                      SizedBox(height: r.hp(context, 32)),
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
        padding: EdgeInsets.only(
          right: r.wp(context, 22),
          top: r.hp(context, 14),
          bottom: r.hp(context, 4),
        ),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Icon(
            Icons.close_rounded,
            size: r.adaptiveValue(context, mobile: 24, tablet: 32),
            color: const Color(0xFFB89A7A),
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
        SizedBox(height: r.hp(context, 7)),
        Text(
          'Tell AI what your preferred design aesthetic',
          style: TextStyle(
            fontSize: r.sp(context, 14),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6A6058),
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
        fontSize: r.sp(context, 30),
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
        color: Colors.white.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(r.wp(context, 16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.58), width: 1),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        minLines: 3,
        style: TextStyle(
          fontSize: r.sp(context, 15.5),
          color: const Color(0xFF5A4A68),
          height: 1.55,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: r.wp(context, 16),
            vertical: r.hp(context, 14),
          ),
          border: InputBorder.none,
          hintText: 'Describe your vision...',
          hintStyle: const TextStyle(color: Color(0xFFB0A8B8)),
        ),
        cursorColor: const Color(0xFF5A4A68),
      ),
    );
  }

  // ─── Suggestion chips ─────────────────────────────────────────────────
  Widget _buildChipsWrap() {
    return Wrap(
      spacing: r.wp(context, 10),
      runSpacing: r.hp(context, 10),
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
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(context, 15),
              vertical: r.hp(context, 10),
            ),
            decoration: BoxDecoration(
              color: sel
                  ? Colors.white.withValues(alpha: 0.78)
                  : Colors.white.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(r.wp(context, 50)),
              border: Border.all(
                color: Colors.white.withValues(alpha: sel ? 0.92 : 0.68),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
                  size: r.adaptiveValue(context, mobile: 15, tablet: 20),
                  color: sel ? const Color(0xFF2E2C5A) : const Color(0xFF5A5060),
                ),
                SizedBox(width: r.wp(context, 5)),
                Text(
                  _chips[i],
                  style: TextStyle(
                    fontSize: r.sp(context, 14),
                    fontWeight: FontWeight.w500,
                    color: sel ? const Color(0xFF2E2C5A) : const Color(0xFF4A3A50),
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
    final btnHeight = r.adaptiveValue(context, mobile: 58, tablet: 70);
    final fontSize = r.sp(context, 18);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 22),
        r.hp(context, 8),
        r.wp(context, 22),
        botPad > 0 ? botPad : r.hp(context, 22),
      ),
      child: GestureDetector(
        onTap: () async {
          if (_controller.text.trim().isEmpty) {
            showSnackError(context, 'Please enter your vision description');
            return;
          }
          intAshType = _controller.text;
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          Navigator.of(context).pop();
        },
        child: Container(
          width: double.infinity,
          height: btnHeight,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(36, 36, 36, 1),
            borderRadius: BorderRadius.circular(r.wp(context, 32)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(36, 36, 36, 1).withValues(alpha: 0.40),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD4A870),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
