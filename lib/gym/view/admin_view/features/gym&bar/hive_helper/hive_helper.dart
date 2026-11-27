import 'package:hive/hive.dart';

class AdminbarHiveHelper {
  static const barBox = "Bar_Box";
  static const barServiceKey = "Bar_Service_Key";
  static const selectedTabKey = "Selected_Tab_Key";

  // القيم الحالية في الذاكرة (الواجهة بتقرأ منها)
  static bool isBarServiceActive = true;
  static int selectedTab = 0; // 0: Stock, 1: Ingredients, 2: Prices

  // تهيئة وفتح صندوق البار وجلب الإعدادات
  static Future<void> init() async {
    await Hive.openBox(barBox);
    await getBarSettings();
  }

  // جلب الإعدادات من Hive
  static Future<void> getBarSettings() async {
    final box = Hive.box(barBox);
    isBarServiceActive = box.get(barServiceKey, defaultValue: true) as bool;
    selectedTab = box.get(selectedTabKey, defaultValue: 0) as int;
  }

  // تفعيل أو إيقاف خدمة البار
  static Future<void> setBarService(bool value) async {
    isBarServiceActive = value;
    await Hive.box(barBox).put(barServiceKey, value);
  }

  // تغيير التبويب المختار
  static Future<void> setSelectedTab(int tab) async {
    selectedTab = tab;
    await Hive.box(barBox).put(selectedTabKey, tab);
  }
}