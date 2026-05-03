import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

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
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),
      body: Stack(
        children: [
          CustomImageview(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            imagePath: 'assets/images/splash.png',
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                CustomImageview(
                  imagePath: "assets/images/splash_center.png",
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 20),
                Text(
                  "AI Interior",
                  style: TextStyle(
                    color: Color.fromRGBO(71, 126, 132, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                LinearPercentIndicator(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  lineHeight: 5, // iOS-style thin bar
                  percent: _animation.value,
                  backgroundColor: Colors.white,
                  progressColor: Color.fromRGBO(50, 116, 127, 1),
                  barRadius: const Radius.circular(2),
                  animation: false, // we control animation
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
