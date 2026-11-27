import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/core/const/customer_bottom_nav.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/cubit/cubit/bar_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/hive_helper/bar_hive_helper.dart';

class UserCartPage extends StatelessWidget {
  const UserCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BarCubit>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.plateBackground,
        ),
        child: SafeArea(
          child: BlocBuilder<BarCubit, BarState>(
            builder: (context, state) {
              final isOrderPlaced = BarHiveHelper.isOrderPlaced;
              final items = BarHiveHelper.cartItems;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isOrderPlaced ? "Order #214" : "My Cart",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                        if (isOrderPlaced)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F6F0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "3 min",
                              style: TextStyle(
                                color: Color(0xFF2E7D59),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => cubit.clearCart(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: (items.isEmpty && !isOrderPlaced)
                        ? const Center(
                            child: Text(
                              "Your Cart is Empty",
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF6B7886)),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                if (isOrderPlaced) ...[
                                  _buildOrderTrackingCard(),
                                  const SizedBox(height: 15),
                                ],
                                ListView.builder(
                                  itemCount: items.length,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final cartItem = items[index];
                                    final product = cartItem.effectiveProduct;
                                    final bool isAvailable =
                                        product.isReadyForSale;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.02),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF4F6F6),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                product.productImage,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                  Icons.local_drink_rounded,
                                                  color: Color(0xFFF4877B),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.productTitle,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF1D2733),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  isOrderPlaced
                                                      ? "${product.subtitle.split('·')[0]}· Qty ${cartItem.quantity}"
                                                      : product.subtitle,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: isAvailable
                                                        ? const Color(0xFF6B7886)
                                                        : Colors.grey.shade400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "EGP ${cartItem.total.toInt()}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1D2733),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Payment",
                                        style: TextStyle(
                                          color: Color(0xFF8C98A4),
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "Pay at the gym",
                                        style: TextStyle(
                                          color: Color(0xFF1D2733),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isOrderPlaced
                                          ? Colors.white
                                          : const Color(0xFFF4877B),
                                      foregroundColor: isOrderPlaced
                                          ? const Color(0xFFF4877B)
                                          : Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: isOrderPlaced
                                            ? const BorderSide(
                                                color: Color(0xFFF4877B),
                                                width: 1.5,
                                              )
                                            : BorderSide.none,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (isOrderPlaced) {
                                        cubit.cancelOrder();
                                      } else {
                                        cubit.placeOrder();
                                      }
                                    },
                                    child: Text(
                                      isOrderPlaced
                                          ? "Cancel order"
                                          : "Place Order · EGP ${BarHiveHelper.subtotal.toInt()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildOrderTrackingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStepRow(
              title: "Placed",
              subtitle: "05:25 PM",
              isDone: true,
              isCurrent: false),
          _buildStepRow(
              title: "Preparing",
              subtitle: "Ready in about 3 min",
              isDone: false,
              isCurrent: true),
          _buildStepRow(
              title: "Ready for pickup",
              subtitle: "",
              isDone: false,
              isCurrent: false),
          _buildStepRow(
              title: "Picked up",
              subtitle: "",
              isDone: false,
              isCurrent: false,
              isLast: true),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDone || isCurrent
                      ? const Color(0xFFF4877B)
                      : const Color(0xFFD2D6DC),
                  width: 2,
                ),
                color: isDone ? const Color(0xFFF4877B) : Colors.transparent,
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : isCurrent
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF4877B),
                            ),
                          ),
                        )
                      : null,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isCurrent
                        ? const Color(0xFFF4877B)
                        : const Color(0xFF1D2733),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrent
                          ? const Color(0xFFF4877B)
                          : const Color(0xFF8C98A4),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 2, height: 24, color: const Color(0xFFE5E7EB)),
            ),
          ),
      ],
    );
  }
}