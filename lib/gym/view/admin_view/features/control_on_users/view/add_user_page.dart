import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/view/Edit_Prices&History_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym_occupancy/gym_occupancy.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/overview/view/overview_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/policies_view.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addPhoneController = TextEditingController();
  final TextEditingController addEmailController = TextEditingController();
  final TextEditingController addPasswordController =
      TextEditingController(text: "PLATE-4821");
  final TextEditingController addStartDateController =
      TextEditingController(text: "16 Oct 2026");
  final TextEditingController addEndDateController =
      TextEditingController(text: "16 Oct 2027");

  UserRole selectedRole = UserRole.coach;
  String selectedPlan = "Quarterly";
  String selectedCoach = "Hany Salah";
  Map<String, bool> adminPermissions = {
    'admins': false,
    'users': true,
    'subs': true,
    'bar': false,
    'prices': false,
    'occ': true,
  };

  bool isDrawerOpen = false;
  bool isAccountCreated = false;

  final List<String> plansList = [
    "Monthly",
    "Quarterly",
    "Half-yearly",
    "Yearly",
  ];

  final List<String> coachesList = [
    "Hany Salah",
    "Mona Tarek",
    "Omar Ezzat",
  ];

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

    final isStaff =
        selectedRole == UserRole.coach || selectedRole == UserRole.barWorker;

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
      subscriptionPlan:
          selectedRole == UserRole.client ? selectedPlan : null,
      coachName: selectedRole == UserRole.client ? selectedCoach : null,
      contractStartDate:
          isStaff ? DateTime.tryParse(addStartDateController.text.trim()) : null,
      contractEndDate:
          isStaff ? DateTime.tryParse(addEndDateController.text.trim()) : null,
      permissions: selectedRole == UserRole.admin
          ? Map<String, bool>.from(adminPermissions)
          : null,
    );

    context.read<UserCubit>().addUser(newUser);
  }

  @override
  Widget build(BuildContext context) {
    final bool isStaff =
        selectedRole == UserRole.coach || selectedRole == UserRole.barWorker;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserAddedState) {
          setState(() {
            isAccountCreated = true;
          });
          addNameController.clear();
          addPhoneController.clear();
          addEmailController.clear();
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
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildRoleSegmentedBar(),
                            const SizedBox(height: 16),
                            _buildFieldLabel("Full name"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addNameController,
                              hint: "e.g. Mohamed Adel",
                            ),
                            const SizedBox(height: 14),
                            _buildFieldLabel("Phone"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addPhoneController,
                              hint: "01x xxxx xxxx",
                            ),
                            const SizedBox(height: 14),
                            _buildFieldLabel("Email (login)"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addEmailController,
                              hint: "name@email.com",
                            ),
                            const SizedBox(height: 14),
                            _buildFieldLabel("Temporary password"),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: addPasswordController,
                              hint: "PLATE-4821",
                            ),
                            const SizedBox(height: 16),
                            if (isStaff)
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
                            if (selectedRole == UserRole.client)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: const Color(0xFFE3ECEA)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Subscription",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D2733),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: plansList.map((plan) {
                                        final isSelected = selectedPlan == plan;
                                        return ChoiceChip(
                                          label: Text(plan),
                                          selected: isSelected,
                                          selectedColor: const Color(0xFF56C5B1),
                                          labelStyle: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF1D2733),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          onSelected: (_) {
                                            setState(() => selectedPlan = plan);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      "Coach",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D2733),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: coachesList.map((coach) {
                                        final isSelected =
                                            selectedCoach == coach;
                                        return ChoiceChip(
                                          label: Text(coach),
                                          selected: isSelected,
                                          selectedColor: const Color(0xFF56C5B1),
                                          labelStyle: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF1D2733),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          onSelected: (_) {
                                            setState(
                                                () => selectedCoach = coach);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            if (selectedRole == UserRole.admin)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: const Color(0xFFE3ECEA)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Admin permissions",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D2733),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...adminPermissions.entries.map((entry) {
                                      return SwitchListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        value: entry.value,
                                        activeColor: const Color(0xFFF4877B),
                                        onChanged: (val) {
                                          setState(() {
                                            adminPermissions[entry.key] = val;
                                          });
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),
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
                                    Border.all(color: const Color(0xFFE3ECEA)),
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
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleSegmentedBar() {
    final items = [
      (UserRole.coach, "Coach"),
      (UserRole.barWorker, "Bar worker"),
      (UserRole.client, "Client"),
      (UserRole.admin, "Admin"),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3ECEA)),
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = selectedRole == item.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedRole = item.$1;
                  isAccountCreated = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF56C5B1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF6B7886),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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