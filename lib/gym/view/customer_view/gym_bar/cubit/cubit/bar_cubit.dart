import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/hive_helper/bar_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/items_model.dart';
part 'bar_state.dart';

class BarCubit extends Cubit<BarState> {
  BarCubit() : super(BarInitial());

  Future<void> getBar() async {
    emit(BarLoadingState());
    await BarHiveHelper.getBar();
    emit(BarSuccessState());
  }

  void changeCategory(String category) {
    BarHiveHelper.selectedCategory = category;
    emit(BarCategoryChangedState());
  }

  Future<void> addProduct(ProductModel product) async {
    await BarHiveHelper.addToCart(product);
    emit(BarProductAddedState());
  }

  Future<void> clearCart() async {
    await BarHiveHelper.clearCart();
    emit(BarCartClearedState());
  }

  Future<void> placeOrder() async {
    await BarHiveHelper.placeOrder();
    emit(BarOrderPlacedState());
  }

  Future<void> cancelOrder() async {
    await BarHiveHelper.cancelOrder();
    emit(BarOrderCancelledState());
  }
}
