import 'dart:ui';

import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_four.dart';
import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/custom_elevated_button.dart';

String selectedUserRelation = "";
String selectedUserRelationTwo = "";

class UserDataScreenThree extends StatefulWidget {
  static const routeName = "/user-data-three";

  const UserDataScreenThree({super.key});

  @override
  State<UserDataScreenThree> createState() => _UserDataScreenThreeState();
}

class _UserDataScreenThreeState extends State<UserDataScreenThree> {
  int selectedIndex = 0;

  final List<String> imagePaths = [
    'assets/images/women_img.png',
    'assets/images/men_img.png',
    'assets/images/non_bin_img.png',
    'assets/images/everyone_img.png',
  ];

  List<String> stringList = [
    "Women",
    "Men",
    "Non-Binary",
    "Everyone",
  ];

  List<String> realtionList = [
    "Male",
    "Female",
    "Female",
    "Female",
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 16, top: 20, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 62),
                height: height * 0.15,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blurred Gradient Background
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaY: 75, sigmaX: 75),
                      child: Container(
                        height: height * 0.15,
                        width: width*0.3,
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
                      "assets/images/love_img.png",
                      fit: isIPad(context)?BoxFit.contain:BoxFit.cover,
                      height: isIPad(context)? height*0.15:height * 0.15,
                      width: isIPad(context)?width*0.25:width * 0.3,
                    ),
                  ],
                ),
              ),
        
        
              SizedBox(
                height: 30,
              ),
              RichText(text:
              TextSpan(children: [
                TextSpan(
                  text: "What kind of ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w600,
                  )
                ),
                TextSpan(
                    text: "people",
                    style: TextStyle(
                      color:                 Color.fromRGBO(242, 113, 33, 1),
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
        
                    )
                ),
                TextSpan(
                    text: " are",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
        
                    )
                ),
                TextSpan(
                    text: "\nyou into?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
        
                    )
                ),
              ]),textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,),
              // SizedBox(
              //   height: height*0.036,
              // ),
        SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              // height: isIPad(context)?height*0.3:height * 0.43,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: imagePaths.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: isIPad(context)?10:12,
                  mainAxisSpacing: isIPad(context)?10:12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
        
                      setState(() {
                        selectedIndex= index;
                        selectedUserRelation = stringList[index];
                        selectedUserRelationTwo = realtionList[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                        selectedIndex == index
                            ? Border.all(
                          color: Color.fromRGBO(233, 64, 87, 0.7),
                          width: 1.5,
                        )
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                          height: isIPad(context) ?MediaQuery.of(context).size.height * 0.2: 300,
                          width: isIPad(context)? MediaQuery.of(context).size.width * 0.5:300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
              SizedBox(
                height: height*0.05,
              ),
        
            ],
        
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 25),
        child: CustomElevatedButton(text: 'Continue',onPressed: () {
          Navigator.of(context).pushNamed(UserDataScreenFour.routeName);
        },),
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
          value: 0.5,
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
