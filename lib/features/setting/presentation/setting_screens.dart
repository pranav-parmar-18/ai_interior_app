// import 'dart:async';
// import 'dart:io';
//
// import 'package:ai_interior/bloc/delete_account/delete_account_bloc.dart';
// import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
// import 'package:ai_interior/features/setting/presentation/web_view_screen.dart';
// import 'package:ai_interior/features/subscription/presentation/subscription_screen.dart';
// import 'package:ai_interior/theme/app_decoration.dart';
// import 'package:ai_interior/theme/theme.dart';
// import 'package:ai_interior/widgets/custom_imageview.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_review/in_app_review.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../widgets/app_bar/custom_app_bar.dart';
// import '../../../widgets/custom_gradient_ellipsis.dart';
//
// class SettingScreens extends StatefulWidget {
//   const SettingScreens({super.key});
//
//   static const routeName = "/setting";
//
//   @override
//   State<SettingScreens> createState() => _SettingScreensState();
// }
//
// class _SettingScreensState extends State<SettingScreens> {
//   final DeleteAccountBloc _deleteAccountBloc = DeleteAccountBloc();
//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   final InAppReview inAppReview = InAppReview.instance;
//   bool? isSubscribed;
//   final Stream<List<PurchaseDetails>> _purchaseStream =
//       InAppPurchase.instance.purchaseStream;
//   late final StreamSubscription<List<PurchaseDetails>> _subscription;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isSubscriptionActive();
//     _subscription = _purchaseStream.listen(
//       (purchaseDetailsList) {
//         _listenToPurchases(purchaseDetailsList);
//       },
//       onDone: () => _subscription.cancel(),
//       onError: (error) {
//         // Handle error here
//       },
//     );
//     print("isSubscribed: ${isSubscribed}");
//     analytics.logEvent(
//       name: 'setting_screen_viewed',
//       parameters: {'time': DateTime.now().toIso8601String()},
//     );
//   }
//
//   void _listenToPurchases(List<PurchaseDetails> purchaseDetailsList) {
//     for (final purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.restored ||
//           purchaseDetails.status == PurchaseStatus.purchased) {
//         // Verify the purchase with your backend if needed
//
//         if (!purchaseDetails.pendingCompletePurchase) {
//           InAppPurchase.instance.completePurchase(purchaseDetails);
//         }
//
//         // Unlock premium features or update your UI/state
//         print('Restored/Purchased: ${purchaseDetails.productID}');
//       } else if (purchaseDetails.status == PurchaseStatus.error) {
//         print('Purchase Error: ${purchaseDetails.error}');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       backgroundColor: Color.fromRGBO(13, 13, 16, 1),
//       body: BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
//         bloc: _deleteAccountBloc,
//         listener: (context, state) {
//           if (state is DeleteAccountSuccessState) {
//             Navigator.of(
//               context,
//             ).pushNamedAndRemoveUntil(OnBoardingFirstScreen.routeName, (route) => false);
//           } else if (state is DeleteAccountExceptionState ||
//               state is DeleteAccountFailureState) {
//
//           }
//         },
//         builder: (context, state) {
//           return state is DeleteAccountLoadingState ? Align(
//             child: Image.asset(
//               "assets/gifs/ai_loader.gif",
//               height: 250,
//               width: 250,
//             ),):Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(left: 18, top: 30, right: 18),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [_buildFamiconsStack(context)],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 45),
//         child: GestureDetector(
//           onTap: () {
//             HapticFeedback.heavyImpact();
//
//             _deleteAccountBloc.add(DeleteAccountDataEvent());
//           },
//           child: CustomImageview(imagePath: "assets/images/delete_account.png"),
//         ),
//       ),
//     );
//   }
//
//   Future<void> requestReview() async {
//     if (await inAppReview.isAvailable()) {
//       await inAppReview.requestReview(); // shows native iOS dialog if available
//     } else {
//       // Optionally open store listing as fallback
//       inAppReview.openStoreListing(appStoreId: '6744528960');
//     }
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return AppBar(
//       elevation: 0,
//       toolbarHeight: 56,
//       backgroundColor: Colors.transparent,
//       automaticallyImplyLeading: false,
//       centerTitle: true,
//       leadingWidth: 50,
//       title: Text(
//         "Settings",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 28,
//           fontFamily: 'Sora',
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 15.0),
//           child: GestureDetector(
//             onTap: () {
//               HapticFeedback.heavyImpact();
//
//               Navigator.of(context).pop();
//             },
//             child: CustomImageview(
//               imagePath: "assets/images/cancel_btn_img.png",
//               height: 45,
//               width: 45,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFamiconsStack(BuildContext context) {
//     return SizedBox(
//       height: 388,
//       width: double.maxFinite,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           SizedBox(
//             width: double.maxFinite,
//             child: Column(
//               spacing: 30,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Container(
//                   width: double.maxFinite,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
//                   decoration: AppDecoration.outlineGray.copyWith(
//                     borderRadius: BorderRadiusStyle.roundedBorder24,
//                   ),
//                   child: Column(
//                     spacing: 22,
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.mediumImpact();
//
//                           requestReview();
//                         },
//                         child: Container(
//                           width: double.maxFinite,
//                           margin: EdgeInsets.only(right: 4),
//                           child: _buildContactRow(
//                             context,
//                             imageOne: "assets/images/star_img.png",
//                             contactUsOne: "Rate Us",
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//
//                           if (Platform.isAndroid) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => WebViewScreen(
//                                   url:
//                                   'https://app.tripleit.ltd/support-for-ai-gf/',
//                                   title: 'Privacy Policy',
//                                 ),
//                               ),
//                             );
//                           } else {
//                             final url =
//                                 'https://app.tripleit.ltd/support-for-ai-gf/';
//                             if (await canLaunchUrl(Uri.parse(url))) {
//                           await launchUrl(
//                           Uri.parse(url),
//                           mode:
//                           LaunchMode
//                               .externalApplication, // Ensures it opens in Safari
//                           );
//                           } else {
//                           throw 'Could not launch $url';
//                           }
//                         }
//                         },
//                         child: Container(
//                           width: double.maxFinite,
//                           margin: EdgeInsets.only(right: 4),
//                           child: _buildContactRow(
//                             context,
//                             imageOne: "assets/images/call_img.png",
//                             contactUsOne: "Support",
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//
//                           if (Platform.isAndroid) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => WebViewScreen(
//                                       url:
//                                           'https://app.tripleit.ltd/privacy-policy/',
//                                       title: 'Privacy Policy',
//                                     ),
//                               ),
//                             );
//                           } else {
//                             final url =
//                                 'https://app.tripleit.ltd/privacy-policy/';
//                             if (await canLaunchUrl(Uri.parse(url))) {
//                               await launchUrl(
//                                 Uri.parse(url),
//                                 mode:
//                                     LaunchMode
//                                         .externalApplication, // Ensures it opens in Safari
//                               );
//                             } else {
//                               throw 'Could not launch $url';
//                             }
//                           }
//                         },
//                         child: Container(
//                           width: double.maxFinite,
//                           margin: EdgeInsets.only(right: 4),
//                           child: _buildContactRow(
//                             context,
//                             imageOne: "assets/images/privacy_img.png",
//                             contactUsOne: "Privacy Policy",
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           HapticFeedback.mediumImpact();
//
//                           if (Platform.isAndroid) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => WebViewScreen(
//                                       url: 'https://app.tripleit.ltd/terms-of-use/',
//                                       title: 'Privacy Policy',
//                                     ),
//                               ),
//                             );
//                           } else {
//                             final url = 'https://app.tripleit.ltd/terms-of-use/';
//                             if (await canLaunchUrl(Uri.parse(url))) {
//                               await launchUrl(
//                                 Uri.parse(url),
//                                 mode:
//                                     LaunchMode
//                                         .externalApplication, // Ensures it opens in Safari
//                               );
//                             } else {
//                               throw 'Could not launch $url';
//                             }
//                           }
//                         },
//                         child: Container(
//                           width: double.maxFinite,
//                           margin: EdgeInsets.only(right: 4),
//                           child: _buildContactRow(
//                             context,
//                             imageOne: "assets/images/terms_of_use.png",
//                             contactUsOne: "Terms of Use",
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: double.maxFinite,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         width: double.maxFinite,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 22,
//                           vertical: 17,
//                         ),
//                         decoration: AppDecoration.outlineGray.copyWith(
//                           borderRadius: BorderRadiusStyle.roundedBorder24,
//                         ),
//                         child: Column(
//                           spacing: 22,
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () async {
//                                 if (Platform.isAndroid) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder:
//                                           (_) => WebViewScreen(
//                                             url:
//                                                 'https://app.tripleit.ltd/terms-of-use/',
//                                             title: 'Privacy Policy',
//                                           ),
//                                     ),
//                                   );
//                                 } else {
//                                   final url =
//                                       'https://app.tripleit.ltd/terms-of-use/';
//                                   if (await canLaunchUrl(Uri.parse(url))) {
//                                     await launchUrl(
//                                       Uri.parse(url),
//                                       mode:
//                                           LaunchMode
//                                               .externalApplication, // Ensures it opens in Safari
//                                     );
//                                   } else {
//                                     throw 'Could not launch $url';
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 width: double.maxFinite,
//                                 margin: EdgeInsets.only(right: 4),
//                                 child: _buildContactRow(
//                                   context,
//                                   imageOne: "assets/images/share_image.png",
//                                   contactUsOne: "Share",
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   Widget _buildContactRow(
//     BuildContext context, {
//     required String imageOne,
//     required String contactUsOne,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CustomImageview(
//           imagePath: imageOne,
//           height: 33,
//           width: 25,
//           fit: BoxFit.contain,
//         ),
//         SizedBox(width: 20),
//         Text(
//           contactUsOne,
//           style: TextStyle(
//             color: appTheme.whiteA700,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Manrope',
//             fontSize: 22,
//           ),
//         ),
//         // Spacer(flex: 84),
//         // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
//       ],
//     );
//   }
//
//   void showSnackMessage(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         duration: Duration(seconds: 3),
//         content: ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromRGBO(138, 105, 241, 1),
//                   Color.fromRGBO(251, 137, 152, 1),
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     CupertinoIcons.check_mark_circled_solid,
//                     color: Colors.white,
//                     size: 25,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     "Email copied to clipboard",
//                     style: TextStyle(
//                       fontFamily: 'Lato',
//                       fontWeight: FontWeight.w800,
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> setIsOnboardingDone() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setBool('is_onboarding_done', false);
//   }
//
//   void _showProgressDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return CupertinoTheme(
//           data: CupertinoThemeData(brightness: Brightness.dark),
//           child: CupertinoAlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'In-progress',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontFamily: 'Lato',
//                     color: appTheme.whiteA700,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 CupertinoActivityIndicator(),
//                 // This shows the in-progress spinner
//               ],
//             ),
//             actions: [
//               CupertinoDialogAction(
//                 child: Text('Cancel'),
//                 onPressed: () {
//                   Navigator.pop(context); // Close the dialog
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<bool> isSubscriptionActive() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString('subscription_info');
//     if (data == null) {
//       setState(() {
//         isSubscribed = false;
//       });
//       return false;
//     }
//
//     final sub = SubscriptionInfo.fromJson(data);
//     setState(() {
//       isSubscribed = sub?.isActive ?? false;
//     });
//
//     return sub?.isActive ?? false;
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = "/setting-screen";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE8),
      body: Column(
        children: [
          SizedBox(height: topPadding),

          // ── App Bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back chevron
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                // Title
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Premium Banner ───────────────────────────────────
                _PremiumBanner(),

                const SizedBox(height: 20),

                // ── Group 1 ──────────────────────────────────────────
                _SettingsGroup(
                  items: [
                    _SettingsItem(
                      icon: _CreditIcon(),
                      label: '200 Credits',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: const Icon(
                        Icons.recent_actors_outlined,
                        size: 24,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Manage Subscription',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: const Icon(
                        Icons.translate,
                        size: 24,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Change Language',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Group 2 ──────────────────────────────────────────
                _SettingsGroup(
                  items: [
                    _SettingsItem(
                      icon: const Icon(
                        Icons.ios_share,
                        size: 22,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Share App',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: const Icon(
                        Icons.star,
                        size: 23,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Rate Us',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: const Icon(
                        Icons.headset_mic_outlined,
                        size: 23,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Support',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: const Icon(
                        Icons.insert_drive_file_outlined,
                        size: 23,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Terms & Conditions',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: const Icon(
                        Icons.shield_outlined,
                        size: 23,
                        color: Color(0xFF1A1A1A),
                      ),
                      label: 'Privacy Policy',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Home indicator
          Container(
            width: 134,
            height: 5,
            margin: EdgeInsets.only(
              bottom: bottomPadding > 0 ? bottomPadding - 4 : 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Premium Banner
// ─────────────────────────────────────────────────────────────────────────────
class _PremiumBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: const Color(0xFF3A7D8C),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),

            // House icon in white circle
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(44, 44),
                  painter: _HouseDiamondPainter(),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Text
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade To Premium',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Unlock all benefits!',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            const Icon(Icons.chevron_right, color: Colors.white, size: 26),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// House + Diamond painter (matches the icon in the screenshot)
// ─────────────────────────────────────────────────────────────────────────────
class _HouseDiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── House body ───────────────────────────────────────────────────
    final wallPaint =
        Paint()
          ..color = const Color(0xFFF5F0EB)
          ..style = PaintingStyle.fill;
    final strokePaint =
        Paint()
          ..color = const Color(0xFF2A2A2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeJoin = StrokeJoin.round;

    // House walls
    final houseRect = Rect.fromLTWH(w * 0.12, h * 0.42, w * 0.76, h * 0.50);
    canvas.drawRect(houseRect, wallPaint);
    canvas.drawRect(houseRect, strokePaint);

    // Roof
    final roofPath =
        Path()
          ..moveTo(w * 0.05, h * 0.44)
          ..lineTo(w * 0.50, h * 0.08)
          ..lineTo(w * 0.95, h * 0.44)
          ..close();
    canvas.drawPath(roofPath, Paint()..color = const Color(0xFF5A5A5A));
    canvas.drawPath(roofPath, strokePaint);

    // Chimney
    canvas.drawRect(
      Rect.fromLTWH(w * 0.62, h * 0.05, w * 0.12, h * 0.22),
      Paint()..color = const Color(0xFF5A5A5A),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.62, h * 0.05, w * 0.12, h * 0.22),
      strokePaint,
    );

    // Door
    final doorPaint = Paint()..color = const Color(0xFFD4B896);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(w * 0.38, h * 0.62, w * 0.24, h * 0.30),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
      doorPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(w * 0.38, h * 0.62, w * 0.24, h * 0.30),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
      strokePaint,
    );

    // Window left
    canvas.drawRect(
      Rect.fromLTWH(w * 0.16, h * 0.56, w * 0.18, h * 0.16),
      Paint()..color = const Color(0xFFB8D4E8),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.16, h * 0.56, w * 0.18, h * 0.16),
      strokePaint,
    );

    // Window right
    canvas.drawRect(
      Rect.fromLTWH(w * 0.66, h * 0.56, w * 0.18, h * 0.16),
      Paint()..color = const Color(0xFFB8D4E8),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.66, h * 0.56, w * 0.18, h * 0.16),
      strokePaint,
    );

    // ── Diamond (overlapping bottom-left of house) ────────────────
    final diamondCx = w * 0.22;
    final diamondCy = h * 0.82;
    final dw = w * 0.30;
    final dh = h * 0.30;

    final diamondPath =
        Path()
          ..moveTo(diamondCx, diamondCy - dh * 0.5)
          ..lineTo(diamondCx + dw * 0.5, diamondCy - dh * 0.1)
          ..lineTo(diamondCx, diamondCy + dh * 0.5)
          ..lineTo(diamondCx - dw * 0.5, diamondCy - dh * 0.1)
          ..close();

    canvas.drawPath(diamondPath, Paint()..color = const Color(0xFFF0C060));
    canvas.drawPath(diamondPath, strokePaint..strokeWidth = 1.4);

    // Inner facet lines
    final facetPaint =
        Paint()
          ..color = const Color(0xFFE0A030)
          ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(diamondCx - dw * 0.5, diamondCy - dh * 0.1),
      Offset(diamondCx, diamondCy - dh * 0.5),
      facetPaint,
    );
    canvas.drawLine(
      Offset(diamondCx + dw * 0.5, diamondCy - dh * 0.1),
      Offset(diamondCx, diamondCy - dh * 0.5),
      facetPaint,
    );
    canvas.drawLine(
      Offset(diamondCx - dw * 0.3, diamondCy - dh * 0.1),
      Offset(diamondCx, diamondCy + dh * 0.5),
      facetPaint,
    );
    canvas.drawLine(
      Offset(diamondCx + dw * 0.3, diamondCy - dh * 0.1),
      Offset(diamondCx, diamondCy + dh * 0.5),
      facetPaint,
    );
    canvas.drawLine(
      Offset(diamondCx - dw * 0.5, diamondCy - dh * 0.1),
      Offset(diamondCx + dw * 0.5, diamondCy - dh * 0.1),
      facetPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Credit coin icon
// ─────────────────────────────────────────────────────────────────────────────
class _CreditIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE08020),
      ),
      child: Center(
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Center(
            child: Icon(Icons.diamond, size: 7, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings Group (white card with items + dividers)
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;

  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: items),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings Item Row
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsItem extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  State<_SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<_SettingsItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        color: _pressed ? const Color(0xFFF0EDE8) : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  // Icon container (fixed width for alignment)
                  SizedBox(width: 30, child: widget.icon),
                  const SizedBox(width: 14),
                  // Label
                  Expanded(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  // Chevron
                  const Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: Color(0xFF888888),
                  ),
                ],
              ),
            ),
            // Divider (not shown for last item)
            if (!widget.isLast)
              const Divider(
                height: 1,
                thickness: 0.5,
                indent: 62,
                endIndent: 18,
                color: Color(0xFFDDDAD6),
              ),
          ],
        ),
      ),
    );
  }
}
