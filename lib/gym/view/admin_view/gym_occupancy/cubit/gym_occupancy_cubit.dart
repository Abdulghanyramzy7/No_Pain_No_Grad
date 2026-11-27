import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/models/occupancy/occupancy_store.dart';
import 'gym_occupancy_state.dart';

class GymOccupancyCubit extends Cubit<GymOccupancyState> {
  final OccupancyStore _store = OccupancyStore.instance;

  GymOccupancyCubit() : super(_snapshot(OccupancyStore.instance)) {
    // لما الـ store يتغير (حتى من صفحة العميل) الصفحة تتحدث
    _store.addListener(_refresh);
  }

  static GymOccupancyState _snapshot(OccupancyStore s) {
    return GymOccupancyState(
      currentPeople: s.currentPeople,
      maxPeople: s.maxPeople,
      levels: s.levels,
      currentLevel: s.currentLevel,
      percentage: s.percentage,
    );
  }

  void _refresh() => emit(_snapshot(_store));

  void setCurrent(int v) => _store.setCurrent(v);
  void changeMax(int delta) => _store.changeMax(delta);
  void incrementLevel(int index) => _store.incrementLevel(index);
  void decrementLevel(int index) => _store.decrementLevel(index);

  @override
  Future<void> close() {
    _store.removeListener(_refresh);
    return super.close();
  }
}