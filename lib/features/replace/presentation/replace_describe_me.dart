import 'package:ai_interior/bloc/smart_replace_create/smart_replace_create_bloc.dart';
import 'package:ai_interior/bloc/smart_replace_create/smart_replace_create_bloc.dart';
import 'package:ai_interior/features/replace/presentation/replace_output_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReplaceDescribeVisionScreen extends StatefulWidget {
  const ReplaceDescribeVisionScreen({super.key});

  static const routeName = "/replace-describe-vision";

  @override
  State<ReplaceDescribeVisionScreen> createState() =>
      _ReplaceDescribeVisionScreenState();
}

class _ReplaceDescribeVisionScreenState
    extends State<ReplaceDescribeVisionScreen> {
  final SmartReplaceCreateBloc _smartReplaceCreateBloc =
      SmartReplaceCreateBloc();
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
      child: BlocConsumer<SmartReplaceCreateBloc, SmartReplaceCreateState>(
        bloc: _smartReplaceCreateBloc,
        listener: (context, state) {
          if (state is SmartReplaceCreateSuccessState) {
            Navigator.of(context).pushNamed(ReplaceOutputScreen.routeName);
          } else if (state is SmartReplaceCreateFailureState ||
              state is SmartReplaceCreateExceptionState) {}
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body:
                state is SmartReplaceCreateLoadingState
                    ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8F6F4),
                            // rgba(248, 246, 244, 1.00) — spec stop 1
                            Color(0xFFD7C9B6),
                            // rgba(202, 184, 158, 0.75) — spec stop 2
                            Color(0xFF73808A),
                            // rgba(90,  106, 117, 0.85) — spec stop 3
                          ],
                          stops: [0.0, 0.48, 1.0],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 300),
                          Image.asset("assets/gifs/loading.gif", height: 393),
                          SizedBox(height: 10),
                          Text(
                            "Bringing your vision to life...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(90, 106, 117, 1),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 150),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Text(
                              "Keep the app open & don’t lock your device. This may take around 10 seconds.",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(90, 106, 117, 1),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF8F6F4),
                            // rgba(248, 246, 244, 1.00) — spec stop 1
                            Color(0xFFD7C9B6),
                            // rgba(202, 184, 158, 0.75) — spec stop 2
                            Color(0xFF73808A),
                            // rgba(90,  106, 117, 0.85) — spec stop 3
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
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
          );
        },
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
          _smartReplaceCreateBloc.add(SmartReplaceCreateDataEvent(login: {}));
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
