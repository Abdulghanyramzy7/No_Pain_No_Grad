part of 'bar_cubit.dart';

@immutable
sealed class BarState {}

final class BarInitial extends BarState {}

final class BarLoadingState extends BarState {}

final class BarLoadedState extends BarState {}

final class BarServiceChangedState extends BarState {}

final class BarTabChangedState extends BarState {}

final class BarDrawerToggledState extends BarState {}
