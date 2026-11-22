import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/policies/remove_client_view.dart';
import 'clinet_model.dart';

class ClientDetailScreen extends StatefulWidget {
  final ClientModel client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
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
                    TextSpan(text: "PLATE ", style: TextStyle(color: Color(0xFF1D2733))),
                    TextSpan(text: "Admin", style: TextStyle(color: Color(0xFFF4877B))),
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
                          style: TextStyle(color: Color(0xFFF4877B), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dr. Khaled", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("Zamalek Club · Admin",
                            style: TextStyle(fontSize: 11, color: Color(0xFF6B7886))),
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
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => AdminOverviewPage()));
                },
              ),
              _buildDrawerItem(
                icon: Icons.group_outlined,
                title: "User Management",
                isSelected: false,
                onTap: () {
                  _toggleDrawer();
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => UsersManagementPage()));
                },
              ),
              _buildDrawerItem(icon: Icons.person_outline, title: "Gym Occupancy", isSelected: false, onTap: () {}),
              _buildDrawerItem(
                icon: Icons.local_bar_outlined,
                title: "Gym & Bar",
                isSelected: false,
                onTap: () {
                  _toggleDrawer();
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => GymBarPage()));
                },
              ),
              _buildDrawerItem(
                icon: Icons.local_offer_outlined,
                title: "Price History",
                isSelected: false,
                onTap: () {
                  _toggleDrawer();
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => EditPricesPage()));
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
          Icon(icon, size: 22, color: isSelected ? Colors.white : const Color(0xFF1D2733)),
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
  static const List<int> _allowedMonths = [1, 3, 6, 12];
  late int durationMonths;
  bool isDurationUpdated = false;

  @override
  void initState() {
    super.initState();
    // تعيين قيمة افتراضية لعدد الشهور حسب نوع الخطة
    durationMonths = PlansRepository.byTitle(widget.client.planType).months;
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.client;

    return Scaffold(
      body: Stack(
        children:[ Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Back Button + Title)
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.menu,
                              color: Color(0xFF1A1D1F)),
                         onPressed: _toggleDrawer,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Subscription',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
        
                  // 1. Client Card (المشابه للكارت الرئيسي)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            client.initials, // مستخرجة تلقائياً بالـ String
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF8C6D62),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: client.isEditable
                                ? const Color(0xFFD9F5EE)
                                : const Color(0xFFFCE4E4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            client.statusLabel,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: client.isEditable
                                  ? const Color(0xFF1B8A75)
                                  : const Color(0xFFD65A5A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // 2. Progress Section (منطقي حسب الأيام)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'PROGRESS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9CA3AF),
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Day ${client.currentDay}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: client.progressValue,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              client.isEditable
                                  ? const Color(0xFF1E9E89)
                                  : const Color(0xFFE57373),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '15-day window',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Text(
                              client.isEditable
                                  ? '${client.daysLeft} days left'
                                  : 'ended',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: client.isEditable
                                    ? const Color(0xFF1E9E89)
                                    : const Color(0xFFE57373),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // 3. الحالة الشرطية (Conditional UI) بناءً على الـ isEditable
                  if (client.isEditable) ...[
                    // --- حالة التعديل المتاحة (مثل Sara) ---
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9F5EE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'Editable. ${client.daysLeft} days left in the 15-day window.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1B8A75),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
        
                    // Duration Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DURATION',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9CA3AF),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  final i =
                                      _allowedMonths.indexOf(durationMonths);
                                  if (i > 0) {
                                    setState(() =>
                                        durationMonths = _allowedMonths[i - 1]);
                                  }
                                },
                                icon: const Icon(Icons.remove),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFFF3F4F6),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Text(
                                '$durationMonths ${durationMonths == 1 ? 'month' : 'months'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(width: 24),
                              IconButton(
                                onPressed: () {
                                  final i =
                                      _allowedMonths.indexOf(durationMonths);
                                  if (i < _allowedMonths.length - 1) {
                                    setState(() =>
                                        durationMonths = _allowedMonths[i + 1]);
                                  }
                                },
                                icon: const Icon(Icons.add),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFFF3F4F6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE57373),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.client.planType =
                                      PlansRepository.byMonths(durationMonths)
                                          .title;
                                  isDurationUpdated = true;
                                });
                              },
                              child: const Text(
                                'Save duration',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isDurationUpdated) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Duration updated.',
                        style: TextStyle(
                          color: Color(0xFF1B8A75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
        
                    // Remove Client Button (Outlined)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE57373)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final plan = PlansRepository.byTitle(client.planType);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RemoveClientScreen(
                                client: client,
                                planPrice: plan.price,
                                planDurationDays: plan.durationDays,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Remove client',
                          style: TextStyle(
                            color: Color(0xFFE57373),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // --- حالة القفل وعدم السماح بالتعديل (مثل Youssef) ---
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4E4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Locked. Editing or Removing the duration is not allowed after 15 days, in any case.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD65A5A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ),
        if(_isDrawerOpen) _buildDrawerOverlay()
        ]
      ),
    );
  }
}
