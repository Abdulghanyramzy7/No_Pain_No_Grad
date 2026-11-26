part of 'bar_cubit.dart';

@immutable
sealed class BarState {}

final class BarInitial extends BarState {}

final class BarLoadingState extends BarState {}

final class BarSuccessState extends BarState {}

final class BarCategoryChangedState extends BarState {}

final class BarProductAddedState extends BarState {}

final class BarCartClearedState extends BarState {}

final class BarOrderPlacedState extends BarState {}

final class BarOrderCancelledState extends BarState {}
