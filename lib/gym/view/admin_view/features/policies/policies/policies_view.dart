import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/view/Edit_Prices&History_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym_occupancy/gym_occupancy_view.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/overview/view/overview_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/client_detail/client_detail_view.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/clinet_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/policies_cubit.dart';
import 'cubit/policies_state.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PoliciesCubit(),
      child: const _PoliciesView(),
    );
  }
}

class _PoliciesView extends StatefulWidget {
  const _PoliciesView();

  @override
  State<_PoliciesView> createState() => _PoliciesViewState();
}

class _PoliciesViewState extends State<_PoliciesView> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() => setState(() => _isDrawerOpen = !_isDrawerOpen);

  Widget _buildDrawerOverlay() {
    return Stack(
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
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE0DC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("DK",
                            style: TextStyle(
                                color: Color(0xFFF4877B),
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dr. Khaled",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("Zamalek Club · Admin",
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF6B7886))),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AdminOverviewPage()));
                  },
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
                            builder: (_) => UsersManagementPage()));
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => GymBarPage()));
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.local_offer_outlined,
                  title: "Price History",
                  isSelected: false,
                  onTap: () {
                    _toggleDrawer();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EditPricesPage()));
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.credit_card_outlined,
                  title: "Subscriptions & Policies",
                  isSelected: true,
                  onTap: _toggleDrawer,
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
            Icon(icon,
                size: 22,
                color: isSelected ? Colors.white : const Color(0xFF1D2733)),
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

  // فتح Bottom Sheet لتعديل سعر الخطة
  void _showEditPriceBottomSheet(PlanModel plan) {
    final cubit = context.read<PoliciesCubit>();
    final TextEditingController priceController =
        TextEditingController(text: plan.price.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit ${plan.title} Price',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D1F),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Price (EGP)',
                  suffixText: 'EGP',
                  filled: true,
                  fillColor: const Color(0xFFF4F6F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E9E89),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    final newPrice = int.tryParse(priceController.text.trim());
                    if (newPrice != null && newPrice > 0) {
                      cubit.updatePrice(plan, newPrice);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoliciesCubit, PoliciesState>(
      builder: (context, state) {
        final _plans = state.plans;
        final _clients = state.clients;
        return Scaffold(
          body: Stack(children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 152, 238, 224),
                    Color.fromRGBO(182, 239, 228, 1),
                    Color.fromARGB(255, 209, 238, 231),
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (Menu Icon + Policies Title)
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
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
                            child: IconButton(
                              icon: const Icon(Icons.menu,
                                  color: Color(0xFF1A1D1F)),
                              onPressed: _toggleDrawer,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Policies',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Rules Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rules',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildRuleItem(
                              number: '1',
                              text:
                                  'Duration can be edited during the first 15 days only. After day 15 it is locked in every case.',
                            ),
                            const SizedBox(height: 10),
                            _buildRuleItem(
                              number: '2',
                              text:
                                  "Removing a client before day 15 deducts consumed days and the admin fee (300 EGP), then needs the client's approval.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // PLANS Section Title
                      const Text(
                        'PLANS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // PLANS Grid (2x2)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _plans.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.38,
                        ),
                        itemBuilder: (context, index) {
                          final plan = _plans[index];
                          return _buildPlanCard(plan);
                        },
                      ),
                      const SizedBox(height: 22),

                      // CLIENTS Section Title
                      const Text(
                        'CLIENTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // CLIENTS List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _clients.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final client = _clients[index];
                          return ClientCard(
                            client: client,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClientDetailScreen(client: client),
                                ),
                              );
                              context.read<PoliciesCubit>().refresh();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isDrawerOpen) _buildDrawerOverlay()
          ]),
        );
      },
    );
  }

  Widget _buildRuleItem({required String number, required String text}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF374151),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PlanModel plan) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              InkWell(
                onTap: () => _showEditPriceBottomSheet(plan),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          Text(
            _formatNumber(plan.price),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          Text(
            'EGP · ${plan.durationDays} days',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

// الـ Widget الخاص بكارت العميل (Clickable)
class ClientCard extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onTap;

  const ClientCard({
    super.key,
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color badgeBgColor =
        client.isEditable ? const Color(0xFFD9F5EE) : const Color(0xFFFCE4E4);
    final Color badgeTextColor =
        client.isEditable ? const Color(0xFF1B8A75) : const Color(0xFFD65A5A);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  client.initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color.fromARGB(255, 231, 136, 102),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      client.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  client.statusLabel,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
