import 'package:hive/hive.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';

class UserHiveHelper {
  static const userBox = "Users_Box";
  static const userKey = "Users_Key";
  static List<UserModel> myUsers = [];

  // فتح الـ Box مرة واحدة قبل تشغيل التطبيق
  static Future<void> init() async {
    if (!Hive.isBoxOpen(userBox)) {
      await Hive.openBox(userBox);
    }
  }

  // جلب المستخدمين من Hive
  static Future<void> getUsers() async {
    await init();
    var box = Hive.box(userBox);
    var data = box.get(userKey, defaultValue: <dynamic>[]);
    myUsers = (data as List)
        .map((item) => _userFromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // حفظ القائمة كلها
  static Future<void> saveUsers() async {
    await init();
    await Hive.box(userBox).put(
      userKey,
      myUsers.map((user) => _userToMap(user)).toList(),
    );
  }

  // إضافة مستخدم جديد
  static Future<void> addUser(UserModel user) async {
    myUsers.add(user);
    await saveUsers();
  }

  // تحديث بيانات مستخدم
  static Future<void> updateUser(UserModel user) async {
    int index = myUsers.indexWhere((item) => item.id == user.id);
    if (index != -1) {
      myUsers[index] = user;
      await saveUsers();
    }
  }

  // إنهاء عقد / حساب مستخدم
  static Future<void> terminateUser(String userId) async {
    int index = myUsers.indexWhere((item) => item.id == userId);
    if (index != -1) {
      final user = myUsers[index];
      myUsers[index] = UserModel(
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        role: user.role,
        status: AccountStatus.terminated,
        joinedDate: user.joinedDate,
        subscriptionPlan: user.subscriptionPlan,
        subscriptionStartDate: user.subscriptionStartDate,
        renewalDate: user.renewalDate,
        daysElapsed: user.daysElapsed,
        coachId: user.coachId,
        coachName: user.coachName,
        specialization: user.specialization,
        capacity: user.capacity,
        clientIds: user.clientIds,
        clientNames: user.clientNames,
        clientsCount: user.clientsCount,
        shift: user.shift,
        contractStartDate: user.contractStartDate,
        contractEndDate: user.contractEndDate,
        permissions: user.permissions,
      );
      await saveUsers();
    }
  }

  // تحويل UserModel إلى Map عشان Hive يخزنه بدون Adapter
  static Map<String, dynamic> _userToMap(UserModel user) {
    return {
      'id': user.id,
      'name': user.name,
      'phone': user.phone,
      'email': user.email,
      'role': user.role.name,
      'status': user.status.name,
      'joinedDate': user.joinedDate,
      'subscriptionPlan': user.subscriptionPlan,
      'subscriptionStartDate': user.subscriptionStartDate?.toIso8601String(),
      'renewalDate': user.renewalDate?.toIso8601String(),
      'daysElapsed': user.daysElapsed,
      'coachId': user.coachId,
      'coachName': user.coachName,
      'specialization': user.specialization,
      'capacity': user.capacity,
      'clientIds': user.clientIds,
      'clientNames': user.clientNames,
      'clientsCount': user.clientsCount,
      'shift': user.shift,
      'contractStartDate': user.contractStartDate?.toIso8601String(),
      'contractEndDate': user.contractEndDate?.toIso8601String(),
      'permissions': user.permissions,
    };
  }

  // تحويل Map المخزنة إلى UserModel
  static UserModel _userFromMap(Map<String, dynamic> map) {
    DateTime? dateFrom(dynamic value) =>
        value == null ? null : DateTime.tryParse(value.toString());

    return UserModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString(),
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.client,
      ),
      status: AccountStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => AccountStatus.active,
      ),
      joinedDate: map['joinedDate']?.toString() ?? '',
      subscriptionPlan: map['subscriptionPlan']?.toString(),
      subscriptionStartDate: dateFrom(map['subscriptionStartDate']),
      renewalDate: dateFrom(map['renewalDate']),
      daysElapsed: map['daysElapsed'] as int?,
      coachId: map['coachId']?.toString(),
      coachName: map['coachName']?.toString(),
      specialization: map['specialization']?.toString(),
      capacity: map['capacity'] as int?,
      clientIds: (map['clientIds'] as List?)?.map((e) => e.toString()).toList(),
      clientNames: (map['clientNames'] as List?)?.map((e) => e.toString()).toList(),
      clientsCount: map['clientsCount'] as int?,
      shift: map['shift']?.toString(),
      contractStartDate: dateFrom(map['contractStartDate']),
      contractEndDate: dateFrom(map['contractEndDate']),
      permissions: (map['permissions'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value == true),
      ),
    );
  }
}
