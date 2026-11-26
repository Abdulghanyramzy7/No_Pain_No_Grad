part of 'edit_history_cubit.dart';

@immutable
sealed class EditPricesState {}

final class EditPricesInitial extends EditPricesState {}

final class EditPricesLoadingState extends EditPricesState {}

final class EditPricesLoadedState extends EditPricesState {}

final class EditPricesFilterChangedState extends EditPricesState {}

final class EditPricesCardToggledState extends EditPricesState {}

final class EditPricesDrawerToggledState extends EditPricesState {}
