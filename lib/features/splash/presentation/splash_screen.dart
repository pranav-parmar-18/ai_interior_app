import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isOnboardingDone = preferences.getBool('is_onboarding_done') ?? false;
    bool isSignUpCompleted = preferences.getBool('sign_up_completed') ?? false;

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        isOnboardingDone
            ? isSignUpCompleted
                ? MainScreen.routeName
                : OnBoardingFirstScreen.routeName
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
            imagePath: 'assets/images/splash_screen.png',
          ),
        ],
      ),
    );
  }
}
