import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:get/get.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/hive_helper/hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_controller/items_controller.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/items_model.dart';
part 'edit_history_state.dart';

class EditPricesCubit extends Cubit<EditPricesState> {
  EditPricesCubit() : super(EditPricesInitial());

  final ItemsController itemsController = Get.isRegistered<ItemsController>()
      ? Get.find<ItemsController>()
      : Get.put(ItemsController());

  List<String> expandedCardIds = [];
  bool isDrawerOpen = false;

  Future<void> getFilter() async {
    emit(EditPricesLoadingState());
    await HiveHelper.getRoleFilter();
    await HiveHelper.getBarSettings();
    await HiveHelper.loadPriceOverrides();
    _applySavedOverridesToController();
    if (isClosed) return;
    emit(EditPricesLoadedState());
  }

  void _applySavedOverridesToController() {
    if (HiveHelper.priceOverrides.isEmpty) return;

    bool changed = false;
    for (int i = 0; i < itemsController.products.length; i++) {
      final current = itemsController.products[i];
      final saved = HiveHelper.priceOverrides[current.id];
      if (saved != null) {
        final double? savedPrice = (saved['price'] as num?)?.toDouble();
        final double? savedOldPrice = (saved['oldPrice'] as num?)?.toDouble();
        final String? savedUpdater = saved['updatedBy'] as String?;

        if (savedPrice != null) {
          itemsController.products[i] = ProductModel(
            id: current.id,
            productTitle: current.productTitle,
            productImage: current.productImage,
            price: savedPrice,
            oldPrice: savedOldPrice ?? current.oldPrice,
            updatedBy: savedUpdater ?? current.updatedBy,
            subtitle: current.subtitle,
            category: current.category,
            isAvailable: current.isAvailable,
            statusMessage: current.statusMessage,
            description: current.description,
            rating: current.rating,
            reviewsCount: current.reviewsCount,
            stockQuantity: current.stockQuantity,
            minStockAlert: current.minStockAlert,
            storageLocation: current.storageLocation,
          );
          changed = true;
        }
      }
    }

    if (changed) {
      itemsController.products.refresh();
    }
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

  Future<void> saveProductPrice({
    required ProductModel product,
    required double newPrice,
    required String editorName,
  }) async {
    final index =
        itemsController.products.indexWhere((p) => p.id == product.id);
    final double previousPrice =
        index != -1 ? itemsController.products[index].price : product.price;

    await HiveHelper.savePriceOverride(
      productId: product.id,
      price: newPrice,
      oldPrice: previousPrice,
      updatedBy: editorName,
    );

    if (index != -1) {
      final current = itemsController.products[index];
      itemsController.products[index] = ProductModel(
        id: current.id,
        productTitle: current.productTitle,
        productImage: current.productImage,
        price: newPrice,
        oldPrice: previousPrice,
        updatedBy: editorName,
        subtitle: current.subtitle,
        category: current.category,
        isAvailable: current.isAvailable,
        statusMessage: current.statusMessage,
        description: current.description,
        rating: current.rating,
        reviewsCount: current.reviewsCount,
        stockQuantity: current.stockQuantity,
        minStockAlert: current.minStockAlert,
        storageLocation: current.storageLocation,
      );
      itemsController.products.refresh();
    }

    if (!isClosed) {
      emit(EditPricesLoadedState());
    }
  }

  List<ProductModel> get filteredProducts {
    final List<ProductModel> allProducts = itemsController.products;
    final String filter = HiveHelper.selectedRoleFilter;

    if (filter == 'Everyone') {
      return allProducts;
    }

    return allProducts.where((ProductModel p) {
      final String updater = (p.updatedBy ?? '').toLowerCase();
      if (filter == 'Admin') {
        return updater.contains('admin') || updater.contains('khaled');
      }
      return updater.contains('bar') ||
          updater.contains('omar') ||
          updater.contains('fawzy');
    }).toList();
  }
}