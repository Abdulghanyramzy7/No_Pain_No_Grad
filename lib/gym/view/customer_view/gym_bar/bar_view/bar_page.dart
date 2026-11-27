import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/core/const/customer_bottom_nav.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_view/cart_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/cubit/cubit/bar_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/hive_helper/bar_hive_helper.dart';

class BarPage extends StatefulWidget {
  const BarPage({super.key});

  @override
  State<BarPage> createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  static const List<String> categories = ["Shakes", "Meals", "Supplements"];

  @override
  void initState() {
    super.initState();
    context.read<BarCubit>().getBar();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BarCubit>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.plateBackground,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Gym bar",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2733),
                        fontFamily: 'Inter Tight',
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UserCartPage(),
                                  ),
                                );
                                if (context.mounted) {
                                  cubit.getBar();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Color(0xFF1D2733),
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.more_horiz,
                              color: Color(0xFF1D2733)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<BarCubit, BarState>(
                  builder: (context, state) {
                    return Row(
                      children: categories.map((category) {
                        final isSelected =
                            BarHiveHelper.selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => cubit.changeCategory(category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF56C5B1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF6B7886),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: BlocBuilder<BarCubit, BarState>(
                  builder: (context, state) {
                    if (state is BarLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = BarHiveHelper.filteredProducts;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          "No products available in this category",
                          style: TextStyle(color: Color(0xFF6B7886)),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final bool isAvailable = product.isReadyForSale;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
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
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6F6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    product.productImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      product.subtitle,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "EGP ${product.price.toInt()}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D2733),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (isAvailable)
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          cubit.addProduct(product);
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${product.productTitle} added to cart",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 800),
                                                backgroundColor:
                                                    const Color(0xFF56C5B1),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                margin: const EdgeInsets.all(15),
                                              ),
                                            );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFF4877B),
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Icon(Icons.add, size: 18),
                                      ),
                                    )
                                  else
                                    Text(
                                      product.statusMessage ??
                                          (product.stockQuantity <= 0
                                              ? "Out of stock"
                                              : "Unavailable"),
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<BarCubit, BarState>(
                builder: (context, state) {
                  if (BarHiveHelper.cartItems.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final int totalCount = BarHiveHelper.cartItems
                      .fold<int>(0, (sum, item) => sum + item.quantity);

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4877B),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFFF4877B).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UserCartPage()),
                          );
                          if (context.mounted) {
                            cubit.getBar();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$totalCount ${totalCount == 1 ? 'item' : 'items'}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Reserve · EGP ${BarHiveHelper.subtotal.toInt()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 2),
    );
  }
}