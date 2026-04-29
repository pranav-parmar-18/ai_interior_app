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
