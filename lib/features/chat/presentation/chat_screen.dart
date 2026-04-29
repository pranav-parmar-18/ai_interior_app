// import 'dart:io';
// import 'dart:ui';
// import 'package:ai_interior/bloc/chat/delete_ai_message/delete_ai_message_bloc.dart';
// import 'package:ai_interior/bloc/chat/fix_ai_message_from_gf/fix_ai_message_from_gf_bloc.dart';
// import 'package:ai_interior/bloc/chat/get_request_people_message_list/get_request_people_message_list_bloc.dart';
// import 'package:ai_interior/features/chat/presentation/AI_chat_screen.dart';
// import 'package:ai_interior/features/chat/presentation/invite_screen.dart';
// import 'package:ai_interior/features/chat/presentation/people_chat_screen.dart';
// import 'package:ai_interior/features/credit/presentataion/credit_screen.dart';
// import 'package:ai_interior/features/main/presentaion/main_screen.dart';
// import 'package:ai_interior/models/get_request_people_message_list_response.dart';
// import 'package:ai_interior/widgets/custom_imageview.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../bloc/chat/get_ai_message_list/get_ai_message_list_bloc.dart';
// import '../../../bloc/chat/get_people_message_list/get_people_message_list_bloc.dart';
// import '../../../models/get_ai_chat_message_list_response.dart';
// import '../../../models/get_people_message_list_response.dart';
// import '../../../services/subscription_manager.dart';
// import '../../subscription/presentation/subscription_screen.dart';
// import '../../subscription/presentation/subscription_screen_three.dart';
// import '../../subscription/presentation/subscription_screen_two.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   late TabController _tabController;
//   String? credits;
//   final FixAIMessageFromGFBloc _fixAIMessageFromGFBloc =
//       FixAIMessageFromGFBloc();
//   bool? isSubscribed;
//
//   @override
//   void initState() {
//     super.initState();
//     getCredits();
//     _tabController = TabController(length: 3, vsync: this);
//     isSubscriptionActive();
//     _checkAndCallBloc();
//   }
//
//   Future<void> _checkAndCallBloc() async {
//     final prefs = await SharedPreferences.getInstance();
//     final hasCalled = prefs.getBool("fix_ai_message_called") ?? false;
//
//     if (!hasCalled) {
//       // 👇 Call your bloc only once
//       _fixAIMessageFromGFBloc.add(FixAIMessageFromGFDataEvent());
//
//       // ✅ Store flag so it won't be called again
//       await prefs.setBool("fix_ai_message_called", true);
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     print("PRINT");
//     setState(() {
//       getCredits();
//     });
//   }
//
//   Future<void> getCredits() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//
//     setState(() {
//       credits = preferences.getString('credits') ?? "0";
//     });
//     print("CREDITS  SC: ${credits}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(13, 13, 16, 1),
//       body: BlocConsumer<FixAIMessageFromGFBloc, FixAIMessageFromGFState>(
//         bloc: _fixAIMessageFromGFBloc,
//         listener: (context, state) {
//           if (state is FixAIMessageFromGFSuccessState) {
//           } else if (state is FixAIMessageFromGFExceptionState ||
//               state is FixAIMessageFromGFFailureState) {}
//         },
//         builder: (context, state) {
//           return SizedBox(
//             width: double.maxFinite,
//             child: Column(
//               children: [
//                 _buildTopappbar(context),
//                 Expanded(
//                   child: Container(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         AllTabPage(),
//                         PeopleTabPage(),
//                         RequestsTabPage(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTopappbar(BuildContext context) {
//     return SizedBox(
//       width: double.maxFinite,
//       child: ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
//           child: Container(
//             width: double.maxFinite,
//             padding: EdgeInsets.symmetric(vertical: 14),
//             decoration: BoxDecoration(color: Color(0X990D0D10)),
//             child: Column(
//               spacing: 22,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AppBar(
//                   elevation: 0,
//                   toolbarHeight: isIPad(context) ? 70 : 45,
//                   backgroundColor: Colors.transparent,
//                   automaticallyImplyLeading: false,
//                   centerTitle: true,
//                   title: Padding(
//                     padding: EdgeInsets.only(left: 5),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(
//                               context,
//                             ).pushNamed(InviteScreen.routeName);
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(right: 18),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Color.fromRGBO(233, 64, 87, 1),
//                                 width: 1,
//                               ),
//                               gradient: LinearGradient(
//                                 begin: Alignment(0, 0.5),
//                                 end: Alignment(1, 0.5),
//                                 colors: [
//                                   Color.fromRGBO(
//                                     138,
//                                     35,
//                                     135,
//                                     1,
//                                   ).withValues(alpha: 0.2),
//                                   Color.fromRGBO(
//                                     233,
//                                     64,
//                                     87,
//                                     1,
//                                   ).withValues(alpha: 0.2),
//                                   Color.fromRGBO(
//                                     242,
//                                     113,
//                                     33,
//                                     1,
//                                   ).withValues(alpha: 0.2),
//                                 ],
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.fromLTRB(11, 12, 12, 11),
//                                   child: CustomImageview(
//                                     imagePath: "assets/images/add_btn.png",
//                                     height: isIPad(context) ? 30 : 18,
//                                     width: isIPad(context) ? 25 : 20,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     right: 15,
//                                     left: 3,
//                                     top: 9,
//                                     bottom: 9,
//                                   ),
//                                   child: Text(
//                                     "Add",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: isIPad(context) ? 30 : 16,
//                                       fontFamily: 'Manrope',
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             left: Platform.isAndroid?15 :isIPad(context) ? 300 :isIPhoneMini(context)?23: 50,
//                           ),
//                           child: Text(
//                             "Chats",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: isIPad(context) ? 40 : 28,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   actions: [
//                     GestureDetector(
//                       onTap: () {
//                         HapticFeedback.heavyImpact();
//
//                         if (isSubscribed == true) {
//                           Navigator.of(
//                             context,
//                           ).pushNamed(CreditScreen.routeName).then((value) {
//                             setState(() {
//                               getCredits();
//                             });
//                           },);
//                         } else {
//                           openSubscriptionScreen(context);
//                         }
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(right: 18),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Color.fromRGBO(233, 64, 87, 1),
//                             width: 1,
//                           ),
//                           gradient: LinearGradient(
//                             begin: Alignment(0, 0.5),
//                             end: Alignment(1, 0.5),
//                             colors: [
//                               Color.fromRGBO(
//                                 138,
//                                 35,
//                                 135,
//                                 1,
//                               ).withValues(alpha: 0.2),
//                               Color.fromRGBO(
//                                 233,
//                                 64,
//                                 87,
//                                 1,
//                               ).withValues(alpha: 0.2),
//                               Color.fromRGBO(
//                                 242,
//                                 113,
//                                 33,
//                                 1,
//                               ).withValues(alpha: 0.2),
//                             ],
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 left: 15,
//                                 top: 9,
//                                 bottom: 9,
//                               ),
//                               child: Text(
//                                 credits.toString(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: isIPad(context) ? 30 : 16,
//                                   fontFamily: 'Manrope',
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(11, 12, 12, 11),
//                               child: CustomImageview(
//                                 imagePath: "assets/images/heart_icon.png",
//                                 height: isIPad(context) ? 30 : 18,
//                                 width: isIPad(context) ? 28 : 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 18),
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(37, 37, 40, 0.6),
//                     borderRadius: BorderRadius.circular(26),
//                   ),
//                   width: double.maxFinite,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(26),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelPadding: EdgeInsets.zero,
//                       labelColor: Colors.white,
//                       labelStyle: TextStyle(
//                         fontSize: isIPad(context) ? 30 : 18,
//                         fontFamily: 'Manrope',
//                         fontWeight: FontWeight.w700,
//                       ),
//                       unselectedLabelColor: Colors.white,
//                       unselectedLabelStyle: TextStyle(
//                         fontSize: isIPad(context) ? 30 : 18,
//                         fontFamily: 'Manrope',
//                         fontWeight: FontWeight.w500,
//                       ),
//                       indicatorSize: TabBarIndicatorSize.tab,
//                       indicator: BoxDecoration(
//                         borderRadius: BorderRadius.circular(26),
//                         gradient: LinearGradient(
//                           // begin: Alignment(0, 0.5),
//                           // end: Alignment(1, 0.5),
//                           colors: [
//                             Color.fromRGBO(138, 35, 135, 1),
//                             Color.fromRGBO(233, 64, 87, 1),
//                             Color.fromRGBO(242, 113, 33, 1),
//                           ],
//                         ),
//                       ),
//                       dividerHeight: 0.0,
//
//                       tabs: [
//                         Tab(
//                           height: isIPad(context) ? 70 : 52,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               "AI",
//                               style: TextStyle(
//                                 fontSize: isIPad(context) ? 30 : 18,
//                                 fontFamily: 'Manrope',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Tab(
//                           height: isIPad(context) ? 70 : 52,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               "People",
//                               style: TextStyle(
//                                 fontSize: isIPad(context) ? 30 : 18,
//                                 fontFamily: 'Manrope',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Tab(
//                           height: isIPad(context) ? 70 : 52,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               "Requests",
//                               style: TextStyle(
//                                 fontSize: isIPad(context) ? 30 : 18,
//                                 fontFamily: 'Manrope',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
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
//
// class AllTabPage extends StatefulWidget {
//   const AllTabPage({super.key});
//
//   @override
//   State<AllTabPage> createState() => _AllTabPageState();
// }
//
// class _AllTabPageState extends State<AllTabPage>
//     with AutomaticKeepAliveClientMixin {
//   final GetAIMessageListBloc _getAiMessageListBloc = GetAIMessageListBloc();
//   GetAIMessageListResponse? getAiMessageListResponse;
//   final DeleteAIMessageBloc _deleteAIMessageBloc = DeleteAIMessageBloc();
//
//   bool? isSubscribed;
//   bool _isFirstTime = true;
//
//   @override
//   void initState() {
//     super.initState();
//     isSubscriptionActive();
//
//     _getAiMessageListBloc.add(GetAIMessageListDataEvent());
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<GetAIMessageListBloc, GetAIMessageListState>(
//       bloc: _getAiMessageListBloc,
//       listener: (context, state) {
//         if (state is GetAIMessageListSuccessState) {
//           getAiMessageListResponse = state.exploreSongResponse;
//           setState(() {
//
//             _isFirstTime= false;
//           });
//         }
//       },
//       builder: (context, state) {
//         return state is GetAIMessageListLoadingState && _isFirstTime == true? Align(
//             child: Image.asset(
//               "assets/gifs/ai_loader.gif",
//               height: 250,
//               width: 250,
//             ),):(getAiMessageListResponse?.result?.length ?? 0) > 0
//             ? SingleChildScrollView(
//               child: Container(
//                 width: double.maxFinite,
//                 padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     ListView.separated(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: getAiMessageListResponse?.result?.length ?? 0,
//                       itemBuilder: (context, index) {
//                         final item = getAiMessageListResponse?.result?[index];
//
//                         return KeyedSubtree(
//                           key: ValueKey(item?.otherUserId),
//                           child: _buildMessage(
//                             context,
//                             index.toString(),
//                             (item?.otherUserId != null &&
//                                     item?.fromUserId != null &&
//                                     item!.otherUserId == item.fromUserId)
//                                 ? item.fromUserName
//                                 : item?.toUserName,
//
//                             getAiMessageListResponse?.result?[index] ??
//                                 AIMSGResult(),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) {
//                         return SizedBox(height: 10);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             )
//             : NoChatScreen();
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
//
//   Widget _buildMessage(
//     BuildContext context,
//     String messageId,
//     String? name,
//     AIMSGResult getAIMessageListResponse,
//   ) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Dismissible(
//       key: Key(messageId),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(211, 16, 39, 1),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             bottomLeft: Radius.circular(15),
//           ),
//         ),
//         child: Icon(Icons.delete, color: Colors.white, size: 28),
//       ),
//       confirmDismiss: (direction) async {
//         showDeleteDialog(
//           context,
//           getAIMessageListResponse.otherUserId.toString() ?? "",
//         );
//         return true;
//       },
//       onDismissed: (direction) {
//         // TODO: handle delete action (e.g. remove from list)
//         print('Message $messageId deleted');
//       },
//       child: InkWell(
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         hoverColor: Colors.transparent,
//         focusColor: Colors.transparent,
//         onTap: () {
//           if (isSubscribed == true) {
//             Navigator.of(context)
//                 .pushNamed(
//                   AIChatScreen.routeName,
//                   arguments: getAIMessageListResponse,
//                 )
//                 .then((value) {
//                   _getAiMessageListBloc.add(GetAIMessageListDataEvent());
//                 });
//           } else {
//             openSubscriptionScreen(context);
//           }
//         },
//         child: Container(
//           width: double.maxFinite,
//           margin: EdgeInsets.only(right: 4),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   height: height * 0.086, // 70 / 812
//                   width: width * 0.181,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       ClipOval(
//                         child: CustomImageview(
//                           imagePath: getAIMessageListResponse.image.toString(),
//                           height: height * 0.086,
//                           // Make sure height and width are the same
//                           width: height * 0.086,
//                         ),
//                       ),
//
//                       Positioned(
//                         bottom: 0,
//                         right: isIPad(context) ? 40 : 5,
//                         child: Container(
//                           height: isIPad(context) ? 25 : 14,
//                           width: isIPad(context) ? 25 : 14,
//                           margin: EdgeInsets.only(right: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             border: Border.all(
//                               color: Color.fromRGBO(138, 35, 135, 1),
//                               width: 1.5,
//                             ),
//                             gradient: LinearGradient(
//                               begin: Alignment(0.5, 0),
//                               end: Alignment(0.5, 1),
//                               colors: [Colors.greenAccent, Colors.greenAccent],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 15),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 2),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               name ?? "",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: isIPad(context) ? 30 : 20,
//                                 fontFamily: 'Manrope',
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Container(
//                               height: isIPad(context) ? 30 : 14,
//                               width: isIPad(context) ? 30 : 14,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 gradient: LinearGradient(
//                                   begin: Alignment(0.5, 0),
//                                   end: Alignment(0.5, 1),
//                                   colors: [
//                                     Colors.greenAccent,
//                                     Colors.greenAccent,
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: isIPad(context) ? 700 : 230,
//                               child: buildMessageText(context, getAIMessageListResponse.lastMessage ?? ''),
//                             ),
//                             Spacer(),
//                             Container(
//                               height: 3,
//                               width: 3,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(1),
//                               ),
//                             ),
//                             Container(
//                               width: 34,
//                               margin: EdgeInsets.only(left: 4),
//                               child: Text(
//                                 "25m",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                   fontFamily: 'Manrope',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildMessageText(BuildContext context, String? message) {
//     if (message == null || message.isEmpty) {
//       return const SizedBox();
//     }
//
//     final lower = message.toLowerCase();
//
//     bool isImage = lower.endsWith('.png') ||
//         lower.endsWith('.jpg') ||
//         lower.endsWith('.jpeg') ||
//         lower.endsWith('.gif') ||
//         lower.endsWith('.webp');
//
//     bool isVideo = lower.endsWith('.mp4') ||
//         lower.endsWith('.mov') ||
//         lower.endsWith('.avi') ||
//         lower.endsWith('.mkv') ||
//         lower.endsWith('.webm');
//
//     if (isImage) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(CupertinoIcons.photo, color: Colors.white, size: 18),
//           const SizedBox(width: 4),
//           Text(
//             'Image',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isIPad(context) ? 28 : 16,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       );
//     } else if (isVideo) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(CupertinoIcons.videocam, color: Colors.white, size: 18),
//           const SizedBox(width: 4),
//           Text(
//             'Video',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isIPad(context) ? 28 : 16,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Text(
//         message,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: isIPad(context) ? 28 : 16,
//           fontFamily: 'Manrope',
//           fontWeight: FontWeight.w500,
//         ),
//       );
//     }
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
//   void showDeleteDialog(BuildContext context, String id) {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return BlocConsumer<DeleteAIMessageBloc, DeleteAIMessageState>(
//           bloc: _deleteAIMessageBloc,
//           listener: (context, state) {
//             if (state is DeleteAIMessageSuccessState) {
//               Navigator.of(context).pop();
//               _getAiMessageListBloc.add(GetAIMessageListDataEvent());
//             } else if (state is DeleteAIMessageExceptionState ||
//                 state is DeleteAIMessageExceptionState) {}
//           },
//           builder: (context, state) {
//             return state is DeleteAIMessageLoadingState ? Align(
//               child: Image.asset(
//                 "assets/gifs/ai_loader.gif",
//                 height: 250,
//                 width: 250,
//               ),):CupertinoTheme(
//               data: CupertinoThemeData(
//                 brightness: Brightness.dark, // Force dark mode
//               ),
//               child: CupertinoAlertDialog(
//                 content: Padding(
//                   padding: const EdgeInsets.only(top: 0.0),
//                   child: Text(
//                     "Are you sure you want to clear history of this chat?",
//                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 actions: [
//                   CupertinoDialogAction(
//                     child: Text("Cancel"),
//                     onPressed: () async {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   CupertinoDialogAction(
//                     child: Text(
//                       "Clear",
//                       style: TextStyle(color: Colors.red.shade500),
//                     ),
//                     onPressed: () async {
//                       _deleteAIMessageBloc.add(
//                         DeleteAIMessageDataEvent(id: id.toString()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class PeopleTabPage extends StatefulWidget {
//   const PeopleTabPage({super.key});
//
//   @override
//   State<PeopleTabPage> createState() => _PeopleTabPageState();
// }
//
// class _PeopleTabPageState extends State<PeopleTabPage>
//     with AutomaticKeepAliveClientMixin {
//   final GetPeopleMessageListBloc _getPeopleMessageListBloc =
//       GetPeopleMessageListBloc();
//   GetPeopleRequestMessageListResponse? getPeopleMessageListResponse;
//   bool? isSubscribed;
//   final DeleteAIMessageBloc _deleteAIMessageBloc = DeleteAIMessageBloc();
//
//
//   bool _isFirstTime = true;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _getPeopleMessageListBloc.add(GetPeopleMessageListDataEvent());
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<GetPeopleMessageListBloc, GetPeopleMessageListState>(
//       bloc: _getPeopleMessageListBloc,
//       listener: (context, state) {
//         // TODO: implement listener
//       },
//       builder: (context, state) {
//         return (getPeopleMessageListResponse?.result?.length ?? 0) > 0
//             ? Container(
//               width: double.maxFinite,
//               padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     itemCount:
//                         getPeopleMessageListResponse?.result?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       return _buildMessage(
//                         context,
//                         '1',
//                         getPeopleMessageListResponse
//                                 ?.result?[index]
//                                 .fromUserName ??
//                             "",
//                           getPeopleMessageListResponse
//                               ?.result?[index] ?? PeopleMSGResult()
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return SizedBox(height: 10);
//                     },
//                   ),
//                 ],
//               ),
//             )
//             : NoChatScreen();
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
//
//   Widget _buildMessage(
//       BuildContext context,
//       String messageId,
//       String? name,
//       PeopleMSGResult getAIMessageListResponse,
//       ) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Dismissible(
//       key: Key(messageId),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(211, 16, 39, 1),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             bottomLeft: Radius.circular(15),
//           ),
//         ),
//         child: Icon(Icons.delete, color: Colors.white, size: 28),
//       ),
//       confirmDismiss: (direction) async {
//         showDeleteDialog(
//           context,
//           getAIMessageListResponse.otherUserId.toString() ?? "",
//         );
//       },
//
//       onDismissed: (direction) {
//         // TODO: handle delete action (e.g. remove from list)
//         print('Message $messageId deleted');
//       },
//       child: InkWell(
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         hoverColor: Colors.transparent,
//         focusColor: Colors.transparent,
//         onTap: () {
//           HapticFeedback.heavyImpact();
//           if (isSubscribed == true) {
//             Navigator.of(context)
//                 .pushNamed(
//               PeopleChatScreen.routeName,
//               arguments: getAIMessageListResponse,
//             )
//                 .then((value) {
//               _getPeopleMessageListBloc.add(GetPeopleMessageListDataEvent());
//             });
//           } else {
//             openSubscriptionScreen(context);
//           }
//         },
//         child: Container(
//           width: double.maxFinite,
//           margin: EdgeInsets.only(right: 4),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   height: height * 0.086, // 70 / 812
//                   width: width * 0.181,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       ClipOval(
//                         child: CustomImageview(
//                           imagePath: getAIMessageListResponse.image.toString(),
//                           height: height * 0.086,
//                           // Make sure height and width are the same
//                           width: height * 0.086,
//                         ),
//                       ),
//
//                       Positioned(
//                         bottom: 0,
//                         right: isIPad(context) ? 40 : 5,
//                         child: Container(
//                           height: isIPad(context) ? 25 : 14,
//                           width: isIPad(context) ? 25 : 14,
//                           margin: EdgeInsets.only(right: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             border: Border.all(
//                               color: Color.fromRGBO(138, 35, 135, 1),
//                               width: 1.5,
//                             ),
//                             gradient: LinearGradient(
//                               begin: Alignment(0.5, 0),
//                               end: Alignment(0.5, 1),
//                               colors: [Colors.greenAccent, Colors.greenAccent],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 15),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 2),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               name ?? "",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: isIPad(context) ? 30 : 20,
//                                 fontFamily: 'Manrope',
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Container(
//                               height: isIPad(context) ? 30 : 14,
//                               width: isIPad(context) ? 30 : 14,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 gradient: LinearGradient(
//                                   begin: Alignment(0.5, 0),
//                                   end: Alignment(0.5, 1),
//                                   colors: [
//                                     Colors.greenAccent,
//                                     Colors.greenAccent,
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: isIPad(context) ? 700 : 230,
//                               child: buildMessageText(context, getAIMessageListResponse.lastMessage ?? ''),
//                             ),
//                             Spacer(),
//                             Container(
//                               height: 3,
//                               width: 3,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(1),
//                               ),
//                             ),
//                             Container(
//                               width: 34,
//                               margin: EdgeInsets.only(left: 4),
//                               child: Text(
//                                 "25m",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                   fontFamily: 'Manrope',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildMessageText(BuildContext context, String? message) {
//     if (message == null || message.isEmpty) {
//       return const SizedBox();
//     }
//
//     final lower = message.toLowerCase();
//
//     bool isImage = lower.endsWith('.png') ||
//         lower.endsWith('.jpg') ||
//         lower.endsWith('.jpeg') ||
//         lower.endsWith('.gif') ||
//         lower.endsWith('.webp');
//
//     bool isVideo = lower.endsWith('.mp4') ||
//         lower.endsWith('.mov') ||
//         lower.endsWith('.avi') ||
//         lower.endsWith('.mkv') ||
//         lower.endsWith('.webm');
//
//     if (isImage) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(CupertinoIcons.photo, color: Colors.white, size: 18),
//           const SizedBox(width: 4),
//           Text(
//             'Image',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isIPad(context) ? 28 : 16,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       );
//     } else if (isVideo) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(CupertinoIcons.videocam, color: Colors.white, size: 18),
//           const SizedBox(width: 4),
//           Text(
//             'Video',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isIPad(context) ? 28 : 16,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Text(
//         message,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: isIPad(context) ? 28 : 16,
//           fontFamily: 'Manrope',
//           fontWeight: FontWeight.w500,
//         ),
//       );
//     }
//   }
//
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
//   void showDeleteDialog(BuildContext context, String id) {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return BlocConsumer<DeleteAIMessageBloc, DeleteAIMessageState>(
//           bloc: _deleteAIMessageBloc,
//           listener: (context, state) {
//             if (state is DeleteAIMessageSuccessState) {
//               Navigator.of(context).pop();
//               _getPeopleMessageListBloc.add(GetPeopleMessageListDataEvent());
//             } else if (state is DeleteAIMessageExceptionState ||
//                 state is DeleteAIMessageExceptionState) {}
//           },
//           builder: (context, state) {
//             return state is DeleteAIMessageLoadingState ? Align(
//               child: Image.asset(
//                 "assets/gifs/ai_loader.gif",
//                 height: 250,
//                 width: 250,
//               ),):CupertinoTheme(
//               data: CupertinoThemeData(
//                 brightness: Brightness.dark, // Force dark mode
//               ),
//               child: CupertinoAlertDialog(
//                 content: Padding(
//                   padding: const EdgeInsets.only(top: 0.0),
//                   child: Text(
//                     "Are you sure you want to clear history of this chat?",
//                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 actions: [
//                   CupertinoDialogAction(
//                     child: Text("Cancel"),
//                     onPressed: () async {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   CupertinoDialogAction(
//                     child: Text(
//                       "Clear",
//                       style: TextStyle(color: Colors.red.shade500),
//                     ),
//                     onPressed: () async {
//                       _deleteAIMessageBloc.add(
//                         DeleteAIMessageDataEvent(id: id.toString()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class RequestsTabPage extends StatefulWidget {
//   const RequestsTabPage({super.key});
//
//   @override
//   State<RequestsTabPage> createState() => _RequestsTabPageState();
// }
//
// class _RequestsTabPageState extends State<RequestsTabPage>
//     with AutomaticKeepAliveClientMixin {
//   final GetRequestPeopleMessageListBloc _getRequestPeopleMessageListBloc =
//       GetRequestPeopleMessageListBloc();
//   GetRequestPeopleRequestMessageListResponse?
//   getRequestPeopleRequestMessageListResponse;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _getRequestPeopleMessageListBloc.add(
//       GetRequestPeopleMessageListDataEvent(),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<
//       GetRequestPeopleMessageListBloc,
//       GetRequestPeopleMessageListState
//     >(
//       bloc: _getRequestPeopleMessageListBloc,
//       listener: (context, state) {
//         // TODO: implement listener
//       },
//       builder: (context, state) {
//         return (getRequestPeopleRequestMessageListResponse?.result?.length ??
//                     0) >
//                 0
//             ? Container(
//               width: double.maxFinite,
//               padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   ListView.separated(
//                     shrinkWrap: true,
//                     itemCount:
//                         getRequestPeopleRequestMessageListResponse
//                             ?.result
//                             ?.length ??
//                         0,
//                     itemBuilder: (context, index) {
//                       return _buildMessage(
//                         context,
//                         '1',
//                         getRequestPeopleRequestMessageListResponse
//                                 ?.result?[index]
//                                 .fromUserName ??
//                             "",
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return SizedBox(height: 10);
//                     },
//                   ),
//                 ],
//               ),
//             )
//             : NoChatScreen();
//       },
//     );
//   }
//
//   Widget _buildMessage(BuildContext context, String messageId, String name) {
//     return Dismissible(
//       key: Key(messageId),
//       direction: DismissDirection.endToStart,
//       // Swipe left
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(211, 16, 39, 1),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             bottomLeft: Radius.circular(15),
//           ),
//         ),
//         child: Icon(Icons.delete, color: Colors.white, size: 28),
//       ),
//       confirmDismiss: (direction) async {
//         showDeleteDialog(context, 0);
//       },
//
//       onDismissed: (direction) {
//         // TODO: handle delete action (e.g. remove from list)
//         print('Message $messageId deleted');
//       },
//       child: GestureDetector(
//         onTap: () {
//           // Navigator.of(context).pushNamed(AIChatScreen.routeName);
//         },
//         child: Container(
//           width: double.maxFinite,
//           margin: EdgeInsets.only(right: 4),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   height: 70,
//                   width: 68,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(34),
//                         child: CustomImageview(
//                           imagePath: "assets/images/anim_one.png",
//                           height: 70,
//                           width: 68,
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Container(
//                           height: 14,
//                           width: 14,
//                           margin: EdgeInsets.only(right: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(
//                               color: Color.fromRGBO(138, 35, 135, 1),
//                               width: 1.5,
//                             ),
//                             gradient: LinearGradient(
//                               begin: Alignment(0.5, 0),
//                               end: Alignment(0.5, 1),
//                               colors: [Colors.greenAccent, Colors.greenAccent],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 15),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 2),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Irma",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontFamily: 'Manrope',
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Container(
//                               height: 14,
//                               width: 14,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 gradient: LinearGradient(
//                                   begin: Alignment(0.5, 0),
//                                   end: Alignment(0.5, 1),
//                                   colors: [
//                                     Colors.greenAccent,
//                                     Colors.greenAccent,
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 156,
//                               child: Text(
//                                 "Hola! How are ya",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontFamily: 'Manrope',
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               height: 3,
//                               width: 3,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(1),
//                               ),
//                             ),
//                             Container(
//                               width: 34,
//                               margin: EdgeInsets.only(left: 4),
//                               child: Text(
//                                 "25m",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                   fontFamily: 'Manrope',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showDeleteDialog(BuildContext context, int index) {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return CupertinoTheme(
//           data: CupertinoThemeData(
//             brightness: Brightness.dark, // Force dark mode
//           ),
//           child: CupertinoAlertDialog(
//             content: Padding(
//               padding: const EdgeInsets.only(top: 0.0),
//               child: Text(
//                 "Are you sure you want to clear history of this chat?",
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//               ),
//             ),
//             actions: [
//               CupertinoDialogAction(
//                 child: Text("Cancel"),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               CupertinoDialogAction(
//                 child: Text(
//                   "Clear",
//                   style: TextStyle(color: Colors.red.shade500),
//                 ),
//                 onPressed: () async {},
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class NoChatScreen extends StatelessWidget {
//   const NoChatScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Screen dimensions
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     // Scale factors
//     double wp(double percent) => screenWidth * percent / 100;
//     double hp(double percent) => screenHeight * percent / 100;
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: wp(10), // ~72px at 720px width
//         vertical: hp(20),   // ~168px at 840px height
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.symmetric(horizontal: wp(8.5)), // ~62px
//                   height: hp(20), // ~160px
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       // Blurred Gradient Background
//                       ImageFiltered(
//                         imageFilter: ImageFilter.blur(
//                           sigmaY: wp(10),
//                           sigmaX: wp(10),
//                         ),
//                         child: Container(
//                           height: hp(20),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(hp(10)),
//                             gradient: const LinearGradient(
//                               begin: Alignment(0, 0.5),
//                               end: Alignment(1, 0.5),
//                               colors: [
//                                 Color.fromRGBO(138, 35, 135, 1),
//                                 Color.fromRGBO(233, 64, 87, 1),
//                                 Color.fromRGBO(242, 113, 33, 1),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Sharp Image on top
//                       Image.asset(
//                         "assets/images/no_chat.png",
//                         height: hp(20),
//                         width: hp(20),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: hp(2)),
//                 Text(
//                   "No conversations yet...",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: wp(5.5), // ~22px at 400px width
//                     fontFamily: 'Manrope',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: hp(1)),
//                 Text(
//                   "Ready to change that? Swipe right & \nlet the conversations begin.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: wp(4), // ~16px
//                     fontFamily: 'Manrope',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }