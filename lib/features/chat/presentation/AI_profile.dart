import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:ai_interior/bloc/duplicate_character/duplicate_character_bloc.dart';
import 'package:ai_interior/bloc/get_character/get_character_bloc.dart';
import 'package:ai_interior/features/chat/presentation/AI_chat_screen.dart';
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../bloc/delete_character/delete_character_bloc.dart';
import '../../../models/get_character_response.dart';
import '../../../widgets/custom_elevated_button.dart';

class AIProfileScreen extends StatefulWidget {
  const AIProfileScreen({super.key});

  static const routeName = "ai-profile";

  @override
  State<AIProfileScreen> createState() => _AIProfileScreenState();
}

class _AIProfileScreenState extends State<AIProfileScreen> {
  final GetCharacterBloc _getCharacterBloc = GetCharacterBloc();
  final DuplicateCharacterBloc _duplicateCharacterBloc =
      DuplicateCharacterBloc();
  final DeleteCharacterBloc _deleteCharacterBloc = DeleteCharacterBloc();
  CharacterResponse? characterResponse;
  Map<String, dynamic> data = {};
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (_isInit) {
      _getCharacterBloc.add(GetCharacterDataEvent(id: data["id"]));
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<GetCharacterBloc, GetCharacterState>(
      bloc: _getCharacterBloc,
      listener: (context, state) {
        if (state is GetCharacterSuccessState) {
          characterResponse = state.characterResponse;
        } else if (state is GetCharacterFailureState ||
            state is GetCharacterExceptionState) {}
      },
      builder: (context, state) {
        return state is GetCharacterLoadingState
            ? Align(
              child: Image.asset(
                "assets/gifs/ai_loader.gif",
                height: 300,
                width: 300,
              ),
            )
            : BlocConsumer<DuplicateCharacterBloc, DuplicateCharacterState>(
              bloc: _duplicateCharacterBloc,
              listener: (context, state) {
                if (state is DuplicateCharacterSuccessState) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainScreen.routeName,
                    (route) => false,
                  );
                } else if (state is DuplicateCharacterExceptionState ||
                    state is DuplicateCharacterFailureState) {}
              },
              builder: (context, state) {
                return BlocConsumer<DeleteCharacterBloc, DeleteCharacterState>(
                  bloc: _deleteCharacterBloc,
                  listener: (context, state) {
                    if (state is DeleteCharacterSuccessState) {
                      Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder:
                              (context) => const MainScreen(initialIndex: 3),
                        ),
                            (route) => false,
                      );
                    }
                  },
                  builder: (context, deleteState) {

                    return SizedBox(
                      height: height,
                      width: width,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: characterResponse?.result?.image ?? "",
                              fit: BoxFit.cover,
                              width: width,
                              placeholder:
                                  (context, url) => Align(
                                    child: Image.asset(
                                      "assets/gifs/ai_loader.gif",
                                      height: 300,
                                      width: 300,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Center(
                                    child: Icon(
                                      CupertinoIcons
                                          .photo_fill_on_rectangle_fill,
                                      size: 40,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                            ),
                          ),

                          Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: _buildAppBar(context),
                            bottomNavigationBar: deleteState is DeleteCharacterLoadingState?Align(
                              child: Image.asset(
                                "assets/gifs/ai_loader.gif",
                                height: 250,
                                width: 250,
                              ),):Container(
                              height: height * 0.35,
                              width: width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(13, 13, 13, 0.5),
                                    Color.fromRGBO(13, 13, 13, 1),
                                  ],
                                ),
                                color: Color.fromRGBO(13, 13, 13, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                border: Border(
                                  top: BorderSide(
                                    color: Color.fromRGBO(42, 42, 42, 1),
                                    // Change to your desired color
                                    width: 3, // Adjust thickness as needed
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: height * 0.02),
                                  Text(
                                    characterResponse?.result?.name ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomElevatedButton(
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();
                                            if (data["isBack"] == false) {
                                              Navigator.of(
                                                context,
                                              ).pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const MainScreen(
                                                            initialIndex: 1,
                                                          ),
                                                ),
                                                (route) => false,
                                              );
                                            } else {
                                              Navigator.of(
                                                context,
                                              ).pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const MainScreen(
                                                            initialIndex: 1,
                                                          ),
                                                ),
                                                (route) => false,
                                              );
                                            }
                                          },
                                          text: "Chat",
                                          width: width * 0.45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromRGBO(138, 35, 135, 1),
                                                Color.fromRGBO(233, 64, 87, 1),
                                                Color.fromRGBO(242, 113, 33, 1),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                            shareImageWithText(
                                              characterResponse
                                                      ?.result
                                                      ?.image ??
                                                  "",
                                              characterResponse?.result?.name ??
                                                  "",
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: CustomImageview(
                                              imagePath:
                                                  "assets/images/share_img.png",
                                              height: MediaQuery.of(context).size.height * 0.08, // ~8% of screen height
                                              width: MediaQuery.of(context).size.width * 0.45,    // ~50% of screen width
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  CustomImageview(
                                    imagePath: "assets/images/divider.png",
                                    width: width,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  SizedBox(
                                    width: width * 0.9,
                                    child: Text(
                                      characterResponse
                                              ?.result
                                              ?.otherData
                                              ?.firstMessage ??
                                          "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 3,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: height * 0.073,
      centerTitle: false,
      leadingWidth: 50,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: GestureDetector(
          onTap: () {
            if (data["isBack"] == false) {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 1),
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: ClipOval(
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: GestureDetector(
            onTap: () {
              _showCupertinoPopup(context);
            },
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Icon(CupertinoIcons.ellipsis, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCupertinoPopup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoActionSheet(
              actions: [
                _buildItem(
                  () {
                    _duplicateCharacterBloc.add(
                      DuplicateCharacterDataEvent(
                        makeSongData: {"character_id": data["id"]},
                      ),
                    );
                  },
                  "Duplicate",
                  CupertinoIcons.doc_on_doc,
                ),
                _buildItem(
                  () {
                    _shareNetworkImage(characterResponse?.result?.image ?? "");
                  },
                  "Share Character",
                  CupertinoIcons.share,
                ),
                _buildItem(() {
                  Navigator.of(context).pop();
                  showSnackMessageError(context);
                }, "Report", CupertinoIcons.flag),
                _buildItem(() {
                  Navigator.of(context).pop();

                  showSnackMessage(context);
                }, "Favorite", CupertinoIcons.heart),
                _buildItem(
                  () {
                    _deleteCharacterBloc.add(DeleteCharacterDataEvent(id: characterResponse?.result?.id.toString()??""));
                  },
                  "Clear History",
                  CupertinoIcons.delete,
                  isDestructive: true,
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
          ),
    );
  }

  void showSnackMessageError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: 3),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade500,
                  Colors.red.shade700,
                  Colors.red.shade800,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.info_circle_fill,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Reported Successfully ",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: 3),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.green.shade300,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.white,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Profile Added to Favorites",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _shareNetworkImage(String imageUrl) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/shared_image.jpg');

        // Save the image file
        await file.writeAsBytes(response.bodyBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)], text: 'Check this out!');
      } else {
        print('Failed to download image');
      }
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  Future<void> shareImageWithText(String imageUrl, String text) async {
    try {
      // Download image bytes from network
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) throw Exception('Image load failed');

      final Uint8List bytes = response.bodyBytes;

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.jpg');
      await file.writeAsBytes(bytes);

      // Share the image with text
      await Share.shareXFiles([XFile(file.path)], text: text);
    } catch (e) {
      print('Sharing failed: $e');
    }
  }

  static Widget _buildItem(
    VoidCallback onTap,
    String text,
    IconData icon, {
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CupertinoActionSheetAction(
        onPressed: () {
          onTap();
        },
        isDestructiveAction: isDestructive,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color:
                    isDestructive
                        ? CupertinoColors.systemRed
                        : CupertinoColors.white,
              ),
            ),
            Icon(
              icon,
              color:
                  isDestructive
                      ? CupertinoColors.systemRed
                      : CupertinoColors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ShowChip extends StatelessWidget {
  final List<String> items;

  const ShowChip({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 12,
      runSpacing: 12,
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromRGBO(255, 255, 255, 0.1),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.2),
              width: 1,
            ),
          ),
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }
}

