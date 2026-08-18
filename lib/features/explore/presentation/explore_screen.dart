import 'dart:math' as math;
import 'package:ai_interior/bloc/get_all_designs/get_all_designs_bloc.dart';
import 'package:ai_interior/features/explore/presentation/explore_detail_screen.dart';
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/models/get_all_exterior_design_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../bloc/get_all_exterior_designs/get_all_exterior_designs_bloc.dart';
import '../../../models/get_all_interrior_design_model_response.dart';
import '../../../widgets/custom_imageview.dart';
import '../../../services/subscription_manager.dart';
import '../../../services/user_credit_service.dart';
import '../../credit/presentataion/credit_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../setting/presentation/setting_screens.dart';
import 'package:ai_interior/l10n/generated/app_localizations.dart';

class RoomCardData {
  final String imagePath;

  const RoomCardData(this.imagePath);
}
const _interiorLeft = [
  RoomCardData('assets/rooms/minimal.jpg'),
  RoomCardData('assets/rooms/dark_living.jpg'),
  RoomCardData('assets/rooms/boho.jpg'),
];
const _interiorRight = [
  RoomCardData('assets/rooms/modern.jpg'),
  RoomCardData('assets/rooms/entry.jpg'),
  RoomCardData('assets/rooms/sage.jpg'),
  RoomCardData('assets/rooms/forest.jpg'),
];
const _exteriorLeft = [
  RoomCardData('assets/exterior/facade.jpg'),
  RoomCardData('assets/exterior/garden.jpg'),
  RoomCardData('assets/exterior/patio.jpg'),
];
const _exteriorRight = [
  RoomCardData('assets/exterior/pool.jpg'),
  RoomCardData('assets/exterior/balcony.jpg'),
  RoomCardData('assets/exterior/rooftop.jpg'),
  RoomCardData('assets/exterior/courtyard.jpg'),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  final GetAllInteriorDesignBloc _getAllInteriorDesignBloc =
      GetAllInteriorDesignBloc();
  GetAllInteriorDesignModelResponse? interiorDesignModelResponse;

  final GetAllExteriorDesignBloc _getAllExteriorDesignBloc =
      GetAllExteriorDesignBloc();
  GetAllExteriorDesignModelResponse? exteriorDesignModelResponse;
  late final TabController _tabController;

  int _catIdx = 0;
  int _navIdx = 1;

  final _interiorCats = const [
    'All',
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Dining Room',
    'Bathroom',
    'Laundry Room',
    'Home Office',
    'Study Room',
    'Dorm Room',
    'Gaming Room',
    'Attic',
    'Toilet',
    'Coffee Shop',
    'Restaurant',
    'Office',
    'Other',
  ];
  final _exteriorCats = const [
    'All',
    'House',
    'Villa',
    'Backyard',
    'Courtyard',
    'Ranch',
    'Office',
    'School',
    'Retail',
    'Tower',
    'Museum',
    'Apartment',
    'Commercial',
    'Residential',
    'Other',
  ];

  List<String> get _cats =>
      _tabController.index == 0 ? _interiorCats : _exteriorCats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)..addListener(() {
      if (_tabController.indexIsChanging) return;

      setState(() => _catIdx = 0);
      _loadDesignsForSelectedCategory();
    });
    _getAllInteriorDesignBloc.add(
      GetAllInteriorDesignDataEvent(data: {"space_type": ""}),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _getAllInteriorDesignBloc.close();
    _getAllExteriorDesignBloc.close();
    super.dispose();
  }

  String _spaceTypeForCategory(String category, {required bool isInterior}) {
    if (category == 'All') return '';
    return category.toLowerCase();
  }

  void _loadDesignsForSelectedCategory() {
    final isInterior = _tabController.index == 0;
    final currentCats = _cats;
    final safeIdx = (_catIdx >= 0 && _catIdx < currentCats.length) ? _catIdx : 0;
    final spaceType = _spaceTypeForCategory(
      currentCats[safeIdx],
      isInterior: isInterior,
    );

    if (isInterior) {
      _getAllInteriorDesignBloc.add(
        GetAllInteriorDesignDataEvent(data: {"space_type": spaceType}),
      );
    } else {
      _getAllExteriorDesignBloc.add(
        GetAllExteriorDesignDataEvent(data: {"space_type": spaceType}),
      );
    }
  }

  String _normalizeSpaceType(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  bool _matchesCategory(
    String? value,
    String category, {
    required bool isInterior,
  }) {
    final expected = _normalizeSpaceType(
      _spaceTypeForCategory(category, isInterior: isInterior),
    );
    if (expected.isEmpty) return true;

    final actual = _normalizeSpaceType(value ?? '');
    if (actual.isEmpty) return false;
    return actual == expected ||
        actual.contains(expected) ||
        expected.contains(actual);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllInteriorDesignBloc, GetAllInteriorDesignState>(
      bloc: _getAllInteriorDesignBloc,
      listener: (context, intState) {
        if (intState is GetAllInteriorDesignSuccessState) {
          interiorDesignModelResponse = intState.exploreSongResponse;
        } else if (intState is GetAllInteriorDesignExceptionState) {
          showSnackError(context, intState.message);
        }
      },
      builder: (context, intState) {
        return BlocConsumer<
          GetAllExteriorDesignBloc,
          GetAllExteriorDesignState
        >(
          bloc: _getAllExteriorDesignBloc,
          listener: (context, extState) {
            if (extState is GetAllExteriorDesignSuccessState) {
              exteriorDesignModelResponse = extState.exploreSongResponse;
            } else if (extState is GetAllExteriorDesignExceptionState ||
                extState is GetAllExteriorDesignFailureState) {
              showSnackError(context, "");
            }
          },
          builder: (context, extState) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Scaffold(
                appBar: TopBarAppBar(),
                backgroundColor: const Color(0xFFF5F2EE),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabBar(),
                    SizedBox(height: r.hp(context, 16)),

                    AnimatedBuilder(
                      animation: _tabController,
                      builder: (_, __) => _buildCategoryChips(),
                    ),
                    SizedBox(height: r.hp(context, 14)),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          intState is GetAllInteriorDesignLoadingState
                              ? const Center(child: CircularProgressIndicator(color: Color(0xFF3A7D7B)))
                              : _buildGrid(),
                          extState is GetAllExteriorDesignLoadingState
                              ? const Center(child: CircularProgressIndicator(color: Color(0xFF3A7D7B)))
                              : _buildGridNew(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTabBar() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
      child: GlassSegmentedControl(
        segments: [
          GlassTab(label: l10n?.interiorDesignTitle ?? 'Interior'),
          GlassTab(label: l10n?.exteriorDesignTitle ?? 'Exterior'),
        ],
        selectedIndex: _tabController.index,
        onSegmentSelected: (index) {
          _tabController.animateTo(index);
          setState(() {});
        },
        height: r.hp(context, 52),
        borderRadius: r.wp(context, 30),
        indicatorColor: const Color(0xFFE8C898),
        backgroundColor: const Color(0xFFECE8E0),
        selectedTextStyle: TextStyle(
          fontSize: r.sp(context, 17),
          color: const Color(0xFF5A3E18),
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
        ),
        unselectedTextStyle: TextStyle(
          fontSize: r.sp(context, 17),
          color: const Color(0xFF7A7068),
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
        ),
        quality: GlassQuality.standard,
      ),
    );
  }

  // void _showFilterBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: const Color(0xFFF5F2EE),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (ctx) {
  //       final currentCats = _cats;
  //       final safeIdx = (_catIdx >= 0 && _catIdx < currentCats.length) ? _catIdx : 0;
  //       return StatefulBuilder(
  //         builder: (context, setSheetState) {
  //           return Container(
  //             padding: EdgeInsets.fromLTRB(
  //               r.wp(context, 20),
  //               r.hp(context, 18),
  //               r.wp(context, 20),
  //               MediaQuery.of(context).padding.bottom + 20,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'Select Category',
  //                       style: TextStyle(
  //                         fontSize: r.sp(context, 20),
  //                         fontFamily: 'Georgia',
  //                         fontWeight: FontWeight.w600,
  //                         color: const Color(0xFF1A1A1A),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () => Navigator.of(context).pop(),
  //                       child: Container(
  //                         padding: const EdgeInsets.all(6),
  //                         decoration: const BoxDecoration(
  //                           color: Color(0xFFE8E4DC),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF4A4844)),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: r.hp(context, 16)),
  //                 Flexible(
  //                   child: SingleChildScrollView(
  //                     physics: const BouncingScrollPhysics(),
  //                     child: Wrap(
  //                       spacing: r.wp(context, 10),
  //                       runSpacing: r.hp(context, 10),
  //                       children: List.generate(currentCats.length, (i) {
  //                         final sel = safeIdx == i;
  //                         return GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               _catIdx = i;
  //                             });
  //                             _loadDesignsForSelectedCategory();
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: AnimatedContainer(
  //                             duration: const Duration(milliseconds: 150),
  //                             padding: EdgeInsets.symmetric(
  //                               horizontal: r.wp(context, 16),
  //                               vertical: r.hp(context, 10),
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: sel
  //                                   ? const Color(0xFF4A6A70)
  //                                   : Colors.white,
  //                               borderRadius: BorderRadius.circular(r.wp(context, 20)),
  //                               border: Border.all(
  //                                 color: sel ? const Color(0xFF4A6A70) : const Color(0xFFE0DDD8),
  //                               ),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.black.withOpacity(0.04),
  //                                   blurRadius: 4,
  //                                   offset: const Offset(0, 2),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: Text(
  //                               currentCats[i],
  //                               style: TextStyle(
  //                                 fontSize: r.sp(context, 14),
  //                                 fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
  //                                 color: sel ? Colors.white : const Color(0xFF3A3530),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildCategoryChips() {
    final currentCats = _cats;
    final safeIdx = (_catIdx >= 0 && _catIdx < currentCats.length) ? _catIdx : 0;

    return SizedBox(
      height: r.hp(context, 38),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
        itemCount: currentCats.length,
        separatorBuilder: (_, __) => SizedBox(width: r.wp(context, 8)),
        itemBuilder: (_, i) {
          final sel = safeIdx == i;
          return GestureDetector(
            onTap: () {
              setState(() {
                _catIdx = i;
              });
              _loadDesignsForSelectedCategory();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: r.wp(context, 18)),
              decoration: BoxDecoration(
                color: sel
                    ? const Color(0xFF4A6A70)
                    : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(r.wp(context, 24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                currentCats[i],
                style: TextStyle(
                  fontSize: r.sp(context, 14),
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: sel ? Colors.white : const Color(0xFF3A3530),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    final safeIdx = (_catIdx >= 0 && _catIdx < _interiorCats.length) ? _catIdx : 0;
    final selectedCategory = _interiorCats[safeIdx];
    final designs = interiorDesignModelResponse?.data
            ?.where(
              (design) => _matchesCategory(
                design.spaceType,
                selectedCategory,
                isInterior: true,
              ),
            )
            .toList() ??
        [];

    if (designs.isEmpty) {
      return _buildEmptyState(selectedCategory);
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 14), vertical: r.hp(context, 10)),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.gridColumns(context),
        crossAxisSpacing: r.wp(context, 10),
        mainAxisSpacing: r.hp(context, 10),
        childAspectRatio: r.gridAspectRatio(context, mobile: 0.75, tablet: 0.8),
      ),
      itemCount: designs.length,
      itemBuilder: (context, index) {
        final design = designs[index];
        return _RoomCard(
          data: design.outputImage ?? "",
          color: design.colors ?? "",
          prompt: design.prompt ?? "",
          spaceType: design.spaceType ?? "",
          image: design.outputImage ?? "",
          designAsth: design.designAsthetic ?? "",
        );
      },
    );
  }

  Widget _buildGridNew() {
    final safeIdx = (_catIdx >= 0 && _catIdx < _exteriorCats.length) ? _catIdx : 0;
    final selectedCategory = _exteriorCats[safeIdx];
    final designs = exteriorDesignModelResponse?.data
            ?.where(
              (design) => _matchesCategory(
                design.spaceType,
                selectedCategory,
                isInterior: false,
              ),
            )
            .toList() ??
        [];

    if (designs.isEmpty) {
      return _buildEmptyState(selectedCategory);
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 14), vertical: r.hp(context, 10)),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.gridColumns(context),
        crossAxisSpacing: r.wp(context, 10),
        mainAxisSpacing: r.hp(context, 10),
        childAspectRatio: r.gridAspectRatio(context, mobile: 0.75, tablet: 0.8),
      ),
      itemCount: designs.length,
      itemBuilder: (context, index) {
        final design = designs[index];
        return _RoomCard(
          data: design.outputImage ?? "",
          color: design.colors ?? "",
          prompt: design.prompt ?? "",
          spaceType: design.spaceType ?? "",
          image: design.outputImage ?? "",
          designAsth: design.designAsthetic ?? "",
        );
      },
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.wp(context, 24)),
        child: Text(
          category == 'All'
              ? 'No designs available yet.'
              : 'No $category designs available yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.sp(context, 16),
            color: const Color(0xFF7A7068),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(double botPad) {
    return Container(
      color: const Color(0xFFF5F2EE),
      padding: EdgeInsets.only(top: r.hp(context, 10), bottom: botPad > 0 ? botPad : r.hp(context, 14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBtn(
            icon: Icons.home_filled,
            label: 'Home',
            idx: 0,
            current: _navIdx,
            onTap: (v) => setState(() => _navIdx = v),
          ),
          _CompassNavBtn(
            label: 'Explore',
            idx: 1,
            current: _navIdx,
            onTap: (v) => setState(() => _navIdx = v),
          ),
          _NavBtn(
            icon: Icons.access_time_rounded,
            label: 'Recents',
            idx: 2,
            current: _navIdx,
            onTap: (v) => setState(() => _navIdx = v),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(
        top: topPad + r.hp(context, 6),
        left: r.wp(context, 16),
        right: r.wp(context, 16),
        bottom: r.hp(context, 4),
      ),
      child: Row(
        children: [
          // Title
          Text(
            'AI Interior Design',
            style: TextStyle(
              fontSize: r.sp(context, 30),
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(135, 63, 0, 1),
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          // Coin balance
          GestureDetector(
            onTap: () async {
              await SubscriptionScreenManager.openCreditOrSubscriptionScreen(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: r.wp(context, 10), vertical: r.hp(context, 5)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(r.wp(context, 20)),
                border: Border.all(
                  color: const Color(0xFFE8873A).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: creditsNotifier,
                    builder: (context, credits, _) {
                      return Text(
                        creditsNotifier.value.toString(),
                        style: TextStyle(
                          fontSize: isIPad(context) ? r.sp(context, 50) : r.sp(context, 16),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: r.wp(context, 4)),
                  CustomImageview(
                    imagePath: "assets/images/credit.png",
                    height: r.wp(context, 25),
                    width: r.wp(context, 25),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: r.wp(context, 8)),
          // Settings
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
            child: CustomImageview(
              imagePath: "assets/images/setting.png",
              height: r.wp(context, 25),
              width: r.wp(context, 25),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String data;
  final String image;
  final String prompt;
  final String spaceType;
  final String color;
  final String designAsth;

  const _RoomCard({
    required this.data,
    super.key,
    required this.image,
    required this.prompt,
    required this.spaceType,
    required this.color,
    required this.designAsth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ExploreResultScreen.routeName,
          arguments: {
            "image": image,
            "prompt": prompt,
            "spaceType": spaceType,
            "color": color,
            "designAsth": designAsth,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r.wp(context, 18)),
        child: SizedBox(
          width: double.infinity,
          child: Image.network(data, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  final double height;

  const _CardPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: r.hp(context, height),
      color: const Color(0xFFE0DBD4),
      child: Center(
        child: Icon(Icons.image_outlined, size: r.wp(context, 38), color: const Color(0xFFB0A898)),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final int idx;
  final int current;
  final ValueChanged<int> onTap;

  const _NavBtn({
    required this.icon,
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: r.wp(context, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: r.wp(context, 26), color: color),
            SizedBox(height: r.hp(context, 4)),
            Text(
              label,
              style: TextStyle(
                fontSize: r.sp(context, 12),
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassNavBtn extends StatelessWidget {
  final String label;
  final int idx;
  final int current;
  final ValueChanged<int> onTap;

  const _CompassNavBtn({
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = idx == current;
    final color = sel ? const Color(0xFF2A7A80) : const Color(0xFF8A8480);
    final double paintSize = r.wp(context, 28);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: r.wp(context, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: Size(paintSize, paintSize),
              painter: _CompassPainter(color: color),
            ),
            SizedBox(height: r.hp(context, 4)),
            Text(
              label,
              style: TextStyle(
                fontSize: r.sp(context, 12),
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
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
    final scale = size.width / 28.0;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.0 * scale
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        Offset(cx + 4 * scale * math.cos(angle), cy + 4 * scale * math.sin(angle)),
        Offset(cx + 12 * scale * math.cos(angle), cy + 12 * scale * math.sin(angle)),
        paint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), 2.5 * scale, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) => old.color != color;
}
