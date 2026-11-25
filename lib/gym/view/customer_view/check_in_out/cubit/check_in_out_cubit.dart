import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
part 'check_in_out_state.dart';

class CheckInOutCubit extends Cubit<CheckInOutState> {
  CheckInOutCubit(this.selectedTab) : super(CheckInOutInitial());

  int selectedTab;
  bool isAutoCheckOutOn =
      Hive.box('gymBox').get('autoCheckOut', defaultValue: true);

  void changeTab(int tab) {
    selectedTab = tab;
    emit(CheckInOutChangedState());
  }

  void toggleAutoCheckOut(bool val) {
    isAutoCheckOutOn = val;
    Hive.box('gymBox').put('autoCheckOut', val);
    emit(CheckInOutChangedState());
  }
}