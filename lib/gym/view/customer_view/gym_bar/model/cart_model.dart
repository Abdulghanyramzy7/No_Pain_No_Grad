
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/items_model.dart';


class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}