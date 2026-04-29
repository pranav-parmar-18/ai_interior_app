// import 'dart:io';
// import 'dart:ui';
//
// import 'package:ai_interior/bloc/delete_character/delete_character_bloc.dart';
// import 'package:ai_interior/bloc/duplicate_character/duplicate_character_bloc.dart';
// import 'package:ai_interior/bloc/get_character/get_character_bloc.dart';
// import 'package:ai_interior/bloc/get_character_list/get_character_list_bloc.dart';
// import 'package:ai_interior/bloc/get_user_details/get_user_details_bloc.dart';
//
// import 'package:ai_interior/features/main/presentaion/main_screen.dart';
// import 'package:ai_interior/features/profile/presentation/edit_photo.dart';
// import 'package:ai_interior/features/profile/presentation/edit_profile_screen.dart';
// import 'package:ai_interior/features/setting/presentation/setting_screens.dart';
// import 'package:ai_interior/features/subscription/presentation/subscription_screen.dart';
// import 'package:ai_interior/models/get_user_model_response.dart';
// import 'package:ai_interior/widgets/custom_imageview.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../models/get_character_list_model_response.dart';
// import '../../../models/get_character_response.dart';
// import '../../../services/subscription_manager.dart';
// import '../../chat/presentation/AI_profile.dart';
// import '../../subscription/presentation/subscription_screen_three.dart';
// import '../../subscription/presentation/subscription_screen_two.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final GetUsersBloc _getUsersBloc = GetUsersBloc();
//   final GetCharactersListBloc _getCharactersListBloc = GetCharactersListBloc();
//   final DeleteCharacterBloc _deleteCharacterBloc = DeleteCharacterBloc();
//   final DuplicateCharacterBloc _duplicateCharacterBloc =
//       DuplicateCharacterBloc();
//   GetCharacterListResponse? getCharacterListResponse;
//   UserModelResponse? userModelResponse;
//   String? userId;
//
//   final GetCharacterBloc _getCharacterBloc = GetCharacterBloc();
//   CharacterResponse? characterResponse;
//   bool? isSubscribed;
//
//   @override
//   void initState() {
//     super.initState();
//     isSubscriptionActive();
//     getUserId().then((value) {
//       _getUsersBloc.add(GetUsersDataEvent(id: userId.toString()));
//     });
//   }
//
//   Future<void> setCredits(String userId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString('credits', userId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return BlocConsumer<GetUsersBloc, GetUsersState>(
//       bloc: _getUsersBloc,
//       listener: (context, state) {
//         if (state is GetUsersSuccessState) {
//           userModelResponse = state.user;
//           setUserUsername(userModelResponse?.result?.name ?? "");
//           setPublicLink(userModelResponse?.result?.shareProfileLink ?? "");
//           setCredits(
//             double.tryParse(
//                   userModelResponse?.result?.credits?.toString() ?? "0",
//                 )?.toInt().toString() ??
//                 "0",
//           );
//           _getCharactersListBloc.add(GetCharactersListDataEvent());
//         } else if (state is GetUsersExceptionState ||
//             state is GetUsersFailureState) {}
//       },
//       builder: (context, state) {
//         return BlocConsumer<GetCharactersListBloc, GetCharactersListState>(
//           bloc: _getCharactersListBloc,
//           listener: (context, state) {
//             if (state is GetCharactersListSuccessState) {
//               getCharacterListResponse = state.exploreSongResponse;
//             } else if (state is GetCharactersListFailureState ||
//                 state is GetCharactersListExceptionState) {}
//           },
//           builder: (context, state) {
//             return BlocConsumer<
//               DuplicateCharacterBloc,
//               DuplicateCharacterState
//             >(
//               bloc: _duplicateCharacterBloc,
//               listener: (context, state) {
//                 if (state is DuplicateCharacterSuccessState) {
//                   _getCharactersListBloc.add(GetCharactersListDataEvent());
//                 } else if (state is DuplicateCharacterExceptionState ||
//                     state is DuplicateCharacterFailureState) {}
//               },
//               builder: (context, duplicateState) {
//                 return duplicateState is DuplicateCharacterLoadingState
//                     ? Align(
//                       child: Image.asset(
//                         "assets/gifs/ai_loader.gif",
//                         height: 250,
//                         width: 250,
//                       ),
//                     )
//                     : BlocConsumer<DeleteCharacterBloc, DeleteCharacterState>(
//                       bloc: _deleteCharacterBloc,
//                       listener: (context, state) {
//                         if (state is DeleteCharacterSuccessState) {
//                           _getCharactersListBloc.add(
//                             GetCharactersListDataEvent(),
//                           );
//                         } else if (state is DeleteCharacterExceptionState ||
//                             state is DeleteCharacterFailureState) {}
//                       },
//                       builder: (context, deleteState) {
//
//                         return BlocConsumer<
//                           GetCharacterBloc,
//                           GetCharacterState
//                         >(
//                           bloc: _getCharacterBloc,
//                           listener: (context, state) {
//                             if (state is GetCharacterSuccessState) {
//                               characterResponse = state.characterResponse;
//
//                             } else if (state is GetCharacterExceptionState ||
//                                 state is GetCharacterFailureState) {}
//                           },
//                           builder: (context, state) {
//                             return Scaffold(
//                               appBar: _buildAppBar(context),
//                               backgroundColor: Color.fromRGBO(13, 13, 16, 1),
//                               body:
//                                   deleteState is DeleteCharacterLoadingState
//                                       ? Align(
//                                         child: Image.asset(
//                                           "assets/gifs/ai_loader.gif",
//                                           height: 250,
//                                           width: 250,
//                                         ),
//                                       )
//                                       : SizedBox(
//                                         width: double.maxFinite,
//                                         child: SingleChildScrollView(
//                                           child: Container(
//                                             width: double.maxFinite,
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: 10,
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 SizedBox(height: 35),
//                                                 Stack(
//                                                   clipBehavior: Clip.none,
//                                                   children: [
//                                                     userModelResponse
//                                                                 ?.result
//                                                                 ?.profilePic !=
//                                                             null
//                                                         ? ClipOval(
//                                                           child: CachedNetworkImage(
//                                                             imageUrl:
//                                                                 userModelResponse
//                                                                     ?.result
//                                                                     ?.profilePic ??
//                                                                 "",
//                                                             height:
//                                                                 height * 0.22,
//                                                             // Ensure width and height are the same
//                                                             width:
//                                                                 height * 0.22,
//                                                             fit: BoxFit.cover,
//                                                             placeholder:
//                                                                 (
//                                                                   context,
//                                                                   url,
//                                                                 ) => Align(
//                                                                   child: Image.asset(
//                                                                     "assets/gifs/ai_loader.gif",
//                                                                     height: 150,
//                                                                     width: 150,
//                                                                   ),
//                                                                 ),
//                                                             errorWidget:
//                                                                 (
//                                                                   context,
//                                                                   url,
//                                                                   error,
//                                                                 ) => Center(
//                                                                   child: Icon(
//                                                                     CupertinoIcons
//                                                                         .person_crop_circle_badge_exclam,
//                                                                     size: 40,
//                                                                     color:
//                                                                         CupertinoColors
//                                                                             .systemGrey,
//                                                                   ),
//                                                                 ),
//                                                           ),
//                                                         )
//                                                         : CustomImageview(
//                                                           imagePath:
//                                                               "assets/images/profile_img.png",
//                                                           height: 135,
//                                                           width: 135,
//                                                         ),
//
//                                                     Positioned(
//                                                       bottom: 10,
//                                                       right: -5,
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           Navigator.of(context)
//                                                               .pushNamed(
//                                                                 EditPhotoScreen
//                                                                     .routeName,
//                                                                 arguments:
//                                                                     userModelResponse
//                                                                         ?.result
//                                                                         ?.profilePic ??
//                                                                     "",
//                                                               )
//                                                               .then((value) {
//                                                                 getUserId().then((
//                                                                   value,
//                                                                 ) {
//                                                                   _getUsersBloc.add(
//                                                                     GetUsersDataEvent(
//                                                                       id:
//                                                                           userId
//                                                                               .toString(),
//                                                                     ),
//                                                                   );
//                                                                 });
//                                                               });
//                                                         },
//                                                         child: CustomImageview(
//                                                           imagePath:
//                                                               "assets/images/edit_image.png",
//                                                           height: 40,
//                                                           width: 40,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 10),
//                                                 userModelResponse?.result?.name != "" ? Text(
//                                                   "${userModelResponse?.result?.name ?? ""}, ${userModelResponse?.result?.age ?? ""}",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize:
//                                                         isIPad(context)
//                                                             ? 35
//                                                             : 24,
//                                                     fontFamily: 'Manrope',
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ) : SizedBox.shrink(),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   "Exploring the future of love through AI 🚀",
//                                                   style: TextStyle(
//                                                     color: Color.fromRGBO(
//                                                       204,
//                                                       204,
//                                                       204,
//                                                       1,
//                                                     ),
//                                                     fontSize:
//                                                         isIPad(context)
//                                                             ? 28
//                                                             : isIPhoneMini(
//                                                               context,
//                                                             )
//                                                             ? 16
//                                                             : 18,
//                                                     fontFamily: 'Manrope',
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 30),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         HapticFeedback.mediumImpact();
//                                                         Navigator.of(context)
//                                                             .pushNamed(
//                                                               EditProfileScreen
//                                                                   .routeName,
//                                                               arguments:
//                                                                   userModelResponse,
//                                                             )
//                                                             .then((value) {
//                                                               getUserId().then((
//                                                                 value,
//                                                               ) {
//                                                                 _getUsersBloc.add(
//                                                                   GetUsersDataEvent(
//                                                                     id:
//                                                                         userId
//                                                                             .toString(),
//                                                                   ),
//                                                                 );
//                                                               });
//                                                             });
//                                                       },
//                                                       child: CustomImageview(
//                                                         imagePath:
//                                                             "assets/images/edit_profile.png",
//                                                         height: height * 0.06,
//                                                         // ~56 if screenHeight is around 800
//                                                         width: width * 0.43,
//                                                         //
//                                                         fit:
//                                                             BoxFit
//                                                                 .contain, // ~200 if screen width is ~445
//                                                         // ~200 if screenWidth is around 400
//                                                       ),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         HapticFeedback.mediumImpact();
//                                                         shareImageWithText(
//                                                           userModelResponse
//                                                                   ?.result
//                                                                   ?.profilePic ??
//                                                               "",
//                                                           userModelResponse
//                                                                   ?.result
//                                                                   ?.name ??
//                                                               "",
//                                                         );
//                                                       },
//                                                       child: CustomImageview(
//                                                         imagePath:
//                                                             "assets/images/share_img.png",
//                                                         height: height * 0.06,
//                                                         // ~56 if screenHeight is around 800
//                                                         width: width * 0.43,
//                                                         fit:
//                                                             BoxFit
//                                                                 .contain, // ~200 if screen width is ~445
//                                                         // ~200 if screenWidth is around 400
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 if (isSubscribed == false)
//                                                   SizedBox(height: 30),
//                                                 if (isSubscribed == false)
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       HapticFeedback.heavyImpact();
//
//                                                       openSubscriptionScreen(
//                                                         context,
//                                                       );
//                                                     },
//                                                     child: CustomImageview(
//                                                       imagePath:
//                                                           "assets/images/upgrade_to_prem.png",
//                                                       width:
//                                                           isIPad(context)
//                                                               ? double.maxFinite
//                                                               : null,
//                                                       height:
//                                                           isIPad(context)
//                                                               ? height * 0.17
//                                                               : null,
//                                                       fit: BoxFit.contain,
//                                                     ),
//                                                   ),
//                                                 SizedBox(height: 30),
//                                                 (getCharacterListResponse
//                                                                 ?.result
//                                                                 ?.length ??
//                                                             0) >
//                                                         0
//                                                     ? Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets.symmetric(
//                                                                 horizontal:
//                                                                     10.0,
//                                                               ),
//                                                           child: Text(
//                                                             "Created Characters",
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: 28,
//                                                               fontFamily:
//                                                                   'Manrope',
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w700,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(height: 10),
//                                                         GridView.builder(
//                                                           physics:
//                                                               NeverScrollableScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           padding:
//                                                               const EdgeInsets.all(
//                                                                 16,
//                                                               ),
//                                                           itemCount:
//                                                               getCharacterListResponse
//                                                                   ?.result
//                                                                   ?.length ??
//                                                               0,
//                                                           gridDelegate:
//                                                               SliverGridDelegateWithFixedCrossAxisCount(
//                                                                 crossAxisCount:
//                                                                     isIPad(
//                                                                           context,
//                                                                         )
//                                                                         ? 3
//                                                                         : 2,
//                                                                 mainAxisSpacing:
//                                                                     15,
//                                                                 crossAxisSpacing:
//                                                                     17,
//                                                                 childAspectRatio:
//                                                                     0.7,
//                                                               ),
//                                                           itemBuilder: (
//                                                             context,
//                                                             index,
//                                                           ) {
//                                                             return Container(
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                           22,
//                                                                         ),
//                                                                   ),
//                                                               child: Stack(
//                                                                 children: [
//                                                                   GestureDetector(
//                                                                     onTap: () {
//                                                                       HapticFeedback.heavyImpact();
//
//                                                                       Navigator.of(
//                                                                         context,
//                                                                       ).pushNamed(
//                                                                         AIProfileScreen
//                                                                             .routeName,
//                                                                         arguments: {
//                                                                           "id":
//                                                                               getCharacterListResponse?.result?[index].id.toString() ??
//                                                                               "",
//                                                                           "isBack":
//                                                                               true,
//                                                                         },
//                                                                       );
//                                                                     },
//                                                                     child: ClipRRect(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                             22,
//                                                                           ),
//                                                                       child: CachedNetworkImage(
//                                                                         imageUrl:
//                                                                             getCharacterListResponse?.result?[index].image ??
//                                                                             "",
//                                                                         height:
//                                                                             height *
//                                                                             0.38,
//                                                                         // 310 on ~816 height screen
//                                                                         width:
//                                                                             width *
//                                                                             0.47,
//                                                                         fit:
//                                                                             BoxFit.cover,
//                                                                         placeholder:
//                                                                             (
//                                                                               context,
//                                                                               url,
//                                                                             ) => Center(
//                                                                               child: CupertinoActivityIndicator(
//                                                                                 radius:
//                                                                                     16,
//                                                                                 color:
//                                                                                     Colors.white,
//                                                                               ),
//                                                                             ),
//                                                                         errorWidget:
//                                                                             (
//                                                                               context,
//                                                                               url,
//                                                                               error,
//                                                                             ) => Center(
//                                                                               child: Icon(
//                                                                                 CupertinoIcons.photo_fill_on_rectangle_fill,
//                                                                                 size:
//                                                                                     40,
//                                                                                 color:
//                                                                                     CupertinoColors.systemGrey,
//                                                                               ),
//                                                                             ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   Positioned(
//                                                                     right: 2,
//                                                                     top: 10,
//                                                                     child: Padding(
//                                                                       padding: const EdgeInsets.only(
//                                                                         right:
//                                                                             15.0,
//                                                                       ),
//                                                                       child: GestureDetector(
//                                                                         onTap: () {
//                                                                           _showCupertinoPopup(
//                                                                             context,
//                                                                             () {
//                                                                               print("CALLED");
//                                                                               navigation(
//                                                                                 index,
//                                                                                   getCharacterListResponse?.result?[index].id.toString() ??
//                                                                                       ""
//                                                                               );
//                                                                             },
//                                                                             () {
//                                                                               _duplicateCharacterBloc.add(
//                                                                                 DuplicateCharacterDataEvent(
//                                                                                   makeSongData: {
//                                                                                     "character_id":
//                                                                                         getCharacterListResponse?.result?[index].id.toString() ??
//                                                                                         "",
//                                                                                   },
//                                                                                 ),
//                                                                               );
//                                                                             },
//                                                                             () {
//                                                                               _deleteCharacterBloc.add(
//                                                                                 DeleteCharacterDataEvent(
//                                                                                   id:
//                                                                                       getCharacterListResponse?.result?[index].id.toString() ??
//                                                                                       "",
//                                                                                 ),
//                                                                               );
//                                                                             },
//                                                                           );
//                                                                         },
//                                                                         child: ClipOval(
//                                                                           child: BackdropFilter(
//                                                                             filter: ImageFilter.blur(
//                                                                               sigmaX:
//                                                                                   10,
//                                                                               sigmaY:
//                                                                                   10,
//                                                                             ),
//                                                                             child: Container(
//                                                                               width:
//                                                                                   40,
//                                                                               height:
//                                                                                   40,
//                                                                               decoration: BoxDecoration(
//                                                                                 color: Color.fromRGBO(
//                                                                                   255,
//                                                                                   255,
//                                                                                   255,
//                                                                                   0.2,
//                                                                                 ),
//                                                                                 shape:
//                                                                                     BoxShape.circle,
//                                                                               ),
//                                                                               child: Padding(
//                                                                                 padding: const EdgeInsets.only(
//                                                                                   left:
//                                                                                       0.0,
//                                                                                 ),
//                                                                                 child: Icon(
//                                                                                   CupertinoIcons.ellipsis,
//                                                                                   color:
//                                                                                       Colors.white,
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   Positioned(
//                                                                     bottom: 0,
//                                                                     left: 40,
//                                                                     child: Container(
//                                                                       width:
//                                                                           100,
//                                                                       child: Text(
//                                                                         getCharacterListResponse?.result?[index].name ??
//                                                                             "",
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                         style: TextStyle(
//                                                                           color:
//                                                                               Colors.white,
//                                                                           fontSize:
//                                                                               20,
//                                                                           fontFamily:
//                                                                               'Manrope',
//                                                                           fontWeight:
//                                                                               FontWeight.w600,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       ],
//                                                     )
//                                                     : CustomImageview(
//                                                       imagePath:
//                                                           "assets/images/no_char.png",
//                                                     ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                             );
//                           },
//                         );
//                       },
//                     );
//               },
//             );
//           },
//         );
//       },
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
//   void navigation(int index,String id) {
//     _getCharacterBloc.add(
//       GetCharacterDataEvent(id: id),
//     );
//
//   }
//
//   Future<void> shareImageWithText(String imageUrl, String text) async {
//     try {
//       // Download image bytes from network
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode != 200) throw Exception('Image load failed');
//
//       final Uint8List bytes = response.bodyBytes;
//
//       // Save to temp file
//       final tempDir = await getTemporaryDirectory();
//       final file = File('${tempDir.path}/shared_image.jpg');
//       await file.writeAsBytes(bytes);
//
//       // Share the image with text
//       await Share.shareXFiles([XFile(file.path)], text: text);
//     } catch (e) {
//       print('Sharing failed: $e');
//     }
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
//   void _showCupertinoPopup(
//     BuildContext context,
//     VoidCallback onEdit,
//     VoidCallback onDuplicate,
//     VoidCallback onDelete,
//   ) {
//     showCupertinoModalPopup(
//       context: context,
//       builder:
//           (BuildContext context) => CupertinoTheme(
//             data: CupertinoThemeData(brightness: Brightness.dark),
//             child: CupertinoActionSheet(
//               actions: [
//                 _buildItem(context, "Edit", () {
//                   onEdit();
//                 }, CupertinoIcons.pencil),
//                 _buildItem(context, "Duplicate", () {
//                   onDuplicate();
//                 }, CupertinoIcons.doc_on_doc),
//                 _buildItem(
//                   context,
//                   "Delete",
//                   () {
//                     onDelete();
//                   },
//                   CupertinoIcons.delete,
//                   isDestructive: true,
//                 ),
//               ],
//               cancelButton: CupertinoActionSheetAction(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Cancel"),
//               ),
//             ),
//           ),
//     );
//   }
//
//   Widget _buildItem(
//     BuildContext context,
//     String text,
//     VoidCallback onTap,
//     IconData icon, {
//     bool isDestructive = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: CupertinoActionSheetAction(
//         onPressed: () {
//           onTap();
//           Navigator.of(context).pop();
//         },
//         isDestructiveAction: isDestructive,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               text,
//               style: TextStyle(
//                 color:
//                     isDestructive
//                         ? CupertinoColors.systemRed
//                         : CupertinoColors.white,
//               ),
//             ),
//             Icon(
//               icon,
//               color:
//                   isDestructive
//                       ? CupertinoColors.systemRed
//                       : CupertinoColors.white,
//             ),
//           ],
//         ),
//       ),
//     );
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
//       leadingWidth: 60,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 15.0),
//         child: GestureDetector(
//           onTap: () {
//             HapticFeedback.heavyImpact();
//
//             Navigator.of(context).pushNamed(SettingScreens.routeName);
//           },
//           child: CustomImageview(
//             imagePath: "assets/images/setting_icon.png",
//             height: isIPad(context) ? 55 : 45,
//             width: isIPad(context) ? 55 : 45,
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//       title: Text(
//         "Profile",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: isIPad(context) ? 40 : 28,
//           fontFamily: 'Sora',
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
//
//   Future<void> getUserId() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     userId = preferences.getString('user_id') ?? "";
//   }
//
//   Future<void> setUserUsername(String userId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString('user_name', userId);
//   }
//   Future<void> setPublicLink(String userId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString('public_link', userId);
//   }
// }
