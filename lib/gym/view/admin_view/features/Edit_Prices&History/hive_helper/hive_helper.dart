import 'package:hive/hive.dart';

class HiveHelper {
  static const barBox = "Bar_Box";

  // مفاتيح صفحة Gym & Bar
  static const barServiceKey = "Bar_Service_Key";
  static const selectedTabKey = "Selected_Tab_Key";

  // مفتاح صفحة Edit Prices & History
  static const roleFilterKey = "Role_Filter_Key";
  static const priceOverridesKey = "Price_Overrides_Key";

  // القيم الحالية في الذاكرة
  static bool isBarServiceActive = true;
  static int selectedTab = 0; // 0: Stock, 1: Ingredients, 2: Prices
  static String selectedRoleFilter = 'Everyone'; // Everyone, Admin, Bar worker
  static Map<String, Map<String, dynamic>> priceOverrides = {};

  static Future<void> init() async {
    if (!Hive.isBoxOpen(barBox)) {
      await Hive.openBox(barBox);
    }
  }

  static Future<void> getBarSettings() async {
    await init();
    final box = Hive.box(barBox);
    isBarServiceActive = box.get(barServiceKey, defaultValue: true) as bool;
    selectedTab = box.get(selectedTabKey, defaultValue: 0) as int;
  }

  static Future<void> setBarService(bool value) async {
    await init();
    isBarServiceActive = value;
    await Hive.box(barBox).put(barServiceKey, value);
  }

  static Future<void> setSelectedTab(int tab) async {
    await init();
    selectedTab = tab;
    await Hive.box(barBox).put(selectedTabKey, tab);
  }

  static Future<void> getRoleFilter() async {
    await init();
    final box = Hive.box(barBox);
    selectedRoleFilter =
        box.get(roleFilterKey, defaultValue: 'Everyone') as String;
  }

  static Future<void> setRoleFilter(String filter) async {
    await init();
    selectedRoleFilter = filter;
    await Hive.box(barBox).put(roleFilterKey, filter);
  }

  static Future<void> loadPriceOverrides() async {
    await init();
    final box = Hive.box(barBox);
    final raw = box.get(priceOverridesKey);
    if (raw is Map) {
      priceOverrides = raw.map((key, value) {
        final mapVal =
            value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
        return MapEntry(key.toString(), mapVal);
      });
    } else {
      priceOverrides = {};
    }
  }

  static Future<void> savePriceOverride({
    required String productId,
    required double price,
    required double? oldPrice,
    required String updatedBy,
  }) async {
    await init();
    priceOverrides[productId] = {
      'price': price,
      'oldPrice': oldPrice,
      'updatedBy': updatedBy,
    };
    await Hive.box(barBox).put(priceOverridesKey, priceOverrides);
  }
}