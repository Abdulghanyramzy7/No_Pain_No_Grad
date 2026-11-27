part of 'coach_cubit.dart';

@immutable
sealed class CoachState {}

final class CoachInitial extends CoachState {}

final class CoachLoadingState extends CoachState {}

final class CoachSuccessState extends CoachState {}

final class CoachEmptyState extends CoachState {}

final class CoachChatLoadedState extends CoachState {}

final class CoachMessageSentState extends CoachState {}
