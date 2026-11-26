import 'package:hive/hive.dart';
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

  // المنتجات حسب الفئة المختارة
  static List<ProductModel> get filteredProducts =>
      products.where((p) => p.category == selectedCategory).toList();

  // إجمالي السلة
  static double get subtotal =>
      cartItems.fold<double>(0.0, (sum, item) => sum + item.total);

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
        id: m['id'] as String,
        productTitle: m['productTitle'] as String,
        productImage: m['productImage'] as String,
        price: (m['price'] as num).toDouble(),
        oldPrice: (m['oldPrice'] as num?)?.toDouble(),
        updatedBy: m['updatedBy'] as String?,
        subtitle: m['subtitle'] as String,
        category: m['category'] as String,
        isAvailable: m['isAvailable'] as bool,
        statusMessage: m['statusMessage'] as String?,
        description: m['description'] as String,
        rating: (m['rating'] as num).toDouble(),
        reviewsCount: m['reviewsCount'] as int,
        stockQuantity: m['stockQuantity'] as int,
        minStockAlert: m['minStockAlert'] as int,
        storageLocation: m['storageLocation'] as String?,
      );

  static Map<String, dynamic> _cartItemToMap(CartItemModel c) => {
        'product': _productToMap(c.product),
        'quantity': c.quantity,
      };

  static CartItemModel _cartItemFromMap(Map<String, dynamic> m) => CartItemModel(
        product: _productFromMap(Map<String, dynamic>.from(m['product'])),
        quantity: m['quantity'] as int,
      );

  // ==================== العمليات ====================

  // جلب المنتجات والسلة وحالة الأوردر
  static Future<void> getBar() async {
    // TODO: استبدلي القائمة دي بمنتجات ItemsController (أو نداء الـ API بعدين)
    products = [
      ProductModel(
        id: "1",
        productTitle: "Protein Shake",
        productImage: "",
        price: 60,
        subtitle: "Whey · 500 ml",
        category: "Shakes",
        stockQuantity: 20,
      ),
      ProductModel(
        id: "2",
        productTitle: "Banana Shake",
        productImage: "",
        price: 45,
        subtitle: "Milk · 400 ml",
        category: "Shakes",
        stockQuantity: 15,
      ),
      ProductModel(
        id: "3",
        productTitle: "Chicken & Rice",
        productImage: "",
        price: 120,
        subtitle: "Grilled · 450 g",
        category: "Meals",
        stockQuantity: 10,
      ),
      ProductModel(
        id: "4",
        productTitle: "Tuna Sandwich",
        productImage: "",
        price: 80,
        subtitle: "Tuna · Whole wheat",
        category: "Meals",
        isAvailable: false,
        statusMessage: "Back at 6 PM",
      ),
      ProductModel(
        id: "5",
        productTitle: "Creatine",
        productImage: "",
        price: 25,
        subtitle: "5 g · single serve",
        category: "Supplements",
        stockQuantity: 30,
      ),
    ];

    var box = Hive.box(barBox);
    var cartData = box.get(cartKey, defaultValue: <dynamic>[]);
    cartItems = List<dynamic>.from(cartData)
        .map((e) => _cartItemFromMap(Map<String, dynamic>.from(e)))
        .toList();
    isOrderPlaced = box.get(orderKey, defaultValue: false) as bool;
  }

  // حفظ السلة في الـ Box
  static Future<void> _saveCart() async {
    await Hive.box(barBox).put(cartKey, cartItems.map(_cartItemToMap).toList());
  }

  // إضافة منتج للسلة (لو موجود نزود الكمية)
  static Future<void> addToCart(ProductModel product) async {
    final index = cartItems.indexWhere((e) => e.product.id == product.id);
    if (index == -1) {
      cartItems.add(CartItemModel(product: product));
    } else {
      cartItems[index].quantity++;
    }
    await _saveCart();
  }

  // مسح السلة
  static Future<void> clearCart() async {
    cartItems.clear();
    await _saveCart();
  }

  // تأكيد الأوردر
  static Future<void> placeOrder() async {
    isOrderPlaced = true;
    await Hive.box(barBox).put(orderKey, true);
  }

  // إلغاء الأوردر ومسح السلة
  static Future<void> cancelOrder() async {
    isOrderPlaced = false;
    cartItems.clear();
    await Hive.box(barBox).put(orderKey, false);
    await _saveCart();
  }
}