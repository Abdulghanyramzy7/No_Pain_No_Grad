import 'package:hive/hive.dart';

class AuthHiveHelper {
  static const authBox = "Auth_Box";
  static const sessionKey = "Session_Key";
  static bool isLoggedIn = false;
  static String memberId = "";

  // جلب الجلسة من Hive
  static Future<void> getSession() async {
    var box = Hive.box(authBox);
    var data = box.get(sessionKey);
    if (data == null) {
      isLoggedIn = false;
      memberId = "";
    } else {
      isLoggedIn = true;
      memberId = data as String;
    }
  }

  // حفظ الجلسة بعد تسجيل الدخول (من غير باسورد)
  static Future<void> saveSession(String id) async {
    isLoggedIn = true;
    memberId = id;
    await Hive.box(authBox).put(sessionKey, id);
  }

  // تسجيل الخروج
  static Future<void> clearSession() async {
    isLoggedIn = false;
    memberId = "";
    await Hive.box(authBox).delete(sessionKey);
  }
}