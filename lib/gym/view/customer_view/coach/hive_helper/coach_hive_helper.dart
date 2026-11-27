import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/user_controller.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/chat/chat_message_model.dart';

class CoachHiveHelper {
  static const coachBox = "Coach_Box";
  static const chatKeyPrefix = "Chat_"; // لكل مدرب Key خاص بيه: Chat_<coachId>

  static List<UserModel> coaches = [];
  static List<ChatMessageModel> messages = []; // رسائل الشات المفتوح حالياً

  static Future<void> _ensureBoxOpen() async {
    if (!Hive.isBoxOpen(coachBox)) {
      await Hive.openBox(coachBox);
    }
  }

  // جلب المدربين من UsersController الموحد (UserModel)
  static Future<void> getCoaches() async {
    final UsersController usersController = Get.isRegistered<UsersController>()
        ? Get.find<UsersController>()
        : Get.put(UsersController());

    coaches = usersController.coachesList;
  }

  // جلب رسائل شات مدرب معين من Hive
  static Future<void> getMessages(String coachId) async {
    await _ensureBoxOpen();
    final box = Hive.box(coachBox);
    final data = box.get('$chatKeyPrefix$coachId', defaultValue: <dynamic>[]);

    messages = List<dynamic>.from(data)
        .map((e) => ChatMessageModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    // رسائل تجريبية لأول مرة فقط لو الشات فاضي
    if (messages.isEmpty) {
      final now = DateTime.now();
      messages = [
        ChatMessageModel(
          text:
              "Nice work today. Add 2.5 kg next week if the last set felt easy.",
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

  // حفظ الرسائل في Hive
  static Future<void> _saveMessages(String coachId) async {
    await _ensureBoxOpen();
    await Hive.box(coachBox).put(
      '$chatKeyPrefix$coachId',
      messages.map((e) => e.toMap()).toList(),
    );
  }

  // إرسال رسالة جديدة وحفظها
  static Future<void> sendMessage(String coachId, String text) async {
    messages.add(
      ChatMessageModel(text: text, isMe: true, time: DateTime.now()),
    );
    await _saveMessages(coachId);
  }
}