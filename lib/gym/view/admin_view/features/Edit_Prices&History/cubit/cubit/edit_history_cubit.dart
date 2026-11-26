import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:get/get.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/hive_helper/hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_controller/items_controller.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/items_model.dart';
part 'edit_history_state.dart';

class EditPricesCubit extends Cubit<EditPricesState> {
  EditPricesCubit() : super(EditPricesInitial());

  // المنتجات لسه على GetX
  final ItemsController itemsController = Get.isRegistered<ItemsController>()
      ? Get.find<ItemsController>()
      : Get.put(ItemsController());

  // حالات واجهة فقط، مش بتتحفظ في Hive
  List<String> expandedCardIds = [];
  bool isDrawerOpen = false;

  Future<void> getFilter() async {
    emit(EditPricesLoadingState());
    await HiveHelper.getRoleFilter();
    if (isClosed) return;
    emit(EditPricesLoadedState());
  }

  Future<void> changeFilter(String filter) async {
    await HiveHelper.setRoleFilter(filter);
    if (isClosed) return;
    emit(EditPricesFilterChangedState());
  }

  void toggleCardExpansion(String productId) {
    if (expandedCardIds.contains(productId)) {
      expandedCardIds.remove(productId);
    } else {
      expandedCardIds.add(productId);
    }
    emit(EditPricesCardToggledState());
  }

  bool isExpanded(String productId) => expandedCardIds.contains(productId);

  void toggleDrawer() {
    isDrawerOpen = !isDrawerOpen;
    emit(EditPricesDrawerToggledState());
  }

  // فلترة المنتجات بناءً على الفئة المختارة (Everyone, Admin, Bar worker)
  // الأنواع مكتوبة صريحة، و updatedBy بيتحول لنص فاضي لو null
  List<ProductModel> get filteredProducts {
    final List<ProductModel> allProducts = itemsController.products;
    final String filter = HiveHelper.selectedRoleFilter;

    if (filter == 'Everyone') {
      return allProducts;
    }

    return allProducts.where((ProductModel p) {
      final String updater = (p.updatedBy ?? '').toLowerCase();
      if (filter == 'Admin') {
        return updater.contains('admin');
      }
      // Bar worker
      return updater.contains('bar') || updater.contains('omar');
    }).toList();
  }
}
