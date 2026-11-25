import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:no_pain_no_grad/gym/core/models/exercise_model.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/home.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights/cubit/weights_cubit.dart';


class WeightsScreen extends StatelessWidget {
  const WeightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeightsCubit()..loadSaved(),
      child: const _WeightsView(),
    );
  }
}

class _WeightsView extends StatelessWidget {
  const _WeightsView();

  @override
  Widget build(BuildContext context) {
    const Color primaryTurquoise = Color(0xFF5DBB9E);
    const Color darkText = Color(0xFF0F3036);
    final cubit = context.read<WeightsCubit>();

    return BlocBuilder<WeightsCubit, WeightsState>(
      builder: (context, state) {
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
            child: Column(
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Weights',
                          style: TextStyle(
                              color: darkText,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: darkText, size: 20),
                       onPressed: () => Get.off(() => const CustomerHome()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        ['Barbell', 'Machine', 'Dumbbell'].map((category) {
                      bool isSelected = cubit.category == category;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => cubit.changeCategory(category),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? primaryTurquoise : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                if (!isSelected)
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : darkText,
                                fontSize: 13,fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cubit.exercises.length,
                    padding: const EdgeInsets.only(bottom: 30),
                    itemBuilder: (context, index) {
                      return _buildExerciseCard(
                          context, cubit, cubit.exercises[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, WeightsCubit cubit, ExerciseModel exercise) {
    const Color primaryTurquoise = Color(0xFF5DBB9E);
    const Color darkText = Color(0xFF0F3036);

    final category = cubit.category;
    double currentWeight = exercise.getWeight(category);return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => cubit.toggleExpanded(exercise),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currentWeight kg',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    exercise.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: primaryTurquoise,
                  ),
                  onPressed: () => cubit.toggleExpanded(exercise),
                ),
              ],
            ),
          ),
          if (exercise.isExpanded) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => cubit.updateWeight(exercise, false),
                  icon: const Icon(Icons.remove_circle_outline,
                      size: 32, color: Colors.redAccent),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '$currentWeight kg',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: darkText),
                  ),
                ),
                IconButton(
                  onPressed: () => cubit.updateWeight(exercise, true),
                  icon: const Icon(Icons.add_circle_outline,
                      size: 32, color: primaryTurquoise),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (category == 'Barbell') ...[
              const Center(
                child: Text(
                  'Select Plate Step:',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1.25, 2.5, 5.0].map((stepValue) {
                  bool isStepSelected = exercise.barbellStep == stepValue;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text('+$stepValue kg'),
                      selected: isStepSelected,
                      selectedColor: primaryTurquoise.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isStepSelected ? primaryTurquoise : darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,),
                      onSelected: (selected) =>
                          cubit.setStep(exercise, stepValue),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  cubit.save(exercise);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Saved ${exercise.name} ($category) -> $currentWeight kg'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: primaryTurquoise,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTurquoise,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Save Weight',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}