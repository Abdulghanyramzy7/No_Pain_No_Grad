import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/core/models/occupancy/occupancy_store.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/models/crowd_cycle_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/models/crowd_level_model.dart';

//  اتحولت لـ StatefulWidget عشان نقدر نتحكم في فتح وقفل القائمة بـ setState
class GymOccupancyPage extends StatefulWidget {
  const GymOccupancyPage({Key? key}) : super(key: key);

  @override
  State<GymOccupancyPage> createState() => _GymOccupancyPageState();
}

class _GymOccupancyPageState extends State<GymOccupancyPage> {
  //  متغير الحالة ودالة فتح وقفل القائمة
  bool _isDrawerOpen = false;
  void _toggleDrawer() => setState(() => _isDrawerOpen = !_isDrawerOpen);

  //  القائمة الجانبية (Drawer Overlay)
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
                // الصفحة الحالية (Gym Occupancy) هي المحددة
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: "Gym Occupancy",
                  isSelected: true,
                  onTap: _toggleDrawer,
                ),
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
                  isSelected: false,
                  onTap: () {
                    _toggleDrawer();
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => PoliciesScreen()));
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

  @override
  Widget build(BuildContext context) {
    final store = OccupancyStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Scaffold(
          body: Stack(
            children: [
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 16),
                        _buildMainCard(store),
                        const SizedBox(height: 16),
                        _buildLevelsCard(store),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isDrawerOpen) _buildDrawerOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: _toggleDrawer),
            ),
            const SizedBox(width: 12),
            const Text('Gym occupancy',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(20)),
          child: const Text('Live',
              style: TextStyle(
                  color: Color(0xFF00796B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildMainCard(OccupancyStore store) {
    final CrowdLevel status = store.currentLevel;
    final double percentage = store.percentage;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: crowd_circle(
              percentage: percentage,
              currentPeople: store.currentPeople,
              maxPeople: store.maxPeople,
              statusColor: status.color,
              statusTitle: status.title,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: status.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(status.title,
                    style: TextStyle(
                        color: status.color, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('${(percentage * 100).toInt()}% full',
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 20),

          // التحكم في الـ Max الكلي
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Max: ${store.maxPeople}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.redAccent),
                      onPressed: () => store.changeMax(-5),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.green),
                      onPressed: () => store.changeMax(5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Slider(
            value: store.currentPeople.toDouble(),
            min: 0,
            max: store.maxPeople.toDouble(),
            activeColor: status.color,
            inactiveColor: Colors.grey.shade300,
            onChanged: (v) => store.setCurrent(v.toInt()),
          ),
          const Text('Drag to preview how each level looks',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLevelsCard(OccupancyStore store) {
    final levels = store.levels;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Levels Range Configuration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < levels.length; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: levels[i].color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        levels[i].title,
                        style: TextStyle(
                            color: levels[i].color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${levels[i].minLimit} - ${levels[i].maxLimit} people',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                if (i != levels.length - 1)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () => store.decrementLevel(i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => store.incrementLevel(i),
                      ),
                    ],
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Auto (Max)',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
              ],
            ),
            if (i != levels.length - 1) const Divider(),
          ],
        ],
      ),
    );
  }
}