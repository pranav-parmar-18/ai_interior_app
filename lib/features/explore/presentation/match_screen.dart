import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/chat/send_ai_message_from_gf/send_ai_message_from_gf_bloc.dart';
import '../../../services/subscription_manager.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../main/presentaion/main_screen.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../subscription/presentation/subscription_screen_three.dart';
import '../../subscription/presentation/subscription_screen_two.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  static const routeName = "match-screen";

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final SendAIMessageFromGFBloc _sendAIMessageFromGFBloc =
      SendAIMessageFromGFBloc();
  Map<String, dynamic> data = {};

  bool? isSubscribed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSubscriptionActive();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  }

  Future<bool> isSubscriptionActive() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('subscription_info');
    if (data == null) {
      setState(() {
        isSubscribed = false;
      });
      return false;
    }

    final sub = SubscriptionInfo.fromJson(data);
    setState(() {
      isSubscribed = sub?.isActive ?? false;
    });

    return sub?.isActive ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<SendAIMessageFromGFBloc, SendAIMessageFromGFState>(
      bloc: _sendAIMessageFromGFBloc,
      listener: (context, state) {
        if (state is SendAIMessageFromGFSuccessState) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const MainScreen(initialIndex: 1),
            ),
            (route) => false,
          );
        } else if (state is SendAIMessageFromGFExceptionState ||
            state is SendAIMessageFromGFFailureState) {}
      },
      builder: (context, state) {
        return Scaffold(
          body: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/gifs/bg.gif",
                    fit: BoxFit.cover,
                    width: width,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: height * 0.13),
                    Align(
                      child: Image.asset(
                        "assets/gifs/match.gif",
                        height: height * 0.1,
                        width: width * 0.9,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    1 == 1
                        ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: data["image"] ?? "",
                              fit: BoxFit.cover,
                              height: height * 0.53,
                              width: width * 0.9,
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
                                      CupertinoIcons
                                          .photo_fill_on_rectangle_fill,
                                      size: 40,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                            ),
                          ),
                        )
                        : DiamondContainer(
                          size: height * 0.45,
                          child: Image.asset(
                            "assets/images/anim_one.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                    SizedBox(height: height * 0.03),

                    Text(
                      "You’ve just matched with ${data["name"]} 💕",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    state is SendAIMessageFromGFLoadingState
                        ? Center(
                          child: CupertinoActivityIndicator(
                            radius: 18,
                            color: Colors.white,
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: CustomElevatedButton(
                            text: "Chat Now",
                            onPressed: () async {
                              HapticFeedback.heavyImpact();

                              if (isSubscribed == true) {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                String userId =
                                    preferences.getString('user_id') ?? "";
                                String userName =
                                    preferences.getString('user_name') ?? "";
                                print("FROM ID : ${data["id"]}");
                                print("FROM NAME : ${data["name"]}");
                                print("TO ID: $userId");
                                print("TO NAME : $userName");
                                _sendAIMessageFromGFBloc.add(
                                  SendAIMessageFromGFDataEvent(
                                    SendAIMessageFromGF: {
                                      "from_user_id": data["id"],
                                      "from_user_name": data["name"],
                                      "to_user_id": userId,
                                      "to_user_name": userName,
                                      "message_type": 1,
                                      "message":
                                          "Hey, I’m your Girlfriend 😘Let me be your naughty little secret.",
                                      "character_type": 1,
                                    },
                                  ),
                                );
                              } else {
                               openSubscriptionScreen(context);
                              }
                            },
                          ),
                        ),
                    SizedBox(height: height * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Skip for now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openSubscriptionScreen(BuildContext context) {
    final nextIndex = SubscriptionScreenManager().getNextIndex();

    final screens = [
      SubscriptionScreen(),
      SubscriptionTwoScreen(),
      SubscriptionThreeScreen(),
    ];

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => screens[nextIndex]),
    );
  }

}

class DiamondContainer extends StatelessWidget {
  final double size;
  final Widget child;

  const DiamondContainer({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RoundedDiamondClipper(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ), // fallback for rectangular children
        ),
        child: child,
      ),
    );
  }
}

class RoundedDiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double clipSize = 10.0;

    final width = size.width;
    final height = size.height;

    final path = Path();

    // Start from top middle
    path.moveTo(width / 2, 0);

    // Top-right (curved)
    path.quadraticBezierTo(width, 0, width, height / 2);

    // Bottom-right (clipped inward)
    path.quadraticBezierTo(width, height, width / 2 + clipSize, height);

    // Bottom-left (curved)
    path.quadraticBezierTo(0, height, 0, height / 2);

    // Top-left (clipped inward)
    path.quadraticBezierTo(0, 0, width / 2 - clipSize, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
