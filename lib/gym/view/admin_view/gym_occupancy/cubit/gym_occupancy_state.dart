import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/models/crowd_level_model.dart';

class GymOccupancyState {
  final int currentPeople;
  final int maxPeople;
  final List<CrowdLevel> levels;
  final CrowdLevel currentLevel;
  final double percentage;

  GymOccupancyState({
    required this.currentPeople,
    required this.maxPeople,
    required this.levels,
    required this.currentLevel,
    required this.percentage,
  });
}