import 'package:ai_interior/bloc/update_user_details/update_user_details_bloc.dart';
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/get_user_model_response.dart';
import '../../../widgets/custom_elevated_button.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UpdateUserDetailsBloc _updateUserDetailsBloc = UpdateUserDetailsBloc();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String selectedGender = "";
  UserModelResponse? userModelResponse;
  String? userId;

  bool _isInit = true;


@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(_isInit) {
      userModelResponse = ModalRoute
          .of(context)
          ?.settings
          .arguments as UserModelResponse;

      _nameController.text = userModelResponse?.result?.name ?? "";
      print("Age : ${userModelResponse?.result?.age}");
      _ageController.text =
      (userModelResponse?.result?.age == null || userModelResponse?.result?.age == "null")
          ? ""
          : userModelResponse!.result!.age.toString();

      _bioController.text = userModelResponse?.result?.bio ?? "";
      setState(() {
        selectedGender = userModelResponse?.result?.gender ?? "";
      });_isInit = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: BlocConsumer<UpdateUserDetailsBloc, UpdateUserDetailsState>(
          bloc: _updateUserDetailsBloc,
          listener: (context, state) {
            if (state is UpdateUserDetailsSuccessState) {
              Navigator.of(context).pop();
            } else if (state is UpdateUserDetailsFailureState ||
                state is UpdateUserDetailsExceptionState) {}
          },
          builder: (context, state) {
            return state is UpdateUserDetailsLoadingState
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 35),
                        Text(
                          "Your name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: width * 0.95,
                          child: TextFormField(
                            focusNode: FocusNode(),
                            autofocus: true,
                            controller: _nameController,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: "Your Name",
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
                            ),
                          ),
                        ),

                        SizedBox(height: 25),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.2,
                              child: TextFormField(
                                controller: _ageController,
                                textAlign: TextAlign.center,

                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Age",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(
                                    37,
                                    37,
                                    40,
                                    1,
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Years Old",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 25),
                        Text(
                          "Your identity",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GenderGridSelector(
                          selectedGender: selectedGender,
                          onGenderSelected: (String gender) {
                            setState(() {
                              selectedGender = gender;
                            });
                            print("Selected gender in parent: $gender");
                          },
                        ),
                        Text(
                          "Bio",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: width * 0.99,
                          child: TextFormField(
                            maxLines: 5,
                            textCapitalization:
                            TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            autocorrect: true,

                            controller: _bioController,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText:
                              "Dreamer. Explorer. Coffee-fueled \nthinker chasing sunsets and stories \nacross parallel worlds.",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 18,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 25),
        child: CustomElevatedButton(
          text: 'Save Changes',
          onPressed: () {
            HapticFeedback.heavyImpact();

            _updateUserDetailsBloc.add(
              UpdateUserDetailsDataEvent(
                updateData: {
                  "name": _nameController.text,
                  "gender": selectedGender.isEmpty ? "Male" : selectedGender,
                  "age": int.parse(_ageController.text),
                  "bio": _bioController.text,
                  "onboarding_details": {
                    "partner_id": 1,
                    "interested_in": "Women",
                  },
                  "is_inapp": true,
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('user_id') ?? "";
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
        "Edit Profile",
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

class GenderGridSelector extends StatefulWidget {
  final String? selectedGender;
  final ValueChanged<String> onGenderSelected;

  const GenderGridSelector({
    super.key,
    this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  State<GenderGridSelector> createState() => _GenderGridSelectorState();
}

class _GenderGridSelectorState extends State<GenderGridSelector> {
  final List<String> list = ['Male', 'Female', 'Others'];
  String? selected;

  @override
  void didUpdateWidget(covariant GenderGridSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGender != widget.selectedGender) {
      setState(() {
        selected = widget.selectedGender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio:isIPad(context)?3.5: 2,
      // Adjust for button shape
      padding: const EdgeInsets.all(16),
      children:
          list.map((item) {
            final bool isSelected = selected == item;
            return GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();

                setState(() {
                  selected = item;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient:
                      isSelected
                          ? LinearGradient(
                            colors: [
                              Color.fromRGBO(138, 35, 135, 0.3),
                              Color.fromRGBO(233, 64, 87, 0.3),
                              Color.fromRGBO(242, 113, 33, 0.3),
                            ],
                          )
                          : LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0.1),
                              Color.fromRGBO(255, 255, 255, 0.2),
                            ],
                          ),
                  border:
                      isSelected
                          ? Border.all(
                            color: Color.fromRGBO(138, 35, 135, 1),
                            width: 1.7,
                          )
                          : Border(),
                ),
                alignment: Alignment.center,
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: item == "Non-binary" ? 17 : 18,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
