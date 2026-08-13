import 'dart:async';
import 'dart:convert';
import 'package:ai_interior/models/create_user_model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

import '../../../bloc/create_user/create_user_bloc.dart';
import '../../../services/device_indentification_service.dart';
import '../../main/presentaion/main_screen.dart';
import '../../home/presentation/home_screen.dart';

class OnboardingFourScreen extends StatefulWidget {
  const OnboardingFourScreen({super.key});

  static const routeName = "/onboarding-four";

  @override
  State<OnboardingFourScreen> createState() => _OnboardingFourScreenState();
}

class _OnboardingFourScreenState extends State<OnboardingFourScreen> {
  final CreateUserBloc _createUserBloc = CreateUserBloc();
  CreateUserModelResponse? createUserModelResponse;
  String? deviceId;

  // IAP
  bool _loading = true;
  bool _isPurchasing = false;
  List<ProductDetails> _products = [];
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _iapSubscription;

  Future<void> getDeviceId() async {
    deviceId = await DeviceIdManager.getDeviceId();
    print('Persistent Device ID: $deviceId');
  }

  String _priceForWeekly() {
    if (_loading || _products.isEmpty) return "\$6.99";
    try {
      return _products.firstWhere((p) => p.id == 'com.ai_interior.weekly').price;
    } catch (_) {
      return "\$6.99";
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();

    _iapSubscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _iapSubscription?.cancel(),
      onError: (error) {
        debugPrint('Purchase Stream Error: $error');
      },
    );
    _initIAP();
  }

  Future<void> _saveSubscription(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(const Duration(days: 7));
    await prefs.setBool('is_subscribed', true);
    await prefs.setString(
      'subscription_info',
      jsonEncode({'type': 'weekly', 'expiry': expiryDate.toIso8601String()}),
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _saveSubscription(purchase.productID);
        if (mounted) {
          setState(() => _isPurchasing = false);
        }
        _createUserBloc.add(
          CreateUserDataEvent(
            login: {"uuid": deviceId.toString()},
          ),
        );
      } else if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        if (mounted) {
          setState(() => _isPurchasing = false);
        }
        if (purchase.status == PurchaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Purchase failed: ${purchase.error?.message}')),
          );
        }
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> _initIAP() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        setState(() => _loading = false);
        return;
      }
      final response = await _iap.queryProductDetails({'com.ai_interior.weekly'});
      if (response.productDetails.isNotEmpty) {
        setState(() {
          _products = response.productDetails;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _onContinue() {
    if (_isPurchasing || _loading) return;
    setState(() => _isPurchasing = true);

    try {
      final product = _products.firstWhere(
        (p) => p.id == 'com.ai_interior.weekly',
        orElse: () => _products.isNotEmpty ? _products.first : throw Exception('No products found'),
      );
      final purchaseParam = PurchaseParam(productDetails: product);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      setState(() => _isPurchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to process purchase: $e')),
      );
    }
  }

  @override
  void dispose() {
    _iapSubscription?.cancel();
    _createUserBloc.close();
    super.dispose();
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FooterLink(
          label: 'Terms Of Use',
          onTap: () => launchUrl(
            Uri.parse('https://bvktechnologies.com/terms-of-use-for-bloomnest-ai-interior-design/'),
            mode: LaunchMode.externalApplication,
          ),
        ),
        _FooterLink(
          label: 'Restore',
          onTap: () async {
            try {
              await InAppPurchase.instance.restorePurchases();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restoring purchases...')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Restore failed: $e')),
              );
            }
          },
        ),
        _FooterLink(
          label: 'Privacy Policy',
          onTap: () => launchUrl(
            Uri.parse('https://bvktechnologies.com/privacy-policy-for-bloomnest-ai-interior-design/'),
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final isLandscape = r.isLandscape(context);

    final imageGridWidget = Stack(
      children: [
        // Main content
        Padding(
          padding: EdgeInsets.only(
            top: topPadding + 12,
            left: 16,
            right: 16,
          ),
          child: _ImageGrid(),
        ),

        // Back button (top-right)
        Positioned(
          top: topPadding + 16,
          right: r.adaptiveValue(context, mobile: 20, tablet: 32),
          child: GestureDetector(
            onTap: () {
              setIsOnboardingDone();
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName,
                (route) => false,
              );
            },
            child: Container(
              width: r.adaptiveValue(context, mobile: 32, tablet: 42),
              height: r.adaptiveValue(context, mobile: 32, tablet: 42),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: r.adaptiveValue(context, mobile: 18, tablet: 24),
              ),
            ),
          ),
        ),
      ],
    );

    final detailsContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.adaptiveValue(context, mobile: 24, tablet: 48),
        vertical: isLandscape ? 12 : 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isLandscape) SizedBox(height: r.hp(context, 16)),

          // Title
          Text(
            'Upgrade Your Vision',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: r.sp(context, 32),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF2C2C2C),
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: r.hp(context, 20)),

          // Subtitle with inline auto-renew icon
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: r.sp(context, 15),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A8080),
                height: 1.55,
              ),
              children: [
                TextSpan(
                  text:
                      'Go beyond the basics — unlimited creations,\nexclusive styles, & more for just ${_priceForWeekly()}/week,\n',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _AutoRenewIcon(),
                ),
                const TextSpan(text: ' auto renews, cancel anytime.'),
              ],
            ),
          ),

          if (isLandscape) SizedBox(height: r.hp(context, 24)) else const Spacer(),

          // Continue button
          _ContinueButton(
            onTap: _onContinue,
          ),

          SizedBox(height: r.hp(context, 16)),

          // Privacy, Restore, Terms
          _buildFooter(),

          if (!isLandscape) SizedBox(height: r.hp(context, 16)),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      body: BlocConsumer<CreateUserBloc, CreateUserState>(
        bloc: _createUserBloc,
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            createUserModelResponse = state.login;
            setUserId(createUserModelResponse?.data?.id.toString() ?? "");
            setIsOnboardingDone();
            SharedPreferences.getInstance().then((prefs) {
              final credits = createUserModelResponse?.credits?.toString() ?? "0";
              prefs.setBool('credits_initialized', true);
              prefs.setString('credits', credits);
              creditsNotifier.value = credits;
            });
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
          } else if (state is CreateUserExceptionState ||
              state is CreateUserFailureState) {}
        },
        builder: (context, state) {
          return Stack(
            children: [
              isLandscape
                  ? Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: imageGridWidget,
                        ),
                        Expanded(
                          flex: 50,
                          child: SafeArea(
                            left: false,
                            child: SingleChildScrollView(
                              child: detailsContent,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.58,
                          child: imageGridWidget,
                        ),
                        Expanded(
                          child: Container(
                            color: const Color(0xFFF5F0EA),
                            child: detailsContent,
                          ),
                        ),
                      ],
                    ),
              if (_isPurchasing)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: CupertinoActivityIndicator(radius: 16),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> setIsOnboardingDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_onboarding_done', true);
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user_id', userId);
  }
}

// ─────────────────────────────────────────────
// Auto-Renew Icon (circular arrows)
// ─────────────────────────────────────────────
class _AutoRenewIcon extends StatelessWidget {
  const _AutoRenewIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF6A8CAA),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Icon(Icons.autorenew_rounded, color: Colors.white, size: 14),
    );
  }
}

// ─────────────────────────────────────────────
// 2×2 Image Grid
// ─────────────────────────────────────────────
class _ImageGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EA),
      body: Stack(
        children: [
          _FullScreenAnimatedGrid(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Continue Button
// ─────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: r.adaptiveValue(context, mobile: 56, tablet: 64),
        decoration: BoxDecoration(
          color: const Color(0xFFD9B48C),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: r.sp(context, 17),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF3C3228),
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: r.wp(context, 10)),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF3C3228),
              size: r.adaptiveValue(context, mobile: 22, tablet: 28),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// FULL SCREEN ANIMATED GRID
/// ─────────────────────────────────────────────
class _FullScreenAnimatedGrid extends StatefulWidget {
  const _FullScreenAnimatedGrid();

  @override
  State<_FullScreenAnimatedGrid> createState() =>
      _FullScreenAnimatedGridState();
}

class _FullScreenAnimatedGridState extends State<_FullScreenAnimatedGrid>
    with SingleTickerProviderStateMixin {
  late final ScrollController _leftController;
  late final ScrollController _rightController;
  late final Ticker _ticker;

  Duration _lastTime = Duration.zero;

  static const double _leftSpeed = 12; // slower = smoother
  static const double _rightSpeed = 14;

  @override
  void initState() {
    super.initState();
    _leftController = ScrollController();
    _rightController = ScrollController();

    _ticker = createTicker(_onTick)..start();

    // Start right column from bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_rightController.hasClients) {
        _rightController.jumpTo(_rightController.position.maxScrollExtent);
      }
    });
  }

  void _onTick(Duration elapsed) {
    if (!_leftController.hasClients || !_rightController.hasClients) return;

    if (_lastTime == Duration.zero) {
      _lastTime = elapsed;
      return;
    }

    final dt = (elapsed - _lastTime).inMilliseconds / 100.0; // seconds
    _lastTime = elapsed;

    final leftMax = _leftController.position.maxScrollExtent;
    final rightMax = _rightController.position.maxScrollExtent;

    // LEFT: bottom → top
    double leftOffset = _leftController.offset + _leftSpeed * dt;
    if (leftOffset >= leftMax) leftOffset = 0;
    _leftController.jumpTo(leftOffset);

    // RIGHT: top → bottom
    double rightOffset = _rightController.offset - _rightSpeed * dt;
    if (rightOffset <= 0) rightOffset = rightMax;
    _rightController.jumpTo(rightOffset);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _AnimatedImageColumn(controller: _leftController)),
        const SizedBox(width: 10),
        Expanded(child: _AnimatedImageColumn(controller: _rightController)),
      ],
    );
  }
}

/// ─────────────────────────────────────────────
/// IMAGE COLUMN
/// ─────────────────────────────────────────────
class _AnimatedImageColumn extends StatelessWidget {
  final ScrollController controller;

  const _AnimatedImageColumn({required this.controller});

  static const List<String> _images = [
    "assets/images/exterior/exterior_1.png",
    "assets/images/interior/interior_2.jpg",
    "assets/images/exterior/exterior_3.png",
    "assets/images/interior/interior_7.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final items = [..._images, ..._images]; // infinite illusion

    return ListView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 8),
        vertical: r.hp(context, 24),
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: r.hp(context, 12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r.radius(context, 18)),
            child: AspectRatio(
              aspectRatio: 0.85,
              child: Image.asset(items[index], fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Footer Link
// ─────────────────────────────────────────────
class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: 12,
          color: Color(0xFF7A8080),
        ),
      ),
    );
  }
}
