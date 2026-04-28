import 'dart:ui';

import 'package:ai_interior/features/user/presentation/user_data_screen_two.dart';
import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/material.dart';

String selectedUserGender = "";

class UserDataScreenOne extends StatefulWidget {
  static const routeName = "/user-data-one";

  const UserDataScreenOne({super.key});

  @override
  State<UserDataScreenOne> createState() => _UserDataScreenOneState();
}

class _UserDataScreenOneState extends State<UserDataScreenOne> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),

      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 16, top: 20, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // ImageFiltered(
            //   imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            //   child: Container(
            //     height: height * 0.126,
            //     width: width * 0.128,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(62),
            //       gradient: LinearGradient(colors: [
            //         Color.fromRGBO(138, 35, 135, 1),
            //         Color.fromRGBO(233, 64, 87, 1),
            //         Color.fromRGBO(242, 113, 33, 1),
            //       ])
            //     ),
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //
            //       ],
            //     ),
            //   ),
            //
            // ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 62),
              height: height * 0.15,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Blurred Gradient Background
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaY: 60, sigmaX: 60),
                    child: Container(
                      height: height * 0.15,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        gradient: LinearGradient(
                          begin: Alignment(0, 0.5),
                          end: Alignment(1, 0.5),
                          colors: [
                            Color.fromRGBO(138, 35, 135, 1),
                            Color.fromRGBO(233, 64, 87, 1),
                            Color.fromRGBO(242, 113, 33, 1),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Sharp Image on top
                  Image.asset(
                    "assets/images/gender.png",
                    fit: BoxFit.cover,
                    height: height * 0.15,
                    width: width * 0.25,
                  ),
                ],
              ),
            ),

            SizedBox(height: 35),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "How do you ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "identify",
                    style: TextStyle(
                      color: Color.fromRGBO(242, 113, 33, 1),
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "\nyourself? ",
                    style: TextStyle(
                      color: Colors.white,
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
            SizedBox(height: height * 0.036),
            _buildOptions(context),
          ],
        ),
      ),
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
      leading: Padding(
        padding: EdgeInsets.only(left: 20),
        child: SizedBox(
          height: 44,
          width: 44,
          child: Image.asset("assets/images/back.png", height: 50, width: 50),
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
            value: 0.1,
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

  Widget _buildOptions(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 15,
        children: [
          buildGenderButton(
            label: "Male",
            onPressed: () {
              selectedUserGender = "Male";
              Navigator.of(context).pushNamed(UserDataScreenTwo.routeName);
            },
          ),
          buildGenderButton(label: "Female", onPressed: () {
            selectedUserGender = "Female";
            Navigator.of(context).pushNamed(UserDataScreenTwo.routeName);
          }),
          buildGenderButton(label: "Non-binary", onPressed: () {
            selectedUserGender = "Non-binary";
            Navigator.of(context).pushNamed(UserDataScreenTwo.routeName);
          }),
          buildGenderButton(label: "Prefer not to say", onPressed: () {
            selectedUserGender = "Prefer not to say";
            Navigator.of(context).pushNamed(UserDataScreenTwo.routeName);
          }),
        ],
      ),
    );
  }
}
