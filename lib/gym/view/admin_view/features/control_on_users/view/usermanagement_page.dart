import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/view/Edit_Prices&History_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/hive_helper/user_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/add_user_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/terminate_contract_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym_occupancy/gym_occupancy_view.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/overview/view/overview_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/policies/policies_view.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  bool _isDrawerOpen = false;
  String _selectedRoleFilter = 'All';
  String _searchQuery = '';

  final List<String> filterChips = [
    'All',
    'Coachs',
    'Bar workers',
    'Clients',
    'Admins',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserCubit>().getUsers();
      }
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  List<UserModel> _resolveUsersSource(UserCubit cubit) {
    if (cubit.users.isNotEmpty) {
      return cubit.users;
    }
    if (UserHiveHelper.myUsers.isNotEmpty) {
      return UserHiveHelper.myUsers;
    }
    return const [];
  }

  List<UserModel> _getFilteredUsers(List<UserModel> allUsers) {
    return allUsers.where((user) {
      bool matchesRole = true;
      if (_selectedRoleFilter != 'All') {
        final targetRoleStr = _selectedRoleFilter.toLowerCase();
        if (targetRoleStr.contains('coach')) {
          matchesRole = user.role == UserRole.coach;
        } else if (targetRoleStr.contains('bar')) {
          matchesRole = user.role == UserRole.barWorker;
        } else if (targetRoleStr.contains('client')) {
          matchesRole = user.role == UserRole.client;
        } else if (targetRoleStr.contains('admin')) {
          matchesRole = user.role == UserRole.admin;
        }
      }

      final matchesSearch = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.phone.contains(_searchQuery);

      return matchesRole && matchesSearch;
    }).toList();
  }

  Future<void> _openAddUserPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddUserPage()),
    );
    if (mounted) {
      context.read<UserCubit>().getUsers();
    }
  }

  Future<void> _openTerminateContractPage(UserModel user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TerminateContractPage(user: user)),
    );
    if (mounted) {
      context.read<UserCubit>().getUsers();
    }
  }

  void _openEditSubscriptionFlow(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PoliciesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
                            onTap: _toggleDrawer,
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
                          const Expanded(
                            child: Text(
                              "Users",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D2733),
                              ),
                            ),
                          ),
                          BlocBuilder<UserCubit, UserState>(
                            builder: (context, state) {
                              final count =
                                  _resolveUsersSource(context.read<UserCubit>())
                                      .length;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF3F3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "$count people",
                                  style: const TextStyle(
                                    color: Color(0xFF6B7886),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filterChips.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final chipLabel = filterChips[index];
                          final isSelected = _selectedRoleFilter == chipLabel;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRoleFilter = chipLabel;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF56C5B1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : const Color(0xFFCFDCD9),
                                ),
                              ),
                              child: Text(
                                chipLabel,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1D2733),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search by name or phone",
                          hintStyle: const TextStyle(
                            color: Color(0xFF8C98A4),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFCFDCD9),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFCFDCD9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF56C5B1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UserLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF56C5B1),
                              ),
                            );
                          }

                          final sourceUsers =
                              _resolveUsersSource(context.read<UserCubit>());
                          final list = _getFilteredUsers(sourceUsers);

                          if (list.isEmpty) {
                            return const Center(
                              child: Text(
                                "No users found.",
                                style: TextStyle(
                                  color: Color(0xFF6B7886),
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final user = list[index];
                              return _buildUserCard(context, user);
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: ElevatedButton.icon(
                        onPressed: _openAddUserPage,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: const Text(
                          "Add user",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4877B),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isDrawerOpen)
              Stack(
                children: [
                  GestureDetector(
                    onTap: _toggleDrawer,
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
                              _toggleDrawer();
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
                              _toggleDrawer();
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
                              _toggleDrawer();
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
                              _toggleDrawer();
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
                              _toggleDrawer();
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
      ),
    );
  }

  String _getUserSubtitle(UserModel user) {
    if (user.role == UserRole.coach) {
      return '${user.specialization ?? "Coach"} · ${user.currentClientsCount} clients · ${user.remainingCapacity} spots left';
    }
    return user.summarySubtitle;
  }

  Widget _buildUserCard(BuildContext context, UserModel user) {
    final bool isExpiring = user.status == AccountStatus.expiring;

    return GestureDetector(
      onTap: () => _showUserActionBottomSheet(context, user),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3ECEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEEF3F3),
              child: Text(
                _getInitials(user.name),
                style: const TextStyle(
                  color: Color(0xFFF4877B),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2733),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _getUserSubtitle(user),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7886),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF3F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getRoleDisplayName(user.role),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7886),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isExpiring
                        ? const Color(0xFFFDE9C9)
                        : const Color(0xFFD6F3EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isExpiring
                          ? const Color(0xFFBF7414)
                          : const Color(0xFF1F9A85),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUserActionBottomSheet(BuildContext context, UserModel user) {
    final bool isStaff =
        user.role == UserRole.coach || user.role == UserRole.barWorker;
    final bool isClient = user.role == UserRole.client;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFDCD9),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFEEF3F3),
                    child: Text(
                      _getInitials(user.name),
                      style: const TextStyle(
                        color: Color(0xFFF4877B),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${_getRoleDisplayName(user.role)} · ${_getUserSubtitle(user)}",
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF6B7886),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE3ECEA)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Phone",
                          style: TextStyle(
                            color: Color(0xFF6B7886),
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          user.phone,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFE3ECEA)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Joined",
                          style: TextStyle(
                            color: Color(0xFF6B7886),
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          user.joinedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _showEditUserDialog(context, user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4877B),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Edit data",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isStaff) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _openTerminateContractPage(user);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Color(0xFFD9483B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Terminate contract",
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD9483B),
                    ),
                  ),
                ),
              ],
              if (isClient) ...[
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _openEditSubscriptionFlow(context, user);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B5563),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Edit subscription",
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(sheetContext),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFCFDCD9)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2733),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit user data",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedName = nameController.text.trim();
                final updatedPhone = phoneController.text.trim();
                if (updatedName.isEmpty || updatedPhone.isEmpty) return;

                final updatedUser = UserModel(
                  id: user.id,
                  name: updatedName,
                  phone: updatedPhone,
                  email: emailController.text.trim().isEmpty
                      ? null
                      : emailController.text.trim(),
                  role: user.role,
                  status: user.status,
                  joinedDate: user.joinedDate,
                  subscriptionPlan: user.subscriptionPlan,
                  subscriptionStartDate: user.subscriptionStartDate,
                  renewalDate: user.renewalDate,
                  daysElapsed: user.daysElapsed,
                  coachId: user.coachId,
                  coachName: user.coachName,
                  specialization: user.specialization,
                  capacity: user.capacity,
                  clientIds: user.clientIds,
                  clientNames: user.clientNames,
                  clientsCount: user.clientsCount,
                  shift: user.shift,
                  contractStartDate: user.contractStartDate,
                  contractEndDate: user.contractEndDate,
                  permissions: user.permissions,
                );

                context.read<UserCubit>().updateUser(updatedUser);
                Navigator.pop(dialogContext);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.coach:
        return "Coach";
      case UserRole.barWorker:
        return "Bar worker";
      case UserRole.client:
        return "Client";
      case UserRole.admin:
        return "Admin";
    }
  }
}