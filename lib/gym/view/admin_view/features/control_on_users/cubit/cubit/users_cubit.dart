import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/hive_helper/user_hive_helper.dart';


class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  List<UserModel> users = [];

  // جلب المستخدمين من Hive
  Future<void> getUsers() async {
    emit(UserLoadingState());
    try {
      await UserHiveHelper.getUsers();
      users = List<UserModel>.from(UserHiveHelper.myUsers);
      if (users.isEmpty) {
        emit(UserEmptyState());
      } else {
        emit(UserSuccessState(users));
      }
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  // إضافة مستخدم جديد
  Future<void> addUser(UserModel user) async {
    emit(UserLoadingState());
    try {
      await UserHiveHelper.addUser(user);
      users = List<UserModel>.from(UserHiveHelper.myUsers);
      emit(UserAddedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  // تحديث بيانات مستخدم
  Future<void> updateUser(UserModel user) async {
    emit(UserLoadingState());
    try {
      await UserHiveHelper.updateUser(user);
      users = List<UserModel>.from(UserHiveHelper.myUsers);
      emit(UserUpdatedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  // إنهاء عقد المستخدم وحفظ الحالة في Hive
  Future<void> terminateUser(String userId) async {
    emit(UserLoadingState());
    try {
      await UserHiveHelper.terminateUser(userId);
      users = List<UserModel>.from(UserHiveHelper.myUsers);
      emit(UserTerminatedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
