import 'dart:io';

import 'package:ai_interior/bloc/delete_record/delete_record_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/features/style_transfer/presentation/style_transfer_screeen.dart';
import 'package:ai_interior/bloc/image_enhance/image_enhance_bloc.dart';
import 'package:ai_interior/bloc/publish_record/publish_record_bloc.dart';
import 'package:ai_interior/models/image_enhance_response.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:ai_interior/widgets/custom_snackbar.dart';
import 'package:ai_interior/l10n/generated/app_localizations.dart';



import '../../../bloc/get_enhancment_response_api/get_enhancment_response_api_bloc.dart';
import '../../../models/image_enhance_model_response.dart';

class InteriorOutputScreen extends StatefulWidget {
  const InteriorOutputScreen({super.key});

  static const routeName = "/int-output-screen";

  @override
  State<InteriorOutputScreen> createState() => _InteriorOutputScreenState();
}

class _InteriorOutputScreenState extends State<InteriorOutputScreen> {
  final ImageEnhanceBloc _imageEnhanceBloc = ImageEnhanceBloc();
  final PublishRecordBloc _publishRecordBloc = PublishRecordBloc();
  final DeleteRecordBloc _deleteRecordBloc = DeleteRecordBloc();
  final GerEnhancmentResponseBloc _gerEnhancmentResponseBloc =
      GerEnhancmentResponseBloc();
  ImageEnhanceResponse? imageEnhanceResponse;
  ImageEnhanceModelResponse? imageEnhanceModelResponse;
  Map<String, dynamic> data = {};
  String _userId = '';
  bool _isEnhancing = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id') ?? '';
    });
  }

  int _moduleId = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {};
    _moduleId = int.tryParse(data["module_id"]?.toString() ?? "") ?? 1;
    print("IMAGE : ${data["image"]} | MODULE_ID : $_moduleId");
  }

  Future<void> saveNetworkImageToGallery({
    required BuildContext context,
    required String imageUrl,
  }) async {
    try {
      if (imageUrl.isEmpty) return;

      if (Platform.isAndroid) {
        final storagePermission = await Permission.storage.status;
        if (storagePermission.isDenied) {
          await Permission.storage.request();
        }
      }

      if (!context.mounted) return;

      CustomSnackBar.info(context, 'Saving image to gallery...', duration: const Duration(seconds: 1));

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      Uint8List bytes = response.bodyBytes;
      await Gal.putImageBytes(Uint8List.fromList(bytes));

      if (context.mounted) {
        CustomSnackBar.success(context, 'Image saved to gallery!');
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.error(context, 'Error saving image: $e');
      }
    }
  }


  Future<void> shareNetworkImage({

    required BuildContext context,
    required String imageUrl,
  }) async {
    // 1. Download image
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    Uint8List bytes = response.bodyBytes;

    // 2. Save to temp directory
    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);

    // 3. Get widget position (IMPORTANT for iOS)
    final RenderBox box = context.findRenderObject() as RenderBox;

    // 4. Share
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Check out this image',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: BlocConsumer<PublishRecordBloc, PublishRecordState>(
        bloc: _publishRecordBloc,
        listener: (context, publishState) {
          if (publishState is PublishRecordSuccessState) {
            CustomSnackBar.success(context, 'Design published successfully!');
          } else if (publishState is PublishRecordFailureState ||
              publishState is PublishRecordExceptionState) {
            CustomSnackBar.error(context, 'Publish failed. Please try again.');
          }
        },
        builder: (context, publishState) {
          return BlocConsumer<DeleteRecordBloc, DeleteRecordState>(
            bloc: _deleteRecordBloc,
            listener: (context, deleteState) {
              if (deleteState is DeleteRecordSuccessState) {
                CustomSnackBar.success(context, 'Design deleted successfully!');
                Navigator.of(context).pop();
              } else if (deleteState is DeleteRecordExceptionState ||
                  deleteState is DeleteRecordFailureState) {
                CustomSnackBar.error(context, 'Delete failed. Please try again.');
              }
            },
            builder: (context, deleteState) {
              return BlocConsumer<ImageEnhanceBloc, ImageEnhanceState>(
                bloc: _imageEnhanceBloc,
                listener: (context, enhanceState) {
                  if (enhanceState is ImageEnhanceSuccessState) {
                    imageEnhanceResponse = enhanceState.login;
                    final taskId = imageEnhanceResponse?.data?.id;

                    if (taskId != null && taskId.isNotEmpty) {
                      Future.delayed(const Duration(seconds: 3), () {
                        if (!mounted) return;
                        _gerEnhancmentResponseBloc.add(
                          GerEnhancmentResponseDataEvent(
                            data: {
                              "user_id": int.tryParse(_userId) ?? 0,
                              "module_id": _moduleId,
                              "id": int.tryParse(data["id"]?.toString() ?? "") ?? 0,
                              "task_id": taskId,
                            },
                          ),
                        );
                      });
                    } else {
                      if (mounted) {
                        setState(() {
                          _isEnhancing = false;
                        });
                      }
                      CustomSnackBar.error(context, 'Failed to obtain valid task ID for enhancement.');
                    }
                  } else if (enhanceState is ImageEnhanceFailureState) {
                    if (mounted) {
                      setState(() {
                        _isEnhancing = false;
                      });
                    }
                    CustomSnackBar.error(context, enhanceState.message.isNotEmpty ? enhanceState.message : 'Image enhancement failed.');
                  } else if (enhanceState is ImageEnhanceExceptionState) {
                    if (mounted) {
                      setState(() {
                        _isEnhancing = false;
                      });
                    }
                    CustomSnackBar.error(context, enhanceState.message.isNotEmpty ? enhanceState.message : 'An error occurred during image enhancement.');
                  }
                },
                builder: (context, enhanceState) {
                  return BlocConsumer<
                    GerEnhancmentResponseBloc,
                    GerEnhancmentResponseState
                  >(
                    bloc: _gerEnhancmentResponseBloc,
                    listener: (context, getResponseState) {
                      if (getResponseState is GerEnhancmentResponseSuccessState) {
                        if (mounted) {
                          setState(() {
                            _isEnhancing = false;
                          });
                        }
                        imageEnhanceModelResponse = getResponseState.exploreSongResponse;
                      } else if (getResponseState is GerEnhancmentResponseFailureState ||
                          getResponseState is GerEnhancmentResponseExceptionState) {
                        if (mounted) {
                          setState(() {
                            _isEnhancing = false;
                          });
                        }
                      }
                    },
                    builder: (context, getResponseState) {
                      final bool isEnhancing = _isEnhancing ||
                          enhanceState is ImageEnhanceLoadingState ||
                          getResponseState is GerEnhancmentResponseLoadingState;

                      final currentImageUrl = (imageEnhanceModelResponse?.imageUrl?.outputImage?.isNotEmpty == true
                          ? imageEnhanceModelResponse!.imageUrl!.outputImage
                          : data["image"]) ?? "";

                      return Scaffold(
                        backgroundColor: const Color(0xFFF2EFEA),
                        body:
                            (publishState is PublishRecordLoadingState || deleteState is DeleteRecordLoadingState)
                                ? Center(child: CupertinoActivityIndicator())
                                : Column(
                                  children: [
                                    _PhotoSection(
                                      isEnhancing: isEnhancing,
                                      onTap: () {
                                        if (isEnhancing) return;
                                        setState(() {
                                          _isEnhancing = true;
                                        });
                                        _imageEnhanceBloc.add(
                                          ImageEnhanceDataEvent(
                                            login: {
                                              "user_id": int.tryParse(_userId) ?? 0,
                                              "module_id": _moduleId,
                                              "id": int.tryParse(data["id"]?.toString() ?? "") ?? 0,
                                            },
                                          ),
                                        );
                                      },
                                      topPad: topPad,
                                      img: currentImageUrl,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.fromLTRB(
                                          r.wp(context, 16),
                                          r.hp(context, 16),
                                          r.wp(context, 16),
                                          0,
                                        ),
                                        child: Column(
                                          children: [
                                            _InfoTile(
                                              iconWidget: Icon(
                                                Icons.home_outlined,
                                                size: r.wp(context, 24),
                                                color: const Color(0xFF7A7A7A),
                                              ),
                                              label: AppLocalizations.of(context)?.buildingType ?? 'Building Type',
                                              value:
                                                  data["roomType"]
                                                      .toString()
                                                      .toTitleCase(),
                                              trailing: null,
                                            ),
                                            r.verticalSpace(context, 10),
                                            _InfoTile(
                                              iconWidget: Icon(
                                                Icons.style_outlined,
                                                size: r.wp(context, 24),
                                                color: const Color(0xFF7A7A7A),
                                              ),
                                              label: AppLocalizations.of(context)?.designAesthetic ?? 'Design Aesthetic',
                                              value:
                                                  data["designAsth"]
                                                      .toString()
                                                      .toTitleCase(),
                                              trailing: null,
                                            ),
                                            r.verticalSpace(context, 10),
                                            _InfoTile(
                                              iconWidget: Icon(
                                                Icons.palette_outlined,
                                                size: r.wp(context, 24),
                                                color: const Color(0xFF7A7A7A),
                                              ),
                                              label: AppLocalizations.of(context)?.colorPalette ?? 'Color Palette',
                                              value:
                                                  data["color"]
                                                      .toString()
                                                      .toTitleCase(),
                                              trailing: const _ColorSwatches(),
                                            ),
                                            r.verticalSpace(context, 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        bottomNavigationBar: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildOutputAction(
                                  context,
                                  icon: Icons.refresh_rounded,
                                  label: AppLocalizations.of(context)?.regenerate ?? "Regenerate",
                                  onTap: () => _showRegenerateAlert(context),
                                ),
                                _buildOutputAction(
                                  context,
                                  icon: Icons.download_rounded,
                                  label: AppLocalizations.of(context)?.save ?? "Save",
                                  onTap: () => saveNetworkImageToGallery(
                                    context: context,
                                    imageUrl: currentImageUrl,
                                  ),
                                ),

                                _buildOutputAction(
                                  context,
                                  icon: Icons.more_horiz_rounded,
                                  label: AppLocalizations.of(context)?.publish ?? "Publish",
                                  onTap: () => showPublishSheet(context),
                                ),
                                _buildOutputAction(
                                  context,
                                  icon: Icons.share_outlined,
                                  label: AppLocalizations.of(context)?.share ?? "Share",
                                  onTap: () => shareNetworkImage(
                                    context: context,
                                    imageUrl: currentImageUrl,
                                  ),
                                ),
                                _buildOutputAction(
                                  context,
                                  icon: Icons.delete_outline_rounded,
                                  label: AppLocalizations.of(context)?.delete ?? "Delete",
                                  onTap: () => _showDeleteAlert(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    ));
  }

  void showPublishSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => publishBottomSheet(context),
    );
  }

  void _showDeleteAlert(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(l10n?.deleteDesignTitle ?? 'Delete This Design?'),
            content: Text(
              l10n?.deleteDesignContent ??
                  'This action cannot be undone. Are you sure you want to permanently remove this design?',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n?.cancel ?? 'Cancel'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  Navigator.of(context).pop();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String userId = preferences.getString('user_id') ?? "";

                  final deleteData = {
                    "user_id": userId,
                    "module_id": _moduleId,
                    "id": int.tryParse(data["id"]?.toString() ?? "") ?? data["id"],
                  };

                  debugPrint("Delete Record DataEvent payload: $deleteData");

                  _deleteRecordBloc.add(
                    DeleteRecordDataEvent(login: deleteData),
                  );

                },
                child: Text(l10n?.delete ?? 'Delete'),
              ),
            ],
          ),
    );
  }

  void _showRegenerateAlert(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(l10n?.regenerateDesignTitle ?? 'Regenerate Design?'),
            content: Text(
              l10n?.regenerateDesignContent ??
                  'This action will use 50 credits to generate a new design. Do you want to proceed?',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n?.cancel ?? 'Cancel'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(l10n?.regenerate ?? 'Regenerate'),
              ),
            ],
          ),
    );
  }

  Widget publishBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 24),
        r.hp(context, 12),
        r.wp(context, 24),
        r.hp(context, 36),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(r.wp(context, 24))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: r.wp(context, 40),
            height: r.hp(context, 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(r.wp(context, 3)),
            ),
          ),
          r.verticalSpace(context, 24),

          // Avatar circle
          Container(
            width: r.wp(context, 72),
            height: r.wp(context, 72),
            decoration: const BoxDecoration(
              color: Color(0xFFE8D5BC),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.group, size: r.wp(context, 36), color: const Color(0xFF3D3229)),
          ),
          r.verticalSpace(context, 16),

          // Title
          Text(
            AppLocalizations.of(context)?.publishDesignTitle ?? 'Publish Your Design',
            style: TextStyle(
              fontSize: r.sp(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          r.verticalSpace(context, 10),

          // Subtitle
          Text(
            AppLocalizations.of(context)?.publishDesignSubtitle ??
                'Share your design on the Explore page for\nothers to discover',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.sp(context, 15),
              color: const Color(0xFF8A8A8A),
              height: 1.5,
            ),
          ),
          r.verticalSpace(context, 28),

          // Publish button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                String userId = preferences.getString('user_id') ?? "";

                final publishData = {
                  "user_id": userId,
                  "module_id": _moduleId,
                  "id": data["id"],
                };

                debugPrint("PublishRecordDataEvent payload: $publishData");

                _publishRecordBloc.add(
                  PublishRecordDataEvent(login: publishData),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C756B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: r.hp(context, 16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.wp(context, 14)),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)?.publish ?? 'Publish',
                style: TextStyle(
                  fontSize: r.sp(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          r.verticalSpace(context, 4),

          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1A1A1A),
              padding: EdgeInsets.symmetric(vertical: r.hp(context, 14)),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: r.sp(context, 16), fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final buttonSize = r.adaptiveValue(context, mobile: 44.0, tablet: 56.0);
    final iconSize = r.adaptiveValue(context, mobile: 22.0, tablet: 28.0);
    final fontSize = r.sp(context, 11);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GlassIconButton(
          icon: Icon(icon, color: const Color(0xFF1A1A1A)),
          onPressed: onTap,
          size: buttonSize,
          iconSize: iconSize,
          useOwnLayer: true,
        ),
        r.verticalSpace(context, 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(46, 46, 46, 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final VoidCallback onTap;
  final double topPad;
  final String img;
  final bool isEnhancing;

  const _PhotoSection({
    required this.onTap,
    required this.topPad,
    required this.img,
    this.isEnhancing = false,
  });

  Widget buildSmartImage(String img) {
    if (img.isEmpty) return _errorContainer();
    return CustomImageview(
      imagePath: img,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _errorContainer() {
    return Container(
      color: const Color(0xFF8AAAC8),
      child: const Center(
        child: Icon(
          Icons.location_city_outlined,
          size: 60,
          color: Colors.white54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: r.hp(context, 350),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          buildSmartImage(img),
          if (isEnhancing)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(
                      radius: 16,
                      color: Colors.white,
                    ),
                    SizedBox(height: r.hp(context, 10)),
                    Text(
                      AppLocalizations.of(context)?.enhancingQuality ?? "Enhancing Quality...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: r.sp(context, 14),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: r.hp(context, 15),
            child: Center(
              child: GestureDetector(
                onTap: isEnhancing ? null : onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: r.wp(context, isEnhancing ? 14 : 10),
                    vertical: r.hp(context, 5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(r.wp(context, 50)),
                    gradient: LinearGradient(
                      colors: isEnhancing
                          ? [
                              const Color.fromRGBO(200, 180, 150, 0.9),
                              const Color.fromRGBO(145, 170, 162, 0.9),
                            ]
                          : [
                              const Color.fromRGBO(230, 203, 168, 1),
                              const Color.fromRGBO(167, 196, 188, 1),
                            ],
                    ),
                  ),
                  child: isEnhancing
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CupertinoActivityIndicator(
                              radius: 8,
                              color: Color.fromRGBO(46, 46, 46, 1),
                            ),
                            SizedBox(width: r.wp(context, 6)),
                            Text(
                              AppLocalizations.of(context)?.enhancing ?? "Enhancing...",
                              style: TextStyle(
                                fontSize: r.sp(context, 15),
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.enhance ?? "Enhance",
                              style: TextStyle(
                                fontSize: r.sp(context, 16),
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                            SizedBox(width: r.wp(context, 3)),
                            CustomImageview(
                              imagePath: "assets/images/credit.png",
                              height: r.wp(context, 25),
                              width: r.wp(context, 25),
                            ),
                            SizedBox(width: r.wp(context, 3)),
                            Text(
                              "1",
                              style: TextStyle(
                                fontSize: r.sp(context, 16),
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(46, 46, 46, 1),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + r.hp(context, 64),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: topPad + r.hp(context, 10),
            left: r.wp(context, 16),
            child: GestureDetector(
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Icon(
                Icons.chevron_left_rounded,
                size: r.wp(context, 32),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoTile({
    required this.iconWidget,
    required this.label,
    required this.value,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 16),
        vertical: r.hp(context, 14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.wp(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: r.wp(context, 44),
            height: r.wp(context, 44),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          SizedBox(width: r.wp(context, 14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: r.sp(context, 12.5),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7A7A7A),
                    height: 1.2,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: r.hp(context, 4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: r.sp(context, 15.5),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                    letterSpacing: -0.1,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Optional trailing widget
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Color swatches — overlapping circles for the palette
// ─────────────────────────────────────────────────────────────────────────────
class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  static const _colors = [
    Color(0xFFD8D0C8), // light warm grey
    Color(0xFF8A8880), // mid grey
    Color(0xFF3A3A3A), // dark charcoal
    Color(0xFF6A8EAA), // muted blue
  ];

  @override
  Widget build(BuildContext context) {
    final double size = r.adaptiveValue(context, mobile: 28, tablet: 36);
    final double overlap = r.adaptiveValue(context, mobile: 10, tablet: 12);

    return SizedBox(
      width: size + (_colors.length - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < _colors.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: _colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: r.wp(context, 2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: r.wp(context, 3),
                      offset: Offset(0, r.hp(context, 1)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Building icon — custom painter for the house/city sketch icon
// ─────────────────────────────────────────────────────────────────────────────
class _BuildingIcon extends StatelessWidget {
  const _BuildingIcon();

  @override
  Widget build(BuildContext context) {
    final double size = r.adaptiveValue(context, mobile: 30, tablet: 40);
    return CustomPaint(
      size: Size(size, size),
      painter: _BuildingIconPainter(),
    );
  }
}

class _BuildingIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint =
        Paint()
          ..color = const Color(0xFF5A6068)
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

    // ── Small house (left) ─────────────────────────────────────────────
    // House body
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.44, w * 0.32, h * 0.46),
      paint,
    );
    // Roof
    final roofPath =
        Path()
          ..moveTo(w * 0.01, h * 0.44)
          ..lineTo(w * 0.20, h * 0.20)
          ..lineTo(w * 0.39, h * 0.44);
    canvas.drawPath(roofPath, paint);
    // Door
    canvas.drawRect(
      Rect.fromLTWH(w * 0.13, h * 0.66, w * 0.12, h * 0.24),
      paint,
    );
    // Window
    canvas.drawRect(
      Rect.fromLTWH(w * 0.06, h * 0.52, w * 0.09, h * 0.09),
      paint,
    );

    // ── Tall tower / building (right) ──────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(w * 0.50, h * 0.10, w * 0.22, h * 0.80),
      paint,
    );
    // Tower windows (3 rows)
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 2; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            w * 0.53 + col * w * 0.10,
            h * 0.16 + row * h * 0.20,
            w * 0.07,
            h * 0.10,
          ),
          paint,
        );
      }
    }

    // ── Small building (far right) ─────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(w * 0.76, h * 0.34, w * 0.20, h * 0.56),
      paint,
    );
    // Windows
    for (int row = 0; row < 2; row++) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.79, h * 0.40 + row * h * 0.18, w * 0.06, h * 0.08),
        paint,
      );
    }

    // ── Ground line ────────────────────────────────────────────────────
    canvas.drawLine(Offset(0, h * 0.90), Offset(w, h * 0.90), paint);

    // ── Trees / bushes (between buildings) ────────────────────────────
    canvas.drawCircle(
      Offset(w * 0.44, h * 0.78),
      w * 0.06,
      Paint()
        ..color = const Color(0xFF7A8870)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(Offset(w * 0.44, h * 0.78), w * 0.06, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Apply Style button
// ─────────────────────────────────────────────────────────────────────────────
class _ApplyButton extends StatefulWidget {
  final double botPad;
  final String imgUrl;

  const _ApplyButton({required this.botPad, required this.imgUrl});

  @override
  State<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<_ApplyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.wp(context, 20),
        r.hp(context, 8),
        r.wp(context, 20),
        widget.botPad > 0 ? widget.botPad : r.hp(context, 24),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          Navigator.of(context).pushNamed(
            StyleTransferScreen.routeName,
            arguments: {"styleReference": widget.imgUrl},
          );
        },
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            width: double.infinity,
            height: r.hp(context, 60),
            decoration: BoxDecoration(
              color: const Color(0xFFDEB887),
              borderRadius: BorderRadius.circular(r.wp(context, 34)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDEB887).withOpacity(0.40),
                  blurRadius: r.wp(context, 18),
                  offset: Offset(0, r.hp(context, 7)),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Apply Style',
              style: TextStyle(
                fontSize: r.sp(context, 19),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A3218),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
