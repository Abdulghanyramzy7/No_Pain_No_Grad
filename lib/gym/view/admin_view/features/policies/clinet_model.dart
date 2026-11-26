class ClientModel {
  final String name;
   String planType;
  final int currentDay; // اليوم الحالي للاشتراك
  final int totalDaysWindow; // فترة السماح (15 يوم)

   ClientModel({
    required this.name,
    required this.planType,
    required this.currentDay,
    this.totalDaysWindow = 15,
  });

  // استخراج الـ Initials تلقائياً من الـ String
  String get initials {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      String singleName = nameParts[0];
      return singleName.length >= 2
          ? singleName.substring(0, 2).toUpperCase()
          : singleName.toUpperCase();
    }
    return 'U';
  }

  // هل العميل في فترة التعديل (أقل من أو يساوي 15 يوم)؟
  bool get isEditable => currentDay <= totalDaysWindow;

  String get subtitle => '$planType · started $currentDay days ago';

  String get statusLabel => isEditable ? 'Editable' : 'Locked';

  // حساب نسبة التقدم للشريط (من 0.0 إلى 1.0)
  double get progressValue {
    if (currentDay >= totalDaysWindow) return 1.0;
    return currentDay / totalDaysWindow;
  }

  // الأيام المتبقية في نافذة الـ 15 يوم
  int get daysLeft {
    if (currentDay >= totalDaysWindow) return 0;
    return totalDaysWindow - currentDay;
  }
}


class PriceCalculator {
  final int planPrice;         // سعر الخطة الكلي (مثلاً 2400)
  final int planDurationDays;  // إجمالي أيام الخطة (مثلاً 90)
  final int currentDay;        // الأيام المنقضية (مثلاً 12)
  final int administrativeFee; // المصاريف الإدارية الثابتة (300)

  const PriceCalculator({
    required this.planPrice,
    required this.planDurationDays,
    required this.currentDay,
    this.administrativeFee = 300,
  });

  // سعر اليوم الواحد = سعر الخطة ÷ إجمالي الأيام
  double get pricePerDay => planPrice / planDurationDays;

  
  double get consumedCost => currentDay * pricePerDay;

  
  double get netRefund {
    double refund = planPrice - (consumedCost + administrativeFee);
    return refund < 0 ? 0 : refund;
  }
}

class PlanModel {
  final String title;
  final int months;
  int price;
  final int durationDays;

  PlanModel({
    required this.title,
    required this.months,
    required this.price,
    required this.durationDays,
  });
}

class PlansRepository {
  static final List<PlanModel> plans = [
    PlanModel(title: 'Monthly', months: 1, price: 900, durationDays: 30),
    PlanModel(title: 'Quarterly', months: 3, price: 2400, durationDays: 90),
    PlanModel(title: 'Half-yearly', months: 6, price: 4300, durationDays: 180),
    PlanModel(title: 'Yearly', months: 12, price: 7800, durationDays: 365),
  ];

  static PlanModel byTitle(String title) =>
      plans.firstWhere((p) => p.title == title);

  static PlanModel byMonths(int months) =>
      plans.firstWhere((p) => p.months == months);
}

