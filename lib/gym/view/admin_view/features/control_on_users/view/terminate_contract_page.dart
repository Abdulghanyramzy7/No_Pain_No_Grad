import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/view/Edit_Prices&History_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym_occupancy/gym_occupancy_view.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/overview/view/overview_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/policies/policies_view.dart';

class TerminateContractPage extends StatefulWidget {
  final UserModel user;
  const TerminateContractPage({super.key, required this.user});

  @override
  State<TerminateContractPage> createState() => _TerminateContractPageState();
}

class _TerminateContractPageState extends State<TerminateContractPage> {
  int selectedTab = 1; // 0: Contract ended, 1: Before end date
  bool isAdminApproved = false;
  bool isStaffApproved = false;
  bool isDrawerOpen = false;
  String selectedReason = "Mutual agreement";
  String terminationMessage = '';

  final List<String> reasonsList = [
    "Mutual agreement",
    "Schedule conflict",
    "Relocation",
    "Contract violation",
  ];

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  void toggleTab(int tab) {
    setState(() {
      selectedTab = tab;
      terminationMessage = '';
    });
  }

  void toggleAdminApproval() {
    setState(() {
      isAdminApproved = !isAdminApproved;
      terminationMessage = '';
    });
  }

  void toggleStaffApproval() {
    setState(() {
      isStaffApproved = !isStaffApproved;
      terminationMessage = '';
    });
  }

  void terminateAccount(BuildContext context, bool isReady) {
    if (!isReady) return;
    context.read<UserCubit>().terminateUser(widget.user.id);
  }

  Widget _buildDrawerOverlay(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: toggleDrawer,
          child: Container(color: Colors.black.withOpacity(0.35)),
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
                        style: TextStyle(color: Color(0xFF1D2733)),
                      ),
                      TextSpan(
                        text: "Admin",
                        style: TextStyle(color: Color(0xFFF4877B)),
                      ),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Zamalek Club · Admin",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7886),
                            ),
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
                  isSelected: false,
                  onTap: () {
                    toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminOverviewPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.group_outlined,
                  title: "User Management",
                  isSelected: true,
                  onTap: () {
                    toggleDrawer();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UsersManagementPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: "Gym Occupancy",
                  isSelected: false,
                  onTap: () {
                    toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GymOccupancyPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.local_bar_outlined,
                  title: "Gym & Bar",
                  isSelected: false,
                  onTap: () {
                    toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GymBarPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.local_offer_outlined,
                  title: "Price History",
                  isSelected: false,
                  onTap: () {
                    toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditPricesPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.credit_card_outlined,
                  title: "Subscriptions & Policies",
                  isSelected: false,
                  onTap: () {
                    toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PoliciesScreen(),
                      ),
                    );
                  },
                ),
              ],
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
          color: isSelected ? const Color(0xFF56C5B1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1D2733),
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1D2733),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserTerminatedState) {
          setState(() {
            terminationMessage =
                "Done. ${user.name}'s account is terminated and the ${user.currentClientsCount} clients wait to be reassigned.";
          });
        } else if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UserLoadingState;
        final bool isBeforeEnd = selectedTab == 1;
        final bool isReady =
            !isBeforeEnd || (isAdminApproved && isStaffApproved);

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
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Color(0xFF1D2733),
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: toggleDrawer,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.menu,
                                      color: Color(0xFF1D2733),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Terminate",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D2733),
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE3ECEA)),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFFDE0dc),
                                    child: Text(
                                      _getInitials(user.name),
                                      style: const TextStyle(
                                        color: Color(0xFFF4877B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1D2733),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${user.role == UserRole.coach ? 'Coach' : 'Bar worker'} · contract ends 31 Dec 2026",
                                          style: const TextStyle(
                                            fontSize: 12,
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
                                      color: const Color(0xFFEEF3F3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      selectedTab == 0 ? "Ended" : "76 days left",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6B7886),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3ECEA),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => toggleTab(0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selectedTab == 0
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: selectedTab == 0
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.04),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          "Contract ended",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedTab == 0
                                                ? const Color(0xFF1D2733)
                                                : const Color(0xFF6B7886),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => toggleTab(1),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selectedTab == 1
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: selectedTab == 1
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.04),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          "Before end date",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedTab == 1
                                                ? const Color(0xFF1D2733)
                                                : const Color(0xFF6B7886),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (selectedTab == 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD6F3EC),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      "The contract end date has passed, so the account is removed normally. No approval is needed.",
                                      style: TextStyle(
                                        color: Color(0xFF1F9A85),
                                        fontSize: 13.5,
                                        height: 1.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  if (terminationMessage.isNotEmpty)
                                    Text(
                                      terminationMessage,
                                      style: const TextStyle(
                                        color: Color(0xFF2E7D59),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3E7),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFFDE8D0),
                                      ),
                                    ),
                                    child: Text(
                                      "Ending early needs two approvals: yours and ${user.name.split(' ').first}'s. The account stays active until both are done.",
                                      style: const TextStyle(
                                        color: Color(0xFFD97706),
                                        fontSize: 13.5,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Reason",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D2733),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFE3ECEA),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedReason,
                                        isExpanded: true,
                                        items: reasonsList
                                            .map(
                                              (r) => DropdownMenuItem(
                                                value: r,
                                                child: Text(
                                                  r,
                                                  style: const TextStyle(
                                                    color: Color(0xFF1D2733),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(() => selectedReason = val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildApprovalCard(
                                    step: "1",
                                    title: "Admin approval",
                                    subtitle: isAdminApproved
                                        ? "Approved just now"
                                        : "Waiting for you",
                                    isApproved: isAdminApproved,
                                    buttonText:
                                        isAdminApproved ? "Undo" : "Approve",
                                    onTap: toggleAdminApproval,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildApprovalCard(
                                    step: "2",
                                    title:
                                        "${user.name.split(' ').first}'s approval",
                                    subtitle: isStaffApproved
                                        ? "Approved by ${user.name.split(' ').first}"
                                        : "Request sent to ${user.name.split(' ').first} · pending",
                                    isApproved: isStaffApproved,
                                    buttonText:
                                        isStaffApproved ? "Undo" : "Simulate",
                                    onTap: toggleStaffApproval,
                                  ),
                                  const SizedBox(height: 15),
                                  if (terminationMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        terminationMessage,
                                        style: const TextStyle(
                                          color: Color(0xFF2E7D59),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: (isLoading || !isReady)
                              ? null
                              : () => terminateAccount(context, isReady),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isReady
                                ? const Color(0xFFD9483B)
                                : const Color(0xFFEEF3F3),
                            foregroundColor: isReady
                                ? Colors.white
                                : const Color(0xFF6B7886),
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isBeforeEnd
                                      ? (isReady
                                          ? "Terminate contract now"
                                          : "Waiting for both approvals")
                                      : "Remove account",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isDrawerOpen) _buildDrawerOverlay(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApprovalCard({
    required String step,
    required String title,
    required String subtitle,
    required bool isApproved,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isApproved ? const Color(0xFFD6F3EC) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApproved ? const Color(0xFF56C5B1) : const Color(0xFFE3ECEA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7886),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1D2733),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isApproved
                        ? const Color(0xFF1F9A85)
                        : const Color(0xFF6B7886),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isApproved
                    ? const Color(0xFFCFDCD9)
                    : const Color(0xFF56C5B1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: isApproved
                    ? const Color(0xFF1D2733)
                    : const Color(0xFF1F9A85),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}