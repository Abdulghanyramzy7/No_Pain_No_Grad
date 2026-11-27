class ChatMessageModel {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessageModel({
    required this.text,
    required this.isMe,
    required this.time,
  });

  // تحويل لـ Map عشان يتخزن في Hive
  Map<String, dynamic> toMap() => {
        'text': text,
        'isMe': isMe,
        'time': time.toIso8601String(),
      };

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) => ChatMessageModel(
        text: map['text'] as String,
        isMe: map['isMe'] as bool,
        time: DateTime.parse(map['time'] as String),
      );
}
