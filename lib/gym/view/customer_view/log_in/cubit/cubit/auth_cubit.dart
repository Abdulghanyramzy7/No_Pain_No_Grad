import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/log_in/auth_hive_helper.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(
    String memberId,
    String password, {
    String role = "user",
  }) async {
    emit(AuthLoadingState());

    if (memberId.trim().isEmpty || password.isEmpty) {
      emit(AuthErrorState("Please fill in all fields"));
      return;
    }

    // TODO: استبدلي الجزء ده بنداء الـ API الحقيقي بعدين
    await Future.delayed(const Duration(milliseconds: 800));
    final isValid = memberId.trim() == "1234" && password == "1234";

    if (isValid) {
      await AuthHiveHelper.saveSession(memberId.trim(), role: role);
      emit(AuthSuccessState());
    } else {
      emit(AuthErrorState("Wrong Member ID or password"));
    }
  }

  Future<void> logout() async {
    await AuthHiveHelper.clearSession();
    emit(AuthLogoutState());
  }
}