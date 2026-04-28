import 'package:ai_interior/features/user/presentation/user_data_screen_five.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_one.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_three.dart';
import 'package:ai_interior/theme/theme.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/partner_list/partner_list_bloc.dart';
import '../../../models/partner_list_model_response.dart';
import '../../../widgets/custom_elevated_button.dart';

String selectedUserPartner  = "";

class UserDataScreenFour extends StatefulWidget {
  static const routeName = "/user-data-four";

  const UserDataScreenFour({super.key});

  @override
  State<UserDataScreenFour> createState() => _UserDataScreenFourState();
}

class _UserDataScreenFourState extends State<UserDataScreenFour> {
  final PartnerListBloc _partnerListBloc = PartnerListBloc();
  PartnerListResponse? partnerListResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _partnerListBloc.add(
      PartnerListDataEvent(
        genderId:
        selectedUserRelationTwo == "Male"
                ? "3"
                : selectedUserRelationTwo == "Female"
                ? "1"
                : "3",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/gifs/bg.gif",
            fit: BoxFit.cover,
            width: width,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context),
          body: BlocConsumer<PartnerListBloc, PartnerListState>(
            bloc: _partnerListBloc,
            listener: (context, state) {
              if (state is PartnerListSuccessState) {
                partnerListResponse = state.exploreSongResponse;
              } else if (state is PartnerListFailureState ||
                  state is PartnerListExceptionState) {}
            },
            builder: (context, state) {
              return state is PartnerListLoadingState &&
                      partnerListResponse == null
                  ? Center(child: CupertinoActivityIndicator())
                  : Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(left: 16, top: 20, right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Choose your",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: " partner",
                                style: TextStyle(
                                  color: Color.fromRGBO(242, 113, 33, 1),
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

                        SizedBox(height: height * 0.03),
                        Container(
                          padding: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              width: 2,
                              color: Color.fromRGBO(233, 64, 87, 1),
                            ),
                          ),
                          child: ImageCarousel(
                            partnerListResponse:
                                partnerListResponse ?? PartnerListResponse(),
                            height: height * 0.6,
                            width: width * 0.9,
                          ),
                        ),

                        SizedBox(height: height * 0.01),
                      ],
                    ),
                  );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 25),
            child: CustomElevatedButton(
              text: 'Continue',
              onPressed: () {
                Navigator.of(context).pushNamed(UserDataScreenFive.routeName);
              },
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      toolbarHeight: 64,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leadingWidth: 64,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: SizedBox(
            height: 44,
            width: 44,
            child: Image.asset("assets/images/back.png", height: 50, width: 50),
          ),
        ),
      ),
      centerTitle: true,
      title: Container(
        height: 8,
        width: width * 0.7,
        decoration: BoxDecoration(
          color: appTheme.gray900,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(37, 37, 40, 1),
            value: 0.7,
            color: Color.fromRGBO(242, 113, 33, 1),
          ),
        ),
      ),
    );
  }

  Widget buildGenderButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.maxFinite,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Color.fromRGBO(37, 37, 40, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          visualDensity: VisualDensity(vertical: -4, horizontal: -4),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ImageCarousel extends StatelessWidget {
  final double height;
  final double width;
  final PartnerListResponse partnerListResponse;

  const ImageCarousel({
    required this.height,
    required this.width,
    super.key,
    required this.partnerListResponse,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height * 1,
        // Adjusted to match image height
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 1500),
        viewportFraction: 1,
      ),
      items:
          partnerListResponse.result?.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imagePath.image ?? "",
                        fit: BoxFit.cover,
                        height: height * 0.6,
                        width: width * 1, // full width
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              imagePath.name ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.6),
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              imagePath.bio ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Sora',
                                shadows: [
                                  Shadow(
                                    blurRadius: 8,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
