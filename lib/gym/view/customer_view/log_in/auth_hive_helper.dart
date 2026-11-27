import 'package:hive/hive.dart';

class AuthHiveHelper {
  static const authBox = "Auth_Box";
  static const sessionKey = "Session_Key";
  static const roleKey = "Role_Key";
  static bool isLoggedIn = false;
  static String memberId = "";
  static String userRole = "user"; // "admin" أو "user"

  // جلب الجلسة من Hive
  static Future<void> getSession() async {
    var box = Hive.box(authBox);
    var data = box.get(sessionKey);
    if (data == null) {
      isLoggedIn = false;
      memberId = "";
      userRole = "user";
    } else {
      isLoggedIn = true;
      memberId = data as String;
      userRole = box.get(roleKey, defaultValue: "user") as String;
    }
  }

  // حفظ الجلسة بعد تسجيل الدخول (من غير باسورد)
  static Future<void> saveSession(String id, {String role = "user"}) async {
    isLoggedIn = true;
    memberId = id;
    userRole = role;
    await Hive.box(authBox).put(sessionKey, id);
    await Hive.box(authBox).put(roleKey, role);
  }

  // تسجيل الخروج
  static Future<void> clearSession() async {
    isLoggedIn = false;
    memberId = "";
    userRole = "user";
    await Hive.box(authBox).delete(sessionKey);
    await Hive.box(authBox).delete(roleKey);
  }
}