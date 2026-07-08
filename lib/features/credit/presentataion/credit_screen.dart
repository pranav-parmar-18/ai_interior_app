// import 'dart:async';
// import 'dart:io';
//
// import 'package:ai_interior/bloc/add_credits/add_credits_bloc.dart';
// import 'package:ai_interior/widgets/custom_imageview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../models/add_credit_model_response.dart';
// import '../../../widgets/custom_elevated_button.dart';
// import '../../main/presentaion/main_screen.dart';
//
// int selectedIndex = 6;
//
// class CreditScreen extends StatefulWidget {
//   const CreditScreen({super.key});
//
//   static const routeName = "/credit";
//
//   @override
//   State<CreditScreen> createState() => _CreditScreenState();
// }
//
// class _CreditScreenState extends State<CreditScreen> {
//   final AddCreditsBloc _addCreditsBloc = AddCreditsBloc();
//   AddCreditResponse? addCreditResponse;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   final InAppPurchase _iap = InAppPurchase.instance;
//   List<ProductDetails> _products = [];
//
//   final List<String> _productIds = [
//     'com.ai_interior.credits_100',
//     'com.ai_interior.credits_300',
//     'com.ai_interior.credits_500',
//     'com.ai_interior.credits_700',
//     'com.ai_interior.credits_1000',
//     'com.ai_interior.credits_1300',
//     'com.ai_interior.credits_1500',
//   ];
//
//   bool _isPurchasing = false;
//
//   bool _loading = true;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCredits();
//     _initialize();
//   }
//
//   String credits = "";
//
//   Future<void> getCredits() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     credits = preferences.getString('credits') ?? "";
//   }
//
//   Future<void> setCredits(String userId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString('credits', userId);
//   }
//
//   Future<void> _loadProducts() async {
//     final response = await _iap.queryProductDetails(_productIds.toSet());
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
//       setState(() {
//         _products = sortedProducts;
//         _loading = false;
//       });
//     }
//   }
//
//   void _buy(ProductDetails product) {
//     final purchaseParam = PurchaseParam(productDetails: product);
//     _iap.buyNonConsumable(
//       purchaseParam: purchaseParam,
//     ); // Used for subscriptions too
//   }
//
//   void _buyAndroid(ProductDetails product) {
//     final purchaseParam = PurchaseParam(productDetails: product);
//     _iap.buyConsumable(
//       purchaseParam: purchaseParam,
//       autoConsume: true
//     ); // Used for subscriptions too
//   }
//
//   void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
//     for (final purchase in purchases) {
//       if (purchase.status == PurchaseStatus.purchased ||
//           purchase.status == PurchaseStatus.restored) {
//         if (mounted) {
//           setState(() => _isPurchasing = false);
//         }
//
//         print('✅ Purchased: ${purchase.productID}');
//         print('✅ Purchase ID: ${purchase.purchaseID}');
//
//         // 🔹 Deliver credits
//         if (Platform.isAndroid) {
//           print("ANDROID ");
//           _addCreditsBloc.add(
//             AddCreditsDataEvent(
//               purchaseData: {
//                 "transactionId": purchase.purchaseID.toString(),
//                 "product_id": purchase.productID.toString(),
//               },
//             ),
//           );
//           // 3) Consume on Android via platform addition
//           try {
//             final androidAddition = InAppPurchase.instance
//                 .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//             final billingResult = await androidAddition.consumePurchase(purchase);
//             print('✅ consume result code: ${billingResult.responseCode}');
//           } catch (e, st) {
//             print('❌ consume error: $e\n$st');
//           }
//
//         }
//         else {
//           // iOS (no consumption needed)
//           _addCreditsBloc.add(
//             AddCreditsDataEvent(
//               purchaseData: {
//                 "transactionId": purchase.purchaseID.toString(),
//               },
//             ),
//           );
//         }
//       } else if (purchase.status == PurchaseStatus.error ||
//           purchase.status == PurchaseStatus.canceled) {
//         print('❌ Purchase error: ${purchase.error}');
//         if (mounted) {
//           setState(() => _isPurchasing = false);
//         }
//       }
//
//       // 🔹 Always complete the purchase if required
//       if (purchase.pendingCompletePurchase) {
//         await _iap.completePurchase(purchase);
//         print('✅ Completed purchase: ${purchase.productID}');
//       }
//     }
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
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(13, 13, 16, 1),
//       appBar: _buildAppBar(context),
//       body: BlocConsumer<AddCreditsBloc, AddCreditsState>(
//         bloc: _addCreditsBloc,
//         listener: (context, state) {
//           if (state is AddCreditsSuccessState) {
//             addCreditResponse = state.categoryModalResponse;
//             print("CREDIT RES: ${addCreditResponse?.result?.credit}");
//             setState(() {
//               selectedIndex = 0;
//               setCredits(
//                 double.tryParse(
//                       addCreditResponse?.result?.credit?.toString() ?? "0",
//                     )?.toInt().toString() ??
//                     "0",
//               );
//               getCredits();
//             });
//           } else if (state is AddCreditsExceptionState ||
//               state is AddCreditsFailureState) {}
//         },
//         builder: (context, state) {
//           return _isPurchasing
//               ? Stack(
//                 children: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(height: height * 0.07),
//                         CustomImageview(
//                           imagePath: "assets/images/heart_icon.png",
//                           height: height * 0.12,
//                           width: width * 0.3,
//                           fit: isIPad(context) ? BoxFit.contain : null,
//                         ),
//                         SizedBox(height: height * 0.05),
//
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: "Get Credits for",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 28,
//                                   fontFamily: 'Sora',
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: "AI",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 28,
//                                   fontFamily: 'Sora',
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: " Girlfriend",
//                                 style: TextStyle(
//                                   color: Color.fromRGBO(242, 113, 33, 1),
//                                   fontSize: 28,
//                                   fontFamily: 'Sora',
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: height * 0.02),
//                         Container(
//                           width: width * 0.9,
//                           height: height * 0.07,
//                           decoration: BoxDecoration(
//                             color: Color.fromRGBO(37, 37, 40, 1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15.0,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Balance',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontFamily: 'Sora',
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     CustomImageview(
//                                       imagePath: "assets/images/heart_icon.png",
//                                       height: 26,
//                                       width: 24,
//                                     ),
//                                     SizedBox(width: 7),
//                                     Text(
//                                       credits,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20,
//                                         fontFamily: 'Sora',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: height * 0.05),
//                         VisibilitySelector(),
//                       ],
//                     ),
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
//                             backgroundColor: Color.fromRGBO(233, 64, 87, 1),
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
//               : Align(
//                 alignment: Alignment.center,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: height * 0.07),
//                     CustomImageview(
//                       imagePath: "assets/images/heart_icon.png",
//                       height: height * 0.12,
//                       width: width * 0.3,
//                       fit: isIPad(context) ? BoxFit.contain : null,
//                     ),
//                     SizedBox(height: height * 0.05),
//
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Get Credits for",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 28,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "AI",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 28,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           TextSpan(
//                             text: " Girlfriend",
//                             style: TextStyle(
//                               color: Color.fromRGBO(242, 113, 33, 1),
//                               fontSize: 28,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: height * 0.02),
//                     Container(
//                       width: width * 0.9,
//                       height: height * 0.07,
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(37, 37, 40, 1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Balance',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontFamily: 'Sora',
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 CustomImageview(
//                                   imagePath: "assets/images/heart_icon.png",
//                                   height: 26,
//                                   width: 24,
//                                 ),
//                                 SizedBox(width: 7),
//                                 Text(
//                                   credits,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontFamily: 'Sora',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: height * 0.05),
//                     VisibilitySelector(),
//                   ],
//                 ),
//               );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 45),
//         child: CustomElevatedButton(
//           height: isIPad(context) ? height * 0.07 : null,
//           text: 'Continue',
//           onPressed: () {
//             setState(() {
//               _isPurchasing = true;
//             });
//             if(Platform.isAndroid){
//               _buyAndroid(_products[selectedIndex]);
//             }else{
//             _buy(_products[selectedIndex]);}
//           },
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       automaticallyImplyLeading: false,
//       centerTitle: true,
//       title: Text(
//         "Add Credits",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 28,
//           fontFamily: 'Sora',
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 15.0),
//           child: GestureDetector(
//             onTap: () {
//               HapticFeedback.mediumImpact();
//
//               Navigator.of(context).pop();
//             },
//             child: CustomImageview(
//               imagePath: "assets/images/cancel_btn_img.png",
//               height: 45,
//               width: 45,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class VisibilitySelector extends StatefulWidget {
//   VisibilitySelector({super.key});
//
//   @override
//   State<VisibilitySelector> createState() => _VisibilitySelectorState();
// }
//
// class _VisibilitySelectorState extends State<VisibilitySelector> {
//   String selectedOption = '1500';
//
//   BoxDecoration getBoxDecoration(bool isSelected) {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(20),
//       gradient: LinearGradient(
//         begin: Alignment(0, 0.5),
//         end: Alignment(1, 0.5),
//         colors:
//             isSelected
//                 ? [
//                   Color.fromRGBO(138, 35, 135, 0.3),
//                   Color.fromRGBO(233, 64, 87, 0.3),
//                   Color.fromRGBO(242, 113, 33, 0.3),
//                 ]
//                 : [
//                   Color.fromRGBO(37, 37, 40, 1),
//                   Color.fromRGBO(37, 37, 40, 1),
//                 ],
//       ),
//       border:
//           isSelected
//               ? Border.all(color: Color.fromRGBO(233, 64, 87, 1))
//               : Border.all(color: Color.fromRGBO(255, 255, 255, 0.2)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: isIPad(context) ? 61 : 25.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     HapticFeedback.mediumImpact();
//                     selectedOption = '100';
//                     selectedIndex = 0;
//                   });
//                 },
//                 child: Container(
//                   width: width * 0.28,
//                   height: height * 0.085,
//                   decoration: getBoxDecoration(selectedOption == '100'),
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "\$0.99",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//
//                         children: [
//                           CustomImageview(
//                             imagePath: "assets/images/heart_icon.png",
//                             height: 26,
//                             width: 24,
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             '100',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: width * 0.02),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     HapticFeedback.mediumImpact();
//
//                     selectedOption = '300';
//                     selectedIndex = 1;
//                   });
//                 },
//                 child: Container(
//                   width: width * 0.28,
//                   height: height * 0.085,
//                   decoration: getBoxDecoration(selectedOption == '300'),
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "\$2.99",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//
//                         children: [
//                           CustomImageview(
//                             imagePath: "assets/images/heart_icon.png",
//                             height: 26,
//                             width: 24,
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             '300',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: width * 0.02),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     HapticFeedback.mediumImpact();
//
//                     selectedOption = '500';
//                     selectedIndex = 2;
//                   });
//                 },
//                 child: Container(
//                   width: width * 0.28,
//                   height: height * 0.085,
//                   decoration: getBoxDecoration(selectedOption == '500'),
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "\$4.99",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//
//                         children: [
//                           CustomImageview(
//                             imagePath: "assets/images/heart_icon.png",
//                             height: 26,
//                             width: 24,
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             '500',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.02),
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     HapticFeedback.mediumImpact();
//
//                     selectedOption = '700';
//                     selectedIndex = 3;
//                   });
//                 },
//                 child: Container(
//                   width: width * 0.28,
//                   height: height * 0.085,
//                   decoration: getBoxDecoration(selectedOption == '700'),
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "\$6.99",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//
//                         children: [
//                           CustomImageview(
//                             imagePath: "assets/images/heart_icon.png",
//                             height: 26,
//                             width: 24,
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             '700',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: width * 0.02),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     HapticFeedback.mediumImpact();
//
//                     selectedOption = '1000';
//                     selectedIndex = 4;
//                   });
//                 },
//                 child: Container(
//                   width: width * 0.28,
//                   height: height * 0.085,
//                   decoration: getBoxDecoration(selectedOption == '1000'),
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "\$9.99",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//
//                         children: [
//                           CustomImageview(
//                             imagePath: "assets/images/heart_icon.png",
//                             height: 26,
//                             width: 24,
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             '1000',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: width * 0.02),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     HapticFeedback.mediumImpact();
//
//                     selectedOption = '1300';
//                     selectedIndex = 5;
//                   });
//                 },
//                 child: Container(
//                   width: width * 0.28,
//                   height: height * 0.085,
//                   decoration: getBoxDecoration(selectedOption == '1300'),
//                   padding: EdgeInsets.all(5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "\$12.99",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//
//                         children: [
//                           CustomImageview(
//                             imagePath: "assets/images/heart_icon.png",
//                             height: 26,
//                             width: 24,
//                           ),
//                           SizedBox(width: 7),
//                           Text(
//                             '1300',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontFamily: 'Sora',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.02),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 HapticFeedback.mediumImpact();
//                 selectedOption = '1500';
//                 selectedIndex = 6;
//               });
//             },
//             child: Container(
//               width: width * 0.9,
//               height: height * 0.075,
//               decoration: getBoxDecoration(selectedOption == '1500'),
//               padding: EdgeInsets.all(5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "\$14.99",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Sora',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//
//                     children: [
//                       CustomImageview(
//                         imagePath: "assets/images/heart_icon.png",
//                         height: 26,
//                         width: 24,
//                       ),
//                       SizedBox(width: 7),
//                       Text(
//                         '1500',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:ai_interior/bloc/add_credits/add_credits_bloc.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:ai_interior/utils/responsive_utils.dart';

import '../../../models/add_credit_model_response.dart';
import '../../home/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main/presentaion/main_screen.dart';

// ─── Color tokens ─────────────────────────────────────────────────────────────
const _bg            = Color(0xFFF2EDE8);
const _cardBg        = Color(0xFFFFFFFF);
const _balanceBg     = Color(0xFFFFD9A8);
const _selectedBg    = Color(0xFFFFF0E0);
const _selectedBorder= Color(0xFF8B4513);
const _titleBrown    = Color(0xFF3D1C08);
const _priceBrown    = Color(0xFF5C3317);
const _amountBrown   = Color(0xFF3D1C08);
const _continueText  = Color(0xFF4A2F18);

// ─── Product IDs (must match Play Console / App Store Connect) ────────────────
const _productIds = [
  'com.ai_interior.credits_100',
  'com.ai_interior.credits_300',
  'com.ai_interior.credits_500',
  'com.ai_interior.credits_700',
  'com.ai_interior.credits_1000',
  'com.ai_interior.credits_1300',
  'com.ai_interior.credits_1500',
];

/// Fallback display data when IAP products haven't loaded yet.
class _FallbackPackage {
  final String price;
  final int credits;
  const _FallbackPackage(this.price, this.credits);
}

const _fallback = [
  _FallbackPackage('\$0.99',  100),
  _FallbackPackage('\$2.99',  300),
  _FallbackPackage('\$4.99',  500),
  _FallbackPackage('\$6.99',  700),
  _FallbackPackage('\$9.99',  1000),
  _FallbackPackage('\$12.99', 1300),
  _FallbackPackage('\$14.99', 1500),
];

// ─── Screen ───────────────────────────────────────────────────────────────────
class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  static const routeName = '/credits-screen';

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  final AddCreditsBloc _addCreditsBloc = AddCreditsBloc();

  int _selectedIndex = 0;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [

  ];
  AddCreditResponse? _addCreditResponse;

  bool _loadingProducts = true;
  bool _isPurchasing    = false;

  // ── Balance (replace with your actual source) ─────────────────────────────
  int _balance = 50;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // ── IAP bootstrap ─────────────────────────────────────────────────────────
  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      if (mounted) {
        setState(() => _loadingProducts = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('In-App Purchases not available')),
        );
      }
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('Purchase Stream Error: $error'),
    );

    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds.toSet());

    if (response.error != null) {
      debugPrint('Product query error: ${response.error}');
      if (mounted) setState(() => _loadingProducts = false);
      return;
    }

    // Keep the same order as _productIds
    final sorted = _productIds
        .map((id) {
      try {
        return response.productDetails
            .firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    })
        .whereType<ProductDetails>()
        .toList();

    if (mounted) setState(() { _products = sorted; _loadingProducts = false; });
  }

  // ── Purchase ──────────────────────────────────────────────────────────────
  void _onContinue() {
    if (_products.isEmpty || _isPurchasing) return;

    final product = _products[_selectedIndex];
    setState(() => _isPurchasing = true);

    // Credits are consumable — use buyConsumable
    print("HELLO  BUY ");
    final param = PurchaseParam(productDetails: product);
    _iap.buyConsumable(purchaseParam: param);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (mounted) setState(() => _isPurchasing = false);
          debugPrint('✅ Purchased: ${purchase.productID}');

          if (Platform.isAndroid) {
            _addCreditsBloc.add(
              AddCreditsDataEvent(purchaseData: {
                'transactionId': purchase.purchaseID.toString(),
                'product_id'  : purchase.productID.toString(),
              }),
            );
            try {
              final androidAddition = InAppPurchase.instance
                  .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
              final result = await androidAddition.consumePurchase(purchase);
              debugPrint('✅ consume code: ${result.responseCode}');
            } catch (e) {
              debugPrint('❌ consume error: $e');
            }
          } else {
            _addCreditsBloc.add(
              AddCreditsDataEvent(purchaseData: {
                'transection_id': purchase.purchaseID.toString(),
              }),
            );
          }

        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          debugPrint('❌ Purchase failed: ${purchase.error}');
          if (mounted) setState(() => _isPurchasing = false);

        case PurchaseStatus.pending:
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
        debugPrint('✅ Completed: ${purchase.productID}');
      }
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _priceFor(int index) {
    if (_products.isNotEmpty && index < _products.length) {
      return _products[index].price;
    }
    return index < _fallback.length ? _fallback[index].price : '';
  }

  int _creditsFor(int index) {
    // Parse credits from product id suffix, e.g. "…credits_300" → 300
    if (_products.isNotEmpty && index < _products.length) {
      final id = _products[index].id;
      final suffix = id.split('_').last;
      return int.tryParse(suffix) ?? _fallback[index].credits;
    }
    return index < _fallback.length ? _fallback[index].credits : 0;
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final bottom = mq.padding.bottom;

    final isWide = r.isTablet(context);
    final isLandscape = r.isLandscape(context);

    return Scaffold(
      backgroundColor: _bg,
      body: BlocConsumer<AddCreditsBloc, AddCreditsState>(
        bloc: _addCreditsBloc,
        listener: (context, state) {
          if (state is AddCreditsSuccessState) {
            _addCreditResponse = state.categoryModalResponse;
            final addedCreditStr = _addCreditResponse?.result?.credit;
            if (addedCreditStr != null) {
              int currentCredits = int.tryParse(creditsNotifier.value) ?? 0;
              int addedCredits = int.tryParse(addedCreditStr) ?? 0;
              final newCredits = (currentCredits + addedCredits).toString();
              creditsNotifier.value = newCredits;
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('credits', newCredits);
              });
            }
            setState(() { _selectedIndex = 0; });
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isProcessing = _isPurchasing || state is AddCreditsLoadingState;

          Widget bodyContent;

          if (isLandscape) {
            bodyContent = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 45,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      r.verticalSpace(context, 12),
                      CustomImageview(
                        imagePath: 'assets/images/coin_stack.png',
                        height: r.adaptiveValue(context, mobile: 110, tablet: 180),
                        width:  r.adaptiveValue(context, mobile: 110, tablet: 180),
                        fit: BoxFit.contain,
                      ),
                      r.verticalSpace(context, 16),
                      Text(
                        'Get Credits for\nAI Interior Design',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: r.sp(context, 26),
                          fontWeight: FontWeight.w500,
                          color: _titleBrown,
                          height: 1.2,
                          fontFamily: 'Georgia',
                          letterSpacing: -0.5,
                        ),
                      ),
                      r.verticalSpace(context, 16),
                      _BalanceBar(balance: _balance),
                    ],
                  ),
                ),
                r.horizontalSpace(context, 24),
                Expanded(
                  flex: 55,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      r.verticalSpace(context, 12),
                      _loadingProducts
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CircularProgressIndicator(
                                color: _selectedBorder,
                              ),
                            )
                          : _CreditGrid(
                              count: _productIds.length,
                              selectedIndex: _selectedIndex,
                              priceFor: _priceFor,
                              creditsFor: _creditsFor,
                              onSelect: (i) =>
                                  setState(() => _selectedIndex = i),
                              isWide: isWide,
                            ),
                      r.verticalSpace(context, 20),
                      _ContinueButton(
                        onTap: isProcessing ? null : _onContinue,
                        isLoading: isProcessing,
                        label: _loadingProducts
                            ? 'Loading…'
                            : 'Continue  •  ${_priceFor(_selectedIndex)}',
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            bodyContent = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                r.verticalSpace(context, isWide ? 12 : 4),

                // Coin illustration
                CustomImageview(
                  imagePath: 'assets/images/coin_stack.png',
                  height: r.adaptiveValue(context, mobile: 130, tablet: 200),
                  width:  r.adaptiveValue(context, mobile: 130, tablet: 200),
                  fit: BoxFit.contain,
                ),
                r.verticalSpace(context, isWide ? 28 : 16),

                // Title
                Text(
                  'Get Credits for\nAI Interior Design',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.sp(context, 28),
                    fontWeight: FontWeight.w500,
                    color: _titleBrown,
                    height: 1.2,
                    fontFamily: 'Georgia',
                    letterSpacing: -0.5,
                  ),
                ),
                r.verticalSpace(context, isWide ? 28 : 18),

                // Balance bar
                _BalanceBar(balance: _balance),
                r.verticalSpace(context, isWide ? 20 : 12),

                // Grid or loading
                _loadingProducts
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                          color: _selectedBorder,
                        ),
                      )
                    : _CreditGrid(
                        count: _productIds.length,
                        selectedIndex: _selectedIndex,
                        priceFor: _priceFor,
                        creditsFor: _creditsFor,
                        onSelect: (i) =>
                            setState(() => _selectedIndex = i),
                        isWide: isWide,
                      ),
              ],
            );
          }

          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                _Header(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      r.adaptiveValue(context, mobile: 20, tablet: 40),
                      0,
                      r.adaptiveValue(context, mobile: 20, tablet: 40),
                      bottom + 16,
                    ),
                    child: Column(
                      children: [
                        bodyContent,
                        if (!isLandscape) ...[
                          r.verticalSpace(context, 24),
                          _ContinueButton(
                            onTap: isProcessing ? null : _onContinue,
                            isLoading: isProcessing,
                            label: _loadingProducts
                                ? 'Loading…'
                                : 'Continue  •  ${_priceFor(_selectedIndex)}',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.adaptiveValue(context, mobile: 16, tablet: 32),
        r.hp(context, 14),
        r.adaptiveValue(context, mobile: 16, tablet: 32),
        0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Add Credits',
            style: TextStyle(
              fontSize: r.sp(context, 22),
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E2E2E),
              letterSpacing: -0.3,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: r.adaptiveValue(context, mobile: 32, tablet: 42),
                height: r.adaptiveValue(context, mobile: 32, tablet: 42),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: r.adaptiveValue(context, mobile: 18, tablet: 24),
                  color: const Color(0xFF5C5348),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Balance bar ──────────────────────────────────────────────────────────────
class _BalanceBar extends StatelessWidget {
  final int balance;
  const _BalanceBar({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(context, 20),
        vertical: r.hp(context, 16),
      ),
      decoration: BoxDecoration(
        color: _balanceBg,
        borderRadius: BorderRadius.circular(r.radius(context, 18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Balance',
            style: TextStyle(
              fontSize: r.sp(context, 17),
              fontWeight: FontWeight.w500,
              color: _titleBrown,
            ),
          ),
          Row(
            children: [
              _CoinIcon(size: r.adaptiveValue(context, mobile: 22, tablet: 28)),
              SizedBox(width: r.wp(context, 6)),
              ValueListenableBuilder<String>(
                valueListenable: creditsNotifier,
                builder: (context, credits, _) {
                  return Text(
                    creditsNotifier.value.toString(),
                    style: TextStyle(
                      fontSize: r.sp(context, 16),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Coin icon ────────────────────────────────────────────────────────────────
class _CoinIcon extends StatelessWidget {
  final double size;
  const _CoinIcon({required this.size});

  @override
  Widget build(BuildContext context) => CustomImageview(
    imagePath: 'assets/images/credit.png',
    width: size,
    height: size,
  );
}

// ─── Credit grid ──────────────────────────────────────────────────────────────
class _CreditGrid extends StatelessWidget {
  final int count;
  final int selectedIndex;
  final String Function(int) priceFor;
  final int Function(int) creditsFor;
  final ValueChanged<int> onSelect;
  final bool isWide;

  const _CreditGrid({
    required this.count,
    required this.selectedIndex,
    required this.priceFor,
    required this.creditsFor,
    required this.onSelect,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final gridCount = count - 1;
    final cols = r.isLandscape(context)
        ? (r.isTablet(context) ? 4 : 3)
        : (r.isTablet(context) ? 3 : 3);

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: r.wp(context, 10),
            mainAxisSpacing: r.hp(context, 10),
            childAspectRatio: r.isTablet(context) ? 1.6 : 1.35,
          ),
          itemCount: gridCount,
          itemBuilder: (ctx, i) => _CreditCard(
            price: priceFor(i),
            credits: creditsFor(i),
            isSelected: selectedIndex == i,
            onTap: () => onSelect(i),
          ),
        ),
        SizedBox(height: r.hp(context, 10)),
        // Last item — full width
        _CreditCard(
          price: priceFor(count - 1),
          credits: creditsFor(count - 1),
          isSelected: selectedIndex == count - 1,
          onTap: () => onSelect(count - 1),
          fullWidth: true,
        ),
      ],
    );
  }
}

// ─── Single credit card ───────────────────────────────────────────────────────
class _CreditCard extends StatelessWidget {
  final String price;
  final int credits;
  final bool isSelected;
  final VoidCallback onTap;
  final bool fullWidth;

  const _CreditCard({
    required this.price,
    required this.credits,
    required this.isSelected,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = r.isTablet(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: fullWidth
              ? r.wp(context, 20)
              : (isWide ? r.wp(context, 14) : r.wp(context, 10)),
          vertical: isWide ? r.hp(context, 16) : r.hp(context, 12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBg : _cardBg,
          borderRadius: BorderRadius.circular(r.radius(context, 20)),
          border: Border.all(
            color: isSelected ? _selectedBorder : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: fullWidth
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(context, large: true, isWide: isWide),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildContent(context, large: false, isWide: isWide),
              ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, {required bool large, required bool isWide}) {
    final priceStyle = TextStyle(
      fontSize: r.sp(context, large ? 14 : (isWide ? 13 : 12)),
      fontWeight: FontWeight.w400,
      color: isSelected ? _priceBrown : const Color(0xFF8A7060),
    );
    final amountStyle = TextStyle(
      fontSize: r.sp(context, large ? (isWide ? 30 : 26) : (isWide ? 26 : 22)),
      fontWeight: FontWeight.w700,
      color: isSelected ? _amountBrown : const Color(0xFF2C2C2C),
      letterSpacing: -0.5,
    );
    final coinSize = r.wp(context, large ? 22.0 : (isWide ? 20.0 : 17.0));

    if (large) {
      return [
        Text(price, style: priceStyle),
        SizedBox(width: r.wp(context, 10)),
        _CoinIcon(size: coinSize),
        SizedBox(width: r.wp(context, 6)),
        Text('$credits', style: amountStyle),
      ];
    }

    return [
      Text(price, style: priceStyle),
      SizedBox(height: r.hp(context, 4)),
      Row(
        children: [
          _CoinIcon(size: coinSize),
          SizedBox(width: r.wp(context, 4)),
          Flexible(
            child: Text(
              '$credits',
              style: amountStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ];
  }
}

// ─── Continue button ──────────────────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final String label;

  const _ContinueButton({
    required this.onTap,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          height: r.adaptiveValue(context, mobile: 56, tablet: 64),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(230, 203, 168, 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: r.wp(context, 24),
                    height: r.wp(context, 24),
                    child: const CircularProgressIndicator(
                      color: _continueText,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: r.sp(context, 18),
                      fontWeight: FontWeight.w600,
                      color: _continueText,
                      letterSpacing: 0.1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}