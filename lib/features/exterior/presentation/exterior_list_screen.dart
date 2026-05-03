import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class InteriorDesignApp extends StatelessWidget {
  const InteriorDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interior Design',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8873A),
        ),
        useMaterial3: true,
      ),
      home: const RoomSelectionScreen(),
    );
  }
}

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

class RoomSelectionScreen extends StatefulWidget {
  const RoomSelectionScreen({super.key});

  static const routeName = "/room-selection";
  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  String? _selectedRoom;

  final List<RoomItem> rooms = const [
    RoomItem(
      name: 'Living Room',
      imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&q=80',
      fallbackIcon: Icons.weekend_rounded,
    ),
    RoomItem(
      name: 'Bedroom',
      imageUrl: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=400&q=80',
      fallbackIcon: Icons.bed_rounded,
    ),
    RoomItem(
      name: 'Kitchen',
      imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&q=80',
      fallbackIcon: Icons.kitchen_rounded,
    ),
    RoomItem(
      name: 'Dining Room',
      imageUrl: 'https://images.unsplash.com/photo-1617104678098-de229db51175?w=400&q=80',
      fallbackIcon: Icons.dining_rounded,
    ),
    RoomItem(
      name: 'Bathroom',
      imageUrl: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=400&q=80',
      fallbackIcon: Icons.bathtub_rounded,
    ),
    RoomItem(
      name: 'Laundry Room',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
      fallbackIcon: Icons.local_laundry_service_rounded,
    ),
    RoomItem(
      name: 'Home Office',
      imageUrl: 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=400&q=80',
      fallbackIcon: Icons.computer_rounded,
    ),
    RoomItem(
      name: 'Study Room',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
      fallbackIcon: Icons.menu_book_rounded,
    ),
    RoomItem(
      name: 'Dorm Room',
      imageUrl: 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=400&q=80',
      fallbackIcon: Icons.hotel_rounded,
    ),
    RoomItem(
      name: 'Gaming Room',
      imageUrl: 'https://images.unsplash.com/photo-1616588589676-62b3bd4ff6d2?w=400&q=80',
      fallbackIcon: Icons.sports_esports_rounded,
    ),
    RoomItem(
      name: 'Attic',
      imageUrl: 'https://images.unsplash.com/photo-1595846519845-68e298c2edd8?w=400&q=80',
      fallbackIcon: Icons.roofing_rounded,
    ),
    RoomItem(
      name: 'Toilet',
      imageUrl: 'https://images.unsplash.com/photo-1564540586988-aa4e53c3d799?w=400&q=80',
      fallbackIcon: Icons.wc_rounded,
    ),
    RoomItem(
      name: 'Coffee Shop',
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400&q=80',
      fallbackIcon: Icons.coffee_rounded,
    ),
    RoomItem(
      name: 'Restaurant',
      imageUrl: 'https://images.unsplash.com/photo-1514190051997-0f6f39ca5cde?w=400&q=80',
      fallbackIcon: Icons.restaurant_rounded,
    ),
    RoomItem(
      name: 'Office',
      imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80',
      fallbackIcon: Icons.business_rounded,
    ),
    RoomItem(
      name: 'Other',
      imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=400&q=80',
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
            _buildTitle(),
            Expanded(
              child: _buildRoomGrid(),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          // Title
          const Expanded(
            child: Center(
              child: Text(
                'Interior Design',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Coins badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE8873A).withOpacity(0.3),
                width: 1,
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
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE8873A), Color(0xFFD46B1F)],
                    ),
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Text(
        'What room are you designing?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
          letterSpacing: -0.4,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildRoomGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.05,
        ),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return _buildRoomCard(rooms[index]);
        },
      ),
    );
  }

  Widget _buildRoomCard(RoomItem room) {
    final isSelected = _selectedRoom == room.name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRoom = room.name;
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE8873A)
                : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFE8873A).withOpacity(0.25)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 3),
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 13.5 : 16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Room image
              Image.network(
                room.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFFF5F5F5),
                    child: Center(
                      child: Icon(
                        room.fallbackIcon,
                        size: 36,
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFF0EDE8),
                          const Color(0xFFE5E0D8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        room.fallbackIcon,
                        size: 42,
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
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.62),
                      ],
                    ),
                  ),
                ),
              ),

              // Room name label
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    room.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.1,
                      shadows: [
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
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8873A),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 15,
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _selectedRoom != null ? () {} : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            disabledBackgroundColor: const Color(0xFFD0D0D0),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white70,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}