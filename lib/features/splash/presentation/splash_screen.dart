import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_interior/utils/responsive_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isOnboardingDone = preferences.getBool('is_onboarding_done') ?? false;

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        isOnboardingDone
            ? MainScreen.routeName
            : OnBoardingFirstScreen.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(13, 13, 16, 1),
      body: Stack(
        children: [
          CustomImageview(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            imagePath: 'assets/images/splash.png',
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageview(
                    imagePath: "assets/images/splash_center.png",
                    height: isLandscape
                        ? r.adaptiveValue(context, mobile: 130.0, tablet: 180.0)
                        : r.adaptiveValue(context, mobile: 180.0, tablet: 240.0),
                    width: isLandscape
                        ? r.adaptiveValue(context, mobile: 130.0, tablet: 180.0)
                        : r.adaptiveValue(context, mobile: 180.0, tablet: 240.0),
                  ),
                  SizedBox(height: r.hp(context, 2)),
                  Text(
                    "AI Interior",
                    style: TextStyle(
                      color: const Color.fromRGBO(71, 126, 132, 1),
                      fontSize: r.adaptiveValue(context, mobile: 28.0, tablet: 36.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: r.hp(context, 2.5)),
                  LinearPercentIndicator(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLandscape ? r.wp(context, 35) : r.wp(context, 20),
                    ),
                    lineHeight: r.adaptiveValue(context, mobile: 5.0, tablet: 7.0),
                    percent: _animation.value,
                    backgroundColor: Colors.white,
                    progressColor: const Color.fromRGBO(50, 116, 127, 1),
                    barRadius: const Radius.circular(2),
                    animation: false,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
