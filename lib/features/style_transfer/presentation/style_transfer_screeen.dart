import '../../credit/presentataion/credit_screen.dart';
import 'dart:io';

import 'package:ai_interior/bloc/create_style_transfer/create_style_transfer_bloc.dart';
import 'package:ai_interior/features/snap_trip/presentation/snap_trip_screen.dart';
import 'package:ai_interior/features/style_transfer/presentation/style_output_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../models/create_style_transfer_model_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../home/presentation/home_screen.dart';
import '../../main/presentaion/main_screen.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../subscription/presentation/subscription_screen_two.dart';
import '../../subscription/presentation/subscription_screen_three.dart';
import '../../../services/subscription_manager.dart';

File? picked;

class StyleTransferScreen extends StatefulWidget {
  const StyleTransferScreen({super.key});

  static const routeName = "/style-transfer-screen";

  @override
  State<StyleTransferScreen> createState() => _StyleTransferScreenState();
}

class _StyleTransferScreenState extends State<StyleTransferScreen> {
  int _selectedTemplate = -1;
  File? refImage;
  String? styleReferenceUrl;
  bool _isLoadingStyleReference = false;
  bool? isSubscribed;

  @override
  void initState() {
    super.initState();
    isSubscriptionActive();
  }

  void openSubscriptionScreen(BuildContext context) {
    final nextIndex = SubscriptionScreenManager().getNextIndex();

    final screens = [
      SubscriptionScreen(),
      SubscriptionScreenTwo(),
      SubscriptionScreenThree(),
    ];

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => screens[nextIndex]),
    );
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> &&
        args.containsKey("styleReference") &&
        styleReferenceUrl == null) {
      styleReferenceUrl = args["styleReference"] as String?;
      if (styleReferenceUrl != null && styleReferenceUrl!.isNotEmpty) {
        _downloadStyleReference(styleReferenceUrl!);
      }
    }
  }

  Future<void> _downloadStyleReference(String url) async {
    setState(() {
      _isLoadingStyleReference = true;
    });
    try {
      final response = await http.get(Uri.parse(url));
      final directory = await getTemporaryDirectory();
      final file = File("${directory.path}/temp_style_ref.jpg");
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        refImage = file;
        _isLoadingStyleReference = false;
      });
    } catch (e) {
      print("Error downloading style reference: $e");
      setState(() {
        _isLoadingStyleReference = false;
      });
    }
  }

  final CreateStyleTransferBloc _createStyleTransferBloc =
      CreateStyleTransferBloc();
  CreateStyleTransferResponse? createStyleTransferResponse;

  final List<String> _templateColors = [
    '#E8D5C4', // Living room warm
    '#C8D8E8', // Bedroom cool
    '#8FB5A8', // Bathroom green
    '#5C6B4E', // Dark dining
  ];

  // Template placeholder colors (replace with real AssetImage in a real project)
  final List<Color> _templateSwatches = [
    const Color(0xFFE07B54),
    const Color(0xFFB8C8D8),
    const Color(0xFF6B9E8F),
    const Color(0xFF4A5E3A),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      body: BlocConsumer<CreateStyleTransferBloc, CreateStyleTransferState>(
        bloc: _createStyleTransferBloc,
        listener: (context, state) {
          if (state is CreateStyleTransferSuccessState) {
            createStyleTransferResponse = state.login;
            int currentCredits = int.tryParse(creditsNotifier.value) ?? 0;
            final newCredits =
                (currentCredits - 50).clamp(0, 999999).toString();
            creditsNotifier.value = newCredits;
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('credits', newCredits);
            });
            Navigator.of(context).pushNamed(
              StyleOutputScreen.routeName,
              arguments: {
                "image": createStyleTransferResponse?.data?.outputImage ?? "",
                "prompt": "Style transfer design",
                "spaceType": "Style Transfer",
                "color": "Default",
                "designAsth": "Style Transfer",
                "id": createStyleTransferResponse?.data?.id ?? "",
                "module_id": 3,
              },
            );
          } else if (state is CreateStyleTransferFailureState) {
            showSnackError(
              context,
              state.message.isNotEmpty
                  ? state.message
                  : "Please try once again",
            );
          } else if (state is CreateStyleTransferExceptionState) {
            showSnackError(context, "Please try once again");
          }
        },
        builder: (context, state) {
          if (state is CreateStyleTransferLoadingState) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F3EF),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/gifs/loading.gif",
                        height: r.hp(context, 300),
                      ),
                      r.verticalSpace(context, 20),
                      Text(
                        "Bringing your vision to life...",
                        style: TextStyle(
                          fontSize: r.sp(context, 16),
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(90, 106, 117, 1),
                          letterSpacing: -0.3,
                        ),
                      ),
                      r.verticalSpace(context, 40),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.wp(context, 30),
                        ),
                        child: Text(
                          "Keep the app open & don’t lock your device. This may take around 10 seconds.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: r.sp(context, 14),
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(90, 106, 117, 1),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              // ── Status bar spacer + AppBar ──────────────────────────────
              SizedBox(height: topPadding),
              _buildAppBar(),

              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: r.hp(context, 24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: r.hp(context, 22)),
                      _buildSectionTitle('Upload a photo of your room'),
                      SizedBox(height: r.hp(context, 14)),
                      _buildUploadCard(),
                      SizedBox(height: r.hp(context, 20)),
                      _buildOrDivider(),
                      SizedBox(height: r.hp(context, 20)),
                      _buildSectionTitle('Choose from Template'),
                      SizedBox(height: r.hp(context, 14)),
                      _buildTemplateGrid(),
                      SizedBox(height: r.hp(context, 14)),
                      GestureDetector(
                        onTap:
                            () => showMediaSourcePicker(
                              context,
                              onFilePicked:
                                  (file) => setState(() => refImage = file),
                            ),
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(
                            horizontal: r.wp(context, 15),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: r.wp(context, 15),
                            vertical: r.hp(context, 15),
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(
                              r.wp(context, 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _isLoadingStyleReference
                                      ? "Downloading style reference..."
                                      : (refImage != null
                                          ? "Style Reference: ${refImage!.path.split('/').last}"
                                          : "Upload a style reference"),
                                  style: TextStyle(
                                    fontSize: r.sp(context, 16),
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(46, 46, 46, 1),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              if (_isLoadingStyleReference)
                                const CupertinoActivityIndicator()
                              else if (refImage != null)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF3A7D7B),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Next button ─────────────────────────────────────────────
              _buildNextButton(),
              SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom + r.hp(context, 8),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 16),
        r.hp(context, 8),
        r.wp(context, 16),
        0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: r.wp(context, 36),
              height: r.wp(context, 36),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: r.wp(context, 20),
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Style Transfer',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: r.sp(context, 24),
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Coin badge
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CreditsScreen.routeName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.wp(context, 10),
                vertical: r.hp(context, 5),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(r.wp(context, 20)),
                border: Border.all(
                  color: const Color(0xFFE8873A).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: creditsNotifier,
                    builder: (context, credits, _) {
                      return Text(
                        creditsNotifier.value.toString(),
                        style: TextStyle(
                          fontSize:
                              r.isIPad(context)
                                  ? r.sp(context, 50)
                                  : r.sp(context, 16),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: r.wp(context, 4)),
                  CustomImageview(
                    imagePath: "assets/images/credit.png",
                    height: r.wp(context, 25),
                    width: r.wp(context, 25),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinBadge() {
    return Container(
      height: r.hp(context, 34),
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 10)),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A05A),
        borderRadius: BorderRadius.circular(r.wp(context, 20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '200',
            style: TextStyle(
              color: Colors.white,
              fontSize: r.sp(context, 15),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: r.wp(context, 5)),
          Container(
            width: r.wp(context, 20),
            height: r.wp(context, 20),
            decoration: const BoxDecoration(
              color: Color(0xFFD4721A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.diamond_outlined,
              size: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Progress bar
  // ─────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 10),
        vertical: r.hp(context, 6),
      ),
      child: LinearProgressIndicator(
        value: 0.25,
        minHeight: r.hp(context, 3),
        backgroundColor: const Color(0xFFE0DDD8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3A7D7B)),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Section title
  // ─────────────────────────────────────────────
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: r.sp(context, 18),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1C1C1C),
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Upload Card
  // ─────────────────────────────────────────────
  Widget _buildUploadCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.wp(context, 20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                picked != null
                    ? CustomImageview(imagePath: picked!.path)
                    : _selectedTemplate != -1
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(r.wp(context, 20)),
                            ),
                            child: CustomImageview(
                              imagePath:
                                  "assets/images/interior/interior_${_selectedTemplate + 1}.jpg",
                              width: double.infinity,
                              height: r.hp(context, 330),
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(r.wp(context, 20)),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: r.hp(context, 330),
                              color: const Color(0xFFF8F6F2),
                              child: CustomImageview(
                                imagePath: "assets/images/interior/interior_home.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                Positioned(
                  top: r.hp(context, 14),
                  right: r.wp(context, 14),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SnapTipsScreen.routeName);
                    },
                    child: Container(
                      width: r.wp(context, 32),
                      height: r.wp(context, 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD0CEC9),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: r.wp(context, 18),
                        color: const Color(0xFF5A5754),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: r.hp(context, 18)),
              child: GestureDetector(
                onTap:
                    () => showMediaSourcePicker(
                      context,
                      onFilePicked: (file) => setState(() {
                        picked = file;
                        _selectedTemplate = -1;
                      }),
                    ),
                child: Container(
                  height: r.hp(context, 48),
                  padding: EdgeInsets.symmetric(horizontal: r.wp(context, 32)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2E8DA),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: r.wp(context, 20),
                        color: const Color(0xFF5A4A3A),
                      ),
                      SizedBox(width: r.wp(context, 8)),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          fontSize: r.sp(context, 16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A4A3A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMediaSourcePicker(
    BuildContext context, {
    required void Function(File file) onFilePicked,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext ctx) => _MediaSourceSheet(onFilePicked: onFilePicked),
    );
  }

  /// A simple painter that mimics the isometric room illustration.
  Widget _buildIsometricRoomPlaceholder() {
    return CustomPaint(
      painter: _IsometricRoomPainter(),
      child: const SizedBox.expand(),
    );
  }

  // ─────────────────────────────────────────────
  // OR Divider
  // ─────────────────────────────────────────────
  Widget _buildOrDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: r.hp(context, 1),
              color: const Color(0xFFD8D4CE),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.wp(context, 14)),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: r.sp(context, 12),
                fontWeight: FontWeight.w600,
                color: const Color(0xFFAEA9A3),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: r.hp(context, 1),
              color: const Color(0xFFD8D4CE),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGrid() {
    // Template data: label + accent color pairs
    final templates = [
      _TemplateData(
        'Living Room',
        const Color(0xFFE07B54),
        const Color(0xFFF5E8DF),
      ),
      _TemplateData(
        'Bedroom',
        const Color(0xFF7A9DBF),
        const Color(0xFFE0EAF4),
      ),
      _TemplateData(
        'Bathroom',
        const Color(0xFF6B9E8F),
        const Color(0xFFD5EAE5),
      ),
      _TemplateData('Dining', const Color(0xFF5C7A5A), const Color(0xFFD5E5D3)),
    ];

    return SizedBox(
      height: r.hp(context, 128),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
        itemCount: 8,
        separatorBuilder: (_, __) => SizedBox(width: r.wp(context, 12)),
        itemBuilder: (context, i) {
          final selected = _selectedTemplate == i;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedTemplate = i;
              picked = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: r.wp(context, 108),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r.wp(context, 16)),
                border: Border.all(
                  color:
                      selected ? const Color(0xFF3A7D7B) : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(selected ? 0.12 : 0.06),
                    blurRadius: selected ? 14 : 8,
                    offset: Offset(0, r.hp(context, 4)),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r.wp(context, 14)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background mimicking photo
                    CustomImageview(
                      imagePath: "assets/images/interior/interior_${i + 1}.jpg",
                    ),
                    if (selected)
                      Positioned(
                        top: r.hp(context, 8),
                        right: r.wp(context, 8),
                        child: Container(
                          width: r.wp(context, 22),
                          height: r.wp(context, 22),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A7D7B),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: r.wp(context, 14),
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _roomIcon(int i) {
    switch (i) {
      case 0:
        return Icons.weekend_outlined;
      case 1:
        return Icons.bed_outlined;
      case 2:
        return Icons.bathtub_outlined;
      case 3:
        return Icons.dinner_dining_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  String _getSpaceType(int index) {
    switch (index) {
      case 0:
        return 'Living Room';
      case 1:
        return 'Bedroom';
      case 2:
        return 'Bathroom';
      case 3:
        return 'Dining';
      case 4:
        return 'Kitchen';
      case 5:
        return 'Office';
      case 6:
        return 'Playroom';
      default:
        return 'Living Room';
    }
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(context, 20)),
      child: GestureDetector(
        onTap: () async {
          if (isSubscribed == true) {
            File? roomFile = picked;
            if (roomFile == null && _selectedTemplate >= 0) {
              final assetPath =
                  "assets/images/interior/interior_${_selectedTemplate + 1}.jpg";
              try {
                final byteData = await rootBundle.load(assetPath);
                final directory = await getTemporaryDirectory();
                final file = File("${directory.path}/temp_template_room.jpg");
                await file.writeAsBytes(
                  byteData.buffer.asUint8List(
                    byteData.offsetInBytes,
                    byteData.lengthInBytes,
                  ),
                );
                roomFile = file;
              } catch (e) {
                showSnackError(context, "Error loading template image: $e");
                return;
              }
            }

            if (roomFile == null) {
              showSnackError(
                context,
                "Please upload a photo of your room or choose a template",
              );
              return;
            }
            if (refImage == null) {
              showSnackError(context, "Please upload a style reference");
              return;
            }
            final prefs = await SharedPreferences.getInstance();
            final userId = prefs.getString('user_id') ?? '0';

            final selectedIdx = _selectedTemplate >= 0 ? _selectedTemplate : 0;
            final colorVal =
                _templateColors[selectedIdx % _templateColors.length];
            final spaceTypeVal = _getSpaceType(selectedIdx);

            _createStyleTransferBloc.add(
              CreateStyleTransferDataEvent(
                login: {
                  "user_id": userId,
                  "colors": colorVal,
                  "design_asthetic": "Modern",
                  "space_type": spaceTypeVal,
                },
                image: roomFile,
                refImage: refImage!,
              ),
            );
          } else {
            openSubscriptionScreen(context);
          }
        },
        child: Container(
          width: double.infinity,
          height: r.hp(context, 58),
          decoration: BoxDecoration(
            color: const Color(0xFFE8C9A0),
            borderRadius: BorderRadius.circular(r.wp(context, 32)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8C9A0).withOpacity(0.5),
                blurRadius: 16,
                offset: Offset(0, r.hp(context, 6)),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: r.sp(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A3E1B),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _MediaSourceSheet extends StatelessWidget {
  const _MediaSourceSheet({required this.onFilePicked});

  final void Function(File file) onFilePicked;

  Future<void> _takePhoto(BuildContext context) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) onFilePicked(File(photo.path));
  }

  Future<void> _chooseFromPhotos(BuildContext context) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) onFilePicked(File(image.path));
  }

  Future<void> _browseFiles(BuildContext context) async {
    Navigator.of(context).pop();
    final result = await FilePicker.pickFiles();
    if (result != null && result.files.single.path != null) {
      onFilePicked(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Action sheet ──────────────────────────────────────────────────
        CupertinoActionSheet(
          title: const Text(
            'Choose a Media Source',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          actions: [
            // Take Photo
            CupertinoActionSheetAction(
              onPressed: () => _takePhoto(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.camera, size: 22),
                  SizedBox(width: 10),
                  Text('Take Photo', style: TextStyle(fontSize: 17)),
                ],
              ),
            ),

            // Choose From Photos
            CupertinoActionSheetAction(
              onPressed: () => _chooseFromPhotos(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Multicolor Photos-app icon approximation
                  ShaderMask(
                    shaderCallback:
                        (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFF2D55),
                            Color(0xFFFF9500),
                            Color(0xFFFFCC00),
                            Color(0xFF34C759),
                            Color(0xFF007AFF),
                            Color(0xFF5856D6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                    child: const Icon(
                      CupertinoIcons.photo,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Choose From Photos',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),

            // Browse Files
            CupertinoActionSheetAction(
              onPressed: () => _browseFiles(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    CupertinoIcons.folder,
                    size: 22,
                    color: Color(0xFF007AFF),
                  ),
                  SizedBox(width: 10),
                  Text('Browse Files', style: TextStyle(fontSize: 17)),
                ],
              ),
            ),
          ],

          // Cancel button
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _TemplateData {
  final String label;
  final Color accentColor;
  final Color lightColor;

  const _TemplateData(this.label, this.accentColor, this.lightColor);
}

// ─────────────────────────────────────────────────────────────────────────────
// Isometric room custom painter
// Draws a simplified top-down isometric living room to match the screenshot.
// ─────────────────────────────────────────────────────────────────────────────
class _IsometricRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    // ── Floor ──────────────────────────────────────────────────────────
    final floorPath =
        Path()
          ..moveTo(cx, cy - 80)
          ..lineTo(cx + 140, cy - 10)
          ..lineTo(cx, cy + 70)
          ..lineTo(cx - 140, cy - 10)
          ..close();
    canvas.drawPath(floorPath, Paint()..color = const Color(0xFFD4B896));

    // Floor planks (subtle lines)
    final plankPaint =
        Paint()
          ..color = const Color(0xFFC4A882)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
    for (int i = -3; i <= 3; i++) {
      canvas.drawLine(
        Offset(cx + i * 35 - 10, cy - 70 + i * 5),
        Offset(cx + i * 35 + 50, cy + 60 + i * 5),
        plankPaint,
      );
    }

    // ── Left wall ─────────────────────────────────────────────────────
    final leftWall =
        Path()
          ..moveTo(cx - 140, cy - 10)
          ..lineTo(cx, cy - 80)
          ..lineTo(cx, cy - 160)
          ..lineTo(cx - 140, cy - 90)
          ..close();
    canvas.drawPath(leftWall, Paint()..color = const Color(0xFFDDD5C8));

    // ── Right wall ────────────────────────────────────────────────────
    final rightWall =
        Path()
          ..moveTo(cx, cy - 80)
          ..lineTo(cx + 140, cy - 10)
          ..lineTo(cx + 140, cy - 90)
          ..lineTo(cx, cy - 160)
          ..close();
    canvas.drawPath(rightWall, Paint()..color = const Color(0xFFC8BFB0));

    // ── Dark slat panel on left wall ──────────────────────────────────
    final slatPath =
        Path()
          ..moveTo(cx - 140, cy - 90)
          ..lineTo(cx - 88, cy - 118)
          ..lineTo(cx - 88, cy - 26)
          ..lineTo(cx - 140, cy - 10)
          ..close();
    canvas.drawPath(slatPath, Paint()..color = const Color(0xFF3A2E24));

    // ── Rug ───────────────────────────────────────────────────────────
    final rugPath =
        Path()
          ..moveTo(cx, cy - 20)
          ..lineTo(cx + 80, cy + 20)
          ..lineTo(cx, cy + 55)
          ..lineTo(cx - 80, cy + 20)
          ..close();
    canvas.drawPath(rugPath, Paint()..color = const Color(0xFFE8DFD0));

    // ── L-shaped sofa ─────────────────────────────────────────────────
    // Main sofa body
    final sofaBody =
        Path()
          ..moveTo(cx - 72, cy - 30)
          ..lineTo(cx + 30, cy + 28)
          ..lineTo(cx + 20, cy + 50)
          ..lineTo(cx - 82, cy - 8)
          ..close();
    canvas.drawPath(sofaBody, Paint()..color = const Color(0xFFEFEAE2));

    // Sofa back
    final sofaBack =
        Path()
          ..moveTo(cx - 82, cy - 8)
          ..lineTo(cx - 72, cy - 30)
          ..lineTo(cx - 64, cy - 56)
          ..lineTo(cx - 74, cy - 34)
          ..close();
    canvas.drawPath(sofaBack, Paint()..color = const Color(0xFFE0D8CC));

    // Cushions (yellow)
    final cushionPaint = Paint()..color = const Color(0xFFD4A830);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 20, cy - 8), width: 28, height: 18),
      cushionPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 5, cy + 8), width: 26, height: 16),
      cushionPaint,
    );

    // ── Coffee table ──────────────────────────────────────────────────
    final tablePaint =
        Paint()
          ..color = const Color(0xFF8EAAA0)
          ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 20, cy + 22), width: 46, height: 28),
      tablePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 20, cy + 22), width: 38, height: 22),
      Paint()..color = const Color(0xFFA8C4BC),
    );

    // ── Small sofa (front) ────────────────────────────────────────────
    final sofaFront =
        Path()
          ..moveTo(cx - 30, cy + 52)
          ..lineTo(cx + 60, cy + 10)
          ..lineTo(cx + 68, cy + 28)
          ..lineTo(cx - 22, cy + 70)
          ..close();
    canvas.drawPath(sofaFront, Paint()..color = const Color(0xFFEFEAE2));

    // ── TV / dark console ─────────────────────────────────────────────
    final consolePath =
        Path()
          ..moveTo(cx + 80, cy - 8)
          ..lineTo(cx + 135, cy + 24)
          ..lineTo(cx + 128, cy + 36)
          ..lineTo(cx + 73, cy + 4)
          ..close();
    canvas.drawPath(consolePath, Paint()..color = const Color(0xFF2E2822));

    // ── Wall art frames ───────────────────────────────────────────────
    final framePaint = Paint()..color = const Color(0xFF2E2822);
    // Frame 1
    canvas.drawRect(Rect.fromLTWH(cx - 60, cy - 148, 28, 36), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 58, cy - 146, 24, 32),
      Paint()..color = const Color(0xFF4A7A40),
    );
    // Frame 2
    canvas.drawRect(Rect.fromLTWH(cx - 26, cy - 152, 28, 38), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx - 24, cy - 150, 24, 34),
      Paint()..color = const Color(0xFF3D6A34),
    );
    // Frame 3
    canvas.drawRect(Rect.fromLTWH(cx + 8, cy - 148, 26, 36), framePaint);
    canvas.drawRect(
      Rect.fromLTWH(cx + 10, cy - 146, 22, 32),
      Paint()..color = const Color(0xFF4E8040),
    );

    // ── Right-wall curtain ────────────────────────────────────────────
    final curtainPaint = Paint()..color = const Color(0xFFB8C4B0);
    for (int i = 0; i < 4; i++) {
      final x = cx + 60.0 + i * 16;
      canvas.drawRect(Rect.fromLTWH(x, cy - 88, 12, 70), curtainPaint);
    }

    // ── Plant ─────────────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(cx + 118, cy - 20, 14, 20),
      Paint()..color = const Color(0xFF5A3E24),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 125, cy - 28), width: 24, height: 28),
      Paint()..color = const Color(0xFF5A8050),
    );

    // ── Wall lamp ─────────────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 86, cy - 80), width: 16, height: 16),
      Paint()..color = const Color(0xFFE8D090),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
