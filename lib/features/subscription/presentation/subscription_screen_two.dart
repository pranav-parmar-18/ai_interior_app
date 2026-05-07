// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:ai_interior/features/main/presentaion/main_screen.dart';
// import 'package:ai_interior/features/subscription/presentation/subscription_screen.dart';
// import 'package:ai_interior/services/remote_config_services.dart';
// import 'package:ai_interior/theme/theme.dart';
// import 'package:ai_interior/widgets/app_bar/custom_app_bar.dart';
// import 'package:ai_interior/widgets/custom_elevated_button.dart';
// import 'package:ai_interior/widgets/custom_imageview.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:video_player/video_player.dart';
//
// class SubscriptionTwoScreen extends StatefulWidget {
//   const SubscriptionTwoScreen({super.key});
//
//   static const routeName = "/subscription-two";
//
//   @override
//   State<SubscriptionTwoScreen> createState() => _SubscriptionTwoScreenState();
// }
//
// class _SubscriptionTwoScreenState extends State<SubscriptionTwoScreen> {
//   SubscriptionConfig? subscriptionConfig;
//   static int _visitCount = 0;
//   int? _currentView;
//   bool _isPurchasing = false;
//   late VideoPlayerController _controller;
//
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   final InAppPurchase _iap = InAppPurchase.instance;
//   final List<String> _productIds = [
//     'com.aigirlfriend.weekly',
//     'com.aigirlfriend.yearly',
//     'com.aigirlfriend.monthly',
//   ];
//   final List<String> _productIdsWeekly = ['com.aigirlfriend.weekly'];
//   List<ProductDetails> _products = [];
//   List<ProductDetails> _productsWeekly = [];
//   final List<String> _list1 = ["Yearly Unlimited", "Weekly Unlimited"];
//   List<String> _list2 = [];
//   List<String> _list4 = ["\$39.99","\$6.99"];
//   List<String> _list3 = [];
// bool _isInit = true;
//   @override
//   void initState() {
//     super.initState();
//     _initializeView();
//     _initialize();
//     _controller = VideoPlayerController.asset('assets/videos/subscription.mp4')
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play(); // Auto play
//       });
//     _controller.setLooping(true);
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }
//
//   bool isIPad(BuildContext context) {
//     return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
//   }
//
//   Future<void> getSubscriptionConfig() async {
//     subscriptionConfig = await RemoteConfigService().fetchSubscriptionConfig();
//   }
//
//   Future<void> _saveSubscription(String productId) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final SubscriptionType type;
//     final Duration duration;
//
//     switch (productId) {
//       case 'com.aigirlfriend.weekly':
//         type = SubscriptionType.weekly;
//         duration = const Duration(days: 7);
//         break;
//       case 'com.aigirlfriend.monthly':
//         type = SubscriptionType.monthly;
//         duration = const Duration(days: 30);
//         break;
//       case 'com.aigirlfriend.yearly':
//         type = SubscriptionType.yearly;
//         duration = const Duration(days: 365);
//         break;
//       case 'com.aigirlfriend.weekly':
//         type = SubscriptionType.weekly;
//         duration = const Duration(days: 7);
//         break;
//       default:
//         return;
//     }
//
//     final expiryDate = DateTime.now().add(duration);
//     await prefs.setString(
//       'subscription_info',
//       jsonEncode({'type': type.name, 'expiry': expiryDate.toIso8601String()}),
//     );
//
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Subscribed to ${type.name}")));
//     setState(() {});
//   }
//
//   Future<void> _initializeView() async {
//     await getSubscriptionConfig();
//     if (subscriptionConfig == null) return;
//
//     final orderedScreens = <int>[];
//
//     for (final screen in subscriptionConfig!.screenOrder) {
//       switch (screen) {
//         case 'subscription_screen_one':
//           if (subscriptionConfig!.screenOne) orderedScreens.add(0);
//           break;
//         case 'subscription_screen_two':
//           if (subscriptionConfig!.screenTwo) orderedScreens.add(1);
//           break;
//         case 'subscription_screen_three':
//           if (subscriptionConfig!.screenThree) orderedScreens.add(2);
//           break;
//       }
//     }
//
//     if (orderedScreens.isNotEmpty) {
//       setState(() {
//         _currentView = orderedScreens[_visitCount % orderedScreens.length];
//         _visitCount++;
//       });
//     }
//   }
//
//   bool _loading = true;
//   int _selectedIndex = 0;
//
//   Future<SubscriptionInfo?> _getSubscriptionInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString('subscription_info');
//     if (data == null) return null;
//
//     final map = jsonDecode(data);
//     final type = SubscriptionType.values.firstWhere(
//       (e) => e.name == map['type'],
//     );
//     final expiry = DateTime.tryParse(map['expiry'] ?? '');
//     if (expiry == null || DateTime.now().isAfter(expiry)) return null;
//
//     return SubscriptionInfo(type: type, expiryDate: expiry);
//   }
//
//   Future<void> _initialize() async {
//     final available = await _iap.isAvailable();
//     if (!available) {
//       setState(() {
//         _loading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('In-App Purchases not available')),
//       );
//       return;
//     }
//
//     _subscription = _iap.purchaseStream.listen(
//       _handlePurchaseUpdates,
//       onDone: () => _subscription.cancel(),
//       onError: (error) {
//         print('Purchase Stream Error: $error');
//       },
//     );
//
//     await _loadProducts();
//   }
//
//   // Future<void> _loadProducts() async {
//   //   final response = await _iap.queryProductDetails(_productIds.toSet());
//   //
//   //   if (response.error != null) {
//   //     print('Product query error: ${response.error}');
//   //   } else {
//   //     setState(() {
//   //       _products = response.productDetails;
//   //       _loading = false;
//   //     });
//   //   }
//   // }
//
//   Future<void> _loadProducts() async {
//     final response = await _iap.queryProductDetails(_productIds.toSet());
//     final responseWeekly = await _iap.queryProductDetails(
//       _productIdsWeekly.toSet(),
//     );
//
//     if (response.error != null) {
//       print('Product query error: ${response.error}');
//     } else {
//       // Sort products in the desired order
//       List<ProductDetails> sortedProducts =
//           _productIds
//               .map(
//                 (id) => response.productDetails.firstWhere(
//                   (product) => product.id == id,
//                 ),
//               )
//               .toList();
//
//       List<ProductDetails> sortedProductsWeekly =
//           _productIdsWeekly
//               .map(
//                 (id) => responseWeekly.productDetails.firstWhere(
//                   (product) => product.id == id,
//                 ),
//               )
//               .toList();
//
//       setState(() {
//         _products = sortedProducts;
//         _productsWeekly = sortedProductsWeekly;
//         _list2 = [
//           '${_getPrice("com.aigirlfriend.yearly")}/year',
//           '${_getPriceWeekly("com.aigirlfriend.weekly")}/week',
//         ];
//
//         _list3 = [
//           '${_getPrice("com.aigirlfriend.weekly")}/week',
//           '${_getPrice("com.aigirlfriend.yearly")}/year',
//           '${_getPrice("com.aigirlfriend.monthly")}/mo',
//         ];
//         _loading = false;
//       });
//     }
//   }
//
//   String _getPrice(String productId) {
//     final product = _products.firstWhere(
//       (p) => p.id == productId,
//       orElse:
//           () => ProductDetails(
//             id: '',
//             title: '',
//             description: '',
//             price: '',
//             rawPrice: 0.0,
//             currencyCode: '',
//           ),
//     );
//     return product.price;
//   }
//
//   String _getPriceWeekly(String productId) {
//     final product = _productsWeekly.firstWhere(
//       (p) => p.id == productId,
//       orElse:
//           () => ProductDetails(
//             id: '',
//             title: '',
//             description: '',
//             price: '',
//             rawPrice: 0.0,
//             currencyCode: '',
//           ),
//     );
//     return product.price;
//   }
//
//   void _buy(ProductDetails product) {
//     final purchaseParam = PurchaseParam(productDetails: product);
//     _iap.buyNonConsumable(
//       purchaseParam: purchaseParam,
//     ); // Used for subscriptions too
//   }
//
//   void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
//     for (final purchase in purchases) {
//       if (purchase.status == PurchaseStatus.purchased ||
//           purchase.status == PurchaseStatus.restored) {
//         if (mounted) {
//           setState(() => _isPurchasing = false);
//         }
//         print('Purchased: ${purchase.productID}');
//         _saveSubscription(purchase.productID);
//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Subscribed to ${purchase.productID}')),
//         // );
//       } else if (purchase.status == PurchaseStatus.error ||
//           purchase.status == PurchaseStatus.canceled) {
//         print('Purchase error: ${purchase.error}');
//         if (mounted) {
//           setState(() => _isPurchasing = false);
//         }
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text('Purchase failed: ${purchase.error?.message}'),
//         //   ),
//         // );
//       }
//
//       if (purchase.pendingCompletePurchase) {
//         _iap.completePurchase(purchase);
//       }
//     }
//   }
//
//   Future<void> isSubscribed() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setBool('is_subscribed', true);
//   }
//
//   Future<void> _restorePurchases() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('subscription_info');
//     _iap.restorePurchases();
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Restoring purchases...')));
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:
//           _isPurchasing
//               ? Stack(
//                 children: [
//                   Stack(
//                     children: [
//                       SizedBox(
//                         width: double.infinity,
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: isIPad(context)?height*0.6:height * 0.63,
//                               width: double.infinity,
//                               child: Stack(
//                                 children: [
//                                   _buildMainStack(context),
//                                   GradientContainer(),
//                                   _buildFeaturesColumn(context),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: height * 0.02),
//
//                             Align(
//                               alignment: Alignment.topCenter,
//                               child: SizedBox(
//                                 height: height * 0.2,
//                                 child: ListView.separated(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.zero,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: _list1.length,
//                                   itemBuilder: (context, index) {
//                                     return _loading
//                                         ? _buildDummyPricingStack(
//                                       _list1[index],
//                                       _list4[index],
//                                       index == 0,
//                                       index,
//                                     )
//                                         : _buildPricingStack(
//                                       _list1[index],
//                                       _list2[index],
//                                       index == 0,
//                                       index,
//                                     );
//                                   },
//                                   separatorBuilder:
//                                       (context, index) => SizedBox(height: height * 0.01),
//                                 ),
//                               ),
//                             ),
//                             _currentView == 0
//                                 ? _loading
//                                 ? SizedBox.shrink()
//                                 : Text(
//                               "Only ${_list3[_selectedIndex]}, auto renews, cancel anytime",
//                               style: TextStyle(
//                                 color: Color.fromRGBO(255, 255, 255, 0.5),
//                                 fontSize: width * 0.03,
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: 'Manrope',
//                               ),
//                             )
//                                 : _currentView == 1
//                                 ? _loading
//                                 ? SizedBox.shrink()
//                                 : Text(
//                               "Only ${_list2[_selectedIndex]}, auto renews, cancel anytime",
//                               style: TextStyle(
//                                 color: Color.fromRGBO(255, 255, 255, 0.5),
//                                 fontSize: width * 0.03,
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: 'Manrope',
//                               ),
//                             )
//                                 : Text(
//                               "Only ${_getPrice("com.aigirlfriend.yearly")}/year, auto renews, cancel anytime",
//                               style: TextStyle(
//                                 color: Color.fromRGBO(255, 255, 255, 0.5),
//                                 fontSize: width * 0.03,
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: 'Manrope',
//                               ),
//                             ),
//                             SizedBox(height: height * 0.01),
//                             CustomElevatedButton(
//                               height: isIPad(context)?70  :null,
//                               text: "Continue",
//                               onPressed:
//                               _isPurchasing
//                                   ? null
//                                   : () {
//                                 setState(() {
//                                   _isPurchasing = true;
//                                 });
//
//                                 print("Current View : $_currentView");
//                                 print("Selected Index : $_selectedIndex");
//                                 ProductDetails selectedProduct;
//
//                                 if (_currentView == 1) {
//                                   selectedProduct =
//                                   (_selectedIndex == 1)
//                                       ? _productsWeekly[0]
//                                       : _products[1];
//                                 } else if (_currentView == 2) {
//                                   selectedProduct = _products[1];
//                                 } else {
//                                   selectedProduct =
//                                   _products[_selectedIndex];
//                                 }
//
//                                 print("Product: ${selectedProduct.title}");
//                                 print("Product: ${selectedProduct.price}");
//
//                                 // _buy(selectedProduct);
//                               },
//                               margin: EdgeInsets.symmetric(
//                                 horizontal: width * 0.05,
//                               ),
//                               buttonStyle: ButtonStyle(
//                                 backgroundColor: WidgetStateProperty.all<Color>(
//                                   Colors.transparent,
//                                 ),
//                                 elevation: WidgetStateProperty.all<double>(0),
//                                 padding:
//                                 WidgetStateProperty.all<EdgeInsetsGeometry>(
//                                   EdgeInsets.zero,
//                                 ),
//                                 side: WidgetStateProperty.all<BorderSide>(
//                                   BorderSide(color: Colors.transparent),
//                                 ),
//                               ),
//                               buttonTextStyle: TextStyle(
//                                 color: appTheme.gray200,
//                                 fontSize:
//                                 isIPad(context) ? width * 0.035 : width * 0.055,
//                                 fontWeight: FontWeight.w800,
//                                 fontFamily: 'Lato',
//                               ),
//                             ),
//                             SizedBox(height: height * 0.015),
//                             _buildPrivacyPolicyRow(context),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned.fill(child: Container(color: Colors.black54)),
//                   Center(
//                     child: Container(
//                       height: 70,
//                       width: 70,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Color.fromRGBO(233, 64, 87, 1),
//                           width: 0.25,
//                         ),
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.black87,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Align(
//                           child: CircularProgressIndicator(
//                             // value: 0.7, // 70%
//                             strokeWidth: 1,
//                             backgroundColor:  Color.fromRGBO(233, 64, 87, 1),
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//               : Stack(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: isIPad(context)?height*0.6:height * 0.63,
//                           width: double.infinity,
//                           child: Stack(
//                             children: [
//                               _buildMainStack(context),
//                               GradientContainer(),
//                               _buildFeaturesColumn(context),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: height * 0.02),
//
//                         Align(
//                           alignment: Alignment.topCenter,
//                           child: SizedBox(
//                             height: height * 0.2,
//                             child: ListView.separated(
//                               shrinkWrap: true,
//                               padding: EdgeInsets.zero,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: _list1.length,
//                               itemBuilder: (context, index) {
//                                 return _loading
//                                     ? _buildDummyPricingStack(
//                                   _list1[index],
//                                   _list4[index],
//                                   index == 0,
//                                   index,
//                                 )
//                                     : _buildPricingStack(
//                                   _list1[index],
//                                   _list2[index],
//                                   index == 0,
//                                   index,
//                                 );
//                               },
//                               separatorBuilder:
//                                   (context, index) => SizedBox(height: height * 0.01),
//                             ),
//                           ),
//                         ),
//                          _loading
//                                 ? SizedBox.shrink()
//                                 : Text(
//                                   "Only ${_list2[_selectedIndex]}, auto renews, cancel anytime",
//                                   style: TextStyle(
//                                     color: Color.fromRGBO(255, 255, 255, 0.5),
//                                     fontSize: width * 0.03,
//                                     fontWeight: FontWeight.w700,
//                                     fontFamily: 'Manrope',
//                                   ),
//                                 )
//                             ,
//                         SizedBox(height: height * 0.01),
//                         CustomElevatedButton(
//                           height: isIPad(context)?70  :null,
//                           text: "Continue",
//                           onPressed:
//                               _isPurchasing
//                                   ? null
//                                   : () {
//                                     setState(() {
//                                       _isPurchasing = true;
//                                     });
//
//                                     print("Current View : $_currentView");
//                                     print("Selected Index : $_selectedIndex");
//                                     ProductDetails selectedProduct;
//
//
//                                       selectedProduct =
//                                           (_selectedIndex == 1)
//                                               ? _productsWeekly[0]
//                                               : _products[1];
//
//                                     print("Product: ${selectedProduct.title}");
//                                     print("Product: ${selectedProduct.price}");
//
//                                     _buy(selectedProduct);
//                                   },
//                           margin: EdgeInsets.symmetric(
//                             horizontal: width * 0.05,
//                           ),
//                           buttonStyle: ButtonStyle(
//                             backgroundColor: WidgetStateProperty.all<Color>(
//                               Colors.transparent,
//                             ),
//                             elevation: WidgetStateProperty.all<double>(0),
//                             padding:
//                                 WidgetStateProperty.all<EdgeInsetsGeometry>(
//                                   EdgeInsets.zero,
//                                 ),
//                             side: WidgetStateProperty.all<BorderSide>(
//                               BorderSide(color: Colors.transparent),
//                             ),
//                           ),
//                           buttonTextStyle: TextStyle(
//                             color: appTheme.gray200,
//                             fontSize:
//                                 isIPad(context) ? width * 0.035 : width * 0.055,
//                             fontWeight: FontWeight.w800,
//                             fontFamily: 'Lato',
//                           ),
//                         ),
//                         SizedBox(height: height * 0.015),
//                         _buildPrivacyPolicyRow(context),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//     );
//   }
//
//   Widget _buildMainStack(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Align(
//       alignment: Alignment.topCenter,
//       child: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//              InfiniteImageScroller()
//            ,
//             Align(
//               alignment: Alignment.topCenter,
//               child: CustomAppBar(
//                 actions: [
//                   Padding(
//                     padding: EdgeInsets.only(right: width * 0.02),
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//
//                       // 🔥 Makes entire area tappable
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         CupertinoIcons.clear_circled_solid,
//                         size: width * 0.07,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeaturesColumn(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Container(
//         width: double.maxFinite,
//         margin: EdgeInsets.only(left: isIPad(context) ? width * 0.25 : 70),
//         child: Column(
//           spacing: 14,
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "AI",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: isIPad(context) ? width * 0.065 : width * 0.08,
//                       fontFamily: 'Manrope',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   TextSpan(
//                     text: " Girlfriend",
//                     style: TextStyle(
//                       color: Color.fromRGBO(242, 113, 33, 1),
//
//                       fontSize: isIPad(context) ? width * 0.065 : width * 0.08,
//                       fontFamily: 'Manrope',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   TextSpan(
//                     text: " PRO",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: isIPad(context) ? width * 0.065 : width * 0.08,
//                       fontFamily: 'Manrope',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             SizedBox(
//               height: 1,
//             ),
//             SizedBox(
//               width: double.maxFinite,
//               child: _buildGenerateLyricsRow(
//                 context,
//                 studioOne: "assets/images/sub_heart.png",
//                 generateYour: "Unlimited Intimate Chats",
//               ),
//             ),
//             SizedBox(
//               width: double.maxFinite,
//               child: _buildGenerateLyricsRow(
//                 context,
//                 studioOne: "assets/images/sub_heart.png",
//                 generateYour: "Exclusive Role-Play Scenarios",
//               ),
//             ),
//             SizedBox(
//               width: double.maxFinite,
//               child: _buildGenerateLyricsRow(
//                 context,
//                 studioOne: "assets/images/sub_heart.png",
//                 generateYour: "Swipe through 100+ Desiring Profiles",
//               ),
//             ),
//             SizedBox(
//               width: double.maxFinite,
//               child: _buildGenerateLyricsRow(
//                 context,
//                 studioOne: "assets/images/sub_heart.png",
//                 generateYour: "Request Hot & Sassy Pictures",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPricingStack(
//     String title,
//     String trallingText,
//     bool isShow,
//     int index,
//   ) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Container(
//         height: height * 0.08, // Responsive height
//         width: double.infinity,
//         margin: EdgeInsets.symmetric(horizontal: width * 0.05),
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(width * 0.035),
//                     border: Border.all(
//                       color:
//                           _selectedIndex == index
//                               ? Color.fromRGBO(233, 64, 87, 1)
//                               : Color.fromRGBO(255, 255, 255, 0.2),
//                     ),
//                     gradient:
//                         _selectedIndex == index
//                             ? LinearGradient(
//                               colors: [
//                                 Color.fromRGBO(138, 35, 135, 1),
//                                 Color.fromRGBO(233, 64, 87, 1),
//                                 Color.fromRGBO(242, 113, 33, 1),
//                               ],
//                             )
//                             : const LinearGradient(
//                               colors: [Colors.transparent, Colors.transparent],
//                             ),
//                   ),
//                   width: double.infinity,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(width * 0.035),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: width * 0.035,
//                           vertical: height * 0.01,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Align(
//                               alignment: Alignment.center,
//                               child: SizedBox(
//                                 width: width * 0.18,
//                                 child: Text(
//                                   title,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     color: appTheme.whiteA700,
//                                     fontSize:
//                                         isIPad(context)
//                                             ? width * 0.025
//                                             : width * 0.032,
//                                     fontFamily: 'Lato',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (isShow)
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   bottom: height * 0.005,
//                                 ),
//                                 child: Text(
//                                   "(Less than \$0.77/week)",
//                                   style: TextStyle(
//                                     color: appTheme.gray200,
//                                     fontSize: width * 0.03,
//                                     fontFamily: 'Lato',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             Padding(
//                               padding: EdgeInsets.only(bottom: height * 0.005),
//                               child: Text(
//                                 _loading ? "" : trallingText,
//                                 style: TextStyle(
//                                   color: appTheme.whiteA700,
//                                   fontSize: width * 0.032,
//                                   fontFamily: 'Lato',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (isShow)
//               CustomElevatedButton(
//                 text: "Popular - 80% OFF",
//                 height: height * 0.027,
//                 width: width * 0.38,
//                 buttonTextStyle: TextStyle(
//                   color: appTheme.whiteA700,
//                   fontSize: width * 0.026,
//                   fontFamily: 'Lato',
//                   fontWeight: FontWeight.w800,
//                 ),
//                 buttonStyle: ElevatedButton.styleFrom(
//                   backgroundColor: appTheme.pinkA100,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(width * 0.015),
//                   ),
//                   elevation: 0,
//                   padding: EdgeInsets.zero,
//                 ),
//                 aligemnt: Alignment.topCenter,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDummyPricingStack(
//     String title,
//     String trallingText,
//     bool isShow,
//     int index,
//   ) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Container(
//         height: height * 0.08, // Responsive height
//         width: double.infinity,
//         margin: EdgeInsets.symmetric(horizontal: width * 0.05),
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(width * 0.035),
//                     border: Border.all(
//                       color:
//                           _selectedIndex == index
//                               ? Color.fromRGBO(233, 64, 87, 1)
//                               : Color.fromRGBO(255, 255, 255, 0.2),
//                     ),
//                     gradient:
//                         _selectedIndex == index
//                             ? LinearGradient(
//                               colors: [
//                                 Color.fromRGBO(138, 35, 135, 1),
//                                 Color.fromRGBO(233, 64, 87, 1),
//                                 Color.fromRGBO(242, 113, 33, 1),
//                               ],
//                             )
//                             : const LinearGradient(
//                               colors: [Colors.transparent, Colors.transparent],
//                             ),
//                   ),
//                   width: double.infinity,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(width * 0.035),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: width * 0.035,
//                           vertical: height * 0.01,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Align(
//                               alignment: Alignment.center,
//                               child: SizedBox(
//                                 width: width * 0.18,
//                                 child: Text(
//                                   title,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     color: appTheme.whiteA700,
//                                     fontSize:
//                                         isIPad(context)
//                                             ? width * 0.025
//                                             : width * 0.032,
//                                     fontFamily: 'Lato',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (isShow)
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   bottom: height * 0.005,
//                                 ),
//                                 child: Text(
//                                   "(Less than \$0.77/week)",
//                                   style: TextStyle(
//                                     color: appTheme.gray200,
//                                     fontSize: width * 0.03,
//                                     fontFamily: 'Lato',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             Padding(
//                               padding: EdgeInsets.only(bottom: height * 0.005),
//                               child: Text(
//                                 _loading ? "" : trallingText,
//                                 style: TextStyle(
//                                   color: appTheme.whiteA700,
//                                   fontSize: width * 0.032,
//                                   fontFamily: 'Lato',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (isShow)
//               CustomElevatedButton(
//                 text: "Popular - 80% OFF",
//                 height: height * 0.027,
//                 width: width * 0.38,
//                 buttonTextStyle: TextStyle(
//                   color: appTheme.whiteA700,
//                   fontSize: width * 0.026,
//                   fontFamily: 'Lato',
//                   fontWeight: FontWeight.w800,
//                 ),
//                 buttonStyle: ElevatedButton.styleFrom(
//                   backgroundColor: appTheme.pinkA100,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(width * 0.015),
//                   ),
//                   elevation: 0,
//                   padding: EdgeInsets.zero,
//                 ),
//                 aligemnt: Alignment.topCenter,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPricingSlider(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return _loading
//         ? const Center(child: CircularProgressIndicator())
//         : _products.isEmpty
//         ? const Center(child: Text('No subscriptions available'))
//         : Padding(
//           padding: EdgeInsets.only(
//             right: width * 0.08,
//             left: width * 0.08,
//             bottom: height * 0.01,
//           ),
//           child: SizedBox(
//             height: height * 0.2,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: _products.length,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     if (index != 1) SizedBox(height: height * 0.01),
//                     Align(
//                       child: PricingSliderItemWidget(
//                         products: _products,
//                         index: index,
//                         onPurchase: () {},
//                         selectedIndex: _selectedIndex,
//                         onSelected: (int newIndex) {
//                           setState(() {
//                             _selectedIndex = newIndex;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               separatorBuilder: (context, index) {
//                 return SizedBox(width: width * 0.03);
//               },
//             ),
//           ),
//         );
//   }
//
//   Widget _buildContainer(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: width * 0.08,
//         vertical: isIPad(context) ? height * 0.03 : height * 0.048,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(width * 0.05),
//           // border: Border.all(color:  Color.fromRGBO(233, 64, 87, 1),),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: width * 0.04,
//             vertical: height * 0.015,
//           ),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Just ",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Manrope',
//                       fontSize: width * 0.05,
//                       color: appTheme.whiteA700,
//                     ),
//                   ),
//                   if (Platform.isIOS)
//                     Text(
//                       "\$79.99 ",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Manrope',
//                         fontSize: width * 0.05,
//                         color: Color.fromRGBO(233, 64, 87, 1),
//                         decoration: TextDecoration.lineThrough,
//                         // <-- Adds center line
//                         decorationColor: Color.fromRGBO(233, 64, 87, 1),
//                         // Optional: match line color
//                         decorationThickness:
//                             2, // Optional: control line thickness
//                       ),
//                     ),
//                   Text(
//                     "${_getPrice("com.aigirlfriend.yearly")} per year",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontFamily: 'Manrope',
//                       fontSize: width * 0.05,
//                       color: appTheme.whiteA700,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: height * 0.005),
//               Text(
//                 "(less than 0.09 per day)",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Manrope',
//                   fontSize: width * 0.035,
//                   color: appTheme.whiteA700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPrivacyPolicyRow(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//
//     return Container(
//       width: double.maxFinite,
//       margin: EdgeInsets.symmetric(horizontal: width * 0.05),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () async {
//               final url = 'https://app.tripleit.ltd/privacy-policy/';
//               if (await canLaunchUrl(Uri.parse(url))) {
//                 await launchUrl(
//                   Uri.parse(url),
//                   mode:
//                       LaunchMode
//                           .externalApplication, // Ensures it opens in Safari
//                 );
//               } else {
//                 throw 'Could not launch $url';
//               }
//             },
//             child: Text(
//               "Privacy Policy",
//               style: TextStyle(
//                 color: appTheme.gray200.withAlpha(130),
//                 fontSize: width * 0.035,
//                 fontFamily: 'Lato',
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               _restorePurchases();
//             },
//             child: Text(
//               "Restore",
//               style: TextStyle(
//                 color: appTheme.gray200.withAlpha(130),
//                 fontSize: width * 0.035,
//                 fontFamily: 'Lato',
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               final url = 'https://app.tripleit.ltd/terms-of-use/';
//               if (await canLaunchUrl(Uri.parse(url))) {
//                 await launchUrl(
//                   Uri.parse(url),
//                   mode:
//                       LaunchMode
//                           .externalApplication, // Ensures it opens in Safari
//                 );
//               } else {
//                 throw 'Could not launch $url';
//               }
//             },
//             child: Text(
//               "Terms of Use",
//               style: TextStyle(
//                 color: appTheme.gray200.withAlpha(130),
//                 fontSize: width * 0.035,
//                 fontFamily: 'Lato',
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGenerateLyricsRow(
//     BuildContext context, {
//     required String studioOne,
//     required String generateYour,
//   }) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Row(
//       children: [
//         CustomImageview(imagePath: studioOne, height: 22, width: 22),
//         Padding(
//           padding: EdgeInsets.only(left: 14),
//           child: Text(
//             generateYour,
//             style: TextStyle(
//               color: appTheme.gray200,
//               fontSize: isIPad(context) ? width * 0.03 : width * 0.04,
//               fontFamily: 'Manrope',
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class PricingSliderItemWidget extends StatefulWidget {
//   const PricingSliderItemWidget({
//     super.key,
//     required this.products,
//     required this.index,
//     required this.onPurchase,
//     required this.onSelected,
//     required this.selectedIndex,
//   });
//
//   final List<ProductDetails> products;
//   final int index;
//   final VoidCallback onPurchase;
//   final ValueChanged<int> onSelected;
//   final int selectedIndex;
//
//   @override
//   State<PricingSliderItemWidget> createState() =>
//       _PricingSliderItemWidgetState();
// }
//
// class _PricingSliderItemWidgetState extends State<PricingSliderItemWidget> {
//   final List<String> _list = ["\$1.43/day", "\$3.33/mo", "\$3.25/week"];
//   final List<String> _list1 = ["Weekly", "Yearly", "Monthly"];
//
//   String extractLabel(String input) {
//     return input.split(' ')[0];
//   }
//
//   bool isIPad(BuildContext context) {
//     return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     final bool isSelected = widget.index == widget.selectedIndex;
//
//     return GestureDetector(
//       onTap: () {
//         widget.onSelected(widget.index);
//         widget.onPurchase();
//       },
//       child: Column(
//         children: [
//           Container(
//             width: width * 0.25, // Responsive width
//             padding: EdgeInsets.only(bottom: height * 0.012),
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(37, 37, 40, 0.5),
//               borderRadius: BorderRadius.circular(width * 0.025),
//               border: Border.all(
//                 color:
//                     isSelected
//                         ? Color.fromRGBO(233, 64, 87, 1)
//                         : Color.fromRGBO(255, 255, 255, 0.2),
//                 width: 1.13,
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (widget.index == 1)
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: height * 0.005),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(width * 0.026),
//                         topRight: Radius.circular(width * 0.026),
//                       ),
//                       gradient: LinearGradient(
//                         colors: [
//                           Color.fromRGBO(138, 35, 135, 1),
//                           Color.fromRGBO(233, 64, 87, 1),
//                           Color.fromRGBO(242, 113, 33, 1),
//                         ],
//                       ),
//                     ),
//                     child: Text(
//                       "Best Value",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: width * 0.03,
//                         color: appTheme.whiteA700,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: height * 0.012),
//                 Text(
//                   _list1[widget.index],
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: appTheme.whiteA700,
//                     fontSize: isIPad(context) ? width * 0.02 : width * 0.033,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Manrope',
//                   ),
//                 ),
//                 widget.index == 1
//                     ? SizedBox(height: height * 0.005)
//                     : SizedBox(height: height * 0.01),
//                 if (widget.index == 1)
//                   Text(
//                     "\$79.99 ",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Manrope',
//                       fontSize: isIPad(context) ? width * 0.02 : width * 0.036,
//                       color: Color.fromRGBO(233, 64, 87, 1),
//                       decoration: TextDecoration.lineThrough,
//                       decorationColor: Color.fromRGBO(233, 64, 87, 1),
//                       decorationThickness:
//                           2, // Optional: control line thickness
//                     ),
//                   ),
//                 if (widget.index == 1) SizedBox(height: height * 0.001),
//                 Text(
//                   widget.products[widget.index].price,
//                   style: TextStyle(
//                     color: appTheme.whiteA700,
//                     fontSize: isIPad(context) ? width * 0.02 : width * 0.036,
//                     fontWeight: FontWeight.w800,
//                     fontFamily: 'Manrope',
//                   ),
//                 ),
//                 widget.index == 1
//                     ? SizedBox(height: height * 0.0001)
//                     : SizedBox(height: height * 0.01),
//                 SizedBox(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     child: Divider(color: Color.fromRGBO(255, 255, 255, 0.2)),
//                   ),
//                 ),
//                 SizedBox(height: height * 0.006),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: width * 0.01),
//                   child: Text(
//                     "Less than",
//                     style: TextStyle(
//                       color:
//                           widget.index == 1
//                               ? Color.fromRGBO(233, 64, 87, 1)
//                               : appTheme.whiteA700,
//                       fontSize: isIPad(context) ? width * 0.02 : width * 0.03,
//                       fontWeight:
//                           widget.index == 1 ? FontWeight.w900 : FontWeight.w500,
//                       fontFamily: 'Manrope',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: height * 0.005,
//                     left: width * 0.015,
//                     right: width * 0.015,
//                   ),
//                   child: Text(
//                     _list[widget.index],
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: appTheme.whiteA700.withOpacity(0.8),
//                       fontSize: isIPad(context) ? width * 0.02 : width * 0.03,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Manrope',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class GradientContainer extends StatelessWidget {
//   const GradientContainer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       width: double.maxFinite,
//       height: 318,
//       margin: EdgeInsets.only(top: isIPad(context)?height *0.5:height * 0.35),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color.fromRGBO(0, 0, 0, 0.0), // Transparent
//             Color.fromRGBO(0, 0, 0, 0.2), // Transparent
//             Color.fromRGBO(0, 0, 0, 0.5), // Transparent
//             Color.fromRGBO(0, 0, 0, 0.8), // Transparent
//             Color.fromRGBO(0, 0, 0, 0.95), // Transparent
//             Color.fromRGBO(0, 0, 0, 0.95), // Transparent
//             Color.fromRGBO(0, 0, 0, 1), // Solid black
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class InfiniteImageScroller extends StatefulWidget {
//   @override
//   _InfiniteImageScrollerState createState() => _InfiniteImageScrollerState();
// }
//
// class _InfiniteImageScrollerState extends State<InfiniteImageScroller> {
//   final ScrollController _scrollController = ScrollController();
//   late Timer _timer;
//
//   final double imageWidth = 2500;
//   final double viewWidth = 1000;
//   final double initialOffset = Platform.isAndroid ?650:550; // start at +300px
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Start inside the middle copy
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(imageWidth + initialOffset);
//       }
//     });
//
//     _startAutoScroll();
//   }
//
//   void _startAutoScroll() {
//     _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
//       if (_scrollController.hasClients) {
//         double current = _scrollController.offset + 1;
//         _scrollController.jumpTo(current);
//
//         // When reaching the end of the second copy, reset back by one image width
//         if (current >= imageWidth * 2) {
//           _scrollController.jumpTo(current - imageWidth);
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       child: SizedBox(
//         height: 700,
//         width: viewWidth,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           controller: _scrollController,
//           physics: const NeverScrollableScrollPhysics(),
//           child: Row(
//             children: [
//               // only 3 copies are enough for seamless loop
//               Image.asset(
//                 'assets/images/subscription_top_new.png',
//                 width: imageWidth,
//                 fit: BoxFit.contain,
//               ),
//               Image.asset(
//                 'assets/images/subscription_top_new.png',
//                 width: imageWidth,
//                 fit: BoxFit.contain,
//               ),
//               Image.asset(
//                 'assets/images/subscription_top_new.png',
//                 width: imageWidth,
//                 fit: BoxFit.contain,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//

import 'dart:io';
import 'dart:ui';

import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../theme/theme.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../main/presentaion/main_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Color Palette (matches screenshot exactly)
// ─────────────────────────────────────────────────────────────────────────────
class _AppColors {
  static const bg = Color(0xFFF5F0EB);
  static const cardBg = Color(0xFFEFE9E2);
  static const white = Colors.white;
  static const featureCardBg = Color(0xFFFFFFFF);
  static const pricingSelected = Colors.white;
  static const pricingUnselected = Color(0xFFEDE7DF);
  static const bestValueGradientStart = Color(0xFF6BB8C9);
  static const bestValueGradientEnd = Color(0xFF4A9AB2);
  static const bestValueBorder = Color(0xFF5BAEC3);
  static const continueBtn = Color(0xFFDDC4A0);
  static const continueBtnText = Color(0xFF3A2A1A);
  static const titleText = Color(0xFF1A1A1A);
  static const bodyText = Color(0xFF2A2A2A);
  static const subtitleText = Color(0xFF666666);
  static const footerText = Color(0xFF777777);
  static const divider = Color(0xFFDDD5CC);
  static const selectedBorder = Color(0xFF3A3A3A);
  static const unselectedBorder = Colors.transparent;
  static const iconBg = Color(0xFFF0EBE3);
  static const iconColor = Color(0xFF3A3A3A);
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────────────────────────
class SubscriptionScreenTwo extends StatefulWidget {
  const SubscriptionScreenTwo({super.key});

  static const routeName = '/subscription-two';

  @override
  State<SubscriptionScreenTwo> createState() => _SubscriptionScreenTwoState();
}

class _SubscriptionScreenTwoState extends State<SubscriptionScreenTwo>
    with TickerProviderStateMixin {
  // 0 = Weekly, 1 = Yearly (middle/best value), 2 = Monthly
  int _selectedPlan = 1;

  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // IAP
  bool _loading = true;
  bool _isPurchasing = false;
  List<ProductDetails> _products = [];
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = [
    'com.ai_interior.weekly',
    'com.ai_interior.yearly',
    'com.ai_interior.monthly',
  ];

  // Pricing display data — order: Weekly, Yearly, Monthly
  final List<String> _planLabels = ['Weekly', 'Yearly', 'Monthly'];
  final List<String> _planFallbackPrices = ['\$9.99', '\$39.99', '\$12.99'];
  final List<String> _planSubLabels = [
    'Less than\n\$1.43/day',
    'Less than\n\$3.33/month',
    'Less than\n\$3.25/week',
  ];
  final List<String> _strikethrough = ['', '\$79.99', ''];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.72, initialPage: 1);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _initIAP();
  }

  Future<void> _initIAP() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        setState(() => _loading = false);
        return;
      }
      final response = await _iap.queryProductDetails(_productIds.toSet());
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

  String _priceFor(int index) {
    if (_loading || _products.isEmpty) return _planFallbackPrices[index];
    try {
      final id = _productIds[index];
      return _products.firstWhere((p) => p.id == id).price;
    } catch (_) {
      return _planFallbackPrices[index];
    }
  }

  void _onContinue() {
    if (_isPurchasing || _loading) return;
    setState(() => _isPurchasing = true);
    // Wire up actual IAP purchase here
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Pricing display data — order maps to _productIds: weekly, yearly, monthly
  final List<String> _list1 = ['Yearly Unlimited', 'Weekly Unlimited',];
  final List<String> _list2 = ['\$3.99/year', '\$9.99/week',];
  final List<String> _list4 = ['\$9.99/week', '\$39.99/year', '\$12.99/month'];

  // ───────────────────────────── build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final top = MediaQuery.of(context).padding.top;

    final height = size.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _AppColors.bg,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    // ── Carousel ─────────────────────────────────────────
                    _buildCarousel(size, top),

                    // ── Content ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 22),
                          _buildTitle(),
                          const SizedBox(height: 18),
                          _buildFeatureCard(),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: height * 0.23,
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _list1.length,
                              separatorBuilder:
                                  (_, __) => SizedBox(height: height * 0.01),
                              itemBuilder: (context, index) {
                                return _buildPricingStack(
                                      _list1[index],
                                      _list2[index],
                                      index == 0,
                                      index,
                                    );
                              },
                            ),
                          ),
                          _buildFinePrint(),
                          const SizedBox(height: 18),
                          _buildContinueButton(size),
                          const SizedBox(height: 18),
                          _buildFooter(),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (_isPurchasing)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Carousel ───────────────────────────────────────────────────────────────
  Widget _buildCarousel(Size size, double top) {
    return SizedBox(
      height: size.height * 0.28 + top,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: top + 16,
                    bottom: 8,
                    left: 6,
                    right: 6,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CustomImageview(
                      imagePath:
                          index == 0
                              ? "assets/images/sub_${index + 1}.jpg"
                              : "assets/images/sub_${index + 1}.png",
                    ),
                  ),
                );
              },
            ),
          ),
          // Close button
          Positioned(top: top + 10, right: 14, child: _buildCloseButton()),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

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
                              ? Color.fromRGBO(50, 116, 127, 1)
                              : Color.fromRGBO(255, 255, 255, 0.8),
                      width: 0.5
                    ),
                    gradient:
                        _selectedIndex == index
                            ? LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 218, 179, 1),
                                Color.fromRGBO(50, 116, 127, 1),
                              ],
                            )
                            : const LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 255, 255, 0.8),
                                Color.fromRGBO(255, 255, 255, 0.8),
                              ],
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
                                    color: Color.fromRGBO(46, 46, 46, 1),
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
                                    color: Color.fromRGBO(46, 46, 46, 1),
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
                                  color: Color.fromRGBO(46, 46, 46, 1),
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
                  backgroundColor: Color.fromRGBO(255, 218, 179, 1),
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

  Widget _buildDummyPricingStack(
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

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).maybePop();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.40),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 16),
      ),
    );
  }

  // ── Title ─────────────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Redesign Your Space with AI ',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: _AppColors.titleText,
              height: 1.35,
            ),
          ),
          TextSpan(text: '✨', style: TextStyle(fontSize: 22)),
        ],
      ),
    );
  }

  // ── Feature Card ──────────────────────────────────────────────────────────
  Widget _buildFeatureCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          _FeatureRow(
            image: "assets/images/sub_icon_1.png",
            label: 'Unlimited Design Renders',
          ),
          SizedBox(height: 10),
          _FeatureRow(
            image: "assets/images/sub_icon_2.png",
            label: 'Access All Styles',
          ),
          SizedBox(height: 10),
          _FeatureRow(
            image: "assets/images/sub_icon_3.png",
            label: 'Create Your Own Custom Spaces',
          ),
        ],
      ),
    );
  }

  // ── Pricing Row (3 cards) ─────────────────────────────────────────────────
  Widget _buildPricingRow(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (index) {
        final isSelected = _selectedPlan == index;
        final isBestValue = index == 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 5,
              right: index == 2 ? 0 : 5,
              top: isBestValue ? 0 : 10, // center card raised
            ),
            child: _PricingCard(
              label: _planLabels[index],
              price: _priceFor(index),
              subLabel: _planSubLabels[index],
              strikethrough: _strikethrough[index],
              isSelected: isSelected,
              isBestValue: isBestValue,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedPlan = index);
              },
            ),
          ),
        );
      }),
    );
  }

  // ── Fine print ────────────────────────────────────────────────────────────
  Widget _buildFinePrint() {
    return Text(
      'Only ${_priceFor(_selectedPlan)}/week, auto-renew, cancel anytime.',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12.5,
        color: Color(0xFF888888),
        fontFamily: 'Georgia',
        height: 1.4,
      ),
    );
  }

  // ── Continue Button ───────────────────────────────────────────────────────
  Widget _buildContinueButton(Size size) {
    return _ContinueButton(onPressed: _onContinue, isLoading: _isPurchasing);
  }

  // ── Footer ────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FooterLink(label: 'Terms Of Use', onTap: () {}),
        _FooterLink(label: 'Restore', onTap: () {}),
        _FooterLink(label: 'Privacy Policy', onTap: () {}),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pricing Card
// ─────────────────────────────────────────────────────────────────────────────
class _PricingCard extends StatelessWidget {
  final String label;
  final String price;
  final String subLabel;
  final String strikethrough;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const _PricingCard({
    required this.label,
    required this.price,
    required this.subLabel,
    required this.strikethrough,
    required this.isSelected,
    required this.isBestValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFEEE8E1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _AppColors.selectedBorder : Colors.transparent,
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 218, 179, 0.2),
                      Color.fromRGBO(50, 116, 127, 0.2),
                    ],
                  )
                  : LinearGradient(colors: [Colors.white, Colors.white]),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Best Value header
            if (isBestValue)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(249, 215, 177, 1),
                      Color.fromRGBO(159, 170, 154, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Text(
                  'Best Value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 12,
                    color: Color.fromRGBO(46, 46, 46, 1),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(8, isBestValue ? 10 : 14, 8, 12),
              child: Column(
                children: [
                  // Plan label
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _AppColors.titleText,
                    ),
                  ),

                  // Strikethrough price (Yearly only)
                  if (strikethrough.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      strikethrough,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFCC4444),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFFCC4444),
                        decorationThickness: 1.8,
                      ),
                    ),
                  ],

                  const SizedBox(height: 4),

                  // Price
                  Text(
                    price,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _AppColors.titleText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Divider
                  Container(height: 0.8, color: const Color(0xFFDDD5CC)),

                  const SizedBox(height: 8),

                  // Sub-label
                  Text(
                    subLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color:
                          isBestValue
                              ? const Color(0xFF4A9EBA)
                              : const Color(0xFF555555),
                      height: 1.4,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature Row
// ─────────────────────────────────────────────────────────────────────────────
class _FeatureRow extends StatelessWidget {
  final String image;
  final String label;

  const _FeatureRow({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageview(
          imagePath: image,
          height: 32,
          width: 32,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 15,
              color: _AppColors.bodyText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Continue Button (with press animation)
// ─────────────────────────────────────────────────────────────────────────────
class _ContinueButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _ContinueButton({required this.onPressed, required this.isLoading});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.96,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onPressed();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: _AppColors.continueBtn,
            borderRadius: BorderRadius.circular(30),
          ),
          child:
              widget.isLoading
                  ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _AppColors.continueBtnText,
                      ),
                    ),
                  )
                  : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: _AppColors.continueBtnText,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: _AppColors.continueBtnText,
                        size: 22,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer Link
// ─────────────────────────────────────────────────────────────────────────────
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
          color: _AppColors.footerText,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Room Scene Painter (matches screenshot rooms closely)
// ─────────────────────────────────────────────────────────────────────────────
enum _RoomScene { living, kitchen, study }

class _RoomPainter extends CustomPainter {
  final _RoomScene scene;

  _RoomPainter(this.scene);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background wall
    final wallColor =
        scene == _RoomScene.kitchen
            ? const Color(0xFFCFCFC4)
            : scene == _RoomScene.living
            ? const Color(0xFFE8DFD2)
            : const Color(0xFFD8DDD4);

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = wallColor);

    // Floor
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.62, w, h * 0.38),
      Paint()..color = const Color(0xFFC4A882),
    );

    switch (scene) {
      case _RoomScene.kitchen:
        _drawKitchen(canvas, size);
        break;
      case _RoomScene.living:
        _drawLiving(canvas, size);
        break;
      case _RoomScene.study:
        _drawStudy(canvas, size);
        break;
    }
  }

  void _drawKitchen(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Upper cabinets — blue-grey (matches screenshot)
    final cabinetPaint = Paint()..color = const Color(0xFF4A7EA0);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.04, w, h * 0.26), cabinetPaint);

    // Cabinet door lines
    final linePaint =
        Paint()
          ..color = const Color(0xFF3A6A88)
          ..strokeWidth = 1.0;
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset(w * i / 4, h * 0.04),
        Offset(w * i / 4, h * 0.30),
        linePaint,
      );
      // Horizontal mid line
      canvas.drawLine(
        Offset(w * (i - 1) / 4 + 4, h * 0.17),
        Offset(w * i / 4 - 4, h * 0.17),
        linePaint,
      );
    }

    // Counter top — dark
    final darkTop = Paint()..color = const Color(0xFF2A3540);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.50, w, h * 0.045), darkTop);

    // Lower cabinets — warm wood
    final lowerCab = Paint()..color = const Color(0xFFD4B896);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.545, w, h * 0.455), lowerCab);

    // Lower cabinet lines
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset(w * i / 4, h * 0.545),
        Offset(w * i / 4, h),
        Paint()
          ..color = const Color(0xFFBCA07A)
          ..strokeWidth = 1.0,
      );
    }

    // Island (centered, wood)
    final islandPaint = Paint()..color = const Color(0xFFB8936A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.58, w * 0.70, h * 0.42),
        const Radius.circular(4),
      ),
      islandPaint,
    );
    // Island dark top
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.56, w * 0.70, h * 0.045),
        const Radius.circular(2),
      ),
      darkTop,
    );

    // Pendant lights
    final pendantPaint = Paint()..color = const Color(0xFFD4B860);
    for (int i = 0; i < 3; i++) {
      final x = w * (0.30 + i * 0.20);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, h * 0.44),
        Paint()
          ..color = const Color(0xFF999999)
          ..strokeWidth = 1.0,
      );
      canvas.drawCircle(Offset(x, h * 0.46), 9, pendantPaint);
      canvas.drawCircle(
        Offset(x, h * 0.46),
        9,
        Paint()..color = const Color(0xFFFFE88A).withOpacity(0.4),
      );
    }
  }

  void _drawLiving(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sofa back
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.44, w * 0.92, h * 0.13),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFD4CBBA),
    );
    // Sofa seat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.52, w * 0.92, h * 0.30),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFE2D8C8),
    );
    // Cushions
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.51, w * 0.27, h * 0.22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFC8BFB0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.63, h * 0.51, w * 0.27, h * 0.22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFC8BFB0),
    );

    // Side table
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.38, w * 0.18, h * 0.20),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFA07850),
    );

    // Wall art — left
    canvas.drawRect(
      Rect.fromLTWH(w * 0.08, h * 0.07, w * 0.28, h * 0.28),
      Paint()..color = const Color(0xFFD0C8B8),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.09, h * 0.08, w * 0.26, h * 0.26),
      Paint()..color = const Color(0xFFB8D4B0),
    );

    // Floor lamp
    canvas.drawRect(
      Rect.fromLTWH(w * 0.84, h * 0.08, 3, h * 0.42),
      Paint()..color = const Color(0xFF999999),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.77, h * 0.06, 26, 16),
      Paint()..color = const Color(0xFFEED89A),
    );
  }

  void _drawStudy(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Two wall shelves
    final shelfPaint = Paint()..color = const Color(0xFFB8956A);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.14, w * 0.92, h * 0.04),
      shelfPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.30, w * 0.92, h * 0.04),
      shelfPaint,
    );

    // Books
    final bookColors = [
      const Color(0xFF6B8E6B),
      const Color(0xFF8E7B6B),
      const Color(0xFF6B7B8E),
      const Color(0xFF8E8E6B),
      const Color(0xFF9E6B6B),
      const Color(0xFF7B8E7B),
    ];
    for (int shelf = 0; shelf < 2; shelf++) {
      final top = h * (shelf == 0 ? 0.02 : 0.18);
      for (int b = 0; b < 6; b++) {
        canvas.drawRect(
          Rect.fromLTWH(w * 0.06 + b * (w * 0.145), top, w * 0.115, h * 0.13),
          Paint()..color = bookColors[b % bookColors.length],
        );
      }
    }

    // Desk
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.60, w, h * 0.055),
      Paint()..color = const Color(0xFFB8956A),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.635, w * 0.05, h * 0.37),
      Paint()..color = const Color(0xFF9A7A52),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.90, h * 0.635, w * 0.05, h * 0.37),
      Paint()..color = const Color(0xFF9A7A52),
    );

    // Plant
    canvas.drawRect(
      Rect.fromLTWH(w * 0.70, h * 0.52, w * 0.14, h * 0.10),
      Paint()..color = const Color(0xFF8B6914),
    );
    canvas.drawCircle(
      Offset(w * 0.775, h * 0.46),
      w * 0.10,
      Paint()..color = const Color(0xFF5A8A5A),
    );
    canvas.drawCircle(
      Offset(w * 0.73, h * 0.44),
      w * 0.07,
      Paint()..color = const Color(0xFF4A7A4A),
    );

    // Monitor on desk
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.44, w * 0.36, h * 0.20),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2A3035),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.29, h * 0.62, w * 0.08, h * 0.04),
      Paint()..color = const Color(0xFF444444),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
