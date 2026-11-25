part of 'weights_cubit.dart';

@immutable
sealed class WeightsState {}

final class WeightsInitial extends WeightsState {}

final class WeightsChangedState extends WeightsState {}

final class WeightsSavedState extends WeightsState {}