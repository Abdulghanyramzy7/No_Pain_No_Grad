import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';

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
  String terminationMessage = '';

  void toggleTab(int tab) {
    setState(() {
      selectedTab = tab;
      terminationMessage = '';
    });
  }

  void toggleAdminApproval() {
    setState(() {
      isAdminApproved = !isAdminApproved;
    });
  }

  void toggleStaffApproval() {
    setState(() {
      isStaffApproved = !isStaffApproved;
    });
  }

  void terminateAccount(BuildContext context) {
    context.read<UserCubit>().terminateUser(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserTerminatedState) {
          setState(() {
            terminationMessage =
                "Done. ${user.name}'s account is removed and the ${user.currentClientsCount} clients wait to be reassigned.";
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

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.plateBackground,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // الهيدر العلوي
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        const Text(
                          "Terminate",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                        const Icon(Icons.more_horiz, color: Color(0xFF1D2733)),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // كارت بيانات المستخدم
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                        // أزرار التبديل (Tabs)
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
                                      borderRadius: BorderRadius.circular(12),
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
                                      borderRadius: BorderRadius.circular(12),
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

                        // محتوى التبويب حسب الاختيار
                        if (selectedTab == 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "The contract end date has passed, so the account is removed normally. No approval is needed.",
                                style: TextStyle(
                                  color: Color(0xFF2E7D59),
                                  fontSize: 14,
                                  height: 1.5,
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
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE3ECEA),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mutual agreement",
                                      style: TextStyle(
                                        color: Color(0xFF1D2733),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF6B7886),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // الموافقة الأولى (Admin)
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

                              // الموافقة الثانية (Staff/Coach)
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

                  // الزر السفلي لإنهاء العقد
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => terminateAccount(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9483B),
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
                                  ? "Terminate contract now"
                                  : "Remove account",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3ECEA)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F3),
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
                        ? const Color(0xFF2E7D59)
                        : const Color(0xFF6B7886),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
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
                    : const Color(0xFF2E7D59),
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