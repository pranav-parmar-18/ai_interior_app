import 'dart:io';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/contact_us/contact_us_bloc.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  static const routeName = "/contact-us";

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String selectedOption = "issue";
  final ContactUsBloc _contactUsBloc = ContactUsBloc();

  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _msgTextEditingController = TextEditingController();

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _msgTextEditingController.dispose();
    _contactUsBloc.close();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  void _submitForm() {
    final email = _emailTextEditingController.text.trim();
    final message = _msgTextEditingController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message.')),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    _contactUsBloc.add(
      ContactUsDataEvent(
        makeSongData: {
          "name": _nameTextEditingController.text.trim(),
          "email": email,
          "phone": "",
          "message": message,
          "subject": selectedOption == "issue"
              ? "Report an Issue"
              : selectedOption == "refund"
                  ? "Refund Request"
                  : "General Support",
          "source": "AI Interior App",
          "bundle_id": "com.ai.interior",
          "developer_account": "BVK Technologies Pvt. Ltd.",
          "platform": Platform.isAndroid ? "android" : "ios",
        },
        file: selectedImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE8),
      body: BlocConsumer<ContactUsBloc, ContactUsState>(
        bloc: _contactUsBloc,
        listener: (context, state) {
          if (state is ContactUsSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isNotEmpty
                      ? state.message
                      : 'Thank you! Your message has been sent.',
                ),
                backgroundColor: const Color(0xFF2C6E7E),
              ),
            );
            _nameTextEditingController.clear();
            _emailTextEditingController.clear();
            _msgTextEditingController.clear();
            setState(() {
              selectedImage = null;
            });
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.of(context).maybePop();
              }
            });
          } else if (state is ContactUsFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isNotEmpty ? state.message : 'Submission failed.',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is ContactUsExceptionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isNotEmpty
                      ? state.message
                      : 'An error occurred while sending your request.',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ContactUsLoadingState;

          return Column(
            children: [
              SizedBox(height: topPadding),

              // ── Header ───────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.wp(context, 20),
                  vertical: r.hp(context, 14),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Icon(
                          Icons.chevron_left,
                          size: r.adaptiveValue(context, mobile: 30, tablet: 38),
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    Text(
                      'Support',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: r.sp(context, 26),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),

              r.verticalSpace(context, 8),

              // ── Form Content Card ────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    r.wp(context, 20),
                    0,
                    r.wp(context, 20),
                    bottomPadding + r.hp(context, 24),
                  ),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.all(r.wp(context, 20)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.wp(context, 20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Selection
                          Text(
                            'How can we help you?',
                            style: TextStyle(
                              fontSize: r.sp(context, 16),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          r.verticalSpace(context, 12),
                          Row(
                            children: [
                              Expanded(
                                child: _OptionChip(
                                  label: 'Report Issue',
                                  icon: Icons.bug_report_outlined,
                                  isSelected: selectedOption == 'issue',
                                  onTap: () {
                                    setState(() => selectedOption = 'issue');
                                  },
                                ),
                              ),
                              r.horizontalSpace(context, 10),
                              Expanded(
                                child: _OptionChip(
                                  label: 'Ask Refund',
                                  icon: Icons.receipt_long_outlined,
                                  isSelected: selectedOption == 'refund',
                                  onTap: () {
                                    setState(() => selectedOption = 'refund');
                                  },
                                ),
                              ),
                            ],
                          ),

                          r.verticalSpace(context, 20),

                          // Name Input Field
                          _FormField(
                            label: 'Name',
                            hintText: 'John Doe',
                            controller: _nameTextEditingController,
                            keyboardType: TextInputType.name,
                          ),

                          r.verticalSpace(context, 16),

                          // Email Input Field
                          _FormField(
                            label: 'Email Address',
                            hintText: 'name@example.com',
                            controller: _emailTextEditingController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          r.verticalSpace(context, 16),

                          // Message Input Field
                          _FormField(
                            label: 'Message',
                            hintText: 'Describe your issue or feedback in detail...',
                            controller: _msgTextEditingController,
                            maxLines: 4,
                          ),

                          r.verticalSpace(context, 20),

                          // Image Attachment Section
                          Text(
                            'Attach Screenshot (Optional)',
                            style: TextStyle(
                              fontSize: r.sp(context, 14),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          r.verticalSpace(context, 8),

                          if (selectedImage == null)
                            GestureDetector(
                              onTap: _pickFromGallery,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: r.hp(context, 16),
                                  horizontal: r.wp(context, 16),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F8F6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2DDD7),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: const Color(0xFF2C6E7E),
                                      size: r.wp(context, 22),
                                    ),
                                    r.horizontalSpace(context, 8),
                                    Text(
                                      'Upload Image from Gallery',
                                      style: TextStyle(
                                        fontSize: r.sp(context, 14),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF2C6E7E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    selectedImage!,
                                    height: r.hp(context, 160),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          r.verticalSpace(context, 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: r.hp(context, 52),
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C6E7E),
                                disabledBackgroundColor: const Color(0xFF2C6E7E).withValues(alpha: 0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const CupertinoActivityIndicator(color: Colors.white)
                                  : Text(
                                      'Submit Request',
                                      style: TextStyle(
                                        fontSize: r.sp(context, 16),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: r.hp(context, 12),
          horizontal: r.wp(context, 12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C6E7E) : const Color(0xFFF9F8F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C6E7E) : const Color(0xFFE2DDD7),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: r.wp(context, 18),
              color: isSelected ? Colors.white : const Color(0xFF4A4A4A),
            ),
            r.horizontalSpace(context, 6),
            Text(
              label,
              style: TextStyle(
                fontSize: r.sp(context, 13),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const _FormField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.sp(context, 14),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        r.verticalSpace(context, 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: r.sp(context, 15),
            color: const Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: r.sp(context, 14),
              color: const Color(0xFF999999),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F8F6),
            contentPadding: EdgeInsets.symmetric(
              horizontal: r.wp(context, 14),
              vertical: r.hp(context, 12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2DDD7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2DDD7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2C6E7E), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
