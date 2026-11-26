import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/hive_helper/coach_hive_helper.dart';
part 'coach_state.dart';

class CoachCubit extends Cubit<CoachState> {
  CoachCubit() : super(CoachInitial());

  Future<void> getCoaches() async {
    emit(CoachLoadingState());
    await CoachHiveHelper.getCoaches();
    if (CoachHiveHelper.coaches.isEmpty) {
      emit(CoachEmptyState());
    } else {
      emit(CoachSuccessState());
    }
  }

  Future<void> getMessages(String coachId) async {
    await CoachHiveHelper.getMessages(coachId);
    emit(CoachChatLoadedState());
  }

  Future<void> sendMessage(String coachId, String text) async {
    if (text.trim().isEmpty) return;
    await CoachHiveHelper.sendMessage(coachId, text.trim());
    emit(CoachMessageSentState());
  }
}
