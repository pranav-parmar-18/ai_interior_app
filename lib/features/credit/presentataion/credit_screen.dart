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

import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ─── Color tokens ───────────────────────────────────────────────────────────
const _bg = Color(0xFFF2EDE8);
const _cardBg = Color(0xFFFFFFFF);
const _balanceBg = Color(0xFFFFD9A8); // warm peach
const _selectedBg = Color(0xFFFFF0E0);
const _selectedBorder = Color(0xFF8B4513);
const _orangeCoin = Color(0xFFD4762A);
const _titleBrown = Color(0xFF3D1C08);
const _priceBrown = Color(0xFF5C3317);
const _amountBrown = Color(0xFF3D1C08);
const _continueBg = Color(0xFFD4A87A);
const _continueText = Color(0xFF4A2F18);
const _sparkle = Color(0xFF6B1515);

// ─── Credit package model ───────────────────────────────────────────────────
class _CreditPackage {
  final String price;
  final int credits;

  const _CreditPackage(this.price, this.credits);
}

const _packages = [
  _CreditPackage('\$0.99', 100),
  _CreditPackage('\$2.99', 300),
  _CreditPackage('\$4.99', 500),
  _CreditPackage('\$6.99', 700),
  _CreditPackage('\$9.99', 1000),
  _CreditPackage('\$12.99', 1300),
  _CreditPackage('\$14.99', 1500),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  static const routeName = '/credits-screen';

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          SizedBox(height: top),
          // ── Header ──────────────────────────────────────────────────────
          _Header(),
          // ── Scrollable body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  // Coin stack illustration
                  CustomImageview(
                    imagePath: "assets/images/coin_stack.png",
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  // Title
                  const Text(
                    'Get Credits for\nAI Interior Design',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: _titleBrown,
                      height: 1.2,
                      fontFamily: 'Georgia',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Balance bar
                  _BalanceBar(balance: 50),
                  // Credit grid
                  _CreditGrid(
                    packages: _packages,
                    selectedIndex: _selectedIndex,
                    onSelect: (i) => setState(() => _selectedIndex = i),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // ── Continue button ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 16),
            child: _ContinueButton(onTap: () {}),
          ),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Add Credits',
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Lato',

              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(46, 46, 46, 1),
              letterSpacing: -0.3,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Color(0xFF5C5348),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Balance bar ─────────────────────────────────────────────────────────────
class _BalanceBar extends StatelessWidget {
  final int balance;

  const _BalanceBar({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: _balanceBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Balance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _titleBrown,
              letterSpacing: -0.2,
            ),
          ),
          Row(
            children: [
              _CoinIcon(size: 22),
              const SizedBox(width: 6),
              Text(
                '$balance',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: _titleBrown,
                  letterSpacing: -0.3,
                ),
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
  Widget build(BuildContext context) {
    return CustomImageview(
      imagePath: "assets/images/credit.png",
      width: 25,
      height: 25,
    );
  }
}

// ─── Credit grid ─────────────────────────────────────────────────────────────
class _CreditGrid extends StatelessWidget {
  final List<_CreditPackage> packages;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _CreditGrid({
    required this.packages,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Separate grid items (first 6) from the last centered one
    final gridItems = packages.sublist(0, 6);
    final lastItem = packages[6];

    return Column(
      children: [
        // 3-column grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.4,
          ),
          itemCount: gridItems.length,
          itemBuilder:
              (ctx, i) => _CreditCard(
                package: gridItems[i],
                isSelected: selectedIndex == i,
                onTap: () => onSelect(i),
              ),
        ),
        // Last item — full width
        _CreditCard(
          package: lastItem,
          isSelected: selectedIndex == 6,
          onTap: () => onSelect(6),
          fullWidth: true,
        ),
      ],
    );
  }
}

// ─── Single credit card ───────────────────────────────────────────────────────
class _CreditCard extends StatelessWidget {
  final _CreditPackage package;
  final bool isSelected;
  final VoidCallback onTap;
  final bool fullWidth;

  const _CreditCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: fullWidth ? 20 : 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBg : _cardBg,
          borderRadius: BorderRadius.circular(30),
          border:
              isSelected
                  ? Border.all(color: _selectedBorder, width: 1.8)
                  : Border.all(color: Colors.transparent, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child:
            fullWidth
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _content(large: true),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _content(),
                ),
      ),
    );
  }

  List<Widget> _content({bool large = false}) {
    final priceStyle = TextStyle(
      fontSize: large ? 15 : 13,
      fontWeight: FontWeight.w400,
      color: isSelected ? _priceBrown : const Color(0xFF8A7060),
      letterSpacing: -0.1,
    );
    final amountStyle = TextStyle(
      fontSize: large ? 28 : 24,
      fontWeight: FontWeight.w700,
      color: isSelected ? _amountBrown : const Color(0xFF2C2C2C),
      letterSpacing: -0.5,
    );

    if (large) {
      return [
        Text(package.price, style: priceStyle),
        const SizedBox(width: 10),
        _CoinIcon(size: 22),
        const SizedBox(width: 6),
        Text('${package.credits}', style: amountStyle),
      ];
    }

    return [
      Text(package.price, style: priceStyle),
      const SizedBox(height: 4),
      Row(
        children: [
          _CoinIcon(size: 18),
          const SizedBox(width: 5),
          Text('${package.credits}', style: amountStyle),
        ],
      ),
    ];
  }
}

// ─── Continue button ──────────────────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 203, 168, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _continueText,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
