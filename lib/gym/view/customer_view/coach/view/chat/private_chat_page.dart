import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/cubit/cubit/coach_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/hive_helper/coach_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/trainers_list_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_view/bar_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/home.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/profile.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/chat/chat_message_model.dart';

class PrivateChatPage extends StatefulWidget {
  final UserModel coach;

  const PrivateChatPage({super.key, required this.coach});

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // تحميل رسايل الشات الخاصة بالمدرب ده
    context.read<CoachCubit>().getMessages(widget.coach.id);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<CoachCubit>().sendMessage(widget.coach.id, text);
    _messageController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // التنقل بين صفحات شريط التنقل السفلي
  void _onNavTap(int index) {
    final Widget page = switch (index) {
      0 => const CustomerHome(),
      1 => const WeightsScreen(),
      2 => const BarPage(),
      3 => const TrainersListPage(),
      _ => const ProfileScreen(),
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coach = widget.coach;

    return BlocListener<CoachCubit, CoachState>(
      listener: (context, state) {
        if (state is CoachMessageSentState || state is CoachChatLoadedState) {
          _scrollToBottom();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.plateBackground,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // الهيدر العلوي (زر الرجوع + My coach + وزر الاتصال والثلاث نقاط)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // زر الرجوع لصفحة المدربين
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => Navigator.pop(context),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Color(0xFF1D2733),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "My coach",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D2733),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.phone, color: Color(0xFFF4877B), size: 20),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.more_horiz, color: Color(0xFF1D2733)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<CoachCubit, CoachState>(
                    builder: (context, state) {
                      return ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          // كارت بيانات المدرب (من UserModel)
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      const Color(0xFFF4877B).withValues(alpha: 0.2),
                                  child: Text(
                                    coach.name[0],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF4877B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coach.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D2733),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${coach.specialization ?? 'Coach'} · ${coach.coachStatusLabel}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7886),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // كارت الأداء (Bench Press وغيرها)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                _ProgressRow(exercise: "Bench Press", weight: "62.5 → 65 kg"),
                                Divider(height: 20, color: Color(0xFFF0F2F5)),
                                _ProgressRow(exercise: "Chest Press", weight: "45 → 50 kg"),
                                Divider(height: 20, color: Color(0xFFF0F2F5)),
                                _ProgressRow(exercise: "Incline DB", weight: "24 → 22 kg"),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // رسايل الشات من Hive
                          ...CoachHiveHelper.messages.map(
                            (m) => _buildChatBubble(message: m.text, isMe: m.isMe),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),

                // خانة كتابة الرسائل (Type a message...)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Color(0xFF8C98A4)),
                      filled: true,
                      fillColor: const Color(0xFFF4F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFFF4877B)),
                        onPressed: _send,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // شريط التنقل السفلي
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: 3, // صفحة الشات تابعة للـ Coach
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFF4877B),
            unselectedItemColor: const Color(0xFF8C98A4),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            onTap: _onNavTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Train'),
              BottomNavigationBarItem(icon: Icon(Icons.local_drink_rounded), label: 'Bar'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Coach'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  // ودجت رسائل الشات
  Widget _buildChatBubble({required String message, required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFF4877B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF1D2733),
            fontSize: 14,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

// ودجت صفوف التقدم في التمارين
class _ProgressRow extends StatelessWidget {
  final String exercise;
  final String weight;

  const _ProgressRow({required this.exercise, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          exercise,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1D2733),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          weight,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2733),
          ),
        ),
      ],
    );
  }
}
