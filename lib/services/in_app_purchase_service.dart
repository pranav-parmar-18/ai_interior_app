import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  InAppPurchaseService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    _subscription = _iap.purchaseStream.listen((purchaseDetailsList) {
      _handlePurchases(purchaseDetailsList);
    });

    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    const Set<String> _kIds = {'premium_subscription'}; // Your Product ID
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      print("Products not found: ${response.notFoundIDs}");
    }

    _products = response.productDetails;
  }

  Future<void> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchases(List<PurchaseDetails> purchases) {
    for (PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _verifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        print("Purchase Error: ${purchase.error}");
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // Send purchase details to your backend for verification
    print("Purchase Verified: ${purchase.productID}");
  }

  void dispose() {
    _subscription.cancel();
  }

  List<ProductDetails> get products => _products;

  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

}
