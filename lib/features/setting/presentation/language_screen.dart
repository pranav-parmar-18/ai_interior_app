import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _languages = [
  'English',
  'Espanol',
  'Italian',
  'French',
  'Arabic',
  'Turkish',
  'Russian',
  'Portuguese',
  'German',
  'Filipino',
  'Japanese',
  'Korean',
  'Chinese, simplified',
  'Dutch',
];

class LanguageScreen extends StatefulWidget {

  const LanguageScreen({super.key});

  static const routeName = "/language-screen";

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'English';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: top),

          // ── Navigation header ──────────────────────────────────────────
          _Header(),

          const SizedBox(height: 16),

          // ── White card list ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _languages.length,
                    separatorBuilder:
                        (_, __) => const Divider(
                          height: 1,
                          thickness: 0.6,
                          color: Color(0xFFE0DADA),
                          indent: 16,
                          endIndent: 16,
                        ),
                    itemBuilder: (context, index) {
                      final lang = _languages[index];
                      final isSelected = lang == _selected;

                      return _LanguageRow(
                        language: lang,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selected = lang),
                        isFirst: index == 0,
                        isLast: index == _languages.length - 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: bottom + 12),

          // ── Home indicator ─────────────────────────────────────────────
          Center(
            child: Container(
              width: 130,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back chevron (left-aligned)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 30,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ),
          ),

          // Centered title
          const Text(
            'Language',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1C),
              fontFamily: 'Georgia',
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Language row ─────────────────────────────────────────────────────────────
class _LanguageRow extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _LanguageRow({
    required this.language,
    required this.isSelected,
    required this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Slightly tinted background when selected
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: const Color(0xFF1C1C1C),
                  letterSpacing: -0.1,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                size: 22,
                color: Color(0xFF1C1C1C),
              ),
          ],
        ),
      ),
    );
  }
}
