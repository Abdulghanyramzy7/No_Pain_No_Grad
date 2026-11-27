import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/core/const/customer_bottom_nav.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/user_controller.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/cubit/cubit/coach_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/hive_helper/coach_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/chat/private_chat_page.dart';

class TrainersListPage extends StatefulWidget {
  const TrainersListPage({super.key});

  @override
  State<TrainersListPage> createState() => _TrainersListPageState();
}

class _TrainersListPageState extends State<TrainersListPage> {
  late final UsersController _usersController;

  @override
  void initState() {
    super.initState();
    _usersController = Get.isRegistered<UsersController>()
        ? Get.find<UsersController>()
        : Get.put(UsersController());
    context.read<CoachCubit>().getCoaches();
  }

  (Color, Color) _badgeColors(String label) {
    switch (label) {
      case 'Available':
        return (const Color(0xFFE2F6F0), const Color(0xFF2E7D59));
      case 'Almost full':
        return (const Color(0xFFFFF1DE), const Color(0xFFE08A1E));
      default:
        return (Colors.grey.shade100, Colors.grey);
    }
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
              Expanded(
                child: Obx(() {
                  // يقرأ مباشرة من UsersController.coachesList ويتحدث تلقائياً
                  final coaches = _usersController.coachesList;
                  CoachHiveHelper.coaches = coaches;

                  return BlocBuilder<CoachCubit, CoachState>(
                    builder: (context, state) {
                      if (state is CoachLoadingState && coaches.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF4877B),
                          ),
                        );
                      }

                      if (coaches.isEmpty) {
                        return const Center(
                          child: Text(
                            "No trainers available yet",
                            style: TextStyle(
                              color: Color(0xFF6B7886),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: coaches.length,
                        itemBuilder: (context, index) {
                          final coach = coaches[index];
                          final (badgeBg, badgeFg) =
                              _badgeColors(coach.coachStatusLabel);

                          return GestureDetector(
                            onTap: () {
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
                                    backgroundColor: const Color(0xFFF4877B)
                                        .withValues(alpha: 0.2),
                                    child: Text(
                                      coach.name.isNotEmpty
                                          ? coach.name[0].toUpperCase()
                                          : '?',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          "${coach.specialization ?? 'Coach'} · ${coach.currentClientsCount}/${coach.capacity ?? 0} clients",
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
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 3),
    );
  }
}