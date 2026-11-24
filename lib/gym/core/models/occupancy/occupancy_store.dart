import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/models/crowd_level_model.dart';

class OccupancyStore extends ChangeNotifier {
  OccupancyStore._();
  static final OccupancyStore instance = OccupancyStore._();

   int currentPeople = 42;
  int maxPeople = 100;

  final List<CrowdLevel> levels = [
    CrowdLevel(
        title: 'Light',
        color: const Color(0xFF4DB6AC),
        minLimit: 0,
        maxLimit: 45),
    CrowdLevel(
        title: 'Moderate',
        color: const Color(0xffFF7F73),
        minLimit: 45,
        maxLimit: 75),
    CrowdLevel(
        title: 'Busy',
        color: const Color(0xffE53935),
        minLimit: 75,
        maxLimit: 100),
  ];

  void _sync() {
    levels[1].minLimit = levels[0].maxLimit;
    levels[2].minLimit = levels[1].maxLimit;
    levels[2].maxLimit = maxPeople;
  }
  void _save() {
    final box = Hive.box('gymBox');
    box.put('occ_current', currentPeople);
    box.put('occ_max', maxPeople);
    box.put('occ_l0', levels[0].maxLimit);
    box.put('occ_l1', levels[1].maxLimit);
  }

  void load() {
    final box = Hive.box('gymBox');
    currentPeople = box.get('occ_current', defaultValue: currentPeople);
    maxPeople = box.get('occ_max', defaultValue: maxPeople);
    levels[0].maxLimit = box.get('occ_l0', defaultValue: levels[0].maxLimit);
    levels[1].maxLimit = box.get('occ_l1', defaultValue: levels[1].maxLimit);
    _sync();
  }

  double get percentage =>
      maxPeople == 0 ? 0 : (currentPeople / maxPeople).clamp(0.0, 1.0);

  CrowdLevel get currentLevel {
    _sync();
    for (final l in levels) {
      if (currentPeople >= l.minLimit && currentPeople <= l.maxLimit) return l;
    }
    return levels.last;
  }

  // ---- دوال الأدمن فقط ----
  void setCurrent(int v) {
    currentPeople = v.clamp(0, maxPeople);
    _save();
    notifyListeners();
  }

  void changeMax(int delta) {
    final v = maxPeople + delta;
    if (v < 10) return;
    maxPeople = v;
    if (currentPeople > maxPeople) currentPeople = maxPeople;
    // لازم الليفل الأول والتاني ميعدّوش الماكس الجديد
    for (final l in levels.take(2)) {
      if (l.maxLimit > maxPeople - 1) l.maxLimit = maxPeople - 1;
    }
    _sync();
     _save();
    notifyListeners();
  }

  void incrementLevel(int index) {
    final upper = index == 0 ? levels[1].maxLimit - 1 : maxPeople - 1;
    if (levels[index].maxLimit < upper) {
      levels[index].incrementLimit();
      _sync();
       _save();
      notifyListeners();
    }
  }

  void decrementLevel(int index) {
    levels[index].decrementLimit();
    _sync();
     _save();
    notifyListeners();
  }
}
