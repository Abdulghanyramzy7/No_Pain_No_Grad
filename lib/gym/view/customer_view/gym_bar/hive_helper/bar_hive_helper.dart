import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_controller/items_controller.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/cart_model.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/items_model.dart';

class BarHiveHelper {
  static const barBox = "Bar_Box";
  static const cartKey = "Cart_Key";
  static const orderKey = "Order_Key";

  static List<ProductModel> products = [];
  static List<CartItemModel> cartItems = [];
  static bool isOrderPlaced = false;
  static String selectedCategory = "Shakes";

  static Future<void> _ensureBoxOpen() async {
    if (!Hive.isBoxOpen(barBox)) {
      await Hive.openBox(barBox);
    }
  }

  static ItemsController _itemsController() {
    return Get.isRegistered<ItemsController>()
        ? Get.find<ItemsController>()
        : Get.put(ItemsController());
  }

  // أحدث نسخة للمنتج من ItemsController (عشان أي تعديل سعر يظهر فوراً)
  static ProductModel resolveLatestProduct(ProductModel product) {
    final ctrl = _itemsController();
    final found = ctrl.products.firstWhereOrNull((p) => p.id == product.id);
    return found ?? product;
  }

  // المنتجات حسب الفئة المختارة
  static List<ProductModel> get filteredProducts =>
      products.where((p) => p.category == selectedCategory).toList();

  // إجمالي السلة بناءً على أحدث أسعار المنتجات
  static double get subtotal => cartItems.fold<double>(
        0.0,
        (sum, item) => sum + (resolveLatestProduct(item.product).price * item.quantity),
      );

  // ==================== تحويل الموديل لـ Map عشان Hive ====================
  static Map<String, dynamic> _productToMap(ProductModel p) => {
        'id': p.id,
        'productTitle': p.productTitle,
        'productImage': p.productImage,
        'price': p.price,
        'oldPrice': p.oldPrice,
        'updatedBy': p.updatedBy,
        'subtitle': p.subtitle,
        'category': p.category,
        'isAvailable': p.isAvailable,
        'statusMessage': p.statusMessage,
        'description': p.description,
        'rating': p.rating,
        'reviewsCount': p.reviewsCount,
        'stockQuantity': p.stockQuantity,
        'minStockAlert': p.minStockAlert,
        'storageLocation': p.storageLocation,
      };

  static ProductModel _productFromMap(Map<String, dynamic> m) => ProductModel(
        id: (m['id'] ?? '').toString(),
        productTitle: (m['productTitle'] ?? '').toString(),
        productImage: (m['productImage'] ?? '').toString(),
        price: (m['price'] as num?)?.toDouble() ?? 0.0,
        oldPrice: (m['oldPrice'] as num?)?.toDouble(),
        updatedBy: m['updatedBy'] as String?,
        subtitle: (m['subtitle'] ?? '').toString(),
        category: (m['category'] ?? 'Shakes').toString(),
        isAvailable: (m['isAvailable'] as bool?) ?? true,
        statusMessage: m['statusMessage'] as String?,
        description: (m['description'] ?? '').toString(),
        rating: (m['rating'] as num?)?.toDouble() ?? 0.0,
        reviewsCount: (m['reviewsCount'] as int?) ?? 0,
        stockQuantity: (m['stockQuantity'] as int?) ?? 0,
        minStockAlert: (m['minStockAlert'] as int?) ?? 5,
        storageLocation: m['storageLocation'] as String?,
      );

  static Map<String, dynamic> _cartItemToMap(CartItemModel c) => {
        'product': _productToMap(resolveLatestProduct(c.product)),
        'quantity': c.quantity,
      };

  static CartItemModel _cartItemFromMap(Map<String, dynamic> m) {
    final parsedProduct =
        _productFromMap(Map<String, dynamic>.from(m['product'] ?? {}));
    return CartItemModel(
      product: resolveLatestProduct(parsedProduct),
      quantity: (m['quantity'] as int?) ?? 1,
    );
  }

  // ==================== العمليات ====================

  // جلب المنتجات من ItemsController + السلة وحالة الأوردر من Hive
  static Future<void> getBar() async {
    await _ensureBoxOpen();
    final ctrl = _itemsController();
    products = List<ProductModel>.from(ctrl.products);

    final box = Hive.box(barBox);
    final cartData = box.get(cartKey, defaultValue: <dynamic>[]);
    cartItems = List<dynamic>.from(cartData)
        .map((e) => _cartItemFromMap(Map<String, dynamic>.from(e)))
        .toList();
    isOrderPlaced = (box.get(orderKey, defaultValue: false) as bool?) ?? false;
  }

  static Future<void> _saveCart() async {
    await _ensureBoxOpen();
    await Hive.box(barBox)
        .put(cartKey, cartItems.map(_cartItemToMap).toList());
  }

  static Future<void> addToCart(ProductModel product) async {
    final latest = resolveLatestProduct(product);
    final index = cartItems.indexWhere((e) => e.product.id == latest.id);
    if (index == -1) {
      cartItems.add(CartItemModel(product: latest));
    } else {
      cartItems[index].product = latest;
      cartItems[index].quantity++;
    }
    await _saveCart();
  }

  static Future<void> clearCart() async {
    cartItems.clear();
    await _saveCart();
  }

  static Future<void> placeOrder() async {
    await _ensureBoxOpen();
    isOrderPlaced = true;
    await Hive.box(barBox).put(orderKey, true);
  }

  static Future<void> cancelOrder() async {
    await _ensureBoxOpen();
    isOrderPlaced = false;
    cartItems.clear();
    await Hive.box(barBox).put(orderKey, false);
    await _saveCart();
  }
}