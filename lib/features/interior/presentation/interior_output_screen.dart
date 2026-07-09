import 'dart:io';

import 'package:ai_interior/bloc/delete_record/delete_record_bloc.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/features/style_transfer/presentation/style_transfer_screeen.dart';
import 'package:ai_interior/bloc/get_all_designs/get_all_designs_bloc.dart';
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print("IMAGE : ${data["image"]}");
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
    final botPad = mq.padding.bottom;

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
        listener: (context, state) {
          if (state is PublishRecordSuccessState) {
          } else if (state is PublishRecordFailureState ||
              state is PublishRecordExceptionState) {}
        },
        builder: (context, state) {
          return BlocConsumer<DeleteRecordBloc, DeleteRecordState>(
            bloc: _deleteRecordBloc,
            listener: (context, state) {
              if (state is DeleteRecordSuccessState) {
              } else if (state is DeleteRecordExceptionState ||
                  state is DeleteRecordFailureState) {}
            },
            builder: (context, state) {
              return BlocConsumer<ImageEnhanceBloc, ImageEnhanceState>(
                bloc: _imageEnhanceBloc,
                listener: (context, state) {
                  if (state is ImageEnhanceSuccessState) {
                    imageEnhanceResponse = state.login;

                    Future.delayed(const Duration(seconds: 3), () {
                      _gerEnhancmentResponseBloc.add(
                        GerEnhancmentResponseDataEvent(
                          data: {
                            "user_id": int.tryParse(_userId) ?? 0,
                            "module_id": 1,
                            "id": int.tryParse(data["id"]?.toString() ?? "") ?? 0,
                            "task_id": imageEnhanceResponse?.data?.id ?? "",
                          },
                        ),
                      );
                    });

                  } else if (state is ImageEnhanceExceptionState ||
                      state is ImageEnhanceFailureState) {}
                },
                builder: (context, state) {
                  return BlocConsumer<
                    GerEnhancmentResponseBloc,
                    GerEnhancmentResponseState
                  >(
                    bloc: _gerEnhancmentResponseBloc,
                    listener: (context, state) {
                      if (state is GerEnhancmentResponseSuccessState) {
                        imageEnhanceModelResponse = state.exploreSongResponse;
                      }
                    },
                    builder: (context, state) {
                      final currentImageUrl = (imageEnhanceModelResponse?.imageUrl?.outputImage?.isNotEmpty == true
                          ? imageEnhanceModelResponse!.imageUrl!.outputImage
                          : data["image"]) ?? "";

                      return Scaffold(
                        backgroundColor: const Color(0xFFF2EFEA),
                        body:
                            state is PublishRecordLoadingState
                                ? Center(child: CupertinoActivityIndicator())
                                : Column(
                                  children: [
                                    _PhotoSection(
                                      onTap: () {
                                        _imageEnhanceBloc.add(
                                          ImageEnhanceDataEvent(
                                            login: {
                                              "user_id": int.tryParse(_userId) ?? 0,
                                              "module_id": 1,
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
                                              iconWidget: const _BuildingIcon(),
                                              label: 'Building Type',
                                              value:
                                                  data["spaceType"]
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
                                              label: 'Design Aesthetic',
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
                                              label: 'Color Palette',
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
                        bottomNavigationBar: Container(
                          height: r.adaptiveValue(context, mobile: r.hp(context, 100), tablet: r.hp(context, 120)),
                          padding: EdgeInsets.only(bottom: botPad > 0 ? botPad : r.hp(context, 8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOutputAction(
                                context,
                                imagePath: "assets/images/output_1.png",
                                label: "Regenerate",
                                onTap: () => _showRegenerateAlert(context),
                              ),
                              _buildOutputAction(
                                context,
                                imagePath: "assets/images/output_2.png",
                                label: "Save",
                                onTap: () => shareNetworkImage(
                                  context: context,
                                  imageUrl: currentImageUrl,
                                ),
                              ),
                              _buildOutputAction(
                                context,
                                imagePath: "assets/images/output_3.png",
                                label: "Publish",
                                onTap: () => showPublishSheet(context),
                              ),
                              _buildOutputAction(
                                context,
                                imagePath: "assets/images/output_4.png",
                                label: "Share",
                                onTap: () => shareNetworkImage(
                                  context: context,
                                  imageUrl: currentImageUrl,
                                ),
                              ),
                              _buildOutputAction(
                                context,
                                imagePath: "assets/images/output_5.png",
                                label: "Delete",
                                onTap: () => _showDeleteAlert(context),
                              ),
                            ],
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
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Delete This Design?'),
            content: const Text(
              'This action cannot be undone. Are you sure you want to permanently remove this design?',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  Navigator.of(context).pop();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String userId = preferences.getString('user_id') ?? "";

                  final publishData = {
                    "user_id": userId,
                    "module_id": 1,
                    "id": data["id"],
                  };

                  debugPrint("Publish Record DataEvent payload: $publishData");

                  debugPrint("user_id: $userId");
                  debugPrint("module_id: 1");
                  debugPrint("id: ${data["id"]}");

                  _publishRecordBloc.add(
                    PublishRecordDataEvent(login: publishData),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showRegenerateAlert(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Regenerate Design?'),
            content: const Text(
              'This action will use 10 credits to generate a new design. Do you want to proceed?',
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: handle regenerate
                },
                child: const Text('Regenerate'),
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
            'Publish Your Design',
            style: TextStyle(
              fontSize: r.sp(context, 18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          r.verticalSpace(context, 10),

          // Subtitle
          Text(
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
                  "module_id": 1,
                  "id": data["id"],
                };

                debugPrint("PublishRecordDataEvent payload: $publishData");

                debugPrint("user_id: $userId");
                debugPrint("module_id: 1");
                debugPrint("id: ${data["id"]}");

                _publishRecordBloc.add(
                  PublishRecordDataEvent(login: publishData),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8D5BC),
                foregroundColor: const Color(0xFF3D3229),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: r.hp(context, 16)),
                shape: const StadiumBorder(),
                textStyle: TextStyle(
                  fontSize: r.sp(context, 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Publish'),
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
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    final iconSize = r.adaptiveValue(context, mobile: 40, tablet: 50);
    final fontSize = r.sp(context, 12);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageview(
            imagePath: imagePath,
            height: iconSize,
            width: iconSize,
          ),
          r.verticalSpace(context, 6),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(46, 46, 46, 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final VoidCallback onTap;
  final double topPad;
  final String img;

  const _PhotoSection({
    required this.onTap,
    required this.topPad,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: r.hp(context, 350),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            img,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Container(
                  color: const Color(0xFF8AAAC8),
                  child: Center(
                    child: Icon(
                      Icons.location_city_outlined,
                      size: r.wp(context, 60),
                      color: Colors.white54,
                    ),
                  ),
                ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: r.hp(context, 15),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  onTap();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.wp(context, 10),
                    vertical: r.hp(context, 5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(r.wp(context, 50)),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(230, 203, 168, 1),
                        Color.fromRGBO(167, 196, 188, 1),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enhance",
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
