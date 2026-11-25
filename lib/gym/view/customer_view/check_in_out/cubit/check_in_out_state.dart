part of 'check_in_out_cubit.dart';

@immutable
sealed class CheckInOutState {}

final class CheckInOutInitial extends CheckInOutState {}

final class CheckInOutChangedState extends CheckInOutState {}