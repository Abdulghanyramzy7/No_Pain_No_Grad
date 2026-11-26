import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/core/model/user_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_state.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/hive_helper/user_hive_helper.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  List<UserModel> users = [];
  String selectedRoleFilter = 'All';
  String searchQuery = '';

  // القائمة المفلترة حسب الـ Role والبحث
  List<UserModel> get filteredUsers {
    return users.where((user) {
      final matchesRole = switch (selectedRoleFilter) {
        'Coachs' => user.role == UserRole.coach,
        'Bar workers' => user.role == UserRole.barWorker,
        'Clients' => user.role == UserRole.client,
        'Admins' => user.role == UserRole.admin,
        _ => true,
      };

      final query = searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.phone.toLowerCase().contains(query);

      return matchesRole && matchesSearch;
    }).toList();
  }

  void changeRoleFilter(String filter) {
    selectedRoleFilter = filter;
    emit(users.isEmpty ? UserEmptyState() : UserSuccessState(filteredUsers));
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    emit(users.isEmpty ? UserEmptyState() : UserSuccessState(filteredUsers));
  }

  // جلب المستخدمين من Hive
  Future<void> getUsers() async {
    emit(UserLoadingState());
    try {
      await UserHiveHelper.getUsers();
      users = List<UserModel>.from(UserHiveHelper.myUsers);
      if (users.isEmpty) {
        emit(UserEmptyState());
      } else {
        emit(UserSuccessState(filteredUsers));
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
      emit(UserAddedState(filteredUsers));
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
      emit(UserUpdatedState(filteredUsers));
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
      emit(UserTerminatedState(filteredUsers));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}