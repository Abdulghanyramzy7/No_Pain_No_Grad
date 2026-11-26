import 'package:hive/hive.dart';

class HiveHelper {
  static const barBox = "Bar_Box";

  // مفاتيح صفحة Gym & Bar
  static const barServiceKey = "Bar_Service_Key";
  static const selectedTabKey = "Selected_Tab_Key";

  // مفتاح صفحة Edit Prices & History
  static const roleFilterKey = "Role_Filter_Key";

  // القيم الحالية في الذاكرة (الواجهة بتقرأ منها)
  static bool isBarServiceActive = true;
  static int selectedTab = 0; // 0: Stock, 1: Ingredients, 2: Prices
  static String selectedRoleFilter = 'Everyone'; // Everyone, Admin, Bar worker

  // ---------- Gym & Bar ----------

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

  // ---------- Edit Prices & History ----------

  // جلب الفلتر المحفوظ
  static Future<void> getRoleFilter() async {
    final box = Hive.box(barBox);
    selectedRoleFilter =
        box.get(roleFilterKey, defaultValue: 'Everyone') as String;
  }

  // حفظ الفلتر المختار
  static Future<void> setRoleFilter(String filter) async {
    selectedRoleFilter = filter;
    await Hive.box(barBox).put(roleFilterKey, filter);
  }
}
