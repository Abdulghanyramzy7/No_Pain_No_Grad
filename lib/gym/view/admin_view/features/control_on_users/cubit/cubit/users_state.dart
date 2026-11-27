import 'package:meta/meta.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';


@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoadingState extends UserState {}

final class UserSuccessState extends UserState {
  final List<UserModel> users;
  UserSuccessState(this.users);
}

final class UserEmptyState extends UserState {}

final class UserAddedState extends UserState {
  final List<UserModel> users;
  UserAddedState(this.users);
}

final class UserUpdatedState extends UserState {
  final List<UserModel> users;
  UserUpdatedState(this.users);
}

final class UserTerminatedState extends UserState {
  final List<UserModel> users;
  UserTerminatedState(this.users);
}

final class UserErrorState extends UserState {
  final String message;
  UserErrorState(this.message);
}
