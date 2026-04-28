import 'dart:io';

import 'package:ai_interior/bloc/update_user_details/update_user_details_bloc.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_five.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_one.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_seven.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_three.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_two.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class UserDataScreenSix extends StatefulWidget {
  UserDataScreenSix({super.key});

  static const routeName = "/user-data-six";

  @override
  State<UserDataScreenSix> createState() => _UserDataScreenSixState();
}

class _UserDataScreenSixState extends State<UserDataScreenSix> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  late VideoPlayerController _controller;
  bool showPercentage = true;
  final UpdateUserDetailsBloc _updateUserDetailsBloc= UpdateUserDetailsBloc();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/loading.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true); // make it loop
        _controller.play(); // Auto play
        setState(() {}); // Auto play
      });
    analytics.logEvent(
      name: 'onboarding_screen_1_viewed',
      parameters: {'time': DateTime.now().toIso8601String()},
    );
    print("selectedUserAge: ${selectedUserAge}");
   _updateUserDetailsBloc.add(UpdateUserDetailsDataEvent(updateData: {
     "name": selectedYourNameController.text,
     "gender": selectedUserGender,
     "age": selectedUserAge,
     "bio": "",
     "onboarding_details": {
       "partner_id": 1,
       "interested_in": selectedUserRelation.isNotEmpty
           ? selectedUserRelation
           : "Women",
     },
     "is_inapp": true
   }));
  }

  Future<void> setSignUp(bool isSignUp) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('sign_up_completed', isSignUp);
  }

  final backgroundColors = [
    Color.fromRGBO(138, 35, 135, 1).withOpacity(0.22),
    Color.fromRGBO(233, 64, 87, 1).withOpacity(0.22),
    Color.fromRGBO(242, 113, 33, 1).withOpacity(0.22),
  ];
  final gradientColors = [
    [Color.fromRGBO(233, 64, 87, 1), Color.fromRGBO(242, 113, 33, 1)],
    [
      Color.fromRGBO(138, 35, 135, 1),
      Color.fromRGBO(233, 64, 87, 1),
      Color.fromRGBO(242, 113, 33, 1),
    ],
    [
      Color.fromRGBO(138, 35, 135, 1),
      Color.fromRGBO(233, 64, 87, 1),
      Color.fromRGBO(242, 113, 33, 1),
    ],
  ];
  final duration = Duration(seconds: 3);



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 16, 1),
      body: BlocConsumer<UpdateUserDetailsBloc, UpdateUserDetailsState>(
        bloc: _updateUserDetailsBloc,
        listener: (context, state) {
    if(state is UpdateUserDetailsSuccessState){
      Navigator.of(context).pushNamed(UserDataScreenSeven.routeName);
    }
    else if(state is UpdateUserDetailsExceptionState || state is UpdateUserDetailsFailureState){

    }
  },
  builder: (context, state) {
    return state is UpdateUserDetailsLoadingState
        ? Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: height * 0.09),
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Creating your unique",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "\nfeed experience",
                  style: TextStyle(
                    color: Color.fromRGBO(242, 113, 33, 1),
                    fontSize: 35,
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
        ),
        SizedBox(height: height * 0.15),
        _controller.value.isInitialized
            ? Container(
          height: height * 0.3,
          width: width * 0.6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              if (showPercentage)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 100.0),
                  duration: Duration(seconds: 1,milliseconds: 500),
                  builder: (context, value, child) {
                    return Text(
                      '${value.toInt()}%',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        )
            : SizedBox.shrink(),
        SizedBox(height: height * 0.01),
        Text(
          "Analysing your data...",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    )
        : SizedBox.shrink();
  },
),
    );
  }

  bool isIPad(BuildContext context) {
    return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
  }

  Future<void> setIsOnboardingDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_onboarding_done', true);
  }
}
