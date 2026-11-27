import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/view/Edit_Prices&History_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/hive_helper/user_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/cubit/cubit/bar_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/hive_helper/hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym_occupancy/gym_occupancy.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/policies_view.dart';

class AdminOverviewPage extends StatefulWidget {
  const AdminOverviewPage({super.key});

  @override
  State<AdminOverviewPage> createState() => _AdminOverviewPageState();
}

class _AdminOverviewPageState extends State<AdminOverviewPage> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() => setState(() => _isDrawerOpen = !_isDrawerOpen);

  // TODO: مفيش موديل للإشغال لسه، الأرقام دي ثابتة لحد ما نربط صفحة Gym Occupancy
  static const int _peopleInside = 42;
  static const int _maxCapacity = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UserCubit>().getUsers();
      context.read<BarCubit>().getBarSettings();
    });
  }

  List<UserModel> _getExpiringClients(List<UserModel> sourceUsers) {
    final now = DateTime.now();
    return sourceUsers.where((user) {
      if (user.role != UserRole.client ||
          user.status == AccountStatus.terminated) {
        return false;
      }
      if (user.status == AccountStatus.expiring) {
        return true;
      }
      if (user.renewalDate != null) {
        final diffDays = user.renewalDate!.difference(now).inDays;
        return diffDays >= 0 && diffDays <= 7;
      }
      return false;
    }).toList();
  }

  String _daysLeftLabel(UserModel user) {
    if (user.renewalDate != null) {
      final diffDays = user.renewalDate!.difference(DateTime.now()).inDays;
      final safeDays = diffDays < 0 ? 0 : diffDays;
      return "$safeDays ${safeDays == 1 ? 'day' : 'days'} left";
    }
    if (user.daysElapsed != null) {
      return "Day ${user.daysElapsed}";
    }
    return "Expiring";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.plateBackground,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _toggleDrawer,
                          child: Container(
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
                            child: const Icon(Icons.menu,
                                color: Color(0xFF1D2733), size: 22),
                          ),
                        ),
                        const Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2F6F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Admin",
                            style: TextStyle(
                              color: Color(0xFF2E7D59),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, usersState) {
                        return BlocBuilder<BarCubit, BarState>(
                          builder: (context, barState) {
                            final allUsers = UserHiveHelper.myUsers;
                            final expiring = _getExpiringClients(allUsers);
                            final isBarActive =
                                AdminbarHiveHelper.isBarServiceActive;

                            return ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                _buildCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "GYM RIGHT NOW",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF8C98A4),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE2F6F0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(
                                              "Light",
                                              style: TextStyle(
                                                color: Color(0xFF2E7D59),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            "$_peopleInside",
                                            style: TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1D2733),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "people inside · ${_peopleInside * 100 ~/ _maxCapacity}% of max",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF6B7886),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const LinearProgressIndicator(
                                          value: _peopleInside / _maxCapacity,
                                          backgroundColor: Color(0xFFF4F6F6),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color(0xFF56C5B1),
                                          ),
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      const Row(
                                        children: [
                                          Icon(Icons.arrow_drop_up,
                                              color: Color(0xFF2E7D59),
                                              size: 20),
                                          Text(
                                            "Increasing. Updated 1 minute ago.",
                                            style: TextStyle(
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSmallMetricCard(
                                        title: "Active bar orders",
                                        count: isBarActive ? "0" : "—",
                                        subtitle: isBarActive
                                            ? "Being prepared"
                                            : "Bar is off",
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _buildSmallMetricCard(
                                        title: "Expiring soon",
                                        count: "${expiring.length}",
                                        subtitle: "Within 7 days",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Subscriptions expiring soon",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1D2733),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      if (expiring.isEmpty)
                                        const Text(
                                          "No subscriptions expiring soon",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6B7886),
                                          ),
                                        )
                                      else
                                        for (int i = 0;
                                            i < expiring.length;
                                            i++) ...[
                                          if (i > 0)
                                            const Divider(
                                                height: 24,
                                                color: Color(0xFFF0F2F5)),
                                          _buildSubscriptionItem(
                                            name: expiring[i].name,
                                            plan: expiring[i].subscriptionPlan ??
                                                "Member",
                                            daysLeft: _daysLeftLabel(expiring[i]),
                                          ),
                                        ],
                                    ],
                                  ),
                                ),
                                if (isBarActive) ...[
                                  const SizedBox(height: 20),
                                  _buildCard(
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Active bar orders",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1D2733),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "No active orders right now",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6B7886),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),
                              ],
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
          if (_isDrawerOpen) ...[
            GestureDetector(
              onTap: _toggleDrawer,
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 300,
                height: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 52, 16, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(
                              text: "PLATE ",
                              style: TextStyle(color: Color(0xFF1D2733))),
                          TextSpan(
                              text: "Admin",
                              style: TextStyle(color: Color(0xFFF4877B))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE3ECEA)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE0DC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "DK",
                              style: TextStyle(
                                color: Color(0xFFF4877B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dr. Khaled",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                "Zamalek Club · Admin",
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF6B7886)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDrawerItem(
                      icon: Icons.dashboard_outlined,
                      title: "Overview",
                      isSelected: true,
                      onTap: _toggleDrawer,
                    ),
                    _buildDrawerItem(
                      icon: Icons.group_outlined,
                      title: "User Management",
                      isSelected: false,
                      onTap: () {
                        _toggleDrawer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UsersManagementPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.person_outline,
                      title: "Gym Occupancy",
                      isSelected: false,
                      onTap: () {
                        _toggleDrawer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GymOccupancyPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.local_bar_outlined,
                      title: "Gym & Bar",
                      isSelected: false,
                      onTap: () {
                        _toggleDrawer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => GymBarPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.local_offer_outlined,
                      title: "Price History",
                      isSelected: false,
                      onTap: () {
                        _toggleDrawer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditPricesPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.credit_card_outlined,
                      title: "Subscriptions & Policies",
                      isSelected: false,
                      onTap: () {
                        _toggleDrawer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PoliciesScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSmallMetricCard({
    required String title,
    required String count,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7886),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2733),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8C98A4)),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionItem({
    required String name,
    required String plan,
    required String daysLeft,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2733),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              plan,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7886)),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3E7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            daysLeft,
            style: const TextStyle(
              color: Color(0xFFD97706),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE2F6F0) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF2E7D59)
                  : const Color(0xFF1D2733),
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF2E7D59)
                    : const Color(0xFF1D2733),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
