import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/cubit/cubit/coach_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/hive_helper/coach_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/chat/private_chat_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_view/bar_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/home.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/profile.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights.dart';

class TrainersListPage extends StatelessWidget {
  const TrainersListPage({super.key});

  // ألوان الـ Badge حسب حالة سعة المدرب (من UserModel.coachStatusLabel)
  (Color, Color) _badgeColors(String label) {
    switch (label) {
      case 'Available':
        return (const Color(0xFFE2F6F0), const Color(0xFF2E7D59));
      case 'Almost full':
        return (const Color(0xFFFFF1DE), const Color(0xFFE08A1E));
      default: // Full
        return (Colors.grey.shade100, Colors.grey);
    }
  }

  // التنقل بين صفحات شريط التنقل السفلي
  void _onNavTap(BuildContext context, int index) {
    if (index == 3) return; // احنا واقفين على صفحة المدربين
    final Widget page = switch (index) {
      0 => const CustomerHome(),
      1 => const WeightsScreen(),
      2 => const BarPage(),
      _ => const ProfileScreen(),
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.plateBackground,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الهيدر
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Our Trainers",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2733),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // لستة المدربين
              Expanded(
                child: BlocBuilder<CoachCubit, CoachState>(
                  builder: (context, state) {
                    if (state is CoachLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final coaches = CoachHiveHelper.coaches;

                    if (coaches.isEmpty) {
                      return const Center(
                        child: Text(
                          "No trainers available yet",
                          style: TextStyle(color: Color(0xFF6B7886), fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: coaches.length,
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        final (badgeBg, badgeFg) = _badgeColors(coach.coachStatusLabel);

                        return GestureDetector(
                          onTap: () {
                            // الانتقال لصفحة الشات البرايفت وتمرير بيانات المدرب
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrivateChatPage(coach: coach),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      const Color(0xFFF4877B).withValues(alpha: 0.2),
                                  child: Text(
                                    coach.name[0],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF4877B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
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
                                      const SizedBox(height: 4),
                                      Text(
                                        coach.specialization ?? "Coach",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF6B7886),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    coach.coachStatusLabel,
                                    style: TextStyle(
                                      color: badgeFg,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
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
          currentIndex: 3,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFF4877B),
          unselectedItemColor: const Color(0xFF8C98A4),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (index) => _onNavTap(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Train'),
            BottomNavigationBarItem(icon: Icon(Icons.local_drink_rounded), label: 'Bar'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Coach'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
