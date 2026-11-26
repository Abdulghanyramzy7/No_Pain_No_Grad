import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/view/trainers_list_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/bar_view/cart_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/cubit/cubit/bar_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/hive_helper/bar_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/home.dart';

import 'package:no_pain_no_grad/gym/view/customer_view/profile.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights.dart';

class BarPage extends StatelessWidget {
  const BarPage({super.key});

  static const List<String> categories = ["Shakes", "Meals", "Supplements"];

  // التنقل بين صفحات شريط التنقل السفلي
  void _onNavTap(BuildContext context, int index) {
    if (index == 2) return; // احنا واقفين على صفحة البار
    final Widget page = switch (index) {
      0 => const CustomerHome(),
      1 => const WeightsScreen(),
      3 => const TrainersListPage(),
      _ => const ProfileScreen(),
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
              // الهيدر العلوي (العنوان وزر السلة العلوي)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        // زر السلة العلوي للانتقال لصفحة السلة
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UserCartPage(),
                                  ),
                                );
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
                          child: const Icon(Icons.more_horiz, color: Color(0xFF1D2733)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // أزرار الفئات (Categories)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<BarCubit, BarState>(
                  builder: (context, state) {
                    return Row(
                      children: categories.map((category) {
                        final isSelected = BarHiveHelper.selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => cubit.changeCategory(category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF56C5B1) : Colors.white,
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
                                  color: isSelected ? Colors.white : const Color(0xFF6B7886),
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

              // قائمة المنتجات المتغيرة حسب الفئة
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
                        bool isAvailable = product.isAvailable;

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
                                    errorBuilder: (context, error, stackTrace) => const Icon(
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
                                          // إضافة المنتج للسلة وإظهار إشعار
                                          cubit.addProduct(product);
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${product.productTitle} added to cart",
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                duration: const Duration(milliseconds: 800),
                                                backgroundColor: const Color(0xFF56C5B1),
                                                behavior: SnackBarBehavior.floating,
                                                margin: const EdgeInsets.all(15),
                                              ),
                                            );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF4877B),
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Icon(Icons.add, size: 18),
                                      ),
                                    )
                                  else
                                    Text(
                                      product.statusMessage ?? "Unavailable",
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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

              // كارت الحجز السفلي
              BlocBuilder<BarCubit, BarState>(
                builder: (context, state) {
                  if (BarHiveHelper.cartItems.isEmpty) return const SizedBox.shrink();
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
                            color: const Color(0xFFF4877B).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UserCartPage()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${BarHiveHelper.cartItems.length} item",
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

      // شريط التنقل السفلي
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 2,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFF4877B),
          unselectedItemColor: const Color(0xFF8C98A4),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (index) => _onNavTap(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Train'),
            BottomNavigationBarItem(icon: Icon(Icons.local_drink_rounded), label: 'Bar'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Coach'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
