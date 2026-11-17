import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/core/models/occupancy/occupancy_store.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/models/crowd_cycle_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/models/crowd_level_model.dart';

class GymOccupancyPage extends StatelessWidget {
  const GymOccupancyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = OccupancyStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Scaffold(
          body: Container(
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
                  onPressed: () {
                  
                  }),
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
