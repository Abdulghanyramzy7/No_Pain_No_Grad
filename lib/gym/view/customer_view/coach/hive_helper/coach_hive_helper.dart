import 'package:hive/hive.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/chat/chat_message_model.dart';

class CoachHiveHelper {
  static const coachBox = "Coach_Box";
  static const chatKeyPrefix = "Chat_"; // لكل مدرب Key خاص بيه: Chat_<coachId>

  static List<UserModel> coaches = [];
  static List<ChatMessageModel> messages = []; // رسايل الشات المفتوح حالياً

  // جلب المدربين من الـ UserModel
  static Future<void> getCoaches() async {
    // TODO: استبدلي القائمة دي بنداء الـ API / مصدر المستخدمين الموحد بعدين
    final allUsers = <UserModel>[
      UserModel(
        id: 'c1',
        name: 'Hany Salah',
        phone: '010 1234 5678',
        role: UserRole.coach,
        status: AccountStatus.active,
        joinedDate: 'Jan 2024',
        specialization: 'Strength',
        capacity: 20,
        clientNames: ['Sara Mahmoud', 'Dina Maher', 'Huda Adel'],
        contractStartDate: DateTime(2026, 1, 1),
        contractEndDate: DateTime(2026, 12, 31),
      ),
      UserModel(
        id: 'c2',
        name: 'Mona Tarek',
        phone: '011 2233 4455',
        role: UserRole.coach,
        status: AccountStatus.active,
        joinedDate: 'Mar 2024',
        specialization: 'Yoga',
        capacity: 20,
        clientNames: ['Youssef Ammar', 'Mai Sherif', 'Ayat'],
        contractStartDate: DateTime(2024, 3, 1),
        contractEndDate: DateTime(2027, 3, 1),
      ),
      UserModel(
        id: 'c3',
        name: 'Omar Ezzat',
        phone: '012 3344 5566',
        role: UserRole.coach,
        status: AccountStatus.active,
        joinedDate: 'May 2024',
        specialization: 'Fitness',
        capacity: 10,
        clientNames: ['C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9'],
        contractStartDate: DateTime(2024, 5, 1),
        contractEndDate: DateTime(2027, 5, 1),
      ),
    ];

    // بنعرض المدربين بس
    coaches = allUsers.where((u) => u.role == UserRole.coach).toList();
  }

  // جلب رسايل شات مدرب معين
  static Future<void> getMessages(String coachId) async {
    var box = Hive.box(coachBox);
    var data = box.get('$chatKeyPrefix$coachId', defaultValue: <dynamic>[]);
    messages = List<dynamic>.from(data)
        .map((e) => ChatMessageModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    // TODO: رسايل تجريبية لأول مرة بس، احذفيها لما الشات يبقى حقيقي
    if (messages.isEmpty) {
      final now = DateTime.now();
      messages = [
        ChatMessageModel(
          text: "Nice work today. Add 2.5 kg next week if the last set felt easy.",
          isMe: false,
          time: now,
        ),
        ChatMessageModel(
          text: "My shoulder feels tight on incline.",
          isMe: true,
          time: now,
        ),
        ChatMessageModel(
          text: "Drop 2 kg and send me one set on video.",
          isMe: false,
          time: now,
        ),
      ];
      await _saveMessages(coachId);
    }
  }

  // حفظ الرسايل في الـ Box
  static Future<void> _saveMessages(String coachId) async {
    await Hive.box(coachBox).put(
      '$chatKeyPrefix$coachId',
      messages.map((e) => e.toMap()).toList(),
    );
  }

  // إرسال رسالة جديدة
  static Future<void> sendMessage(String coachId, String text) async {
    messages.add(
      ChatMessageModel(text: text, isMe: true, time: DateTime.now()),
    );
    await _saveMessages(coachId);
  }
}
