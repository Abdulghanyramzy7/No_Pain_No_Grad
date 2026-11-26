import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/overview/view/overview_page.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addPhoneController = TextEditingController();
  final TextEditingController addEmailController = TextEditingController();
  final TextEditingController addPasswordController = TextEditingController();
  final TextEditingController addStartDateController = TextEditingController();
  final TextEditingController addEndDateController = TextEditingController();

  UserRole selectedRole = UserRole.client;
  bool isDrawerOpen = false;
  bool isAccountCreated = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  void dispose() {
    addNameController.dispose();
    addPhoneController.dispose();
    addEmailController.dispose();
    addPasswordController.dispose();
    addStartDateController.dispose();
    addEndDateController.dispose();
    super.dispose();
  }

  void _createNewUser(BuildContext context) {
    final phone = addPhoneController.text.trim();
    final email = addEmailController.text.trim();
    final name = addNameController.text.trim().isNotEmpty
        ? addNameController.text.trim()
        : (email.contains('@') ? email.split('@').first : 'New User');

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email.isEmpty ? null : email,
      role: selectedRole,
      status: AccountStatus.active,
      joinedDate: addStartDateController.text.trim().isNotEmpty
          ? addStartDateController.text.trim()
          : "26 Nov 2026",
      contractStartDate: DateTime.tryParse(addStartDateController.text.trim()),
      contractEndDate: DateTime.tryParse(addEndDateController.text.trim()),
    );

    context.read<UserCubit>().addUser(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserAddedState) {
          setState(() {
            isAccountCreated = true;
          });
          addNameController.clear();
          addPhoneController.clear();
          addEmailController.clear();
          addPasswordController.clear();
          addStartDateController.clear();
          addEndDateController.clear();
        } else if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UserLoadingState;

        return Scaffold(
          body: Stack(
            children: [
              // 1. المحتوى الأساسي للصفحة
              Container(
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
                          children: [
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
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Add user",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D2733),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // المحتوى القابل للتمرير (الحقول)
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildFieldLabel("Full Name"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addNameController,
                              hint: "Ahmed Ali",
                            ),
                            const SizedBox(height: 16),

                            _buildFieldLabel("Role"),
                            const SizedBox(height: 6),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: const Color(0xFFCFDCD9)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<UserRole>(
                                  value: selectedRole,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(
                                      value: UserRole.client,
                                      child: Text("Client"),
                                    ),
                                    DropdownMenuItem(
                                      value: UserRole.coach,
                                      child: Text("Coach"),
                                    ),
                                    DropdownMenuItem(
                                      value: UserRole.barWorker,
                                      child: Text("Bar worker"),
                                    ),
                                    DropdownMenuItem(
                                      value: UserRole.admin,
                                      child: Text("Admin"),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => selectedRole = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildFieldLabel("Phone"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addPhoneController,
                              hint: "01x xxxx xxxx",
                            ),
                            const SizedBox(height: 16),

                            _buildFieldLabel("Email (login)"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addEmailController,
                              hint: "name@email.com",
                            ),
                            const SizedBox(height: 16),

                            _buildFieldLabel("Temporary password"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addPasswordController,
                              hint: "PLATE-4821",
                            ),
                            const SizedBox(height: 16),

                            // كارت الـ Contract
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: const Color(0xFFE3ECEA)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Contract",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D2733),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFieldLabel("Start date"),
                                  const SizedBox(height: 6),
                                  _buildTextField(
                                    controller: addStartDateController,
                                    hint: "16 Oct 2026",
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFieldLabel("End date"),
                                  const SizedBox(height: 6),
                                  _buildTextField(
                                    controller: addEndDateController,
                                    hint: "16 Oct 2027",
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Ending before this date later needs your approval and the person's approval.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8C98A4),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // رسالة النجاح الخضراء تظهر بعد الإضافة في Hive
                            if (isAccountCreated)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2F6F0),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  "Account created. Login details were sent to the new user.",
                                  style: TextStyle(
                                    color: Color(0xFF2E7D59),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // الأزرار السفلية (Cancel و Create account)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  side: const BorderSide(
                                      color: Color(0xFFCFDCD9)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D2733),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _createNewUser(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF4877B),
                                  minimumSize: const Size(double.infinity, 50),
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
                                    : const Text(
                                        "Create account",
                                        style: TextStyle(
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
                    ],
                  ),
                ),
              ),

              // القائمة الجانبية (Drawer Menu)
              if (isDrawerOpen)
                Stack(
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
                                border:
                                    Border.all(color: const Color(0xFFE3ECEa)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDE0dc),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    builder: (_) => AdminOverviewPage(),
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
                                Navigator.pop(context);
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.person_outline,
                              title: "Gym Occupancy",
                              isSelected: false,
                              onTap: () {},
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
                              onTap: () {},
                            ),
                            _buildDrawerItem(
                              icon: Icons.credit_card_outlined,
                              title: "Subscriptions & Policies",
                              isSelected: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B7886),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF8C98A4), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCFDCD9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCFDCD9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF56C5B1)),
        ),
      ),
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
}