import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:no_pain_no_grad/gym/core/models/exercise_model.dart';
part 'weights_state.dart';

class WeightsCubit extends Cubit<WeightsState> {
  WeightsCubit() : super(WeightsInitial());

  final box = Hive.box('gymBox');
  String category = 'Barbell';

 final List<ExerciseModel> exercises = [
  ExerciseModel(id: '1', name: 'Barbell Bench Press', barbellWeight: 60.0, machineWeight: 50.0, dumbbellWeight: 25.0),
  ExerciseModel(id: '2', name: 'Incline Barbell Press', barbellWeight: 50.0, machineWeight: 40.0, dumbbellWeight: 22.0),
  ExerciseModel(id: '3', name: 'Decline Barbell Press', barbellWeight: 55.0, machineWeight: 45.0, dumbbellWeight: 22.5),
  ExerciseModel(id: '4', name: 'Incline Dumbbell Press', barbellWeight: 40.0, machineWeight: 35.0, dumbbellWeight: 18.0),
  ExerciseModel(id: '5', name: 'Flat Dumbbell Press', barbellWeight: 45.0, machineWeight: 35.0, dumbbellWeight: 20.0),
  ExerciseModel(id: '6', name: 'Chest Fly (Pec Deck)', barbellWeight: 30.0, machineWeight: 35.0, dumbbellWeight: 12.5),
  ExerciseModel(id: '7', name: 'Incline Dumbbell Fly', barbellWeight: 25.0, machineWeight: 30.0, dumbbellWeight: 10.0),
  ExerciseModel(id: '8', name: 'Cable Crossover', barbellWeight: 20.0, machineWeight: 25.0, dumbbellWeight: 10.0),
  ExerciseModel(id: '9', name: 'Low Cable Fly', barbellWeight: 17.5, machineWeight: 20.0, dumbbellWeight: 7.5),
  ExerciseModel(id: '10', name: 'Weighted Dips', barbellWeight: 10.0, machineWeight: 15.0, dumbbellWeight: 5.0),
  ExerciseModel(id: '11', name: 'Machine Chest Press', barbellWeight: 50.0, machineWeight: 60.0, dumbbellWeight: 25.0),
  ExerciseModel(id: '12', name: 'Push-ups (Bodyweight)', barbellWeight: 0.0, machineWeight: 0.0, dumbbellWeight: 0.0),
];

  void loadSaved() {
    for (final e in exercises) {
      for (final c in ['Barbell', 'Machine', 'Dumbbell']) {
        final saved = box.get('${e.id}_$c');
        if (saved != null) e.setWeight(c, saved as double);
      }
    }
    emit(WeightsChangedState());
  }

  void changeCategory(String c) {
    category = c;
    emit(WeightsChangedState());
  }

  void toggleExpanded(ExerciseModel e) {
    e.isExpanded = !e.isExpanded;
    emit(WeightsChangedState());
  }

  void updateWeight(ExerciseModel e, bool increase) {
    e.updateWeight(category, increase);
    emit(WeightsChangedState());
  }

  void setStep(ExerciseModel e, double value) {
    e.barbellStep = value;
    emit(WeightsChangedState());
  }

  void save(ExerciseModel e) {
    box.put('${e.id}_$category', e.getWeight(category));
    e.isExpanded = false;
    emit(WeightsSavedState());
  }
}