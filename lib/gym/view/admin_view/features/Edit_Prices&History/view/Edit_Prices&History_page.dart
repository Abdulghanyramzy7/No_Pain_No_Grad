import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:no_pain_no_grad/gym/core/const/appgradients.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/hive_helper/hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/Edit_Prices&History/cubit/cubit/edit_history_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/view/gym&bar_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/overview/view/overview_page.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/view/usermanagement_page.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/model/items_model.dart';

/// الصفحة بتعمل الكيوبت بنفسها، عشان Get.to(() => EditPricesPage()) تشتغل من أي مكان
class EditPricesPage extends StatelessWidget {
  const EditPricesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPricesCubit()..getFilter(),
      child: const _EditPricesView(),
    );
  }
}

class _EditPricesView extends StatelessWidget {
  const _EditPricesView();

  static const List<String> _filters = ['Everyone', 'Admin', 'Bar worker'];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditPricesCubit>();

    return Scaffold(
      body: BlocBuilder<EditPricesCubit, EditPricesState>(
        builder: (context, state) {
          final bool isDrawerOpen = cubit.isDrawerOpen;
          final String selectedFilter = HiveHelper.selectedRoleFilter;

          return Stack(
            children: [
              // المحتوى الأساسي للصفحة
              Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.plateBackground,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // الهيدر العلوي (زر القائمة + العنوان بجانبه)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => cubit.toggleDrawer(),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.menu, color: Color(0xFF1D2733), size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Edit Prices & History",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D2733),
                                ),
                              ),
                            ),
                            const Icon(Icons.more_horiz, color: Color(0xFF1D2733)),
                          ],
                        ),
                      ),

                      // شريط الفلاتر الأفقية (Everyone, Admin, Bar worker)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final filter = _filters[index];
                              final bool isSelected = selectedFilter == filter;
                              return GestureDetector(
                                onTap: () => cubit.changeFilter(filter),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF56C5B1) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? Colors.transparent : const Color(0xFFCFDCD9),
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : const Color(0xFF1D2733),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // قائمة المنتجات المفلترة (Obx لأن المنتجات لسه على GetX)
                      Expanded(
                        child: Obx(() {
                          final products = cubit.filteredProducts;
                          if (products.isEmpty) {
                            return const Center(
                              child: Text(
                                "No price history found for this filter.",
                                style: TextStyle(color: Color(0xFF6B7886), fontSize: 14),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            itemCount: products.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return _buildProductPriceCard(context, cubit, product);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              // 🎯 القائمة الجانبية (Drawer Menu)
              if (isDrawerOpen)
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => cubit.toggleDrawer(),
                      child: Container(
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 300,
                        height: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 52, 16, 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
                                children: [
                                  TextSpan(text: "PLATE ", style: TextStyle(color: Color(0xFF1D2733))),
                                  TextSpan(text: "Admin", style: TextStyle(color: Color(0xFFF4877B))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE3ECEA)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDE0DC),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "DK",
                                      style: TextStyle(color: Color(0xFFF4877B), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Dr. Khaled", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text("Zamalek Club · Admin", style: TextStyle(fontSize: 11, color: Color(0xFF6B7886))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDrawerItem(
                              icon: Icons.dashboard_outlined,
                              title: "Overview",
                              isSelected: false,
                              onTap: () {
                                cubit.toggleDrawer();
                                Get.to(() => AdminOverviewPage());
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.group_outlined,
                              title: "User Management",
                              isSelected: false,
                              onTap: () {
                                cubit.toggleDrawer();
                                Get.to(() => UsersManagementPage());
                              },
                            ),
                            _buildDrawerItem(icon: Icons.person_outline, title: "Gym Occupancy", isSelected: false, onTap: () {}),
                            _buildDrawerItem(
                              icon: Icons.local_bar_outlined,
                              title: "Gym & Bar",
                              isSelected: false,
                              onTap: () {
                                cubit.toggleDrawer();
                                Get.to(() => GymBarPage());
                              },
                            ),
                            _buildDrawerItem(
                              icon: Icons.local_offer_outlined,
                              title: "Price History",
                              isSelected: true,
                              onTap: () => cubit.toggleDrawer(),
                            ),
                            _buildDrawerItem(icon: Icons.credit_card_outlined, title: "Subscriptions & Policies", isSelected: false, onTap: () {}),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  /// تصميم الكارت التفاعلي مع تفعيل زر الـ Edit لفتح نافذة التعديل
  Widget _buildProductPriceCard(BuildContext context, EditPricesCubit cubit, ProductModel product) {
    final bool expanded = cubit.isExpanded(product.id);

    return GestureDetector(
      onTap: () => cubit.toggleCardExpansion(product.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE3ECEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        product.productTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D2733),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF3F3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7886),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 🎯 زر الـ Edit يفتح نافذة التعديل (Bottom Sheet)
                ElevatedButton(
                  onPressed: () => _showEditPriceBottomSheet(context, cubit, product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B5563),
                    minimumSize: const Size(64, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current: ${product.price} EGP",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2733),
                  ),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFF6B7886),
                  size: 20,
                ),
              ],
            ),

            // التفاصيل تظهر فقط عند الضغط على الكارت
            if (expanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: Color(0xFFE3ECEA), height: 1),
              ),
              const SizedBox(height: 4),
              _detailRow("User", product.updatedBy ?? "Ahmed Fawzy · Bar worker"),
              const SizedBox(height: 6),
              _detailRow("Timestamp", "Today 14:20"),
              const SizedBox(height: 6),
              _detailRow("Price Change", "was ${product.oldPrice ?? 60} EGP"),
            ],
          ],
        ),
      ),
    );
  }

  /// 🎯 نافذة Bottom Sheet لتعديل السعر
  /// بنمرر الـ cubit من برّه لأن الـ Bottom Sheet بتتفتح فوق الصفحة ومش جواها في الشجرة
  void _showEditPriceBottomSheet(BuildContext context, EditPricesCubit cubit, ProductModel product) {
    // السعر المؤقت جوه النافذة بس (حالة محلية مؤقتة)
    var tempPrice = product.price;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCFDCD9),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Edit price · ${product.productTitle}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D2733),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // حقل تعديل السعر مع أزرار الزيادة والنقصان
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE3ECEA)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (tempPrice > 5) {
                              setSheetState(() => tempPrice -= 5);
                            }
                          },
                          icon: const Icon(Icons.remove, color: Color(0xFF6B7886)),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE3ECEA)),
                          ),
                        ),
                        Text(
                          "${tempPrice.toInt()} EGP",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setSheetState(() => tempPrice += 5);
                          },
                          icon: const Icon(Icons.add, color: Color(0xFF6B7886)),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE3ECEA)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // كارت التنبيه بالتغيير
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE3ECEA)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${product.price.toInt()} EGP ➔ ${tempPrice.toInt()} EGP",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2733),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "The bar worker will see: who edited, old and new price, and the time.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7886),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // أزرار الحفظ والإلغاء
                  ElevatedButton(
                    onPressed: () {
                      cubit.itemsController.updateProductPrice(product.id, tempPrice, "Dr. Khaled");
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4877B),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Save price",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFFCFDCD9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2733),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF6B7886),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2733),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF56C5B1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1D2733),
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1D2733),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
