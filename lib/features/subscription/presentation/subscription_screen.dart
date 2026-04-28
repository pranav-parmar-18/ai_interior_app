import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/services/remote_config_services.dart';
import 'package:ai_interior/theme/theme.dart';
import 'package:ai_interior/widgets/app_bar/custom_app_bar.dart';
import 'package:ai_interior/widgets/custom_elevated_button.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

enum SubscriptionType { weekly, monthly, yearly }

class SubscriptionInfo {
  final SubscriptionType type;
  final DateTime expiryDate;

  SubscriptionInfo({required this.type, required this.expiryDate});

  bool get isActive => DateTime.now().isBefore(expiryDate);

  static SubscriptionInfo? fromJson(String data) {
    final map = jsonDecode(data);
    final type = SubscriptionType.values.firstWhere(
      (e) => e.name == map['type'],
    );
    final expiry = DateTime.tryParse(map['expiry']);
    if (expiry == null) return null;
    return SubscriptionInfo(type: type, expiryDate: expiry);
  }
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  static const routeName = "/subscription";

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionConfig? subscriptionConfig;
  static int _visitCount = 0;
  int? _currentView;
  bool _isPurchasing = false;
  late VideoPlayerController _controller;

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = [
    'com.aigirlfriend.weekly',
    'com.aigirlfriend.yearly',
    'com.aigirlfriend.monthly',
  ];
  final List<String> _productIdsWeekly = ['com.aigirlfriend.weekly'];
  List<ProductDetails> _products = [];
  List<ProductDetails> _productsWeekly = [];
  final List<String> _list1 = ["Yearly Unlimited", "Weekly Unlimited"];
  List<String> _list2 = [];
  List<String> _list3 = [];

  @override
  void initState() {
    super.initState();
    _initializeView();
    _initialize();
    _controller = VideoPlayerController.asset('assets/videos/subscription.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Auto play
      });
    _controller.setLooping(true);
  }


  bool isIPad(BuildContext context) {
    return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
  }

  Future<void> getSubscriptionConfig() async {
    subscriptionConfig = await RemoteConfigService().fetchSubscriptionConfig();
  }

  Future<void> _saveSubscription(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    final SubscriptionType type;
    final Duration duration;

    switch (productId) {
      case 'com.aigirlfriend.weekly':
        type = SubscriptionType.weekly;
        duration = const Duration(days: 7);
        break;
      case 'com.aigirlfriend.monthly':
        type = SubscriptionType.monthly;
        duration = const Duration(days: 30);
        break;
      case 'com.aigirlfriend.yearly':
        type = SubscriptionType.yearly;
        duration = const Duration(days: 365);
        break;
      case 'com.aigirlfriend.weekly':
        type = SubscriptionType.weekly;
        duration = const Duration(days: 7);
        break;
      default:
        return;
    }

    final expiryDate = DateTime.now().add(duration);
    await prefs.setString(
      'subscription_info',
      jsonEncode({'type': type.name, 'expiry': expiryDate.toIso8601String()}),
    );

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Subscribed to ${type.name}")));
    setState(() {});
  }

  Future<void> _initializeView() async {
    await getSubscriptionConfig();
    if (subscriptionConfig == null) return;

    final orderedScreens = <int>[];

    for (final screen in subscriptionConfig!.screenOrder) {
      switch (screen) {
        case 'subscription_screen_one':
          if (subscriptionConfig!.screenOne) orderedScreens.add(0);
          break;
        case 'subscription_screen_two':
          if (subscriptionConfig!.screenTwo) orderedScreens.add(1);
          break;
        case 'subscription_screen_three':
          if (subscriptionConfig!.screenThree) orderedScreens.add(2);
          break;
      }
    }

    if (orderedScreens.isNotEmpty) {
      setState(() {
        _currentView = orderedScreens[_visitCount % orderedScreens.length];
        _visitCount++;
      });
    }
  }

  bool _loading = true;
  int _selectedIndex = 0;

  Future<SubscriptionInfo?> _getSubscriptionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('subscription_info');
    if (data == null) return null;

    final map = jsonDecode(data);
    final type = SubscriptionType.values.firstWhere(
      (e) => e.name == map['type'],
    );
    final expiry = DateTime.tryParse(map['expiry'] ?? '');
    if (expiry == null || DateTime.now().isAfter(expiry)) return null;

    return SubscriptionInfo(type: type, expiryDate: expiry);
  }

  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('In-App Purchases not available')),
      );
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        print('Purchase Stream Error: $error');
      },
    );

    await _loadProducts();
  }

  // Future<void> _loadProducts() async {
  //   final response = await _iap.queryProductDetails(_productIds.toSet());
  //
  //   if (response.error != null) {
  //     print('Product query error: ${response.error}');
  //   } else {
  //     setState(() {
  //       _products = response.productDetails;
  //       _loading = false;
  //     });
  //   }
  // }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds.toSet());
    final responseWeekly = await _iap.queryProductDetails(
      _productIdsWeekly.toSet(),
    );
    print("Requested product IDs: $_productIds");
    print("Available product IDs: ${response.productDetails.map((p) => p.id).toList()}");

    print("Requested weekly IDs: $_productIdsWeekly");
    print("Available weekly IDs: ${responseWeekly.productDetails.map((p) => p.id).toList()}");

    if (response.error != null) {
      print('Product query error: ${response.error}');
    } else {
      // Sort products in the desired order
      List<ProductDetails> sortedProducts =
          _productIds
              .map(
                (id) => response.productDetails.firstWhere(
                  (product) => product.id == id,
                ),
              )
              .toList();

      List<ProductDetails> sortedProductsWeekly =
          _productIdsWeekly
              .map(
                (id) => responseWeekly.productDetails.firstWhere(
                  (product) => product.id == id,
                ),
              )
              .toList();

      setState(() {
        _products = sortedProducts;
        _productsWeekly = sortedProductsWeekly;
        _list2 = [
          '${_getPrice("com.aigirlfriend.yearly")}/year',
          '${_getPriceWeekly("com.aigirlfriend.weekly")}/week',
        ];

        _list3 = [
          '${_getPrice("com.aigirlfriend.weekly")}/week',
          '${_getPrice("com.aigirlfriend.yearly")}/year',
          '${_getPrice("com.aigirlfriend.monthly")}/mo',
        ];
        _loading = false;
      });
    }
  }

  String _getPrice(String productId) {
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse:
          () => ProductDetails(
            id: '',
            title: '',
            description: '',
            price: '',
            rawPrice: 0.0,
            currencyCode: '',
          ),
    );
    return product.price;
  }

  String _getPriceWeekly(String productId) {
    final product = _productsWeekly.firstWhere(
      (p) => p.id == productId,
      orElse:
          () => ProductDetails(
            id: '',
            title: '',
            description: '',
            price: '',
            rawPrice: 0.0,
            currencyCode: '',
          ),
    );
    return product.price;
  }

  void _buy(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(
      purchaseParam: purchaseParam,
    ); // Used for subscriptions too
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (mounted) {
          setState(() => _isPurchasing = false);
        }
        print('Purchased: ${purchase.productID}');
        _saveSubscription(purchase.productID);
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Subscribed to ${purchase.productID}')),
        // );
      } else if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        print('Purchase error: ${purchase.error}');
        if (mounted) {
          setState(() => _isPurchasing = false);
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Purchase failed: ${purchase.error?.message}'),
        //   ),
        // );
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> isSubscribed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_subscribed', true);
  }

  Future<void> _restorePurchases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('subscription_info');
    _iap.restorePurchases();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Restoring purchases...')));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _isPurchasing
              ? Stack(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: isIPad(context)?height * 0.6:height * 0.63,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  _buildMainStack(context),
                                  GradientContainer(),
                                  _buildFeaturesColumn(context),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),

                            _buildPricingSlider(context),
                            _currentView == 0
                                ? _loading
                                ? SizedBox.shrink()
                                : Text(
                              "Only ${_list3[_selectedIndex]}, auto renews, cancel anytime",
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Manrope',
                              ),
                            )

                                : Text(
                              "Only ${_getPrice("com.aigirlfriend.yearly")}/year, auto renews, cancel anytime",
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            CustomElevatedButton(
                              height: isIPad(context)?65:null,
                              text: "Continue",
                              onPressed:
                              _isPurchasing
                                  ? null
                                  : () {
                                setState(() {
                                  _isPurchasing = true;
                                });

                                print("Current View : $_currentView");
                                print("Selected Index : $_selectedIndex");
                                ProductDetails selectedProduct;

                                if (_currentView == 1) {
                                  selectedProduct =
                                  (_selectedIndex == 1)
                                      ? _productsWeekly[0]
                                      : _products[1];
                                } else if (_currentView == 2) {
                                  selectedProduct = _products[1];
                                } else {
                                  selectedProduct =
                                  _products[_selectedIndex];
                                }

                                print("Product: ${selectedProduct.title}");
                                print("Product: ${selectedProduct.price}");

                                // _buy(selectedProduct);
                              },
                              margin: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                              ),
                              buttonStyle: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                                elevation: WidgetStateProperty.all<double>(0),
                                padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero,
                                ),
                                side: WidgetStateProperty.all<BorderSide>(
                                  BorderSide(color: Colors.transparent),
                                ),
                              ),
                              buttonTextStyle: TextStyle(
                                color: appTheme.gray200,
                                fontSize:
                                isIPad(context) ? width * 0.035 : width * 0.055,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Lato',
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            _buildPrivacyPolicyRow(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(child: Container(color: Colors.black54)),
                  Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(233, 64, 87, 1),
                          width: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black87,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          child: CircularProgressIndicator(
                            // value: 0.7, // 70%
                            strokeWidth: 1,
                            backgroundColor:  Color.fromRGBO(233, 64, 87, 1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: isIPad(context)?height * 0.6:height * 0.63,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              _buildMainStack(context),
                              GradientContainer(),
                              _buildFeaturesColumn(context),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),

                        _buildPricingSlider(context),
                         _loading
                                ? SizedBox.shrink()
                                : Text(
                                  "Only ${_list3[_selectedIndex]}, auto renews, cancel anytime",
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                    fontSize: width * 0.03,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Manrope',
                                  ),
                                )
                            ,
                        SizedBox(height: height * 0.01),
                        CustomElevatedButton(
                          height: isIPad(context)?65:null,
                          text: "Continue",
                          onPressed:
                              _isPurchasing
                                  ? null
                                  : () {
                                    setState(() {
                                      _isPurchasing = true;
                                    });

                                    print("Selected Index : $_selectedIndex");
                                    ProductDetails selectedProduct;

                                      selectedProduct =
                                          _products[_selectedIndex];

                                    print("Product: ${selectedProduct.title}");
                                    print("Product: ${selectedProduct.price}");

                                    _buy(selectedProduct);
                                  },
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          buttonStyle: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            elevation: WidgetStateProperty.all<double>(0),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero,
                                ),
                            side: WidgetStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.transparent),
                            ),
                          ),
                          buttonTextStyle: TextStyle(
                            color: appTheme.gray200,
                            fontSize:
                                isIPad(context) ? width * 0.035 : width * 0.055,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Lato',
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        _buildPrivacyPolicyRow(context),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildMainStack(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
             InfiniteImageScroller(),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.02),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      // 🔥 Makes entire area tappable
                      onTap: () {
                        HapticFeedback.heavyImpact();

                        Navigator.pop(context);
                      },
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: width * 0.07,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesColumn(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: isIPad(context) ? width * 0.25 : 70),
        child: Column(
          spacing: 14,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isIPad(context) ? width * 0.065 : width * 0.08,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: " Girlfriend",
                    style: TextStyle(
                      color: Color.fromRGBO(242, 113, 33, 1),

                      fontSize: isIPad(context) ? width * 0.065 : width * 0.08,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: " PRO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isIPad(context) ? width * 0.065 : width * 0.08,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 1,
            ),
            SizedBox(
              width: double.maxFinite,
              child: _buildGenerateLyricsRow(
                context,
                studioOne: "assets/images/sub_heart.png",
                generateYour: "Unlimited Intimate Chats",
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: _buildGenerateLyricsRow(
                context,
                studioOne: "assets/images/sub_heart.png",
                generateYour: "Exclusive Role-Play Scenarios",
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: _buildGenerateLyricsRow(
                context,
                studioOne: "assets/images/sub_heart.png",
                generateYour: "Swipe through 100+ Desiring Profiles",
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: _buildGenerateLyricsRow(
                context,
                studioOne: "assets/images/sub_heart.png",
                generateYour: "Request Hot & Sassy Pictures",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingStack(
    String title,
    String trallingText,
    bool isShow,
    int index,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: height * 0.08, // Responsive height
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.035),
                    border: Border.all(
                      color:
                          _selectedIndex == index
                              ? Color.fromRGBO(233, 64, 87, 1)
                              : Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                    gradient:
                        _selectedIndex == index
                            ? LinearGradient(
                              colors: [
                                Color.fromRGBO(138, 35, 135, 1),
                                Color.fromRGBO(233, 64, 87, 1),
                                Color.fromRGBO(242, 113, 33, 1),
                              ],
                            )
                            : const LinearGradient(
                              colors: [Colors.transparent, Colors.transparent],
                            ),
                  ),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.035),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.035,
                          vertical: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: width * 0.18,
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: appTheme.whiteA700,
                                    fontSize:
                                        isIPad(context)
                                            ? width * 0.025
                                            : width * 0.032,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            if (isShow)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: height * 0.005,
                                ),
                                child: Text(
                                  "(Less than \$0.77/week)",
                                  style: TextStyle(
                                    color: appTheme.gray200,
                                    fontSize: width * 0.03,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height * 0.005),
                              child: Text(
                                _loading ? "" : trallingText,
                                style: TextStyle(
                                  color: appTheme.whiteA700,
                                  fontSize: width * 0.032,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isShow)
              CustomElevatedButton(
                text: "Popular - 80% OFF",
                height: height * 0.027,
                width: width * 0.38,
                buttonTextStyle: TextStyle(
                  color: appTheme.whiteA700,
                  fontSize: width * 0.026,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                ),
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.pinkA100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.015),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                aligemnt: Alignment.topCenter,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSlider(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _loading
        ? Padding(
      padding: EdgeInsets.only(
        right: width * 0.08,
        left: width * 0.08,
        bottom: height * 0.01,
      ),
      child: SizedBox(
        height: height * 0.2,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (index != 1) SizedBox(height: height * 0.01),
                Align(
                  child: PricingSliderDummyItemWidget(
                    index: index,
                    onPurchase: () {},
                    selectedIndex: _selectedIndex,
                    onSelected: (int newIndex) {
                      setState(() {
                        _selectedIndex = newIndex;
                      });
                    },
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: width * 0.03);
          },
        ),
      ),
    )
        : _products.isEmpty
        ? const Center(child: Text('No subscriptions available'))
        : Padding(
          padding: EdgeInsets.only(
            right: width * 0.08,
            left: width * 0.08,
            bottom: height * 0.01,
          ),
          child: SizedBox(
            height: height * 0.2,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (index != 1) SizedBox(height: height * 0.01),
                    Align(
                      child: PricingSliderItemWidget(
                        products: _products,
                        index: index,
                        onPurchase: () {},
                        selectedIndex: _selectedIndex,
                        onSelected: (int newIndex) {
                          setState(() {
                            _selectedIndex = newIndex;
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: width * 0.03);
              },
            ),
          ),
        );
  }

  Widget _buildContainer(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.08,
        vertical: isIPad(context) ? height * 0.03 : height * 0.048,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.05),
          // border: Border.all(color:  Color.fromRGBO(233, 64, 87, 1),),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.015,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Just ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                      fontSize: width * 0.05,
                      color: appTheme.whiteA700,
                    ),
                  ),
                  if (Platform.isIOS)
                    Text(
                      "\$79.99 ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Manrope',
                        fontSize: width * 0.05,
                        color: Color.fromRGBO(233, 64, 87, 1),
                        decoration: TextDecoration.lineThrough,
                        // <-- Adds center line
                        decorationColor: Color.fromRGBO(233, 64, 87, 1),
                        // Optional: match line color
                        decorationThickness:
                            2, // Optional: control line thickness
                      ),
                    ),
                  Text(
                    "${_getPrice("com.aigirlfriend.yearly")} per year",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Manrope',
                      fontSize: width * 0.05,
                      color: appTheme.whiteA700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.005),
              Text(
                "(less than 0.09 per day)",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Manrope',
                  fontSize: width * 0.035,
                  color: appTheme.whiteA700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicyRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              HapticFeedback.heavyImpact();
              final url = 'https://app.tripleit.ltd/privacy-policy/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode:
                      LaunchMode
                          .externalApplication, // Ensures it opens in Safari
                );
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "Privacy Policy",
              style: TextStyle(
                color: appTheme.gray200.withAlpha(130),
                fontSize: width * 0.035,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();

              _restorePurchases();
            },
            child: Text(
              "Restore",
              style: TextStyle(
                color: appTheme.gray200.withAlpha(130),
                fontSize: width * 0.035,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              HapticFeedback.heavyImpact();

              final url = 'https://app.tripleit.ltd/terms-of-use/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode:
                      LaunchMode
                          .externalApplication, // Ensures it opens in Safari
                );
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              "Terms of Use",
              style: TextStyle(
                color: appTheme.gray200.withAlpha(130),
                fontSize: width * 0.035,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateLyricsRow(
    BuildContext context, {
    required String studioOne,
    required String generateYour,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        CustomImageview(imagePath: studioOne, height: 22, width: 22),
        Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text(
            generateYour,
            style: TextStyle(
              color: appTheme.gray200,
              fontSize: isIPad(context) ? width * 0.03 : width * 0.04,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class PricingSliderItemWidget extends StatefulWidget {
  const PricingSliderItemWidget({
    super.key,
    required this.products,
    required this.index,
    required this.onPurchase,
    required this.onSelected,
    required this.selectedIndex,
  });

  final List<ProductDetails> products;
  final int index;
  final VoidCallback onPurchase;
  final ValueChanged<int> onSelected;
  final int selectedIndex;

  @override
  State<PricingSliderItemWidget> createState() =>
      _PricingSliderItemWidgetState();
}

class _PricingSliderItemWidgetState extends State<PricingSliderItemWidget> {
  final List<String> _list = ["\$1.43/day", "\$3.33/mo", "\$3.25/week"];
  final List<String> _list1 = ["Weekly", "Yearly", "Monthly"];

  String extractLabel(String input) {
    return input.split(' ')[0];
  }

  bool isIPad(BuildContext context) {
    return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final bool isSelected = widget.index == widget.selectedIndex;

    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();

        widget.onSelected(widget.index);
        widget.onPurchase();
      },
      child: Column(
        children: [
          Container(
            width: width * 0.25, // Responsive width
            padding: EdgeInsets.only(bottom: height * 0.012),
            decoration: BoxDecoration(
              color: Color.fromRGBO(37, 37, 40, 0.5),
              borderRadius: BorderRadius.circular(width * 0.025),
              border: Border.all(
                color:
                    isSelected
                        ? Color.fromRGBO(233, 64, 87, 1)
                        : Color.fromRGBO(255, 255, 255, 0.2),
                width: 1.13,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.index == 1)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: height * 0.005),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.026),
                        topRight: Radius.circular(width * 0.026),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(138, 35, 135, 1),
                          Color.fromRGBO(233, 64, 87, 1),
                          Color.fromRGBO(242, 113, 33, 1),
                        ],
                      ),
                    ),
                    child: Text(
                      "Best Value",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: appTheme.whiteA700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                SizedBox(height: height * 0.012),
                Text(
                  _list1[widget.index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.whiteA700,
                    fontSize: isIPad(context) ? width * 0.02 : width * 0.033,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Manrope',
                  ),
                ),
                widget.index == 1
                    ? SizedBox(height: height * 0.005)
                    : SizedBox(height: height * 0.01),
                if (widget.index == 1 && !isIPad(context))
                  Text(
                    "\$79.99 ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                      fontSize: isIPad(context) ? width * 0.02 : width * 0.036,
                      color: Color.fromRGBO(233, 64, 87, 1),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Color.fromRGBO(233, 64, 87, 1),
                      decorationThickness:
                          2, // Optional: control line thickness
                    ),
                  ),
                if (widget.index == 1) SizedBox(height: height * 0.001),
                Text(
                  widget.products[widget.index].price,
                  style: TextStyle(
                    color: appTheme.whiteA700,
                    fontSize: isIPad(context) ? width * 0.02 : width * 0.036,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Manrope',
                  ),
                ),
                widget.index == 1
                    ? SizedBox(height: height * 0.0001)
                    : SizedBox(height: height * 0.01),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color.fromRGBO(255, 255, 255, 0.2)),
                  ),
                ),
                SizedBox(height: height * 0.006),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  child: Text(
                    "Less than",
                    style: TextStyle(
                      color:
                          widget.index == 1
                              ? Color.fromRGBO(233, 64, 87, 1)
                              : appTheme.whiteA700,
                      fontSize: isIPad(context) ? width * 0.02 : width * 0.03,
                      fontWeight:
                          widget.index == 1 ? FontWeight.w900 : FontWeight.w500,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.005,
                    left: width * 0.015,
                    right: width * 0.015,
                  ),
                  child: Text(
                    _list[widget.index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appTheme.whiteA700.withOpacity(0.8),
                      fontSize: isIPad(context) ? width * 0.02 : width * 0.03,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PricingSliderDummyItemWidget extends StatefulWidget {
  const PricingSliderDummyItemWidget({
    super.key,
    required this.index,
    required this.onPurchase,
    required this.onSelected,
    required this.selectedIndex,
  });

  final int index;
  final VoidCallback onPurchase;
  final ValueChanged<int> onSelected;
  final int selectedIndex;

  @override
  State<PricingSliderDummyItemWidget> createState() =>
      _PricingSliderDummyItemWidgetState();
}

class _PricingSliderDummyItemWidgetState extends State<PricingSliderDummyItemWidget> {
  final List<String> _list = ["\$1.43/day", "\$3.33/mo", "\$3.25/week"];
  final List<String> _list1 = ["Weekly", "Yearly", "Monthly"];
  final List<String> _list3 = ["\$9.99", "\$39.99", "\$12.99"];

  String extractLabel(String input) {
    return input.split(' ')[0];
  }

  bool isIPad(BuildContext context) {
    return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final bool isSelected = widget.index == widget.selectedIndex;

    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();

        widget.onSelected(widget.index);
        widget.onPurchase();
      },
      child: Column(
        children: [
          Container(
            width: width * 0.25, // Responsive width
            padding: EdgeInsets.only(bottom: height * 0.012),
            decoration: BoxDecoration(
              color: Color.fromRGBO(37, 37, 40, 0.5),
              borderRadius: BorderRadius.circular(width * 0.025),
              border: Border.all(
                color:
                    isSelected
                        ? Color.fromRGBO(233, 64, 87, 1)
                        : Color.fromRGBO(255, 255, 255, 0.2),
                width: 1.13,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.index == 1)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: height * 0.005),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.026),
                        topRight: Radius.circular(width * 0.026),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(138, 35, 135, 1),
                          Color.fromRGBO(233, 64, 87, 1),
                          Color.fromRGBO(242, 113, 33, 1),
                        ],
                      ),
                    ),
                    child: Text(
                      "Best Value",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: appTheme.whiteA700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                SizedBox(height: height * 0.012),
                Text(
                  _list1[widget.index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme.whiteA700,
                    fontSize: isIPad(context) ? width * 0.02 : width * 0.033,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Manrope',
                  ),
                ),
                widget.index == 1
                    ? SizedBox(height: height * 0.005)
                    : SizedBox(height: height * 0.01),
                if (widget.index == 1 && !isIPad(context))
                  Text(
                    "\$79.99 ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                      fontSize: isIPad(context) ? width * 0.02 : width * 0.036,
                      color: Color.fromRGBO(233, 64, 87, 1),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Color.fromRGBO(233, 64, 87, 1),
                      decorationThickness:
                          2, // Optional: control line thickness
                    ),
                  ),
                if (widget.index == 1) SizedBox(height: height * 0.001),
                Text(
                  _list3[widget.index],
                  style: TextStyle(
                    color: appTheme.whiteA700,
                    fontSize: isIPad(context) ? width * 0.02 : width * 0.036,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Manrope',
                  ),
                ),
                widget.index == 1
                    ? SizedBox(height: height * 0.0001)
                    : SizedBox(height: height * 0.01),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color.fromRGBO(255, 255, 255, 0.2)),
                  ),
                ),
                SizedBox(height: height * 0.006),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  child: Text(
                    "Less than",
                    style: TextStyle(
                      color:
                          widget.index == 1
                              ? Color.fromRGBO(233, 64, 87, 1)
                              : appTheme.whiteA700,
                      fontSize: isIPad(context) ? width * 0.02 : width * 0.03,
                      fontWeight:
                          widget.index == 1 ? FontWeight.w900 : FontWeight.w500,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.005,
                    left: width * 0.015,
                    right: width * 0.015,
                  ),
                  child: Text(
                    _list[widget.index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appTheme.whiteA700.withOpacity(0.8),
                      fontSize: isIPad(context) ? width * 0.02 : width * 0.03,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: double.maxFinite,
      height: 318,
      margin: EdgeInsets.only(top: isIPad(context)?height *0.5:height * 0.35),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0.0), // Transparent
            Color.fromRGBO(0, 0, 0, 0.2), // Transparent
            Color.fromRGBO(0, 0, 0, 0.5), // Transparent
            Color.fromRGBO(0, 0, 0, 0.8), // Transparent
            Color.fromRGBO(0, 0, 0, 0.95), // Transparent
            Color.fromRGBO(0, 0, 0, 0.95), // Transparent
            Color.fromRGBO(0, 0, 0, 1), // Solid black
          ],
        ),
      ),
    );
  }
}

class InfiniteImageScroller extends StatefulWidget {
  @override
  _InfiniteImageScrollerState createState() => _InfiniteImageScrollerState();
}

class _InfiniteImageScrollerState extends State<InfiniteImageScroller> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  final double imageWidth = 2500;
  final double viewWidth = 1000;
  final double initialOffset = Platform.isAndroid ?650:550; // start at +300px

  @override
  void initState() {
    super.initState();

    // Jump to initial position after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(initialOffset);
      }
    });

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double current = _scrollController.offset + 1;

        if (current >= maxScroll) {
          _scrollController.jumpTo(0); // Reset to beginning
        } else {
          _scrollController.jumpTo(current);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 700, // image height
        width: viewWidth, // visible part
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            children: [
              Image.asset(
                'assets/images/subscription_top_new.png',
                width: imageWidth,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

