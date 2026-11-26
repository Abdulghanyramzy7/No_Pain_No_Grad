import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/policies/clinet_model.dart';



class RemoveClientScreen extends StatelessWidget {
  final ClientModel client;
  // أفرضي مثلاً أننا نعرف سعر الخطة الكلي وإجمالي أيامها (أو يمكن إضافتها لاحقاً حسب بياناتك)
  final int planPrice;
  final int planDurationDays;

  const RemoveClientScreen({
    super.key,
    required this.client,
    required this.planPrice,
    required this.planDurationDays,
  });

  String _formatNumber(double number) {
    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2);
  }

  String _formatInteger(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    // 1. استخدام الكلاس PriceCalculator كما هو تماماً في الموديل الخاص بكِ
    final priceCalculator = PriceCalculator(
      planPrice: planPrice,
      planDurationDays: planDurationDays,
      currentDay: client.currentDay,
    );

    final double pricePerDay = priceCalculator.pricePerDay;
    final double consumedCost = priceCalculator.consumedCost;
    final double netRefund = priceCalculator.netRefund;

    return Scaffold(
      //backgroundColor: const Color(0xFFD5F1EC), // لون خلفية التطبيق Mint
      body: Container( width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 152, 238, 224),
              Color.fromRGBO(182, 239, 228, 1),
              Color.fromARGB(255, 209, 238, 231),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Back Button + Title)
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D1F)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Remove client',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
        
                // 2. Client Summary Card (مأخوذ من ClientModel الأصلي)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          client.initials, // تم جلبها من الـ Getter في ClientModel
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF8C6D62),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            client.subtitle, // تم جلبها من الـ Getter في ClientModel
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
        
                // 3. Calculations Breakdown Container (مأخوذة من PriceCalculator الأصلي)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _buildCalcRow(
                        'Plan price',
                        '${_formatInteger(planPrice)} EGP',
                        isBold: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFF3F4F6), height: 1),
                      ),
                      _buildCalcRow(
                        'Consumed days (${client.currentDay} × ${_formatNumber(pricePerDay)})',
                        '- ${_formatNumber(consumedCost)} EGP',
                        valueColor: const Color(0xFFD65A5A),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFF3F4F6), height: 1),
                      ),
                      _buildCalcRow(
                        'Administrative fee',
                        '- ${priceCalculator.administrativeFee} EGP',
                        valueColor: const Color(0xFFD65A5A),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFF3F4F6), height: 1),
                      ),
                      _buildCalcRow(
                        'Net refund',
                        '${_formatNumber(netRefund)} EGP',
                        isBold: true,
                        valueColor: const Color(0xFF111827),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
        
                // 4. Notice Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'Removal needs the client\'s approval of the next message.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      height: 1.4,
                    ),
                  ),
                ),
        
                const Spacer(),
        
                // 5. Action Buttons (Back & Continue)
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE57373),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            // TODO: أضف هنا الإجراء التالي عند الضغط على Continue
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            color: isBold ? const Color(0xFF111827) : const Color(0xFF6B7280),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: valueColor ?? const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}