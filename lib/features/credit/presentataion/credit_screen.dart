import 'dart:async';
import 'dart:io';

import 'package:ai_interior/bloc/add_credits/add_credits_bloc.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/add_credit_model_response.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../main/presentaion/main_screen.dart';

int selectedIndex = 6;

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  static const routeName = "/credit";

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  final AddCreditsBloc _addCreditsBloc = AddCreditsBloc();
  AddCreditResponse? addCreditResponse;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];

  final List<String> _productIds = [
    'com.ai_interior.credits_100',
    'com.ai_interior.credits_300',
    'com.ai_interior.credits_500',
    'com.ai_interior.credits_700',
    'com.ai_interior.credits_1000',
    'com.ai_interior.credits_1300',
    'com.ai_interior.credits_1500',
  ];

  bool _isPurchasing = false;

  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredits();
    _initialize();
  }

  String credits = "";

  Future<void> getCredits() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    credits = preferences.getString('credits') ?? "";
  }

  Future<void> setCredits(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('credits', userId);
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds.toSet());

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

      setState(() {
        _products = sortedProducts;
        _loading = false;
      });
    }
  }

  void _buy(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(
      purchaseParam: purchaseParam,
    ); // Used for subscriptions too
  }

  void _buyAndroid(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyConsumable(
      purchaseParam: purchaseParam,
      autoConsume: true
    ); // Used for subscriptions too
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (mounted) {
          setState(() => _isPurchasing = false);
        }

        print('✅ Purchased: ${purchase.productID}');
        print('✅ Purchase ID: ${purchase.purchaseID}');

        // 🔹 Deliver credits
        if (Platform.isAndroid) {
          print("ANDROID ");
          _addCreditsBloc.add(
            AddCreditsDataEvent(
              purchaseData: {
                "transactionId": purchase.purchaseID.toString(),
                "product_id": purchase.productID.toString(),
              },
            ),
          );
          // 3) Consume on Android via platform addition
          try {
            final androidAddition = InAppPurchase.instance
                .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            final billingResult = await androidAddition.consumePurchase(purchase);
            print('✅ consume result code: ${billingResult.responseCode}');
          } catch (e, st) {
            print('❌ consume error: $e\n$st');
          }

        }
        else {
          // iOS (no consumption needed)
          _addCreditsBloc.add(
            AddCreditsDataEvent(
              purchaseData: {
                "transactionId": purchase.purchaseID.toString(),
              },
            ),
          );
        }
      } else if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        print('❌ Purchase error: ${purchase.error}');
        if (mounted) {
          setState(() => _isPurchasing = false);
        }
      }

      // 🔹 Always complete the purchase if required
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
        print('✅ Completed purchase: ${purchase.productID}');
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),
      appBar: _buildAppBar(context),
      body: BlocConsumer<AddCreditsBloc, AddCreditsState>(
        bloc: _addCreditsBloc,
        listener: (context, state) {
          if (state is AddCreditsSuccessState) {
            addCreditResponse = state.categoryModalResponse;
            print("CREDIT RES: ${addCreditResponse?.result?.credit}");
            setState(() {
              selectedIndex = 0;
              setCredits(
                double.tryParse(
                      addCreditResponse?.result?.credit?.toString() ?? "0",
                    )?.toInt().toString() ??
                    "0",
              );
              getCredits();
            });
          } else if (state is AddCreditsExceptionState ||
              state is AddCreditsFailureState) {}
        },
        builder: (context, state) {
          return _isPurchasing
              ? Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.07),
                        CustomImageview(
                          imagePath: "assets/images/heart_icon.png",
                          height: height * 0.12,
                          width: width * 0.3,
                          fit: isIPad(context) ? BoxFit.contain : null,
                        ),
                        SizedBox(height: height * 0.05),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Get Credits for",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "AI",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: " Girlfriend",
                                style: TextStyle(
                                  color: Color.fromRGBO(242, 113, 33, 1),
                                  fontSize: 28,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          width: width * 0.9,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(37, 37, 40, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Balance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    CustomImageview(
                                      imagePath: "assets/images/heart_icon.png",
                                      height: 26,
                                      width: 24,
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      credits,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        VisibilitySelector(),
                      ],
                    ),
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
                            backgroundColor: Color.fromRGBO(233, 64, 87, 1),
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
              : Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.07),
                    CustomImageview(
                      imagePath: "assets/images/heart_icon.png",
                      height: height * 0.12,
                      width: width * 0.3,
                      fit: isIPad(context) ? BoxFit.contain : null,
                    ),
                    SizedBox(height: height * 0.05),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Get Credits for",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "AI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: " Girlfriend",
                            style: TextStyle(
                              color: Color.fromRGBO(242, 113, 33, 1),
                              fontSize: 28,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.9,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(37, 37, 40, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                CustomImageview(
                                  imagePath: "assets/images/heart_icon.png",
                                  height: 26,
                                  width: 24,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  credits,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    VisibilitySelector(),
                  ],
                ),
              );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 45),
        child: CustomElevatedButton(
          height: isIPad(context) ? height * 0.07 : null,
          text: 'Continue',
          onPressed: () {
            setState(() {
              _isPurchasing = true;
            });
            if(Platform.isAndroid){
              _buyAndroid(_products[selectedIndex]);
            }else{
            _buy(_products[selectedIndex]);}
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "Add Credits",
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
              HapticFeedback.mediumImpact();

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

class VisibilitySelector extends StatefulWidget {
  VisibilitySelector({super.key});

  @override
  State<VisibilitySelector> createState() => _VisibilitySelectorState();
}

class _VisibilitySelectorState extends State<VisibilitySelector> {
  String selectedOption = '1500';

  BoxDecoration getBoxDecoration(bool isSelected) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment(0, 0.5),
        end: Alignment(1, 0.5),
        colors:
            isSelected
                ? [
                  Color.fromRGBO(138, 35, 135, 0.3),
                  Color.fromRGBO(233, 64, 87, 0.3),
                  Color.fromRGBO(242, 113, 33, 0.3),
                ]
                : [
                  Color.fromRGBO(37, 37, 40, 1),
                  Color.fromRGBO(37, 37, 40, 1),
                ],
      ),
      border:
          isSelected
              ? Border.all(color: Color.fromRGBO(233, 64, 87, 1))
              : Border.all(color: Color.fromRGBO(255, 255, 255, 0.2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isIPad(context) ? 61 : 25.0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    HapticFeedback.mediumImpact();
                    selectedOption = '100';
                    selectedIndex = 0;
                  });
                },
                child: Container(
                  width: width * 0.28,
                  height: height * 0.085,
                  decoration: getBoxDecoration(selectedOption == '100'),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$0.99",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          CustomImageview(
                            imagePath: "assets/images/heart_icon.png",
                            height: 26,
                            width: 24,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '100',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: width * 0.02),
              GestureDetector(
                onTap: () {
                  setState(() {
                    HapticFeedback.mediumImpact();

                    selectedOption = '300';
                    selectedIndex = 1;
                  });
                },
                child: Container(
                  width: width * 0.28,
                  height: height * 0.085,
                  decoration: getBoxDecoration(selectedOption == '300'),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$2.99",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          CustomImageview(
                            imagePath: "assets/images/heart_icon.png",
                            height: 26,
                            width: 24,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '300',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: width * 0.02),
              GestureDetector(
                onTap: () {
                  setState(() {
                    HapticFeedback.mediumImpact();

                    selectedOption = '500';
                    selectedIndex = 2;
                  });
                },
                child: Container(
                  width: width * 0.28,
                  height: height * 0.085,
                  decoration: getBoxDecoration(selectedOption == '500'),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$4.99",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          CustomImageview(
                            imagePath: "assets/images/heart_icon.png",
                            height: 26,
                            width: 24,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '500',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    HapticFeedback.mediumImpact();

                    selectedOption = '700';
                    selectedIndex = 3;
                  });
                },
                child: Container(
                  width: width * 0.28,
                  height: height * 0.085,
                  decoration: getBoxDecoration(selectedOption == '700'),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$6.99",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          CustomImageview(
                            imagePath: "assets/images/heart_icon.png",
                            height: 26,
                            width: 24,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '700',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: width * 0.02),
              GestureDetector(
                onTap: () {
                  setState(() {
                    HapticFeedback.mediumImpact();

                    selectedOption = '1000';
                    selectedIndex = 4;
                  });
                },
                child: Container(
                  width: width * 0.28,
                  height: height * 0.085,
                  decoration: getBoxDecoration(selectedOption == '1000'),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$9.99",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          CustomImageview(
                            imagePath: "assets/images/heart_icon.png",
                            height: 26,
                            width: 24,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '1000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: width * 0.02),
              GestureDetector(
                onTap: () {
                  setState(() {
                    HapticFeedback.mediumImpact();

                    selectedOption = '1300';
                    selectedIndex = 5;
                  });
                },
                child: Container(
                  width: width * 0.28,
                  height: height * 0.085,
                  decoration: getBoxDecoration(selectedOption == '1300'),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$12.99",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          CustomImageview(
                            imagePath: "assets/images/heart_icon.png",
                            height: 26,
                            width: 24,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '1300',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
            onTap: () {
              setState(() {
                HapticFeedback.mediumImpact();
                selectedOption = '1500';
                selectedIndex = 6;
              });
            },
            child: Container(
              width: width * 0.9,
              height: height * 0.075,
              decoration: getBoxDecoration(selectedOption == '1500'),
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$14.99",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      CustomImageview(
                        imagePath: "assets/images/heart_icon.png",
                        height: 26,
                        width: 24,
                      ),
                      SizedBox(width: 7),
                      Text(
                        '1500',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
