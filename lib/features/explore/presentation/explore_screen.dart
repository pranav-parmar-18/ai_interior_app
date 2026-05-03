

import 'dart:math' as math;
import 'package:ai_interior/bloc/get_all_designs/get_all_designs_bloc.dart';
import 'package:ai_interior/features/explore/presentation/explore_detail_screen.dart';
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/models/get_all_exterior_design_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/get_all_exterior_designs/get_all_exterior_designs_bloc.dart';
import '../../../models/get_all_interrior_design_model_response.dart';
import '../../../widgets/custom_imageview.dart';
import '../../credit/presentataion/credit_screen.dart';
import '../../setting/presentation/setting_screens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// Replace imagePath strings with your actual asset or network image paths.
// ─────────────────────────────────────────────────────────────────────────────
class RoomCardData {
  final String imagePath;

  const RoomCardData(this.imagePath);
}

// ── Interior cards ────────────────────────────────────────────────────────────
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

// ── Exterior cards ────────────────────────────────────────────────────────────
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

// ── Column heights (match screenshot proportions) ────────────────────────────
const _leftH = [370.0, 390.0, 200.0];
const _rightH = [244.0, 268.0, 290.0, 210.0];

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
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
    'Dining',
  ];
  final _exteriorCats = const ['All', 'Garden', 'Patio', 'Pool', 'Balcony'];

  List<String> get _cats =>
      _tabController.index == 0 ? _interiorCats : _exteriorCats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)..addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _catIdx = 0);
      }
      if (_tabController.index == 0) {
        _getAllInteriorDesignBloc.add(
          GetAllInteriorDesignDataEvent(data: {"space_type": "kitchen"}),
        );
      } else {
        _getAllExteriorDesignBloc.add(
          GetAllExteriorDesignDataEvent(data: {"space_type": "school"}),
        );
      }
    });
    _getAllInteriorDesignBloc.add(
      GetAllInteriorDesignDataEvent(data: {"space_type": "school"}),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final botPad = mq.padding.bottom;

    return BlocConsumer<GetAllInteriorDesignBloc, GetAllInteriorDesignState>(
      bloc: _getAllInteriorDesignBloc,
      listener: (context, state) {
        if (state is GetAllInteriorDesignSuccessState) {
          interiorDesignModelResponse = state.exploreSongResponse;
        } else if (state is GetAllInteriorDesignExceptionState) {
          showSnackError(context, state.message);
        }
      },
      builder: (context, state) {
        return BlocConsumer<
          GetAllExteriorDesignBloc,
          GetAllExteriorDesignState
        >(
          bloc: _getAllExteriorDesignBloc,
          listener: (context, state) {
            if (state is GetAllExteriorDesignSuccessState) {
              exteriorDesignModelResponse = state.exploreSongResponse;
            } else if (state is GetAllExteriorDesignExceptionState ||
                state is GetAllExteriorDesignFailureState) {
              showSnackError(context, "");
            }
          },
          builder: (context, state) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Scaffold(
                backgroundColor: const Color(0xFFF5F2EE),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _TopBar(),
                    const SizedBox(height: 18),

                    _buildTabBar(),
                    const SizedBox(height: 16),

                    AnimatedBuilder(
                      animation: _tabController,
                      builder: (_, __) => _buildCategoryChips(),
                    ),
                    const SizedBox(height: 14),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [_buildGrid(), _buildGridNew()],
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


  // ── Flutter TabBar with pill-shaped sliding indicator ──────────────────
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFECE8E0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          controller: _tabController,

          // ── Pill indicator ──────────────────────────────────────
          indicator: BoxDecoration(
            color: const Color(0xFFE8C898),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),

          // ── Remove default underline & ripple ───────────────────
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),

          // ── Label styles ────────────────────────────────────────
          labelColor: const Color(0xFF5A3E18),
          unselectedLabelColor: const Color(0xFF7A7068),
          labelStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'Georgia',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'Georgia',
          ),

          tabs: const [Tab(text: 'Interior'), Tab(text: 'Exterior')],
        ),
      ),
    );
  }

  // ── Category filter chips ───────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
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
                color:
                    sel
                        ? const Color(0xFF4A6A70)
                        : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(24),
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
                _cats[i],
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
  }

  // ── Two-column masonry grid ─────────────────────────────────────────────
  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75, // adjust based on card height
      ),
      itemCount: interiorDesignModelResponse?.data?.length ?? 0,
      itemBuilder: (context, index) {
        return _RoomCard(
          data: interiorDesignModelResponse?.data?[index].outputImage ?? "",
          color: interiorDesignModelResponse?.data?[index].colors ?? "",
          prompt: interiorDesignModelResponse?.data?[index].prompt ?? "",
          spaceType: interiorDesignModelResponse?.data?[index].spaceType ?? "",
          image: interiorDesignModelResponse?.data?[index].outputImage ?? "",
          designAsth:
              interiorDesignModelResponse?.data?[index].designAsthetic ?? "",
        );
      },
    );
  }

  Widget _buildGridNew() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75, // adjust based on card height
      ),
      itemCount: exteriorDesignModelResponse?.data?.length ?? 0,
      itemBuilder: (context, index) {
        return _RoomCard(
          data: exteriorDesignModelResponse?.data?[index].outputImage ?? "",
          color: exteriorDesignModelResponse?.data?[index].colors ?? "",
          prompt: exteriorDesignModelResponse?.data?[index].prompt ?? "",
          spaceType: exteriorDesignModelResponse?.data?[index].spaceType ?? "",
          image: exteriorDesignModelResponse?.data?[index].outputImage ?? "",
          designAsth:
              exteriorDesignModelResponse?.data?[index].designAsthetic ?? "",
        );
      },
    );
  }

  // ── Bottom navigation bar ───────────────────────────────────────────────
  Widget _buildBottomNav(double botPad) {
    return Container(
      color: const Color(0xFFF5F2EE),
      padding: EdgeInsets.only(top: 10, bottom: botPad > 0 ? botPad : 14),
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
      padding: EdgeInsets.only(top: topPad + 6, left: 16, right: 16, bottom: 4),
      child: Row(
        children: [
          // Title
          const Text(
            'AI Interior Design',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(135, 63, 0, 1),
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          // Coin balance
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CreditsScreen.routeName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE8873A).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '200',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  CustomImageview(
                    imagePath: "assets/images/credit.png",
                    height: 25,
                    width: 25,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Settings
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
            child: CustomImageview(
              imagePath: "assets/images/setting.png",
              height: 25,
              width: 25,
            ),
          )
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
        borderRadius: BorderRadius.circular(18),
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
      height: height,
      color: const Color(0xFFE0DBD4),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 38, color: Color(0xFFB0A898)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom nav — standard icon button
// ─────────────────────────────────────────────────────────────────────────────
class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final int idx, current;
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
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
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

// ─────────────────────────────────────────────────────────────────────────────
// Compass nav button for "Explore"
// ─────────────────────────────────────────────────────────────────────────────
class _CompassNavBtn extends StatelessWidget {
  final String label;
  final int idx, current;
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
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(28, 28),
              painter: _CompassPainter(color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
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

// ─────────────────────────────────────────────────────────────────────────────
// Compass rose painter (8-point star)
// ─────────────────────────────────────────────────────────────────────────────
class _CompassPainter extends CustomPainter {
  final Color color;

  const _CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

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
