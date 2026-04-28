import 'package:ai_interior/features/user/presentation/user_data_screen_six.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_three.dart';
import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_elevated_button.dart';

TextEditingController selectedYourNameController = TextEditingController();

class UserDataScreenFive extends StatefulWidget {
  static const routeName = "/user-data-five";

  const UserDataScreenFive({super.key});

  @override
  State<UserDataScreenFive> createState() => _UserDataScreenFiveState();
}

class _UserDataScreenFiveState extends State<UserDataScreenFive> {

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
            Image.asset(
              "assets/images/love_chat.png",
              fit: BoxFit.cover,
              height: height * 0.15,
              width: width * 0.45,
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "What should ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "Jessica",
                    style: TextStyle(
                      color: Color.fromRGBO(242, 113, 33, 1),
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "\ncall you?",
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
            SizedBox(
              width: width * 0.95,
              child: TextFormField(

                controller: selectedYourNameController,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Your Name",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(37, 37, 40, 1),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.1),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 25),
        child: CustomElevatedButton(
          text: 'Continue',
          onPressed: () {
            if(selectedYourNameController.text.isEmpty){
              showSnackMessageError(context);
            }
            else{
            Navigator.of(context).pushNamed(UserDataScreenSix.routeName);}
          },
        ),
      ),
    );
  }
  void showSnackMessageError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        duration: Duration(milliseconds: 1000),
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
                    "Please enter name !",
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

  PreferredSizeWidget _buildAppBar(BuildContext context){
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
        child: Padding(padding: EdgeInsets.only(left: 20),child: SizedBox(
          height: 44,
          width: 44,
          child: Image.asset("assets/images/back.png",height: 50,width: 50,),
        ),),
      ),
      centerTitle: true, title: Container(
      height: 8,
      width: width * 0.7,
      decoration: BoxDecoration(
        color: appTheme.gray900,
        borderRadius: BorderRadius.circular(4)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
        backgroundColor: Color.fromRGBO(37, 37, 40, 1),
          value: 0.9,
          color:                     Color.fromRGBO(242, 113, 33, 1),
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
          backgroundColor:  Color.fromRGBO(37, 37, 40, 1),

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

  Widget _buildOptions(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 15,
        children: [
          buildGenderButton(label: "Male", onPressed: () {

          },),buildGenderButton(label: "Female", onPressed: () {

          },),buildGenderButton(label: "Non-binary", onPressed: () {

          },),buildGenderButton(label: "Prefer not to say", onPressed: () {

          },),
        ])
    );
  }
}
