import 'dart:io';

import 'package:ai_interior/widgets/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/custom_imageview.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  static const routeName = "/invite-screen";

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  bool _loading = true;
  bool _granted = false;
  String sharePublicLink = "";

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoad();
    getLink();
  }

  Future<void> getLink() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      sharePublicLink = preferences.getString('public_link') ?? "0";
    });
    print("CREDITS  SC: ${sharePublicLink}");
  }

  Future<void> _checkPermissionAndLoad() async {
    final granted = await FlutterContacts.requestPermission();
    if (granted) {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
      setState(() {
        _contacts = contacts;
        _loading = false;
        _granted = true; // 👈 mark as granted
      });
    } else {
      setState(() {
        _loading = false;
        _granted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: const Color.fromRGBO(13, 13, 16, 1),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _contacts.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "No contacts found or permission denied.",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
              : SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        // Permission request image
                        if (!_granted)
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              // Call your permission fetch method
                            },
                            child: CustomImageview(
                              imagePath: "assets/images/allow_contact_acc.png",
                              height: height * 0.4,
                              width: width * 0.95,
                              fit: BoxFit.contain,
                            ),
                          ),

                        const SizedBox(height: 15),

                        // Invite from other apps
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(26, 26, 34, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              const Text(
                                "Invite from other apps",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildContactRow(
                                context,
                                imageOne: "assets/images/copy_link.png",
                                contactUsOne: "Copy Link",
                                onTap: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: sharePublicLink),
                                  );
                                  showSnackMessage(context);
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildContactRow(
                                context,
                                imageOne: "assets/images/share_circle.png",
                                contactUsOne: "Other Apps",
                                onTap: () async {
                                  await Share.share(sharePublicLink);
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildContactRow(
                                context,
                                imageOne: "assets/images/msg_icon.png",
                                contactUsOne: "Messages",
                                onTap: () async {
                                  if (Platform.isAndroid) {
                                    await Share.share(sharePublicLink);
                                  } else {
                                    shareLinkInMessages(sharePublicLink);
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        // Contacts list
                        if (_granted)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Your Contacts",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _contacts.length,
                                itemBuilder: (context, i) {
                                  final c = _contacts[i];
                                  return ListTile(
                                    leading:
                                        (c.thumbnail != null &&
                                                c.thumbnail!.isNotEmpty)
                                            ? CircleAvatar(
                                              backgroundImage: MemoryImage(
                                                c.thumbnail!,
                                              ),
                                            )
                                            : CustomImageview(
                                              imagePath:
                                                  "assets/images/profile_contact.png",
                                              height: height * 0.07,
                                              width: width * 0.15,
                                              fit: BoxFit.contain,
                                            ),
                                    title: Text(
                                      c.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle:
                                        c.phones.isNotEmpty
                                            ? Text(
                                              c.phones.first.number,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                  204,
                                                  204,
                                                  204,
                                                  1,
                                                ),
                                                fontSize: 16,
                                                fontFamily: 'Manrope',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                            : const Text("No number"),
                                    trailing: CustomElevatedButton(
                                      text: "Invite",
                                      width: width * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(138, 35, 135, 1),
                                            Color.fromRGBO(233, 64, 87, 1),
                                            Color.fromRGBO(242, 113, 33, 1),
                                          ],
                                        ),
                                      ),
                                      height: 45,
                                      buttonTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onPressed: () async {
                                        HapticFeedback.heavyImpact();
                                        if (Platform.isAndroid) {
                                          await Share.share(sharePublicLink);
                                        }else{
                                        if (c.phones.isNotEmpty) {
                                          final phoneNumber =
                                              c.phones.first.number;

                                          shareLinkInMessagesNumber(
                                            phoneNumber,
                                            sharePublicLink,
                                          );
                                        }}
                                      },
                                      rightIcon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  void showSnackMessage(BuildContext context) {
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
                  Color.fromRGBO(138, 35, 135, 1),
                  Color.fromRGBO(233, 64, 87, 1),
                  Color.fromRGBO(242, 113, 33, 1),
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
                    "Profile Link Copied !",
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

  Future<void> shareLinkInMessages(String link) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      queryParameters: {
        'body': link, // prefilled message body
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not open Messages app';
    }
  }

  Future<void> shareLinkInMessagesNumber(
    String phoneNumber,
    String link,
  ) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber, // recipient phone number
      queryParameters: {
        'body': link, // prefilled message body
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not open Messages app';
    }
  }

  Future<void> _fetchContacts() async {
    final granted = await FlutterContacts.requestPermission();

    if (!granted) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withThumbnail: true,
    );

    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }

  Future<void> requestContactPermission() async {
    var status = await Permission.contacts.status;

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    if (status.isDenied || status.isRestricted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      // 🔑 Refetch contacts when granted
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
      setState(() {
        _contacts = contacts;
      });
    } else {
      print("Contacts permission denied.");
    }
  }

  Widget _buildContactRow(
    BuildContext context, {
    required String imageOne,
    required String contactUsOne,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageview(
              imagePath: imageOne,
              height: 45,
              width: 45,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 20),
            Text(
              contactUsOne,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Manrope',
                fontSize: 22,
              ),
            ),
            Spacer(flex: 84),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 25),
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
      toolbarHeight: 56,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: width * 0.83,
      leading: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: SizedBox(
          width: width * 0.83,
          child: TextFormField(
            controller: _searchController,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),

            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 20,
                fontWeight: FontWeight.w300,
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
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: Colors.grey.shade500,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),

      // title: Text(
      //   "Profile",
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontSize: 28,
      //     fontFamily: 'Sora',
      //     fontWeight: FontWeight.w700,
      //   ),
      // ),
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
