import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_imageview.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  static const routeName = "call-screen";

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int _seconds = 0;
  late Timer _timer;
  bool isSpeaker = false;
  bool isMute = false;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/images/filter_girl_one.png",
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    // increase for stronger blur
                    child: Container(
                      color: Colors.black.withOpacity(
                        0,
                      ), // required to make BackdropFilter work
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: height * 0.15),
                Align(child: VisibilitySelector()),
                SizedBox(height: height * 0.05),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Elizabeth",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w700,
                          height: 1.5, // Add space below this line
                        ),
                      ),

                      TextSpan(
                        text: "\n AI Character",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          height: 1.5, // Add space below this line
                        ),
                      ),
                      TextSpan(
                        text: "\n ${_formatTime(_seconds)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: height * 0.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSpeaker = !isSpeaker;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromRGBO(255, 255, 255, isSpeaker ?1:0.2),
                            child: Icon(
                              CupertinoIcons.speaker_2_fill,
                              color: isSpeaker ?Colors.black:Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Speaker",style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                        ),)
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CustomImageview(
                            imagePath: "assets/images/call_cut.png",
                            height: 90,
                            width: 90,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("End Call",style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                        ),)
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMute = !isMute;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromRGBO(255, 255, 255,isMute ?1: 0.2),
                            child: Icon(
                              CupertinoIcons.mic_slash_fill,
                              color: isMute?Colors.black:Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Mute",style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                        ),)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VisibilitySelector extends StatefulWidget {
  const VisibilitySelector({super.key});

  @override
  State<VisibilitySelector> createState() => _VisibilitySelectorState();
}

class _VisibilitySelectorState extends State<VisibilitySelector> {
  String selectedOption = 'one'; // or 'private'

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          margin: EdgeInsets.symmetric(horizontal: 62),
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Blurred Gradient Background
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaY: 75, sigmaX: 75),
                child: Container(
                  height: 220,
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(color: Color.fromRGBO(233, 64, 87, 1), width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: CustomImageview(
                    imagePath: "assets/images/filter_girl_one.png",
                    height: 220,
                    width: 220,
                  ),
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }
}
