import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/bloc/locale/locale_cubit.dart';
import 'package:ai_interior/l10n/generated/app_localizations.dart';

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

const Map<String, String> _languageCodeMap = {
  'English': 'en',
  'Espanol': 'es',
  'Italian': 'it',
  'French': 'fr',
  'Arabic': 'ar',
  'Turkish': 'tr',
  'Russian': 'ru',
  'Portuguese': 'pt',
  'German': 'de',
  'Filipino': 'fil',
  'Japanese': 'ja',
  'Korean': 'ko',
  'Chinese, simplified': 'zh',
  'Dutch': 'nl',
};

const Map<String, String> _localeToLanguageMap = {
  'en': 'English',
  'es': 'Espanol',
  'it': 'Italian',
  'fr': 'French',
  'ar': 'Arabic',
  'tr': 'Turkish',
  'ru': 'Russian',
  'pt': 'Portuguese',
  'de': 'German',
  'fil': 'Filipino',
  'ja': 'Japanese',
  'ko': 'Korean',
  'zh': 'Chinese, simplified',
  'nl': 'Dutch',
};

class LanguageScreen extends StatefulWidget {

  const LanguageScreen({super.key});

  static const routeName = "/language-screen";

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final currentLocale = context.watch<LocaleCubit>().state;
    final currentLang = _localeToLanguageMap[currentLocale.languageCode] ?? 'English';

    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: top),

          // ── Navigation header ──────────────────────────────────────────
          _Header(),

          r.verticalSpace(context, 16),

          // ── White card list ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: r.wp(context, 16)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(r.wp(context, 16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: r.wp(context, 8),
                      offset: Offset(0, r.hp(context, 2)),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r.wp(context, 16)),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _languages.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 1,
                          thickness: 0.6,
                          color: const Color(0xFFE0DADA),
                          indent: r.wp(context, 16),
                          endIndent: r.wp(context, 16),
                        ),
                    itemBuilder: (context, index) {
                      final lang = _languages[index];
                      final isSelected = lang == currentLang;

                      return _LanguageRow(
                        language: lang,
                        isSelected: isSelected,
                        onTap: () {
                          final code = _languageCodeMap[lang] ?? 'en';
                          context.read<LocaleCubit>().changeLocale(code);
                        },
                        isFirst: index == 0,
                        isLast: index == _languages.length - 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: bottom + r.hp(context, 12)),

          // ── Home indicator ─────────────────────────────────────────────
          Center(
            child: Container(
              width: r.wp(context, 130),
              height: r.hp(context, 5),
              margin: EdgeInsets.only(bottom: r.hp(context, 8)),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(r.wp(context, 3)),
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 16),
        vertical: r.hp(context, 6),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back chevron (left-aligned)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: r.hp(context, 8),
                  horizontal: r.wp(context, 4),
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: r.adaptiveValue(context, mobile: 30, tablet: 38),
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
          ),

          // Centered title
          Text(
            l10n.language,
            style: TextStyle(
              fontSize: r.sp(context, 26),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1C1C),
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
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: r.wp(context, 20),
          vertical: r.hp(context, 18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: r.sp(context, 17),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: const Color(0xFF1C1C1C),
                  letterSpacing: -0.1,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: r.wp(context, 22),
                color: const Color(0xFF1C1C1C),
              ),
          ],
        ),
      ),
    );
  }
}
