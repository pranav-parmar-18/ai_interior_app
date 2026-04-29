// import 'dart:async';
// import 'dart:io';
//
// import 'package:ai_interior/bloc/chat/get_ai_message_details/get_ai_message_details_bloc.dart';
// import 'package:ai_interior/bloc/chat/send_ai_message/send_ai_message_bloc.dart';
// import 'package:ai_interior/bloc/generate_message_media/generate_message_media_bloc.dart';
// import 'package:ai_interior/bloc/get_gift_list/get_gift_list_bloc.dart';
// import 'package:ai_interior/bloc/get_user_details/get_user_details_bloc.dart';
// import 'package:ai_interior/features/chat/presentation/AI_profile.dart';
// import 'package:ai_interior/features/chat/presentation/photos_screen.dart';
// import 'package:ai_interior/features/main/presentaion/main_screen.dart';
// import 'package:ai_interior/models/get_user_model_response.dart';
// import 'package:ai_interior/widgets/custom_elevated_button.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart' as ja;
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../bloc/chat/get_people_message_details/get_people_message_details_bloc.dart';
// import '../../../bloc/chat/send_people_message/send_people_message_bloc.dart';
// import '../../../models/get_ai_chat_message_list_response.dart';
// import '../../../models/get_ai_meesage_details_response.dart';
// import '../../../models/get_gift_list_response.dart';
// import '../../../widgets/custom_imageview.dart';
// import '../../credit/presentataion/credit_screen.dart';
//
// class PeopleChatScreen extends StatefulWidget {
//   const PeopleChatScreen({super.key});
//
//   static const routeName = "/people-chat";
//
//   @override
//   State<PeopleChatScreen> createState() => _AiChatScreenState();
// }
//
// class _AiChatScreenState extends State<PeopleChatScreen> {
//   Timer? _timer;
//   bool _isPolling = false;
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final SendPeopleMessageBloc _sendAIMessageBloc = SendPeopleMessageBloc();
//   final GetPeopleMessageDetailsBloc _getAIMessageDetailsBloc =
//   GetPeopleMessageDetailsBloc();
//   GetAiMessageDetailsResponse? getAiMessageDetailsResponse;
//   final GenerateMessageMediaBloc _generateMessageMediaBloc =
//   GenerateMessageMediaBloc();
//   final GetUsersBloc _getUsersBloc = GetUsersBloc();
//   UserModelResponse? userModelResponse;
//
//   AIMSGResult? aiMsgResults;
//   final GetGiftListBloc _getGiftListBloc = GetGiftListBloc();
//   GetGiftListResponse? giftListResponse;
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   String? credits;
//
//   @override
//   void initState() {
//     super.initState();
//     _getGiftListBloc.add(GetGiftListDataEvent());
//   }
//
//   void _startFastPolling() {
//     print("CODE GOES HERE IN API FETCHING");
//     if (_isPolling) return; // already polling, don’t restart
//     print("_isPolling $_isPolling");
//
//     _isPolling = true;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _getAIMessageDetailsBloc.add(
//         GetPeopleMessageDetailsDataEvent(
//           id: aiMsgResults?.otherUserId.toString() ?? "",
//         ),
//       );
//     });
//
//     // Optional: safety timeout (stop after 2 min max)
//     Future.delayed(const Duration(minutes: 1, seconds: 30), () {
//       if (_isPolling) _stopPolling();
//     });
//   }
//
//   void _stopPolling() {
//     print("CODE GOES HERE _stopPolling");
//     _timer?.cancel();
//     _isPolling = false;
//   }
//
//   bool _isInit = true;
//   bool _isFirstTime = true;
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _stopPolling();
//     super.dispose();
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     if (_isInit) {
//       aiMsgResults = ModalRoute.of(context)?.settings.arguments as AIMSGResult?;
//       print("TO ID  : ${aiMsgResults?.toUserId.toString()}");
//       print("FROM ID  : ${aiMsgResults?.fromUserId.toString()}");
//
//       _getAIMessageDetailsBloc.add(
//         GetPeopleMessageDetailsDataEvent(
//           id: aiMsgResults?.otherUserId.toString() ?? "",
//         ),
//       );
//       _isInit = false;
//     }
//   }
//
//   List<ChatMessage> _messageList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return BlocConsumer<GetPeopleMessageDetailsBloc, GetPeopleMessageDetailsState>(
//       bloc: _getAIMessageDetailsBloc,
//       listener: (context, state) {
//         if (state is GetPeopleMessageDetailsSuccessState) {
//           getAiMessageDetailsResponse = state.exploreSongResponse;
//
//           final List<ChatMessage> convertedMessages = [];
//
//           for (var result in getAiMessageDetailsResponse?.result ?? []) {
//             final isSender = result.role == 'user';
//
//             for (var content in result.content ?? []) {
//               MessageType msgType;
//               switch (content.messageType) {
//                 case 2:
//                   msgType = MessageType.image;
//                   break;
//                 case 3:
//                   msgType = MessageType.video;
//                   break;
//                 case 4:
//                   msgType = MessageType.audio;
//                   break;
//                 case 5:
//                   msgType = MessageType.gift;
//                   break;
//                 case 1:
//                 default:
//                   msgType = MessageType.text;
//                   break;
//               }
//
//               final message = content.text ?? '';
//               String? uuid = content.uuid;
//               int? isViewed = content.isViewed;
//
//               convertedMessages.add(
//                 ChatMessage(
//                   message: message,
//                   isSender: isSender,
//                   type: msgType,
//                   uuid: uuid ?? "",
//                   isViewed: isViewed ?? 0,
//                 ),
//               );
//             }
//           }
//           if (_messageList.isNotEmpty) {
//             final lastMsg = convertedMessages.last;
//
//             // 🔹 Only check the most recent AI message
//             final aiGeneratingExists =
//                 !lastMsg.isSender &&
//                     lastMsg.type == MessageType.text &&
//                     (lastMsg.message.contains("I am generating") ||
//                         lastMsg.message.contains("I am sending"));
//
//             if (aiGeneratingExists) {
//               _startFastPolling(); // start 1s polling
//             }
//           }
//
//           setState(() {
//             _messageList.clear();
//             _messageList.addAll(convertedMessages);
//             _isFirstTime = false;
//           });
//           if (_isPolling == false) _scrollToBottom();
//         } else if (state is GetPeopleMessageDetailsFailureState ||
//             state is GetPeopleMessageDetailsFailureState) {}
//       },
//       builder: (context, state) {
//         return BlocConsumer<
//             GenerateMessageMediaBloc,
//             GenerateMessageMediaState
//         >(
//           bloc: _generateMessageMediaBloc,
//           listener: (context, state) {
//             if (state is GenerateMessageMediaSuccessState) {
//               _getAIMessageDetailsBloc.add(
//                 GetPeopleMessageDetailsDataEvent(
//                   id: aiMsgResults?.otherUserId.toString() ?? "",
//                 ),
//               );
//             } else if (state is GenerateMessageMediaFailureState ||
//                 state is GenerateMessageMediaExceptionState) {}
//           },
//           builder: (context, generateState) {
//             return BlocConsumer<GetGiftListBloc, GetGiftListState>(
//               bloc: _getGiftListBloc,
//               listener: (context, state) {
//                 if (state is GetGiftListSuccessState) {
//                   giftListResponse = state.exploreSongResponse;
//                   getUserId().then((value) {
//                     _getUsersBloc.add(GetUsersDataEvent(id: userId.toString()));
//                   });
//                 } else if (state is GetGiftListExceptionState ||
//                     state is GetGiftListExceptionState) {}
//               },
//               builder: (context, giftState) {
//                 return BlocConsumer<SendPeopleMessageBloc, SendPeopleMessageState>(
//                   bloc: _sendAIMessageBloc,
//                   listener: (context, state) {
//                     if (state is SendPeopleMessageSuccessState) {
//                       _messageController.clear();
//                       _getAIMessageDetailsBloc.add(
//                         GetPeopleMessageDetailsDataEvent(
//                           id: aiMsgResults?.otherUserId.toString() ?? "",
//                         ),
//                       );
//                       getUserId().then((value) {
//                         _getUsersBloc.add(
//                           GetUsersDataEvent(id: userId.toString()),
//                         );
//                       });
//                     } else if (state is SendPeopleMessageExceptionState ||
//                         state is SendPeopleMessageFailureState) {}
//                   },
//                   builder: (context, sendMessageState) {
//                     return state is GetPeopleMessageDetailsLoadingState &&
//                         _isFirstTime == true
//                         ? Stack(
//                       children: [
//                         Stack(
//                           children: [
//                             Positioned.fill(
//                               child: Opacity(
//                                 opacity: 0.5,
//                                 child: CachedNetworkImage(
//                                   imageUrl: aiMsgResults?.image ?? "",
//                                   fit: BoxFit.cover,
//                                   placeholder:
//                                       (context, url) => Center(
//                                     child: CupertinoActivityIndicator(
//                                       radius: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   errorWidget:
//                                       (context, url, error) => Center(
//                                     child: Icon(
//                                       CupertinoIcons
//                                           .photo_fill_on_rectangle_fill,
//                                       size: 40,
//                                       color: CupertinoColors.systemGrey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             Scaffold(
//                               resizeToAvoidBottomInset: true,
//                               backgroundColor: Color.fromRGBO(
//                                 13,
//                                 13,
//                                 16,
//                                 0.85,
//                               ),
//                               appBar: _buildAppBar(context),
//                               body: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Stack(
//                                       children: [
//                                         ListView.builder(
//                                           controller: _scrollController,
//                                           padding: EdgeInsets.only(
//                                             top: 10,
//                                             bottom: 80,
//                                           ),
//                                           itemCount: _messageList.length,
//                                           itemBuilder: (context, index) {
//                                             return buildMessageBubble(
//                                               _messageList[index],
//                                               index,
//                                               generateState,
//                                             );
//                                           },
//                                         ),
//
//                                         /// Typing indicator at bottom-left
//                                         if (sendMessageState
//                                         is SendPeopleMessageLoadingState)
//                                           Positioned(
//                                             bottom: 10,
//                                             left: 15,
//                                             child: Align(
//                                               alignment:
//                                               Alignment.bottomLeft,
//                                               child: Row(
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/gifs/chat_loader.gif",
//                                                     height: 25,
//                                                     width: 35,
//                                                   ),
//                                                   SizedBox(width: 10),
//                                                   Text(
//                                                     "${aiMsgResults?.fromUserName} is typing",
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 16,
//                                                       fontFamily: 'Manrope',
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.black,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                       ),
//                                       border: Border.symmetric(
//                                         horizontal: BorderSide(
//                                           width: 1,
//                                           color: Color.fromRGBO(
//                                             42,
//                                             42,
//                                             42,
//                                             1,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 20,
//                                       vertical: 20,
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             print("CREDITS : ${credits}");
//
//                                             showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (
//                                                   BuildContext context,
//                                                   ) {
//                                                 final height =
//                                                     MediaQuery.of(
//                                                       context,
//                                                     ).size.height;
//                                                 return Material(
//                                                   color: Colors.transparent,
//                                                   child: SafeArea(
//                                                     top: false,
//                                                     child: Container(
//                                                       height: height * 0.85,
//                                                       decoration: const BoxDecoration(
//                                                         color:
//                                                         CupertinoColors
//                                                             .systemBackground,
//                                                         borderRadius:
//                                                         BorderRadius.only(
//                                                           topLeft:
//                                                           Radius.circular(
//                                                             30,
//                                                           ),
//                                                           topRight:
//                                                           Radius.circular(
//                                                             30,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       child: showGiftFilterBottomSheet(
//                                                         context: context,
//                                                         credit:
//                                                         credits ?? '',
//
//                                                         aimsgResult:
//                                                         aiMsgResults ??
//                                                             AIMSGResult(),
//                                                         onTap: () {
//                                                           print(
//                                                             "HELLO GET MSG CALLED",
//                                                           );
//
//                                                           _getAIMessageDetailsBloc.add(
//                                                             GetPeopleMessageDetailsDataEvent(
//                                                               id:
//                                                               aiMsgResults
//                                                                   ?.otherUserId
//                                                                   .toString() ??
//                                                                   "",
//                                                             ),
//                                                           );
//                                                           setState(() {});
//                                                           print(
//                                                             "AFTER HELLO GET MSG CALLED",
//                                                           );
//                                                         },
//                                                         giftListResponse:
//                                                         giftListResponse ??
//                                                             GetGiftListResponse(),
//                                                         height: height,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                           child: CustomImageview(
//                                             imagePath:
//                                             "assets/images/gift_chat.png",
//                                             height:
//                                             isIPad(context)
//                                                 ? height * 0.055
//                                                 : 50, // ≈50 when height is ~900
//                                             width:
//                                             isIPad(context)
//                                                 ? width * 0.075
//                                                 : 50,
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         Flexible(
//                                           child: Scrollbar(
//                                             thickness: 5,
//                                             radius: Radius.circular(8),
//                                             child: TextFormField(
//                                               controller:
//                                               _messageController,
//                                               style: TextStyle(
//                                                 fontSize:
//                                                 isIPad(context)
//                                                     ? 30
//                                                     : 18,
//                                                 color: Colors.white,
//                                                 fontFamily: 'Manrope',
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                               keyboardType: Platform.isIOS ? TextInputType.text : TextInputType.multiline,
//                                               textInputAction: Platform.isIOS ? TextInputAction.done : TextInputAction.newline,
//                                               minLines: 1,
//                                               // start with single line
//                                               maxLines: 3,
//                                               // grow automatically (no limit)
//                                               decoration: InputDecoration(
//                                                 hintText:
//                                                 "Type your message here.",
//                                                 hintStyle: TextStyle(
//                                                   color: Color.fromRGBO(
//                                                     255,
//                                                     255,
//                                                     255,
//                                                     0.6,
//                                                   ),
//                                                   fontSize:
//                                                   isIPad(context)
//                                                       ? 30
//                                                       : 18,
//                                                   fontFamily: 'Manrope',
//                                                   fontWeight:
//                                                   FontWeight.w400,
//                                                 ),
//                                                 enabledBorder:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 focusedBorder:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 disabledBorder:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 filled: true,
//                                                 fillColor: Color.fromRGBO(
//                                                   255,
//                                                   255,
//                                                   255,
//                                                   0.08,
//                                                 ),
//                                                 isDense: true,
//                                                 contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   horizontal: 12,
//                                                   vertical: 10,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (_messageController.text
//                                                 .trim()
//                                                 .isNotEmpty) {
//                                               HapticFeedback.lightImpact();
//
//                                               print("######DATA");
//                                               print(
//                                                 "FROM ID : ${aiMsgResults?.fromUserId}",
//                                               );
//                                               print(
//                                                 "FROM NAME : ${aiMsgResults?.fromUserName}",
//                                               );
//                                               print(
//                                                 "TO ID : ${aiMsgResults?.toUserId}",
//                                               );
//                                               print(
//                                                 "TO NAME : ${aiMsgResults?.toUserName}",
//                                               );
//
//                                               _sendAIMessageBloc.add(
//                                                 SendPeopleMessageDataEvent(
//                                                   SendPeopleMessage: {
//                                                     "from_user_id":
//                                                     aiMsgResults
//                                                         ?.userId,
//                                                     "from_user_name":
//                                                     aiMsgResults?.otherUserId ==
//                                                         aiMsgResults
//                                                             ?.fromUserId
//                                                         ? aiMsgResults
//                                                         ?.fromUserName
//                                                         : aiMsgResults
//                                                         ?.toUserName,
//                                                     "to_user_id":
//                                                     aiMsgResults
//                                                         ?.otherUserId,
//                                                     "to_user_name":
//                                                     aiMsgResults?.otherUserId ==
//                                                         aiMsgResults
//                                                             ?.fromUserId
//                                                         ? aiMsgResults
//                                                         ?.fromUserName
//                                                         : aiMsgResults
//                                                         ?.toUserName,
//                                                     "message_type": 1,
//                                                     //   "message": "I have sent you a red bikini as gift: https://newaigf.b-cdn.net/Male/bikini.webp"
//                                                     "message":
//                                                     _messageController
//                                                         .text,
//                                                     //   "character_type": 2
//                                                   },
//                                                 ),
//                                               );
//                                               if (_messageController.text
//                                                   .trim()
//                                                   .isNotEmpty) {
//                                                 setState(() {
//                                                   _messageList.add(
//                                                     ChatMessage(
//                                                       message:
//                                                       _messageController
//                                                           .text
//                                                           .trim(),
//                                                       isSender: true,
//                                                       type:
//                                                       MessageType.text,
//                                                     ),
//                                                   );
//                                                   _messageController
//                                                       .clear();
//                                                 });
//                                                 _scrollToBottom();
//                                               }
//                                             }
//                                           },
//                                           child:
//                                           sendMessageState
//                                           is SendPeopleMessageLoadingState
//                                               ? SizedBox(
//                                             height: 50,
//                                             width: 50,
//                                             child: Center(
//                                               child:
//                                               CupertinoActivityIndicator(
//                                                 radius: 18,
//                                                 color:
//                                                 Colors
//                                                     .white,
//                                               ),
//                                             ),
//                                           )
//                                               : CustomImageview(
//                                             imagePath:
//                                             "assets/images/chat_message.png",
//                                             height:
//                                             isIPad(context)
//                                                 ? height * 0.055
//                                                 : 50, // ≈50 when height is ~900
//                                             width:
//                                             isIPad(context)
//                                                 ? width * 0.075
//                                                 : 50,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // bottomNavigationBar: ,
//                             ),
//                           ],
//                         ),
//                         Positioned.fill(
//                           child: Container(color: Colors.black12),
//                         ),
//                         Align(
//                           child: Image.asset(
//                             "assets/gifs/ai_loader.gif",
//                             height: 250,
//                             width: 250,
//                           ),
//                         ),
//                       ],
//                     )
//                         : BlocConsumer<GetUsersBloc, GetUsersState>(
//                       bloc: _getUsersBloc,
//                       listener: (context, state) {
//                         if (state is GetUsersSuccessState) {
//                           userModelResponse = state.user;
//                           setState(() {
//                             credits =
//                                 userModelResponse?.result?.credits
//                                     .toString() ??
//                                     "";
//                           });
//                           setCredits(
//                             double.tryParse(
//                               userModelResponse?.result?.credits
//                                   ?.toString() ??
//                                   "0",
//                             )?.toInt().toString() ??
//                                 "0",
//                           );
//
//                           print("CREDITS BLOC : ${credits}");
//                         } else if (state is GetUsersExceptionState ||
//                             state is GetUsersFailureState) {}
//                       },
//                       builder: (context, userstate) {
//                         return Stack(
//                           children: [
//                             Positioned.fill(
//                               child: Opacity(
//                                 opacity: 0.5,
//                                 child: CachedNetworkImage(
//                                   imageUrl: aiMsgResults?.image ?? "",
//                                   fit: BoxFit.cover,
//                                   placeholder:
//                                       (context, url) => Center(
//                                     child: CupertinoActivityIndicator(
//                                       radius: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   errorWidget:
//                                       (context, url, error) => Center(
//                                     child: Icon(
//                                       CupertinoIcons
//                                           .photo_fill_on_rectangle_fill,
//                                       size: 40,
//                                       color: CupertinoColors.systemGrey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             Scaffold(
//                               resizeToAvoidBottomInset: true,
//                               backgroundColor: Color.fromRGBO(
//                                 13,
//                                 13,
//                                 16,
//                                 0.85,
//                               ),
//                               appBar: _buildAppBar(context),
//                               body: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Stack(
//                                       children: [
//                                         ListView.builder(
//                                           controller: _scrollController,
//                                           padding: EdgeInsets.only(
//                                             top: 10,
//                                             bottom: 80,
//                                           ),
//                                           itemCount: _messageList.length,
//                                           itemBuilder: (context, index) {
//                                             return buildMessageBubble(
//                                               _messageList[index],
//                                               index,
//                                               generateState,
//                                             );
//                                           },
//                                         ),
//
//                                         /// Typing indicator at bottom-left
//                                         if (sendMessageState
//                                         is SendPeopleMessageLoadingState)
//                                           Positioned(
//                                             bottom: 10,
//                                             left: 15,
//                                             child: Align(
//                                               alignment:
//                                               Alignment.bottomLeft,
//                                               child: Row(
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/gifs/chat_loader.gif",
//                                                     height: 25,
//                                                     width: 35,
//                                                   ),
//                                                   SizedBox(width: 10),
//                                                   Text(
//                                                     "${aiMsgResults?.fromUserName} is typing",
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 16,
//                                                       fontFamily: 'Manrope',
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.black,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                       ),
//                                       border: Border.symmetric(
//                                         horizontal: BorderSide(
//                                           width: 1,
//                                           color: Color.fromRGBO(
//                                             42,
//                                             42,
//                                             42,
//                                             1,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 20,
//                                       vertical: 20,
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             print("CREDITS : ${credits}");
//
//                                             showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (
//                                                   BuildContext context,
//                                                   ) {
//                                                 final height =
//                                                     MediaQuery.of(
//                                                       context,
//                                                     ).size.height;
//                                                 return Material(
//                                                   color: Colors.transparent,
//                                                   child: SafeArea(
//                                                     top: false,
//                                                     child: Container(
//                                                       height: height * 0.85,
//                                                       decoration: const BoxDecoration(
//                                                         color:
//                                                         CupertinoColors
//                                                             .systemBackground,
//                                                         borderRadius:
//                                                         BorderRadius.only(
//                                                           topLeft:
//                                                           Radius.circular(
//                                                             30,
//                                                           ),
//                                                           topRight:
//                                                           Radius.circular(
//                                                             30,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       child: showGiftFilterBottomSheet(
//                                                         context: context,
//                                                         credit:
//                                                         credits ?? '',
//
//                                                         aimsgResult:
//                                                         aiMsgResults ??
//                                                             AIMSGResult(),
//                                                         onTap: () {
//                                                           print(
//                                                             "HELLO GET MSG CALLED",
//                                                           );
//
//                                                           _getAIMessageDetailsBloc.add(
//                                                             GetPeopleMessageDetailsDataEvent(
//                                                               id:
//                                                               aiMsgResults
//                                                                   ?.otherUserId
//                                                                   .toString() ??
//                                                                   "",
//                                                             ),
//                                                           );
//                                                           setState(() {});
//                                                           print(
//                                                             "AFTER HELLO GET MSG CALLED",
//                                                           );
//                                                         },
//                                                         giftListResponse:
//                                                         giftListResponse ??
//                                                             GetGiftListResponse(),
//                                                         height: height,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                           child: CustomImageview(
//                                             imagePath:
//                                             "assets/images/gift_chat.png",
//                                             height:
//                                             isIPad(context)
//                                                 ? height * 0.055
//                                                 : 50, // ≈50 when height is ~900
//                                             width:
//                                             isIPad(context)
//                                                 ? width * 0.075
//                                                 : 50,
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         Flexible(
//                                           child: Scrollbar(
//                                             thickness: 5,
//                                             radius: Radius.circular(8),
//                                             child: TextFormField(
//                                               controller:
//                                               _messageController,
//                                               style: TextStyle(
//                                                 fontSize:
//                                                 isIPad(context)
//                                                     ? 30
//                                                     : 18,
//                                                 color: Colors.white,
//                                                 fontFamily: 'Manrope',
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                               keyboardType: Platform.isIOS ? TextInputType.text : TextInputType.multiline,
//                                               textInputAction: Platform.isIOS ? TextInputAction.done : TextInputAction.newline,
//                                               minLines: 1,
//                                               // start with single line
//                                               maxLines: 3,
//                                               // grow automatically (no limit)
//                                               decoration: InputDecoration(
//                                                 hintText:
//                                                 "Type your message here.",
//                                                 hintStyle: TextStyle(
//                                                   color: Color.fromRGBO(
//                                                     255,
//                                                     255,
//                                                     255,
//                                                     0.6,
//                                                   ),
//                                                   fontSize:
//                                                   isIPad(context)
//                                                       ? 30
//                                                       : 18,
//                                                   fontFamily: 'Manrope',
//                                                   fontWeight:
//                                                   FontWeight.w400,
//                                                 ),
//                                                 enabledBorder:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 focusedBorder:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 disabledBorder:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                     20,
//                                                   ),
//                                                   borderSide:
//                                                   BorderSide.none,
//                                                 ),
//                                                 filled: true,
//                                                 fillColor: Color.fromRGBO(
//                                                   255,
//                                                   255,
//                                                   255,
//                                                   0.08,
//                                                 ),
//                                                 isDense: true,
//                                                 contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   horizontal: 12,
//                                                   vertical: 10,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: width * 0.02),
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (_messageController.text
//                                                 .trim()
//                                                 .isNotEmpty) {
//                                               HapticFeedback.lightImpact();
//
//                                               print("######DATA");
//                                               print(
//                                                 "FROM ID : ${aiMsgResults?.fromUserId}",
//                                               );
//                                               print(
//                                                 "FROM NAME : ${aiMsgResults?.fromUserName}",
//                                               );
//                                               print(
//                                                 "TO ID : ${aiMsgResults?.toUserId}",
//                                               );
//                                               print(
//                                                 "TO NAME : ${aiMsgResults?.toUserName}",
//                                               );
//
//                                               _sendAIMessageBloc.add(
//                                                 SendPeopleMessageDataEvent(
//                                                   SendPeopleMessage: {
//                                                     "from_user_id":
//                                                     aiMsgResults
//                                                         ?.userId,
//                                                     "from_user_name":
//                                                     aiMsgResults?.otherUserId ==
//                                                         aiMsgResults
//                                                             ?.fromUserId
//                                                         ? aiMsgResults
//                                                         ?.fromUserName
//                                                         : aiMsgResults
//                                                         ?.toUserName,
//                                                     "to_user_id":
//                                                     aiMsgResults
//                                                         ?.otherUserId,
//                                                     "to_user_name":
//                                                     aiMsgResults?.otherUserId ==
//                                                         aiMsgResults
//                                                             ?.fromUserId
//                                                         ? aiMsgResults
//                                                         ?.fromUserName
//                                                         : aiMsgResults
//                                                         ?.toUserName,
//                                                     "message_type": 1,
//                                                     //   "message": "I have sent you a red bikini as gift: https://newaigf.b-cdn.net/Male/bikini.webp"
//                                                     "message":
//                                                     _messageController
//                                                         .text,
//                                                     //   "character_type": 2
//                                                   },
//                                                 ),
//                                               );
//                                               if (_messageController.text
//                                                   .trim()
//                                                   .isNotEmpty) {
//                                                 setState(() {
//                                                   _messageList.add(
//                                                     ChatMessage(
//                                                       message:
//                                                       _messageController
//                                                           .text
//                                                           .trim(),
//                                                       isSender: true,
//                                                       type:
//                                                       MessageType.text,
//                                                     ),
//                                                   );
//                                                   _messageController
//                                                       .clear();
//                                                 });
//                                                 _scrollToBottom();
//                                               }
//                                             }
//                                           },
//                                           child:
//                                           sendMessageState
//                                           is SendPeopleMessageLoadingState
//                                               ? SizedBox(
//                                             height: 50,
//                                             width: 50,
//                                             child: Center(
//                                               child:
//                                               CupertinoActivityIndicator(
//                                                 radius: 18,
//                                                 color:
//                                                 Colors
//                                                     .white,
//                                               ),
//                                             ),
//                                           )
//                                               : CustomImageview(
//                                             imagePath:
//                                             "assets/images/chat_message.png",
//                                             height:
//                                             isIPad(context)
//                                                 ? height * 0.055
//                                                 : 50, // ≈50 when height is ~900
//                                             width:
//                                             isIPad(context)
//                                                 ? width * 0.075
//                                                 : 50,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // bottomNavigationBar: ,
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showFullScreenImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Dialog(
//           insetPadding: EdgeInsets.zero,
//           backgroundColor: Colors.black,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: InteractiveViewer(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(30),
//                     child: CachedNetworkImage(
//                       imageUrl: imageUrl,
//                       fit: BoxFit.contain,
//                       placeholder:
//                           (context, url) => Center(
//                         child: CupertinoActivityIndicator(
//                           radius: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                       errorWidget:
//                           (context, url, error) => Center(
//                         child: Icon(
//                           CupertinoIcons.photo_fill_on_rectangle_fill,
//                           size: 40,
//                           color: CupertinoColors.systemGrey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               Positioned(
//                 top: 40,
//                 right: 20,
//                 child: GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.black54,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       CupertinoIcons.clear,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Future<void> setCredits(String userId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString('credits', userId);
//   }
//
//   int? _loadingIndex; // store only one index at a time
//
//   Widget buildMessageBubble(
//       ChatMessage msg,
//       int index,
//       GenerateMessageMediaState state,
//       ) {
//     final bool isLoading = _loadingIndex == index;
//
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     final bubble = Align(
//       alignment: msg.isSender ? Alignment.topRight : Alignment.topLeft,
//       child: Container(
//         width:
//         isLoading &&
//             !msg.isSender &&
//             (msg.type == MessageType.image ||
//                 msg.type == MessageType.gift)
//             ? width * 0.45
//             : !msg.isSender && msg.type == MessageType.text
//             ? width * 0.7
//             : null,
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius:
//           msg.isSender
//               ? const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(5),
//             topRight: Radius.circular(20),
//           )
//               : const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             bottomLeft: Radius.circular(5),
//             bottomRight: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           color: msg.isSender ? null : const Color.fromRGBO(255, 255, 255, 0.7),
//           gradient:
//           msg.isSender
//               ? const LinearGradient(
//             colors: [
//               Color.fromRGBO(138, 35, 135, 1),
//               Color.fromRGBO(233, 64, 87, 1),
//               Color.fromRGBO(242, 113, 33, 1),
//             ],
//           )
//               : null,
//         ),
//         padding:
//         msg.type == MessageType.text
//             ? const EdgeInsets.all(15)
//             : EdgeInsets.zero,
//         child: buildMessageContent(msg, index, state),
//       ),
//     );
//
//     // Animate both sender & receiver
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         final opacity = value.clamp(0.0, 1.0); // ✅ safe opacity
//         return Opacity(
//           opacity: opacity,
//           child: Transform.translate(
//             offset: Offset(
//               msg.isSender
//                   ? 100 *
//                   (1 - value) // slide from right
//                   : -100 * (1 - value), // slide from left
//               0,
//             ),
//             child: child,
//           ),
//         );
//       },
//       child: bubble,
//     );
//   }
//
//   Widget buildMessageContent(
//       ChatMessage msg,
//       int index,
//       GenerateMessageMediaState state,
//       ) {
//     final bool isLoading = _loadingIndex == index;
//
//     switch (msg.type) {
//       case MessageType.text:
//       // case MessageType.gift:
//         final RegExp imageUrlPattern = RegExp(
//           r'(https?:\/\/[^\s]+\.(?:png|jpg|jpeg|webp|gif))',
//           caseSensitive: false,
//         );
//
//         final match = imageUrlPattern.firstMatch(msg.message);
//
//         if (match != null && msg.type == MessageType.gift) {
//           final imageUrl = match.group(0)!;
//           final messageText = msg.message.replaceAll(imageUrl, '').trim();
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 messageText,
//                 style: TextStyle(
//                   color:
//                   msg.isSender
//                       ? Colors.white
//                       : Color.fromRGBO(13, 13, 16, 1),
//                   fontSize: isIPad(context) ? 30 : 18,
//                   fontFamily: 'Manrope',
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: CachedNetworkImage(
//                   imageUrl: imageUrl,
//                   alignment: Alignment.center,
//                   width: 100,
//                   height: 100,
//                   fit: BoxFit.cover,
//                   placeholder:
//                       (context, url) => CupertinoActivityIndicator(
//                     radius: 12,
//                     color: Colors.grey,
//                   ),
//                   errorWidget:
//                       (context, url, error) => Container(
//                     width: 70,
//                     height: 70,
//                     color: Colors.grey[300],
//                     child: Icon(
//                       CupertinoIcons.photo_fill_on_rectangle_fill,
//                       size: 30,
//                       color: CupertinoColors.systemGrey,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Text(
//             msg.message,
//             style: TextStyle(
//               color:
//               msg.isSender ? Colors.white : Color.fromRGBO(13, 13, 16, 1),
//               fontSize: isIPad(context) ? 30 : 18,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w300,
//             ),
//           );
//         }
//
//       case MessageType.image:
//       case MessageType.gift:
//         if (!msg.isSender) {
//           return GestureDetector(
//             onTap: () {
//               if (msg.isViewed == 0) {
//                 setState(() => _loadingIndex = index);
//                 print("INDEX :: ${_loadingIndex}");
//                 _generateMessageMediaBloc.add(
//                   GenerateMessageMediaDataEvent(
//                     GenerateMessageMedia: {"uuid": msg.uuid.toString()},
//                   ),
//                 );
//                 Future.delayed(Duration(seconds: 3), () {
//                   if (mounted && _loadingIndex == index) {
//                     setState(() => _loadingIndex = null);
//                   }
//                 });
//               } else {
//                 showFullScreenImage(context, msg.message);
//               }
//             },
//             child:
//             isLoading == true && state is GenerateMessageMediaLoadingState
//                 ? Align(
//               alignment: Alignment.topLeft,
//
//               child: Image.asset(
//                 "assets/gifs/ai_loader.gif",
//                 height: 250,
//                 width: 250,
//                 fit: BoxFit.contain,
//               ),
//             )
//                 : msg.isViewed == 0
//                 ? Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     bottomLeft: Radius.circular(5),
//                     bottomRight: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: msg.message,
//                     width: isIPad(context) ? 250 : 200,
//                     height: isIPad(context) ? 300 : 250,
//                     fit: BoxFit.cover,
//                     placeholder:
//                         (context, url) => Container(
//                       width: 200,
//                       height: 250,
//                       alignment: Alignment.center,
//                       child: CupertinoActivityIndicator(
//                         radius: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                     errorWidget:
//                         (context, url, error) => Container(
//                       width: 200,
//                       height: 250,
//                       alignment: Alignment.center,
//                       color: Colors.grey[300],
//                       child: Icon(
//                         CupertinoIcons.photo_fill_on_rectangle_fill,
//                         size: 40,
//                         color: CupertinoColors.systemGrey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 100,
//                   left: 10,
//                   child: CustomElevatedButton(
//                     onPressed: () {
//                       setState(() => _loadingIndex = index);
//                       print("INDEX :: ${_loadingIndex}");
//                       _generateMessageMediaBloc.add(
//                         GenerateMessageMediaDataEvent(
//                           GenerateMessageMedia: {
//                             "uuid": msg.uuid.toString(),
//                           },
//                         ),
//                       );
//                       Future.delayed(Duration(seconds: 3), () {
//                         if (mounted && _loadingIndex == index) {
//                           setState(() => _loadingIndex = null);
//                         }
//                       });
//                     },
//                     height: 40,
//                     text: "Tap to See Photo",
//                     width: 180,
//                     buttonTextStyle: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontFamily: 'Manrope',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//                 : ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(5),
//                 bottomRight: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: msg.message,
//                 width: isIPad(context) ? 250 : 200,
//                 height: isIPad(context) ? 300 : 250,
//                 fit: BoxFit.cover,
//                 placeholder:
//                     (context, url) => Container(
//                   width: 200,
//                   height: 250,
//                   alignment: Alignment.center,
//                   child: Align(
//                     child: Image.asset(
//                       "assets/gifs/ai_loader.gif",
//                       height: 250,
//                       width: 250,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 errorWidget:
//                     (context, url, error) => Container(
//                   width: 200,
//                   height: 250,
//                   alignment: Alignment.center,
//                   color: Colors.grey[300],
//                   child: Icon(
//                     CupertinoIcons.photo_fill_on_rectangle_fill,
//                     size: 40,
//                     color: CupertinoColors.systemGrey,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         } else {
//           final RegExp imageUrlPattern = RegExp(
//             r'(https?:\/\/[^\s]+\.(?:png|jpg|jpeg|webp|gif))',
//             caseSensitive: false,
//           );
//
//           final match = imageUrlPattern.firstMatch(msg.message);
//           final imageUrl = match!.group(0)!;
//
//           final messageText = msg.message.replaceAll(imageUrl, '').trim();
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 9),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   messageText,
//                   style: TextStyle(
//                     color:
//                     msg.isSender
//                         ? Colors.white
//                         : Color.fromRGBO(13, 13, 16, 1),
//                     fontSize: isIPad(context) ? 30 : 18,
//                     fontFamily: 'Manrope',
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl,
//                     alignment: Alignment.center,
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                     placeholder:
//                         (context, url) => CupertinoActivityIndicator(
//                       radius: 12,
//                       color: Colors.grey,
//                     ),
//                     errorWidget:
//                         (context, url, error) => Container(
//                       width: 70,
//                       height: 70,
//                       color: Colors.grey[300],
//                       child: Icon(
//                         CupertinoIcons.photo_fill_on_rectangle_fill,
//                         size: 30,
//                         color: CupertinoColors.systemGrey,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//       case MessageType.video:
//         return SizedBox.shrink();
//
//       case MessageType.audio:
//         return AudioPlayerWidget(
//           url: msg.message,
//           onTap: () {
//             print("AUDIO TAP");
//             if (msg.isViewed == 0) {
//               _generateMessageMediaBloc.add(
//                 GenerateMessageMediaDataEvent(
//                   GenerateMessageMedia: {"uuid": msg.uuid.toString()},
//                 ),
//               );
//             }
//           },
//         );
//     }
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return AppBar(
//       elevation: 3,
//       backgroundColor: Colors.black,
//       automaticallyImplyLeading: false,
//       toolbarHeight: isIPad(context) ? height * 0.08 : height * 0.073,
//       centerTitle: false,
//       leadingWidth: 30,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 15.0),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//             size: isIPad(context) ? 35 : null,
//           ),
//         ),
//       ),
//       title: GestureDetector(
//         onTap: () {
//           Navigator.of(context).pushNamed(
//             AIProfileScreen.routeName,
//             arguments: {
//               "id":
//               (aiMsgResults?.otherUserId != null &&
//                   aiMsgResults?.fromUserId != null &&
//                   aiMsgResults!.otherUserId == aiMsgResults!.fromUserId)
//                   ? (aiMsgResults!.fromUserId.toString() ?? '')
//                   : (aiMsgResults!.toUserId.toString() ?? ''),
//               "isBack": true,
//             },
//           );
//         },
//         child: Row(
//           children: [
//             ClipOval(
//               child: CustomImageview(
//                 imagePath: aiMsgResults?.image ?? "",
//                 height: height * 0.06, // ~45 if screen height is around 900
//                 width: height * 0.06, // keep it square to maintain circle
//               ),
//             ),
//
//             SizedBox(width: isIPad(context) ? 18 : 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   (aiMsgResults?.otherUserId != null &&
//                       aiMsgResults?.fromUserId != null &&
//                       aiMsgResults!.otherUserId == aiMsgResults!.fromUserId)
//                       ? (aiMsgResults!.fromUserName ?? '')
//                       : (aiMsgResults!.toUserName ?? ''),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: isIPad(context) ? 35 : 20,
//                     fontFamily: 'Sora',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   "AI Character",
//                   style: TextStyle(
//                     color: Color.fromRGBO(204, 204, 204, 1),
//                     fontSize: isIPad(context) ? 24 : 16,
//                     fontFamily: 'Manrope',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 15.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pushNamed(
//                 PhotosScreen.routeName,
//                 arguments: {
//                   "id": aiMsgResults?.otherUserId.toString(),
//                   "name":
//                   (aiMsgResults?.otherUserId != null &&
//                       aiMsgResults?.fromUserId != null &&
//                       aiMsgResults!.otherUserId ==
//                           aiMsgResults!.fromUserId)
//                       ? (aiMsgResults!.fromUserName ?? '')
//                       : (aiMsgResults!.toUserName ?? ''),
//                 },
//               );
//             },
//             child: CustomImageview(
//               imagePath: "assets/images/chat_photo.png",
//               height: height * 0.07, // ≈66 on a 900px tall screen
//               width: width * 0.12, // ≈45 on a 375px wide screen
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget showGiftFilterBottomSheet({
//     required BuildContext context,
//     required AIMSGResult aimsgResult,
//     required GetGiftListResponse giftListResponse,
//     required VoidCallback onTap,
//     required String credit,
//     required double height,
//   }) {
//     final SendPeopleMessageBloc _sendAIMessageBloc = SendPeopleMessageBloc();
//     int selectedIndex = 0;
//
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return BlocConsumer<SendPeopleMessageBloc, SendPeopleMessageState>(
//           bloc: _sendAIMessageBloc,
//           listener: (context, state) {
//             if (state is SendPeopleMessageSuccessState) {
//               getUserId().then((value) {
//                 _getUsersBloc.add(GetUsersDataEvent(id: userId.toString()));
//               });
//               _getAIMessageDetailsBloc.add(
//                 GetPeopleMessageDetailsDataEvent(
//                   id: aiMsgResults?.otherUserId.toString() ?? "",
//                 ),
//               );
//               Navigator.of(context).pop();
//               _scrollToBottom();
//             }
//           },
//           builder: (context, state) {
//             return Container(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 color: Color.fromRGBO(30, 30, 30, 1),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color.fromRGBO(255, 255, 255, 0.6),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     width: 100,
//                     height: 5,
//                   ),
//                   const SizedBox(height: 34),
//                   // --- your wishlist header ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${aimsgResult.fromUserName}’s Wishlist",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontFamily: 'Manrope',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const Text(
//                             "Send gifts to get special content",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontFamily: 'Manrope',
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(
//                             context,
//                           ).pushNamed(CreditScreen.routeName);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 18),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 15,
//                             vertical: 9,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: const Color.fromRGBO(233, 64, 87, 1),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 credit.toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontFamily: 'Manrope',
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               const CustomImageview(
//                                 imagePath: "assets/images/heart_icon.png",
//                                 height: 18,
//                                 width: 20,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: height * 0.02),
//                   const CustomImageview(imagePath: "assets/images/divider.png"),
//                   SizedBox(height: height * 0.01),
//
//                   if (state is SendPeopleMessageLoadingState)
//                     Column(
//                       children: [
//                         SizedBox(height: height * 0.2),
//                         const Text(
//                           "Sending Gift...",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontFamily: 'Manrope',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Image.asset(
//                           "assets/gifs/ai_loader.gif",
//                           height: 250,
//                           width: 250,
//                         ),
//                       ],
//                     )
//                   else
//                     Expanded(
//                       child: GridView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: giftListResponse.result?.length ?? 0,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: isIPad(context) ? 4 : 3,
//                           mainAxisSpacing: 15,
//                           crossAxisSpacing: 17,
//                           childAspectRatio: 0.81,
//                         ),
//                         itemBuilder: (context, index) {
//                           final gift = giftListResponse.result?[index];
//                           return GestureDetector(
//                             onTap: () {
//                               HapticFeedback.lightImpact();
//                               setState(() => selectedIndex = index);
//
//                               _sendAIMessageBloc.add(
//                                 SendPeopleMessageDataEvent(
//                                   SendPeopleMessage: {
//                                     "from_user_id": aiMsgResults?.userId,
//                                     "from_user_name":
//                                     aiMsgResults?.otherUserId ==
//                                         aiMsgResults?.fromUserId
//                                         ? aiMsgResults?.fromUserName
//                                         : aiMsgResults?.toUserName,
//                                     "to_user_id": aiMsgResults?.otherUserId,
//                                     "to_user_name":
//                                     aiMsgResults?.otherUserId ==
//                                         aiMsgResults?.fromUserId
//                                         ? aiMsgResults?.fromUserName
//                                         : aiMsgResults?.toUserName,
//                                     "message_type": 5,
//                                     "gift_name": gift?.name ?? "",
//
//                                     "message":
//                                     "I have sent you a ${gift?.name} as gift: ${gift?.image}",
//                                   },
//                                 ),
//                               );
//                               _scrollToBottom();
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: const Color.fromRGBO(37, 37, 40, 1),
//                                 border:
//                                 selectedIndex == index
//                                     ? Border.all(
//                                   color: const Color.fromRGBO(
//                                     233,
//                                     64,
//                                     87,
//                                     0.7,
//                                   ),
//                                   width: 1.5,
//                                 )
//                                     : null,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 25,
//                                 vertical: 5,
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     gift?.name ?? "",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontFamily: 'Manrope',
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   CustomImageview(
//                                     imagePath: gift?.image ?? "",
//                                     height: 70,
//                                     width: 70,
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const CustomImageview(
//                                         imagePath:
//                                         "assets/images/heart_icon.png",
//                                         height: 20,
//                                         width: 20,
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Text(
//                                         gift?.credit.toString() ?? "",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 14,
//                                           fontFamily: 'Manrope',
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   String? userId;
//
//   Future<void> getUserId() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     userId = preferences.getString('user_id') ?? "";
//   }
// }
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerWidget({super.key, required this.videoUrl});
//
//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _controller.value.isPlaying
//                   ? _controller.pause()
//                   : _controller.play();
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying
//                 ? Icons.pause_circle_filled
//                 : Icons.play_circle_fill,
//             size: 50,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     )
//         : Container(
//       width: 200,
//       height: 250,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.black12,
//       ),
//       child: CircularProgressIndicator(),
//     );
//   }
// }
//
// class DurationState {
//   final Duration position;
//   final Duration total;
//
//   DurationState({required this.position, required this.total});
// }
//
// class AudioPlayerWidget extends StatefulWidget {
//   final String url;
//   final VoidCallback onTap;
//
//   const AudioPlayerWidget({super.key, required this.url, required this.onTap});
//
//   @override
//   State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
// }
//
// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   late AudioPlayer _audioPlayer;
//   final playerController = PlayerController();
//
//   Stream<DurationState> get _durationStateStream =>
//       Rx.combineLatest2<Duration, Duration?, DurationState>(
//         _audioPlayer.positionStream,
//         _audioPlayer.durationStream,
//             (position, duration) =>
//             DurationState(position: position, total: duration ?? Duration.zero),
//       );
//
//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _audioPlayer.setUrl(widget.url);
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     playerController.dispose();
//     super.dispose();
//   }
//
//   String formatDuration(Duration duration) {
//     return [
//       duration.inMinutes,
//       duration.inSeconds % 60,
//     ].map((seg) => seg.toString().padLeft(2, '0')).join(':');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.onTap();
//       },
//
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             StreamBuilder<ja.PlayerState>(
//               stream: _audioPlayer.playerStateStream,
//               builder: (context, snapshot) {
//                 final state = snapshot.data;
//                 final playing = state?.playing ?? false;
//                 final processingState = state?.processingState;
//
//                 if (processingState == ProcessingState.loading ||
//                     processingState == ProcessingState.buffering) {
//                   return SizedBox(
//                     width: 32,
//                     height: 32,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   );
//                 }
//
//                 return GestureDetector(
//                   onTap: () {
//                     if (playing) {
//                       _audioPlayer.pause();
//                       playerController.pausePlayer();
//                     } else {
//                       _audioPlayer.play();
//                       playerController.startPlayer();
//                     }
//                   },
//                   child: Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [
//                           Color.fromRGBO(138, 35, 135, 1),
//                           Color.fromRGBO(233, 64, 87, 1),
//                           Color.fromRGBO(242, 113, 33, 1),
//                         ],
//                       ),
//                     ),
//                     child: Icon(
//                       playing
//                           ? CupertinoIcons.pause_solid
//                           : CupertinoIcons.play_arrow_solid,
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(width: 12),
//             CustomImageview(
//               imagePath: "assets/images/black_audio_wave.png",
//               height: 35,
//               width: 100,
//               fit: BoxFit.contain,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// enum MessageType { text, image, video, audio, gift }
//
// class ChatMessage {
//   final dynamic message;
//   final bool isSender;
//   final MessageType type;
//   String? uuid;
//   int? isViewed;
//
//   ChatMessage({
//     required this.message,
//     required this.isSender,
//     required this.type,
//     this.uuid,
//     this.isViewed,
//   });
// }
//
// // class AudioMessageBubble extends StatefulWidget {
// //   final String filePath;
// //
// //   const AudioMessageBubble({required this.filePath});
// //
// //   @override
// //   State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
// // }
// //
// // class _AudioMessageBubbleState extends State<AudioMessageBubble> {
// //   final AudioPlayer _audioPlayer = AudioPlayer();
// //   Waveform? _waveform;
// //   Duration _duration = Duration.zero;
// //   Duration _position = Duration.zero;
// //   bool _isPlaying = false;
// //   bool _isGenerating = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _generateWaveform();
// //     _audioPlayer.positionStream.listen((pos) {
// //       setState(() {
// //         _position = pos;
// //       });
// //     });
// //   }
// //
// //   Future<void> _generateWaveform() async {
// //     final waveFile = File('${widget.filePath}.waveform');
// //
// //     final progress = JustWaveform.extract(
// //       audioInFile: File(widget.filePath),
// //       waveOutFile: waveFile,
// //     );
// //
// //     progress.listen((event) {
// //       setState(() {
// //         _waveform = event.waveform;
// //         // _isGenerating = !event.waveform.isComplete;
// //       });
// //     });
// //
// //     await _audioPlayer.setFilePath(widget.filePath);
// //     _duration = _audioPlayer.duration ?? Duration.zero;
// //   }
// //
// //   Future<void> _togglePlayback() async {
// //     if (_isPlaying) {
// //       await _audioPlayer.pause();
// //     } else {
// //       await _audioPlayer.play();
// //     }
// //
// //     setState(() {
// //       _isPlaying = !_isPlaying;
// //     });
// //
// //     _audioPlayer.playerStateStream.listen((state) {
// //       if (state.processingState == ProcessingState.completed) {
// //         setState(() {
// //           _isPlaying = false;
// //           _position = Duration.zero;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: EdgeInsets.all(8),
// //       color: Colors.grey.shade200,
// //       child: Column(
// //         children: [
// //           ListTile(
// //             leading: Icon(Icons.mic),
// //             title: Text("Voice Message"),
// //             trailing: IconButton(
// //               icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
// //               onPressed: _togglePlayback,
// //             ),
// //           ),
// //
// //
// //         ],
// //       ),
// //     );
// //   }
// // }
