import 'dart:convert';
import 'dart:io';

import 'package:ai_interior/bloc/get_photos_list/get_photos_list_bloc.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/upload_profile_picture/upload_profile_picture_bloc.dart';
import '../../../models/get_photos_response.dart';
import '../../../widgets/custom_elevated_button.dart';

class EditPhotoScreen extends StatefulWidget {
  const EditPhotoScreen({super.key});

  static const routeName = "/edit-photo";

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  final UploadProfilePictureBloc _uploadProfilePictureBloc =
      UploadProfilePictureBloc();
  final GetPhotosListBloc _getPhotosListBloc = GetPhotosListBloc();
  PhotosModelResponse? photosModelResponse;

  File? _imageFile1;
  String? imagePath;
  String? _base64Image1;
  String? lastImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPhotosListBloc.add(GetPhotosListDataEvent());
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    lastImage = ModalRoute.of(context)?.settings.arguments as String;
    print("LAST IMAGE :  ${lastImage}");
  }

  Future<void> _pickImage1(ImageSource src) async {
    final pickedFile = await ImagePicker().pickImage(source: src);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final extension = pickedFile.path.split('.').last.toLowerCase();
      String mimeType;
      if (extension == 'png') {
        mimeType = 'image/png';
      } else {
        mimeType = 'image/jpeg'; // default
      }

      final fullBase64 = 'data:$mimeType;base64,$base64Image';

      setState(() {
        _imageFile1 = file;
        imagePath = null;
        _base64Image1 = fullBase64; // store correct format
      });
    } else {
      print('User cancelled image picking');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<GetPhotosListBloc, GetPhotosListState>(
      bloc: _getPhotosListBloc,
      listener: (context, state) {
        if (state is GetPhotosListSuccessState) {
          photosModelResponse = state.photoModelResponse;
        } else if (state is GetPhotosListFailureState ||
            state is GetPhotosListExceptionState) {}
      },
      builder: (context, state) {
        return BlocConsumer<
          UploadProfilePictureBloc,
          UploadProfilePictureState
        >(
          bloc: _uploadProfilePictureBloc,
          listener: (context, state) {
            if (state is UploadProfilePictureSuccessState) {
              Navigator.of(context).pop();
            } else if (state is UploadProfilePictureFailureState ||
                state is UploadProfilePictureExceptionState) {

            }
          },
          builder: (context, uploadState) {
            return Scaffold(
                  appBar: _buildAppBar(context),
                  backgroundColor: Color.fromRGBO(13, 13, 16, 1),
                  body: uploadState is UploadProfilePictureLoadingState
                      ? Align(
                    child: Image.asset(
                      "assets/gifs/ai_loader.gif",
                      height: 250,
                      width: 250,
                    ),
                  )
                      : SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 35),
                            GestureDetector(
                              child:
                                  imagePath != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                        child: CustomImageview(
                                          imagePath: imagePath,
                                          height: height * 0.22, // Ensure width and height are the same
                                          width: height * 0.22,
                                        ),
                                      )
                                      : _imageFile1 != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.file(
                                          _imageFile1!,
                                          height: height * 0.22, // Ensure width and height are the same
                                          width: height * 0.22,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : lastImage != null ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: lastImage?? "",
                                        height: height * 0.22, // Ensure width and height are the same
                                        width: height * 0.22,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator(
                                            radius: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Center(
                                          child: Icon(
                                            CupertinoIcons.person_crop_circle_badge_exclam,
                                            size: 40,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                      ),
                                    )):CustomImageview(
                                        imagePath:
                                            "assets/images/profile_img.png",
                                        height: 135,
                                        width: 135,
                                      ),
                            ),
                            SizedBox(height: 30),

                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();

                                _pickImage1(ImageSource.gallery);
                              },
                              child: CustomImageview(
                                imagePath:
                                    "assets/images/choose_from_gallery.png",
                                height: height * 0.07,
                                width: width * 0.93,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "You can also choose from these",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 15),
                            state is GetPhotosListLoadingState ? Align(
                      child: Image.asset(
                      "assets/gifs/ai_loader.gif",
                        height: 250,
                        width: 250,
                      )):Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: SizedBox(
                                height: height * 0.5,
                                width: width * 0.9,
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: photosModelResponse?.result?.length ?? 0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // 2 columns
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio:
                                            1, // Adjust for button shape
                                      ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          imagePath =
                                          photosModelResponse?.result?[index];
                                        });
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),

                                        child: Image.network(
                                          photosModelResponse?.result?[index] ?? "",
                                          fit: BoxFit.contain,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(
                      right: 20.0,
                      left: 20,
                      bottom: 25,
                    ),
                    child: CustomElevatedButton(
                      text: 'Save Changes',
                      onPressed: () {
                        HapticFeedback.heavyImpact();

                        print("IMAGE PATH:$imagePath");
                        print("IMAGE PATH NEW :$_base64Image1");
                        _uploadProfilePictureBloc.add(
                          UploadProfilePictureDataEvent(
                            makeSongData: {'profile_pic': imagePath != null ? imagePath : _base64Image1 != null ? _base64Image1 :lastImage},
                          ),
                        );
                      },
                    ),
                  ),
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
      elevation: 0,
      toolbarHeight: 56,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFamily: 'Sora',
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CustomImageview(
              imagePath: "assets/images/cancel_btn_img.png",
              height: 45,
              width: 45,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
