import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/hive_helper/hive_helper.dart';
part 'bar_state.dart';

class BarCubit extends Cubit<BarState> {
  BarCubit() : super(BarInitial());

  // حالة واجهة فقط (القائمة الجانبية)، مش بتتحفظ في Hive
  bool isDrawerOpen = false;

  Future<void> getBarSettings() async {
    emit(BarLoadingState());
    await HiveHelper.getBarSettings();
    emit(BarLoadedState());
  }

  Future<void> toggleBarService(bool value) async {
    await HiveHelper.setBarService(value);
    emit(BarServiceChangedState());
  }

  Future<void> changeTab(int tabIndex) async {
    await HiveHelper.setSelectedTab(tabIndex);
    emit(BarTabChangedState());
  }

  void toggleDrawer() {
    isDrawerOpen = !isDrawerOpen;
    emit(BarDrawerToggledState());
  }
}
