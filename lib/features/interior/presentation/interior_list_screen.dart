import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/custom_imageview.dart';
import '../../../utils/responsive_utils.dart';
import '../../home/presentation/home_screen.dart';
import '../../main/presentaion/main_screen.dart';
import 'interior_ash_list_screen.dart';

String intSpaceType = "";

class RoomItem {
  final String name;
  final String imageUrl;
  final IconData fallbackIcon;

  const RoomItem({
    required this.name,
    required this.imageUrl,
    required this.fallbackIcon,
  });
}

class InteriorRoomSelectionScreen extends StatefulWidget {
  static const routeName = "/interior-room-selection";

  const InteriorRoomSelectionScreen({super.key});

  @override
  State<InteriorRoomSelectionScreen> createState() =>
      _InteriorRoomSelectionScreenState();
}

class _InteriorRoomSelectionScreenState
    extends State<InteriorRoomSelectionScreen> {
  String? _selectedRoom = 'Living Room';

  @override
  void initState() {
    super.initState();
    intSpaceType = 'living room';
  }

  final List<RoomItem> rooms = const [
    RoomItem(
      name: 'Living Room',
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&q=80',
      fallbackIcon: Icons.weekend_rounded,
    ),
    RoomItem(
      name: 'Bedroom',
      imageUrl:
          'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=400&q=80',
      fallbackIcon: Icons.bed_rounded,
    ),
    RoomItem(
      name: 'Kitchen',
      imageUrl:
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&q=80',
      fallbackIcon: Icons.kitchen_rounded,
    ),
    RoomItem(
      name: 'Dining Room',
      imageUrl:
          'https://images.unsplash.com/photo-1617104678098-de229db51175?w=400&q=80',
      fallbackIcon: Icons.dining_rounded,
    ),
    RoomItem(
      name: 'Bathroom',
      imageUrl:
          'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=400&q=80',
      fallbackIcon: Icons.bathtub_rounded,
    ),
    RoomItem(
      name: 'Laundry Room',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
      fallbackIcon: Icons.local_laundry_service_rounded,
    ),
    RoomItem(
      name: 'Home Office',
      imageUrl:
          'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=400&q=80',
      fallbackIcon: Icons.computer_rounded,
    ),
    RoomItem(
      name: 'Study Room',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
      fallbackIcon: Icons.menu_book_rounded,
    ),
    RoomItem(
      name: 'Dorm Room',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=400&q=80',
      fallbackIcon: Icons.hotel_rounded,
    ),
    RoomItem(
      name: 'Gaming Room',
      imageUrl:
          'https://images.unsplash.com/photo-1616588589676-62b3bd4ff6d2?w=400&q=80',
      fallbackIcon: Icons.sports_esports_rounded,
    ),
    RoomItem(
      name: 'Attic',
      imageUrl:
          'https://images.unsplash.com/photo-1595846519845-68e298c2edd8?w=400&q=80',
      fallbackIcon: Icons.roofing_rounded,
    ),
    RoomItem(
      name: 'Toilet',
      imageUrl:
          'https://images.unsplash.com/photo-1564540586988-aa4e53c3d799?w=400&q=80',
      fallbackIcon: Icons.wc_rounded,
    ),
    RoomItem(
      name: 'Coffee Shop',
      imageUrl:
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400&q=80',
      fallbackIcon: Icons.coffee_rounded,
    ),
    RoomItem(
      name: 'Restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1514190051997-0f6f39ca5cde?w=400&q=80',
      fallbackIcon: Icons.restaurant_rounded,
    ),
    RoomItem(
      name: 'Office',
      imageUrl:
          'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80',
      fallbackIcon: Icons.business_rounded,
    ),
    RoomItem(
      name: 'Other',
      imageUrl:
          'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=400&q=80',
      fallbackIcon: Icons.add_home_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildProgressBar(),
            _buildTitle(),
            Expanded(child: _buildRoomGrid()),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final hPad = r.wp(context, 16);
    final backBtnSize = r.adaptiveValue(context, mobile: 36, tablet: 48);
    final backIconSize = r.adaptiveValue(context, mobile: 20, tablet: 28);
    final coinIconSize = r.adaptiveValue(context, mobile: 25, tablet: 35);
    final creditsFontSize = r.sp(context, 16);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, r.hp(context, 8), hPad, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: backBtnSize,
              height: backBtnSize,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: backIconSize,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(width: r.wp(context, 8)),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Interior Design',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: r.sp(context, 24),
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Coin badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(context, 10),
              vertical: r.hp(context, 5),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(r.wp(context, 20)),
              border: Border.all(
                color: const Color(0xFFE8873A).withValues(alpha: 0.3),
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
                        fontSize: creditsFontSize,
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
                  height: coinIconSize,
                  width: coinIconSize,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 15),
        vertical: r.hp(context, 6),
      ),
      child: LinearProgressIndicator(
        value: 0.45,
        minHeight: r.hp(context, 3).clamp(2, 5),
        backgroundColor: const Color(0xFFE0DDD8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 16),
        r.hp(context, 4),
        r.wp(context, 16),
        r.hp(context, 12),
      ),
      child: Text(
        'What room are you designing?',
        style: TextStyle(
          fontSize: r.sp(context, 20),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A1A),
          letterSpacing: -0.4,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildRoomGrid() {
    return Padding(
      padding: r.horizontalPadding(context),
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: r.hp(context, 8)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: r.gridColumns(context),
          crossAxisSpacing: r.wp(context, 10),
          mainAxisSpacing: r.hp(context, 10),
          childAspectRatio: r.gridAspectRatio(context, mobile: 1.05, tablet: 1.2),
        ),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return _buildRoomCard(rooms[index], index);
        },
      ),
    );
  }

  Widget _buildRoomCard(RoomItem room, int index) {
    final isSelected = _selectedRoom == room.name;
    final cardRadius = r.wp(context, 16);
    final overlayHeight = r.hp(context, 68).clamp(50.0, 100.0);
    final textFontSize = r.sp(context, 13.5);
    final checkSize = r.adaptiveValue(context, mobile: 24, tablet: 32);
    final checkIconSize = r.adaptiveValue(context, mobile: 15, tablet: 20);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoom = room.name;
          intSpaceType = room.name.toLowerCase();
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: isSelected ? const Color(0xFFE8873A) : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFE8873A).withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 3),
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? cardRadius - 2.5 : cardRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Room image
              Image.asset(
                "assets/images/interior/room_type_${index + 1}.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF0EDE8),
                          Color(0xFFE5E0D8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        room.fallbackIcon,
                        size: r.adaptiveValue(context, mobile: 42, tablet: 56),
                        color: const Color(0xFFAA9880),
                      ),
                    ),
                  );
                },
              ),

              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: overlayHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.62),
                      ],
                    ),
                  ),
                ),
              ),

              // Room name label
              Positioned(
                bottom: r.hp(context, 10),
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    room.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.1,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Selected checkmark overlay
              if (isSelected)
                Positioned(
                  top: r.hp(context, 10),
                  right: r.wp(context, 10),
                  child: Container(
                    width: checkSize,
                    height: checkSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8873A),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: checkIconSize,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final btnHeight = r.adaptiveValue(context, mobile: 58, tablet: 70);
    final fontSize = r.sp(context, 18);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 20),
        vertical: r.hp(context, 12),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(InteriorAshSelectionScreen.routeName);
        },
        child: Container(
          width: double.infinity,
          height: btnHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFE8C9A0),
            borderRadius: BorderRadius.circular(r.wp(context, 32)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8C9A0).withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A3E1B),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
