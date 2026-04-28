import 'package:ai_interior/features/user/presentation/user_data_screen_three.dart';
import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_elevated_button.dart';

int selectedUserAge = 0;

class UserDataScreenTwo extends StatefulWidget {
  static const routeName = "/user-data-two";

  const UserDataScreenTwo({super.key});

  @override
  State<UserDataScreenTwo> createState() => _UserDataScreenTwoState();
}

class _UserDataScreenTwoState extends State<UserDataScreenTwo> {
  int selectedAge = 25;

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
            Image.asset(
              "assets/images/age_top.png",
              fit: BoxFit.cover,
              height: height * 0.15,
              width: width * 0.25,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(text: TextSpan(children: [
              TextSpan(
                text: "How old are ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,

                )
              ),
              TextSpan(
                  text: "you?",
                  style: TextStyle(
                    color:                 Color.fromRGBO(242, 113, 33, 1),
                    fontSize: 28,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w600,

                  )
              ),

            ]),textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,),
            SizedBox(
              height: height*0.036,
            ),
            SizedBox(
              // color: Colors.black, // Full dark background
              height: height*0.4,
              child: CupertinoPicker(
                // backgroundColor: Colors.black,
                itemExtent: 40,
                scrollController: FixedExtentScrollController(initialItem: selectedAge - 10),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedAge = index + 10;
                    selectedUserAge = index +10;
                  });
                },
                // selectionOverlay: Container(
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF2A2A2A),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                // ),
                children: List.generate(
                  91,
                      (index) => Center(
                    child: Text(
                      '${index + 10}',
                      style: TextStyle(
                        color: (index + 10) == selectedAge ? Colors.white : Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height*0.1,
            ),

          ],

        ),
      ),
      bottomNavigationBar:Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 25),

        child: CustomElevatedButton(text: 'Continue',onPressed: () {
          Navigator.of(context).pushNamed(UserDataScreenThree.routeName);
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
          value: 0.3,
          color:                     Color.fromRGBO(242, 113, 33, 1),
        ),
      ),
    ),
    );
  }

}
