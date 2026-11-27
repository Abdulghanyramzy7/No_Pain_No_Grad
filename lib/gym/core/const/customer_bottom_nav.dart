import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/trainers_list_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_view/bar_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/home.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/profile.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights/weights.dart';

class CustomerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onCoachTapWhenOnChat;

  const CustomerBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onCoachTapWhenOnChat,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) {
      if (index == 3 && onCoachTapWhenOnChat != null) {
        onCoachTapWhenOnChat!();
      }
      return;
    }

    final Widget targetPage = switch (index) {
      0 => const CustomerHome(),
      1 => const WeightsScreen(),
      2 => const BarPage(),
      3 => const TrainersListPage(),
      _ => const ProfileScreen(),
    };

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF4877B),
        unselectedItemColor: const Color(0xFF8C98A4),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Train',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink_rounded),
            label: 'Bar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Coach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}