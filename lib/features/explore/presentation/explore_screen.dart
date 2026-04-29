// import 'package:ai_interior/bloc/daily_claim/daily_claim_bloc.dart';
// import 'package:ai_interior/bloc/explore/explore_bloc.dart';
// import 'package:ai_interior/bloc/profile_match/profile_match_bloc.dart';
// import 'package:ai_interior/features/explore/presentation/match_screen.dart';
// import 'package:ai_interior/features/main/presentaion/main_screen.dart';
// import 'package:ai_interior/features/subscription/presentation/subscription_screen.dart';
// import 'package:ai_interior/models/explore_model_response.dart';
// import 'package:ai_interior/widgets/custom_elevated_button.dart';
// import 'package:ai_interior/widgets/custom_imageview.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../services/subscription_manager.dart';
// import '../../subscription/presentation/subscription_screen_three.dart';
// import '../../subscription/presentation/subscription_screen_two.dart';
//
//
// int rightSwipeCount = 0;
// int maxRightSwipes = 15;
//
// class ExploreScreen extends StatefulWidget {
//   const ExploreScreen({super.key});
//
//   @override
//   State<ExploreScreen> createState() => _ExploreScreenState();
// }
//
// class _ExploreScreenState extends State<ExploreScreen> {
//   final ExploreBloc _exploreBloc = ExploreBloc();
//   ExploreModelResponse? exploreModelResponse;
//   final CardSwiperController _controller = CardSwiperController();
//   final ProfileMatchBloc _profileMatchBloc = ProfileMatchBloc();
//   bool? isSubscribed;
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _exploreBloc.add(ExploreDataEvent());
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       checkAndShowDailyReward(context);
//     });
//   }
//
//   final List<String> images = [
//     "assets/images/anim_one.png",
//     "assets/images/anim_two.png",
//   ];
//   int selectedIndex = 0;
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
//
//   Future<void> checkAndShowDailyReward(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//     final lastShownDate = prefs.getString('daily_reward_shown_date');
//
//     if (lastShownDate != today) {
//       // Save today as the last shown date
//       await prefs.setString('daily_reward_shown_date', today);
//
//       // Show bottom sheet
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (context) => DailyRewardBottomSheet(),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       backgroundColor: Color.fromRGBO(13, 13, 16, 1),
//       body: BlocConsumer<ExploreBloc, ExploreState>(
//         bloc: _exploreBloc,
//         listener: (context, state) {
//           if (state is ExploreSuccessState) {
//             exploreModelResponse = state.exploreSongResponse;
//           } else if (state is ExploreFailureState ||
//               state is ExploreExceptionState) {}
//         },
//         builder: (context, state) {
//           return state is ExploreLoadingState && exploreModelResponse == null
//               ? Align(
//             child: Image.asset(
//               "assets/gifs/ai_loader.gif",
//               height: 250,
//               width: 250,
//             ),)
//               : BlocConsumer<ProfileMatchBloc, ProfileMatchState>(
//                 bloc: _profileMatchBloc,
//                 listener: (context, state) {
//                   if (state is ProfileMatchSuccessState) {
//                     print("PROFILE INDEX : $selectedIndex");
//                     Navigator.of(context).pushNamed(
//                       MatchScreen.routeName,
//                       arguments: {
//                         "id":
//                             exploreModelResponse
//                                 ?.result?[selectedIndex == 0
//                                     ? 0
//                                     : selectedIndex ]
//                                 .id ??
//                             "",
//                         "image":
//                             exploreModelResponse
//                                 ?.result?[selectedIndex == 0
//                                     ? 0
//                                     : selectedIndex ]
//                                 .image ??
//                             "",
//                         "name":
//                             exploreModelResponse
//                                 ?.result?[selectedIndex == 0
//                                     ? 0
//                                     : selectedIndex]
//                                 .name ??
//                             "",
//                       },
//                     );
//                   } else if (state is ProfileMatchFailureState ||
//                       state is ProfileMatchExceptionState) {}
//                 },
//                 builder: (context, matchState) {
//                   return matchState is ProfileMatchLoadingState ?Align(
//                     child: Image.asset(
//                       "assets/gifs/ai_loader.gif",
//                       height: 300,
//                       width: 300,
//                     ),
//                   ):
//                   SizedBox(
//                     width: double.maxFinite,
//                       child: Container(
//                       width: double.maxFinite,
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Column(
//                         children: [
//                           (exploreModelResponse?.result?.isNotEmpty ?? false)
//                               ? Builder(
//                             builder: (context) {
//                               final cardsCount =
//                                   exploreModelResponse?.result?.length ?? 0;
//
//                               // ✅ Ensure selectedIndex always stays within bounds
//                               if (selectedIndex >= cardsCount || selectedIndex < 0) {
//                                 selectedIndex = 0;
//                               }
//
//                               return SizedBox(
//                                 height: isIPad(context)
//                                     ? (isIPhoneMini(context)
//                                     ? height * 0.8
//                                     : height * 0.9)
//                                     : height * 0.7+55,
//                                 width:
//                                 isIPad(context) ? width * 0.6 : double.maxFinite,
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   clipBehavior: Clip.none,
//                                   children: [
//                                     CardSwiper(
//                                       controller: _controller,
//                                       initialIndex: selectedIndex,
//                                       cardsCount: cardsCount,
//                                       isLoop: true,
//                                       allowedSwipeDirection:
//                                       const AllowedSwipeDirection.symmetric(
//                                         horizontal: true,
//                                       ),
//                                       numberOfCardsDisplayed: 1,
//                                       padding: EdgeInsets.zero,
//                                       onSwipe: (
//                                           previousIndex,
//                                           currentIndex,
//                                           direction,
//                                           ) {
//                                         HapticFeedback.heavyImpact();
//
//                                         if (isSubscribed == true) {
//                                           if (direction ==
//                                               CardSwiperDirection.right) {
//                                             final characterId =
//                                                 exploreModelResponse
//                                                     ?.result?[
//                                                 selectedIndex == 0
//                                                     ? 0
//                                                     : selectedIndex - 1]
//                                                     .id ??
//                                                     0;
//                                             _profileMatchBloc.add(
//                                               ProfileMatchDataEvent(
//                                                 ProfileMatch: {
//                                                   "character_id": characterId,
//                                                 },
//                                               ),
//                                             );
//                                           }
//                                         } else {
//                                           if (direction ==
//                                               CardSwiperDirection.right) {
//                                             if (rightSwipeCount < maxRightSwipes) {
//                                               setState(() {
//                                                 rightSwipeCount++;
//                                               });
//
//                                               final characterId =
//                                                   exploreModelResponse
//                                                       ?.result?[
//                                                   selectedIndex == 0
//                                                       ? 0
//                                                       : selectedIndex - 1]
//                                                       .id ??
//                                                       0;
//                                               _profileMatchBloc.add(
//                                                 ProfileMatchDataEvent(
//                                                   ProfileMatch: {
//                                                     "character_id": characterId,
//                                                   },
//                                                 ),
//                                               );
//                                             } else {
//                                               openSubscriptionScreen(context);
//                                               return true;
//                                             }
//                                             return true;
//                                           }
//                                           if (direction ==
//                                               CardSwiperDirection.left) {
//                                             if (rightSwipeCount >=
//                                                 maxRightSwipes) {
//                                               openSubscriptionScreen(context);
//                                             }
//                                           }
//                                         }
//                                         return true;
//                                       },
//                                       cardBuilder: (
//                                           context,
//                                           index,
//                                           percentThresholdX,
//                                           percentThresholdY,
//                                           ) {
//                                         selectedIndex = index;
//                                         return Stack(
//                                           clipBehavior: Clip.none,
//                                           alignment: Alignment.center,
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                               BorderRadius.circular(30),
//                                               child: CachedNetworkImage(
//                                                 imageUrl: exploreModelResponse
//                                                     ?.result?[index]
//                                                     .image ??
//                                                     "",
//                                                 fit: BoxFit.cover,
//                                                 width: double.infinity,
//                                                 height: height * 0.7,
//                                                 placeholder: (context, url) =>
//                                                     Align(
//                                                       child: Image.asset(
//                                                         "assets/gifs/ai_loader.gif",
//                                                         height: 250,
//                                                         width: 250,
//                                                       ),
//                                                     ),
//                                                 errorWidget: (context, url, error) =>
//                                                 const Center(
//                                                   child: Icon(
//                                                     CupertinoIcons
//                                                         .exclamationmark_triangle,
//                                                     size: 40,
//                                                     color: CupertinoColors.systemGrey,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             _buildColumnForStack(
//                                               context,
//                                               exploreModelResponse?.result?[index] ??
//                                                   Result(),
//
//                                             ),
//                                             Positioned(
//                                               bottom: isIPad(context)
//                                                   ? 100
//                                                   : isIPhoneMini(context)
//                                                   ? 0
//                                                   : 0,
//                                               right: isIPad(context)
//                                                   ? 150
//                                                   : isIPhoneMini(context)
//                                                   ? 50
//                                                   : 70,
//                                               child: InkWell(
//                                                 splashColor: Colors.transparent,
//                                                 highlightColor: Colors.transparent,
//                                                 hoverColor: Colors.transparent,
//                                                 focusColor: Colors.transparent,
//                                                 onTap: () {
//                                                   if (rightSwipeCount <
//                                                       maxRightSwipes) {
//                                                     HapticFeedback.heavyImpact();
//
//                                                     setState(() {
//                                                       rightSwipeCount++;
//                                                     });
//
//                                                     _controller.swipe(
//                                                       CardSwiperDirection.right,
//                                                     );
//
//                                                     _profileMatchBloc.add(
//                                                       ProfileMatchDataEvent(
//                                                         ProfileMatch: {
//                                                           "character_id":
//                                                           exploreModelResponse
//                                                               ?.result?[
//                                                           selectedIndex ==
//                                                               0
//                                                               ? 0
//                                                               : selectedIndex -
//                                                               1]
//                                                               .id ??
//                                                               0,
//                                                         },
//                                                       ),
//                                                     );
//                                                   } else {
//                                                     openSubscriptionScreen(context);
//                                                   }
//                                                 },
//                                                 child: const CircleAvatar(
//                                                   radius: 45,
//                                                   backgroundColor: Colors.green,
//                                                   child: Align(
//                                                     child: CustomImageview(
//                                                       imagePath:
//                                                       "assets/images/heart.png",
//                                                       height: 45,
//                                                       width: 45,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Positioned(
//                                               bottom: isIPad(context)
//                                                   ? 100
//                                                   : isIPhoneMini(context)
//                                                   ? 0
//                                                   : 0,
//                                               left: isIPad(context)
//                                                   ? 150
//                                                   : isIPhoneMini(context)
//                                                   ? 50
//                                                   : 70,
//                                               child: InkWell(
//                                                 splashColor: Colors.transparent,
//                                                 highlightColor: Colors.transparent,
//                                                 hoverColor: Colors.transparent,
//                                                 focusColor: Colors.transparent,
//                                                 onTap: () {
//                                                   if (rightSwipeCount <
//                                                       maxRightSwipes) {
//                                                     _controller.swipe(
//                                                       CardSwiperDirection.left,
//                                                     );
//                                                   } else {
//                                                     openSubscriptionScreen(context);
//                                                   }
//                                                 },
//                                                 child: const CircleAvatar(
//                                                   radius: 45,
//                                                   backgroundColor: Colors.red,
//                                                   child: Align(
//                                                     child: CustomImageview(
//                                                       imagePath:
//                                                       "assets/images/cancel.png",
//                                                       height: 45,
//                                                       width: 45,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           )
//                               : Column(
//                             children: [
//                               SizedBox(
//                                 height: isIPhoneMini(context)
//                                     ? height * 0.3
//                                     : height * 0.35,
//                               ),
//                               const Text(
//                                 "No profiles available \nat the moment !",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                   fontFamily: 'Sora',
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                         ],
//                       ),
//                     ),
//                   );
//
//                 },
//               );
//         },
//       ),
//     );
//   }
//
//   void openSubscriptionScreen(BuildContext context) {
//     final nextIndex = SubscriptionScreenManager().getNextIndex();
//
//     final screens = [
//       SubscriptionScreen(),
//       SubscriptionTwoScreen(),
//       SubscriptionThreeScreen(),
//     ];
//
//     Navigator.push(
//       context,
//       CupertinoPageRoute(builder: (_) => screens[nextIndex]),
//     );
//   }
//
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
//       title: Text(
//         "Explore",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: isIPad(context) ? 40 : 28,
//           fontFamily: 'Sora',
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: EdgeInsets.only(right: 21),
//           child: GestureDetector(
//             onTap: () {
//               HapticFeedback.heavyImpact();
//
//               showCupertinoModalPopup(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return Material(
//                     color: Colors.transparent,
//                     child: SafeArea(
//                       top: false,
//                       child: Container(
//                         height: height * 0.51,
//                         decoration: const BoxDecoration(
//                           color: CupertinoColors.systemBackground,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(30),
//                             topRight: Radius.circular(30),
//                           ),
//                         ),
//                         child: ExploreScreensFilterBottomSheet(
//                           onTap: () {
//                             _exploreBloc.add(ExploreDataEvent());
//                           },
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: SizedBox(
//               height: height * 0.03,
//               width: width * 0.07,
//               child: CustomImageview(
//                 imagePath: "assets/images/filter.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//         // Padding(
//         //   padding: EdgeInsets.only(right: 21),
//         //   child: GestureDetector(
//         //     onTap: () {
//         //       showDialog(
//         //         context: context,
//         //         barrierDismissible: true,
//         //         builder: (_) => GestureDetector(
//         //           onTap: () => Navigator.of(context).pop(),
//         //           child: Container(
//         //             color: Colors.black.withOpacity(0.3),
//         //             child: Center(
//         //               child: Image.asset(
//         //                 'assets/images/welcome_pop_up.png',
//         //                 fit: BoxFit.contain,
//         //               ),
//         //             ),
//         //           ),
//         //         ),
//         //       );
//         //
//         //     },
//         //     child: SizedBox(
//         //       height: height * 0.04,
//         //       width: width * 0.08,
//         //       child: CustomImageview(
//         //         imagePath: "assets/images/filter.png",
//         //         fit: BoxFit.contain,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
//
//   Widget _buildColumnForStack(BuildContext context, Result result) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         // width: double.maxFinite,
//         margin: EdgeInsets.only(
//           left: 24,
//           right: 24,
//           bottom: isIPad(context) ? 170 : 100,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               // width: double.maxFinite,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       "${result.name}",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 38,
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   // Container(
//                   //   width: double.maxFinite,
//                   //   height: height * 0.035,
//                   //   margin: EdgeInsets.only(left: 20, top: 6),
//                   //   decoration: BoxDecoration(
//                   //     borderRadius: BorderRadius.circular(16),
//                   //     gradient: LinearGradient(
//                   //       begin: Alignment(0, 0.5),
//                   //       end: Alignment(1, 0.5),
//                   //       colors: [
//                   //         Color.fromRGBO(138, 35, 135, 1),
//                   //         Color.fromRGBO(233, 64, 87, 1),
//                   //         Color.fromRGBO(242, 113, 33, 1),
//                   //       ],
//                   //     ),
//                   //   ),
//                   //   child: ElevatedButton(
//                   //     onPressed: () {},
//                   //     child: Row(
//                   //       mainAxisAlignment: MainAxisAlignment.center,
//                   //       crossAxisAlignment: CrossAxisAlignment.center,
//                   //       children: [
//                   //         Container(
//                   //           margin: EdgeInsets.only(right: 10),
//                   //           child: CustomImageview(
//                   //             imagePath: "assets/images/msg.png",
//                   //             height: 14,
//                   //             width: 14,
//                   //             fit: BoxFit.contain,
//                   //           ),
//                   //         ),
//                   //         Text("21.3K"),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 6),
//             SizedBox(
//               width: width * 0.7,
//               child: Text(
//                 "${result.firstMessage}",
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Sora',
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             ShowChip(
//               items: result.tags?.split(',').map((e) => e.trim()).toList() ?? [],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ExploreScreensFilterBottomSheet extends StatelessWidget {
//   ExploreScreensFilterBottomSheet({super.key, required this.onTap});
//
//   final VoidCallback onTap;
//
//   final List<String> imagePaths = [
//     'assets/images/real_girl.png',
//     'assets/images/anime.png',
//   ];
//
//   final List<String> list = ['Men', 'Women', 'Non-Binary', 'Everyone'];
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30),
//         topRight: Radius.circular(30),
//       ),
//       child: Container(
//         width: double.maxFinite,
//         padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//           color: Color.fromRGBO(30, 30, 30, 1),
//           border: Border(
//             top: BorderSide(
//               color: Color.fromRGBO(255, 255, 255, 0.1),
//               width: 3,
//             ),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 0.6),
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               width: 100,
//               height: 5,
//             ),
//             SizedBox(height: 34),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Show me",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             GenderGridSelector(),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Character Style",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             SizedBox(height: height * 0.02),
//             VisibilitySelector(),
//             SizedBox(height: height * 0.015),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomElevatedButton(
//                   text: "Continue",
//                   width: width * 0.6,
//                   onPressed: () {
//                     onTap();
//                     HapticFeedback.heavyImpact();
//
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 SizedBox(width: width * 0.008),
//                 CustomElevatedButton(
//                   width: width * 0.3,
//
//                   text: "Reset",
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade700,
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   onPressed: () async {
//                     await setGenderType(0);
//                     await setCharType(0);
//                     onTap();
//                     HapticFeedback.mediumImpact();
//
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> setGenderType(int genderType) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setInt('gender_type', genderType);
//   }
//
//   Future<void> setCharType(int genderType) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setInt('char_type', genderType);
//   }
// }
//
// class DailyRewardBottomSheet extends StatefulWidget {
//   DailyRewardBottomSheet({super.key});
//
//   @override
//   State<DailyRewardBottomSheet> createState() => _DailyRewardBottomSheetState();
// }
//
// class _DailyRewardBottomSheetState extends State<DailyRewardBottomSheet> {
//   final DailyClaimBloc _dailyClaimBloc = DailyClaimBloc();
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return BlocConsumer<DailyClaimBloc, DailyClaimState>(
//       bloc: _dailyClaimBloc,
//       listener: (context, state) {
//         if (state is DailyClaimSuccessState) {
//           Navigator.of(context).pop();
//         } else if (state is DailyClaimExceptionState ||
//             state is DailyClaimFailureState) {}
//       },
//       builder: (context, state) {
//         return state is DailyClaimLoadingState
//             ? Center(child: CupertinoActivityIndicator())
//             : ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//               ),
//               child: Container(
//                 width: double.maxFinite,
//                 padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                   color: Color.fromRGBO(30, 30, 30, 1),
//                   border: Border(
//                     top: BorderSide(
//                       color: Color.fromRGBO(255, 255, 255, 0.1),
//                       width: 3,
//                     ),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   spacing: 15,
//                   children: [
//                     SizedBox(height: 1),
//                     Text(
//                       "Your Daily Reward",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 1),
//                     CustomImageview(
//                       imagePath: "assets/images/heart_icon.png",
//                       width: 61,
//                       height: 56,
//                     ),
//                     Text(
//                       "10 Credits",
//                       style: TextStyle(
//                         color: Color.fromRGBO(233, 64, 87, 1),
//                         fontSize: 57,
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       "Get free gems for each day you open app. You can spend gems on various items, gifts to your favorite characters.",
//                       textAlign: TextAlign.center,
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontFamily: 'Sora',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     CustomElevatedButton(
//                       text: "Claim Reward",
//                       onPressed: () {
//                         _dailyClaimBloc.add(
//                           DailyClaimDataEvent(makeSongData: {"amount": 10}),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ),
//             );
//       },
//     );
//   }
// }
//
// class GenderGridSelector extends StatefulWidget {
//   const GenderGridSelector({super.key});
//
//   @override
//   State<GenderGridSelector> createState() => _GenderGridSelectorState();
// }
//
// class _GenderGridSelectorState extends State<GenderGridSelector> {
//   final List<String> list = ['Men', 'Women', 'Non-binary', 'Everyone'];
//   String? selected;
//
//   @override
//   void initState() {
//     super.initState();
//     getGenderType();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       shrinkWrap: true,
//       crossAxisCount: 3,
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       childAspectRatio: isIPad(context) ? 3.5 : 2.5,
//       padding: const EdgeInsets.all(16),
//       children:
//           list.map((item) {
//             final bool isSelected = selected == item;
//             return GestureDetector(
//               onTap: () {
//                 HapticFeedback.lightImpact();
//
//                 setState(() {
//                   selected = item;
//                   if (item == "Men") {
//                     setGenderType(1);
//                   } else if (item == "Women") {
//                     setGenderType(2);
//                   } else if (item == "Non-Binary") {
//                     setGenderType(3);
//                   } else {
//                     setGenderType(3);
//                   }
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 7,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40),
//                   gradient:
//                       isSelected
//                           ? LinearGradient(
//                             colors: [
//                               Color.fromRGBO(138, 35, 135, 0.3),
//                               Color.fromRGBO(233, 64, 87, 0.3),
//                               Color.fromRGBO(242, 113, 33, 0.3),
//                             ],
//                           )
//                           : LinearGradient(
//                             colors: [
//                               Color.fromRGBO(255, 255, 255, 0.1),
//                               Color.fromRGBO(255, 255, 255, 0.2),
//                             ],
//                           ),
//                   border:
//                       isSelected
//                           ? Border.all(
//                             color: Color.fromRGBO(233, 64, 87, 1),
//                             width: 1,
//                           )
//                           : Border(),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: item == "Non-binary" ? 16 : 18,
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//     );
//   }
//
//   Future<void> getGenderType() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int genderType = preferences.getInt('gender_type') ?? 0;
//
//     setState(() {
//       switch (genderType) {
//         case 1:
//           selected = 'Men';
//           break;
//         case 2:
//           selected = 'Women';
//           break;
//         case 3:
//           selected = 'Non-binary';
//           break;
//         case 4:
//           selected = 'Everyone';
//           break;
//         default:
//           selected = null;
//       }
//     });
//   }
//
//   Future<void> setGenderType(int genderType) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setInt('gender_type', genderType);
//   }
// }
//
// class VisibilitySelector extends StatefulWidget {
//   const VisibilitySelector({super.key});
//
//   @override
//   State<VisibilitySelector> createState() => _VisibilitySelectorState();
// }
//
// class _VisibilitySelectorState extends State<VisibilitySelector> {
//   String selectedOption = '';
//
//   @override
//   void initState() {
//     super.initState();
//     getCharacterType(); // Load saved character type on init
//   }
//
//   BoxDecoration getBoxDecoration(bool isSelected) {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(150),
//       border:
//           (selectedOption.isNotEmpty && isSelected)
//               ? Border.all(color: Color.fromRGBO(233, 64, 87, 1), width: 3)
//               : null,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             HapticFeedback.lightImpact();
//
//             setState(() {
//               selectedOption = 'real';
//               setCharacterType(1);
//             });
//           },
//           child: Container(
//             // width: width * 0.5,
//             decoration: getBoxDecoration(selectedOption == 'real'),
//             // padding: EdgeInsets.all(15),
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(150),
//                   child: CustomImageview(
//                     imagePath: "assets/images/filter_girl_one.png",
//                     height: height * 0.11, // 115 is ~14% of 812
//                     width: width * 0.4, // 185 is ~49.3% of 375
//                   ),
//                 ),
//                 // SizedBox(height: height * 0.007),
//                 Positioned(
//                   bottom: 0,
//                   left: 60,
//                   child: Text(
//                     "Realistic",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Manrope',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(width: width * 0.05),
//         GestureDetector(
//           onTap: () {
//             HapticFeedback.lightImpact();
//
//             setState(() {
//               selectedOption = 'anim';
//               setCharacterType(2);
//             });
//           },
//           child: Container(
//             // width: width * 0.5,
//             decoration: getBoxDecoration(selectedOption == 'anim'),
//             // padding: EdgeInsets.all(15),
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(150),
//
//                   child: CustomImageview(
//                     imagePath: "assets/images/filter_girl_two.png",
//                     height: height * 0.11, // 115 is ~14% of 812
//                     width: width * 0.4, // 185 is ~49.3% of 375
//                   ),
//                 ),
//                 SizedBox(height: height * 0.007),
//                 Positioned(
//                   bottom: 0,
//                   left: 60,
//                   child: Text(
//                     "Anime",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Manrope',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> getCharacterType() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     int? type = preferences.getInt('char_type');
//
//     if (type != null) {
//       setState(() {
//         selectedOption =
//             (type == 2)
//                 ? 'anim'
//                 : (type == 1)
//                 ? 'real'
//                 : '';
//       });
//     } else {
//       setState(() {
//         selectedOption = ''; // No selection if not set before
//       });
//     }
//   }
//
//   Future<void> setCharacterType(int charType) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setInt('char_type', charType);
//   }
// }
//
// class ShowChip extends StatelessWidget {
//   final List<String> items;
//
//   const ShowChip({
//     super.key,
//     required this.items,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       alignment: WrapAlignment.start,
//       spacing: 12,
//       runSpacing: 12,
//       children: List.generate(items.length, (index) {
//         final item = items[index];
//
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: const Color.fromRGBO(255, 255, 255, 0.1),
//             border: Border.all(
//               color: const Color.fromRGBO(255, 255, 255, 0.2),
//               width: 1,
//             ),
//           ),
//           child: Text(
//             item,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // SizedBox(
// // height: height * 0.7,
// // child: Stack(
// // alignment: Alignment.center,
// // clipBehavior: Clip.none,
// // children: [
// // Positioned.fill(
// // child: Image.asset(
// // 'assets/images/bg_img.png',
// // fit: BoxFit.contain,
// // ),
// // ),
// // Column(
// // children: [
// // SizedBox(height: 70),
// // Image.asset(
// // "assets/gifs/heart.gif",
// // height: 180,
// // width: 179,
// // ),
// // Text(
// // "Get",
// // style: TextStyle(
// // color: Colors.white,
// // fontSize: 40,
// // fontFamily: 'Sora',
// // fontWeight: FontWeight.w400,
// // ),
// // ),
// // RichText(
// // text: TextSpan(
// // children: [
// // TextSpan(
// // text: "more ",
// // style: TextStyle(
// // color: Colors.white,
// // fontSize: 40,
// // fontFamily: 'Sora',
// // fontWeight: FontWeight.w400,
// // ),
// // ),
// // TextSpan(
// // text: "Swipes",
// // style: TextStyle(
// // color: Color.fromRGBO(
// // 242,
// // 113,
// // 33,
// // 1,
// // ),
// // fontSize: 40,
// // fontFamily: 'Sora',
// // fontWeight: FontWeight.w700,
// // ),
// // ),
// // TextSpan(
// // text: " in",
// // style: TextStyle(
// // color: Colors.white,
// // fontSize: 40,
// // fontFamily: 'Sora',
// // fontWeight: FontWeight.w400,
// // ),
// // ),
// // ],
// // ),
// // textAlign: TextAlign.center,
// // maxLines: 2,
// // overflow: TextOverflow.ellipsis,
// // ),
// // SizedBox(height: 15),
// // SlideCountdownSeparated(
// // duration: Duration(days: 50),
// // style: TextStyle(
// // color: Color.fromRGBO(
// // 233,
// // 64,
// // 87,
// // 1,
// // ),
// // fontWeight: FontWeight.w700,
// // fontSize: 40,
// // fontFamily: 'Sora',
// // ),
// // decoration: BoxDecoration(
// // color: Colors.white,
// // borderRadius:
// // BorderRadius.circular(10),
// // ),
// // ),
// // SizedBox(height: 110),
// // Text(
// // "Get unlimited swipes with premium",
// // style: TextStyle(
// // color: Colors.white,
// // fontSize: 18,
// // fontFamily: 'Manrope',
// // fontWeight: FontWeight.w400,
// // ),
// // ),
// // SizedBox(height: 10),
// // Padding(
// // padding: const EdgeInsets.symmetric(
// // horizontal: 18.0,
// // ),
// // child: CustomElevatedButton(
// // text: "Get Unlimited Swipes",
// // onPressed: () {},
// // ),
// // ),
// // ],
// // ),
// // ],
// // ),
// // )
