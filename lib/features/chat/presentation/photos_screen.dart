import 'dart:ui';

import 'package:ai_interior/bloc/get_user_details/get_user_details_bloc.dart';
import 'package:ai_interior/bloc/unlock_character_photo/unlock_character_photo_bloc.dart';
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/models/get_character_photo_response.dart';
import 'package:ai_interior/models/get_user_model_response.dart';
import 'package:ai_interior/widgets/custom_elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/character_photo/get_character_photo_bloc.dart';
import '../../../widgets/custom_imageview.dart';
import '../../credit/presentataion/credit_screen.dart';

class PhotosScreen extends StatefulWidget {
  static const routeName = "/photo-screen";

  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  Map<String, dynamic> data = {};
  int? _loadingIndex;
  String credits = "";
  bool _isFirstTime = true;

  String? userId;

  Future<void> getCredits() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    credits = preferences.getString('credits') ??"";
  }

  final GetUsersBloc _getUsersBloc = GetUsersBloc();
  UserModelResponse? userModelResponse;
  final GetCharacterPhotoBloc _getCharacterPhotoBloc = GetCharacterPhotoBloc();
  final UnlockCharacterPhotoBloc _unlockCharacterPhotoBloc =
      UnlockCharacterPhotoBloc();
  CharacterPhotosResponse? characterPhotosResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredits();

  }

  Future<void> setCredits(String credits) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('credits', credits);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print("ID : ${data["id"]}");
    _getCharacterPhotoBloc.add(
      GetCharacterPhotoDataEvent(id:  data["id"]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<GetCharacterPhotoBloc, GetCharacterPhotoState>(
      bloc: _getCharacterPhotoBloc,
      listener: (context, state) {
        if (state is GetCharacterPhotoSuccessState) {
          characterPhotosResponse = state.exploreSongResponse;
          setState(() {
            _isFirstTime = false;
          });
        } else if (state is GetCharacterPhotoExceptionState ||
            state is GetCharacterPhotoFailureState) {}
      },
      builder: (context, state) {
        return BlocConsumer<GetUsersBloc, GetUsersState>(
          bloc: _getUsersBloc,
  listener: (context, state) {
   if(state is GetUsersSuccessState){
     userModelResponse= state.user;
     setState(() {
       credits = userModelResponse?.result?.credits.toString() ??"";
       setCredits(double.tryParse(userModelResponse?.result?.credits.toString() ?? "0")
           ?.toInt()
           .toString() ?? "0",);
     });
   }
  },
  builder: (context, state) {
    return BlocConsumer<
          UnlockCharacterPhotoBloc,
          UnlockCharacterPhotoState
        >(
          bloc: _unlockCharacterPhotoBloc,
          listener: (context, state) {
            if (state is UnlockCharacterPhotoSuccessState) {
              getUserId().then((value) {
                _getUsersBloc.add(GetUsersDataEvent(id: userId.toString()));
              });
              _getCharacterPhotoBloc.add(
                GetCharacterPhotoDataEvent(id: data["id"]),
              );
              setState(() {
                _loadingIndex = null;
              });
            } else if (state is UnlockCharacterPhotoExceptionState ||
                state is UnlockCharacterPhotoFailureState) {}
          },
          builder: (context, unlockState) {
            return Scaffold(
              backgroundColor: Color.fromRGBO(13, 13, 16, 1),
              appBar: _buildAppBar(context),
              body: state is GetCharacterPhotoLoadingState && _isFirstTime?Align(
                child: Image.asset(
                  "assets/gifs/ai_loader.gif",
                  height: 250,
                  width: 250,
                ),):(characterPhotosResponse?.result?.length??0) >0 ?GridView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: characterPhotosResponse?.result?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isIPad(context)?4:2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 17,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child:
                        characterPhotosResponse?.result?[index].isUnlocked == 0
                            ? Stack(
                              children: [
                                CustomImageview(
                                  imagePath: "assets/images/photos_bg.png",
                                ),
                                unlockState is UnlockCharacterPhotoLoadingState && _loadingIndex == index
                                    ? Align(
                                      child: CupertinoActivityIndicator(
                                        radius: 18,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          child: CustomImageview(
                                            imagePath:
                                                "assets/images/heart_icon.png",
                                            width: 65,
                                            height: 60,
                                          ),
                                        ),
                                        SizedBox(height: 50),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 25.0,
                                          ),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: CustomElevatedButton(
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();

                                                setState(() {
                                                  _loadingIndex = index;
                                                });
                                                _unlockCharacterPhotoBloc.add(
                                                  UnlockCharacterPhotoDataEvent(
                                                    UnlockCharacterPhoto: {
                                                      "photo_id":
                                                          characterPhotosResponse
                                                              ?.result?[index]
                                                              .id,
                                                      "character_id": data["id"],
                                                    },
                                                  ),
                                                );
                                              },
                                              text:
                                                  "Unlock for ${characterPhotosResponse?.result?[index].credit}",
                                              rightIcon: Row(
                                                children: [
                                                  SizedBox(width: width * 0.01),

                                                  CustomImageview(
                                                    imagePath:
                                                        "assets/images/heart_icon.png",
                                                    width: 20,
                                                    height: 18,
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(
                                                      138,
                                                      35,
                                                      135,
                                                      1,
                                                    ),
                                                    Color.fromRGBO(
                                                      233,
                                                      64,
                                                      87,
                                                      1,
                                                    ),
                                                    Color.fromRGBO(
                                                      242,
                                                      113,
                                                      33,
                                                      1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              width: width * 0.39,
                                              height: height * 0.04,
                                              buttonTextStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                fontFamily: 'Manrope',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              ],
                            )
                            : Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    showFullScreenImage(context, characterPhotosResponse?.result?[index].image ?? "");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: CachedNetworkImage(
                                      imageUrl: characterPhotosResponse?.result?[index].image ?? "",
                                      height: 310,
                                      width: 188,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CupertinoActivityIndicator(
                                          radius: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Center(
                                        child: Icon(
                                          CupertinoIcons.photo_fill_on_rectangle_fill,
                                          size: 40,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                  );
                },
              ) : Center(child: Text("No photos available !",style: TextStyle(
                color: Colors.white,
                fontSize: isIPad(context)?35:20,
                fontFamily: 'Sora',
                fontWeight: FontWeight.w500,
              ),),),
            );
          },
        );
  },
);
      },
    );
  }

  void showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder:
                          (context, url) => Center(
                        child: CupertinoActivityIndicator(
                          radius: 16,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget:
                          (context, url, error) => Center(
                        child: Icon(
                          CupertinoIcons.photo_fill_on_rectangle_fill,
                          size: 40,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.clear,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),
      automaticallyImplyLeading: false,
      toolbarHeight: height * 0.073,
      centerTitle: false,
      leadingWidth: 30,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white,size: isIPad(context)?30:null,),
        ),
      ),
      title: Text(
        data["name"] ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: isIPad(context)?35:20,
          fontFamily: 'Sora',
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            HapticFeedback.heavyImpact();

            Navigator.of(context).pushNamed(CreditScreen.routeName);
          },
          child: Container(
            margin: EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color.fromRGBO(233, 64, 87, 1),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment(0, 0.5),
                end: Alignment(1, 0.5),
                colors: [
                  Color.fromRGBO(138, 35, 135, 1).withValues(alpha: 0.2),
                  Color.fromRGBO(233, 64, 87, 1).withValues(alpha: 0.2),
                  Color.fromRGBO(242, 113, 33, 1).withValues(alpha: 0.2),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 9, bottom: 9),
                  child: Text(
                    credits,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isIPad(context)?30:16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(11, 12, 12, 11),
                  child: CustomImageview(
                    imagePath: "assets/images/heart_icon.png",
                    height: isIPad(context)?30:18,
                    width: isIPad(context)?25:20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Future<void> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('user_id') ?? "";
  }
}
