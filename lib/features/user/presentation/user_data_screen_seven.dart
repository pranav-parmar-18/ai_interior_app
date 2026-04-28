import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/widgets/custom_elevated_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../services/subscription_manager.dart';
import '../../../theme/theme.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../subscription/presentation/subscription_screen_three.dart';
import '../../subscription/presentation/subscription_screen_two.dart';

class UserDataScreenSeven extends StatefulWidget {
  UserDataScreenSeven({super.key});

  static const routeName = "/user-data-seven";

  @override
  State<UserDataScreenSeven> createState() => _UserDataScreenSevenState();
}

class _UserDataScreenSevenState extends State<UserDataScreenSeven> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/on_boarding.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true); // make it loop
        _controller.play(); // Auto play
        setState(() {});
      });
    analytics.logEvent(
      name: 'onboarding_screen_1_viewed',
      parameters: {'time': DateTime.now().toIso8601String()},
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  final backgroundColors = [
    Color.fromRGBO(138, 35, 135, 1).withOpacity(0.22),
    Color.fromRGBO(233, 64, 87, 1).withOpacity(0.22),
    Color.fromRGBO(242, 113, 33, 1).withOpacity(0.22),
  ];
  final gradientColors = [
    [Color.fromRGBO(233, 64, 87, 1), Color.fromRGBO(242, 113, 33, 1)],
    [
      Color.fromRGBO(138, 35, 135, 1),
      Color.fromRGBO(233, 64, 87, 1),
      Color.fromRGBO(242, 113, 33, 1),
    ],
    [
      Color.fromRGBO(138, 35, 135, 1),
      Color.fromRGBO(233, 64, 87, 1),
      Color.fromRGBO(242, 113, 33, 1),
    ],
  ];
  final duration = Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 16, 1),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // 👈 prevents full expansion
              children: [
                // SizedBox(height: 30),
                _controller.value.isInitialized
                    ? Padding(
                  padding: const EdgeInsets.only(left: 10.0,top: 60),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.63,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                )
                    : SizedBox.shrink(),
                SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: RichText(

                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Unlock unlimited",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: " chatting,",
                          style: TextStyle(
                            color: Color.fromRGBO(242, 113, 33, 1),
                            fontSize: 28,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: "\nrole-play",
                          style: TextStyle(
                            color: Color.fromRGBO(242, 113, 33, 1),
                            fontSize: 28,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: " from AI friend",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Try premium features for just \$39.99/year",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: "\nAuto-renewable, Cancel anytime",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            right:0,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                setIsSingUpCompleted();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName,
                      (route) => false,
                );
              },
              child: Icon(Icons.cancel, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(
              text: 'Unlock Now',
              onPressed: () {
                Navigator.of(context).pushNamed(SubscriptionThreeScreen.routeName);
              },
            ),
            SizedBox(height: 10),
            _buildPrivacyPolicyRow(context),
          ],
        ),
      ),
    )
    ;
  }


  Widget _buildPrivacyPolicyRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              final url = 'https://app.tripleit.ltd/privacy-policy/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode:
                  LaunchMode
                      .externalApplication, // Ensures it opens in Safari
                );
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "Privacy Policy",
              style: TextStyle(
                color: appTheme.gray200.withAlpha(130),
                fontSize: width * 0.035,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _restorePurchases();
            },
            child: Text(
              "Restore",
              style: TextStyle(
                color: appTheme.gray200.withAlpha(130),
                fontSize: width * 0.035,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final url = 'https://app.tripleit.ltd/terms-of-use/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode:
                  LaunchMode
                      .externalApplication, // Ensures it opens in Safari
                );
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "Terms of Use",
              style: TextStyle(
                color: appTheme.gray200.withAlpha(130),
                fontSize: width * 0.035,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> _initialize() async {


    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        print('Purchase Stream Error: $error');
      },
    );

  }

  Future<void> _saveSubscription(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    final SubscriptionType type;
    final Duration duration;

    switch (productId) {
      case 'com.aigirlfriend.weekly':
        type = SubscriptionType.weekly;
        duration = const Duration(days: 7);
        break;
      case 'com.aigirlfriend.monthly':
        type = SubscriptionType.monthly;
        duration = const Duration(days: 30);
        break;
      case 'com.aigirlfriend.yearly':
        type = SubscriptionType.yearly;
        duration = const Duration(days: 365);
        break;
      case 'com.aigirlfriend.weekly_spacial':
        type = SubscriptionType.weekly;
        duration = const Duration(days: 7);
        break;
      default:
        return;
    }

    final expiryDate = DateTime.now().add(duration);
    await prefs.setString(
      'subscription_info',
      jsonEncode({'type': type.name, 'expiry': expiryDate.toIso8601String()}),
    );

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Subscribed to ${type.name}")));
    setState(() {});
  }


  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (mounted) {
          // setState(() => _isPurchasing = false);
        }
        print('Purchased: ${purchase.productID}');
        _saveSubscription(purchase.productID);
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Subscribed to ${purchase.productID}')),
        // );
      } else if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        print('Purchase error: ${purchase.error}');
        if (mounted) {
          // setState(() => _isPurchasing = false);
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Purchase failed: ${purchase.error?.message}'),
        //   ),
        // );
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }


  Future<void> _restorePurchases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('subscription_info');
    _iap.restorePurchases();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Restoring purchases...')));
  }

  void openSubscriptionScreen(BuildContext context) {
    final nextIndex = SubscriptionScreenManager().getNextIndex();

    final screens = [
      SubscriptionScreen(),
      SubscriptionTwoScreen(),
      SubscriptionThreeScreen(),
    ];

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => screens[nextIndex]),
    );
  }

  bool isIPad(BuildContext context) {
    return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
  }

  Future<void> setIsSingUpCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('sign_up_completed', true);
  }

  Future<void> setIsOnboardingDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_onboarding_done', true);
  }
}

class AutoSwipeDemo extends StatefulWidget {
  const AutoSwipeDemo({Key? key}) : super(key: key);

  @override
  State<AutoSwipeDemo> createState() => _AutoSwipeDemoState();
}

class _AutoSwipeDemoState extends State<AutoSwipeDemo>
    with SingleTickerProviderStateMixin {
  final List<String> images = [
    "assets/images/anim_one.png",
    "assets/images/anim_two.png",
    "assets/images/anim_one.png",
    "assets/images/anim_two.png",
    "assets/images/anim_one.png",
  ];

  int currentIndex = 0;
  bool swipeRight = true;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Auto-swipe every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        swipeRight = !swipeRight;
        currentIndex = (currentIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < images.length; i++)
              if (i == currentIndex)
                AnimatedSlide(
                  key: ValueKey(i),
                  offset:
                      swipeRight ? const Offset(1.2, 0) : const Offset(-1.2, 0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        images[i],
                        width: 300,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

