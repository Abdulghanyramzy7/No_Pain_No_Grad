import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/core/models/occupancy/occupancy_store.dart';
import 'package:no_pain_no_grad/gym/core/widgets/check_in_slider.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/check_in_out.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights.dart';


class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _currentIndex = 0;
  int actualPeople = 23;
  bool isCheckedIn = false;

  // مصدر البيانات المشترك (الأدمن بيكتب فيه واليوزر بيقرأ بس)
  final store = OccupancyStore.instance;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final maxPeople = store.maxPeople;
        final crowdPercentage = (actualPeople / maxPeople).clamp(0.0, 1.0);
        final percentageInt = (crowdPercentage * 100).round();

// الحالة حسب رينجات الأدمن على عدد الناس الفعلي
        final level = store.levels.firstWhere(
          (l) => actualPeople >= l.minLimit && actualPeople <= l.maxLimit,
          orElse: () => store.levels.last,
        );

        return Scaffold(
          body: Container(
            width: double.infinity,
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
              child: Column(
                children: [
                  // 1. الهيدر
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good evening",
                              style: TextStyle(
                                color: Color(0xff6B7886),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Inter",
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Ahmed",
                              style: TextStyle(
                                color: Color(0xff1D2733),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 188, 245, 231),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1F9A85),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Live",
                                style: TextStyle(
                                  color: Color(0xFF1F9A85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          // كارت الازدحام الديناميكي
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Right now at Zamalek Club",
                                  style: TextStyle(
                                    color: Color(0xff6B7886),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // الدائرة البيانية الديناميكية
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: CircularProgressIndicator(
                                        value:
                                            crowdPercentage, // تحديث مقدار ملء الدائرة تلقائياً
                                        strokeWidth: 8,
                                        backgroundColor:
                                            const Color(0xffE5E9EE),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          level
                                              .color, // تغيير لون الدائرة تلقائياً
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "$percentageInt%", // نص النسبة المئوية المضروب في 100
                                          style: const TextStyle(
                                            color: Color(0xff1D2733),
                                            fontSize: 36,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Text(
                                          "crowd level",
                                          style: TextStyle(
                                            color: Color(0xff6B7886),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // شارة وصف حالة الازدحام
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: level.color.withAlpha(150),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    level
                                        .title, // تغيير الكلمة تلقائياً حسب رينج الأدمن
                                    style: TextStyle(
                                      color: level.color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // زر السحب أو كارت الحضور
                          SimpleSlideToCheckIn(
                            onCheckInTriggered: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckInOutScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // البطاقات السفلية
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      const Text(
                                        "Inside now",
                                        style: TextStyle(
                                          color: Color(0xff6B7886),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "$actualPeople / ${store.maxPeople}", // العدد الحالي والماكس من الأدمن
                                        style: TextStyle(
                                          color: level.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Next workout",
                                        style: TextStyle(
                                          color: Color(0xff6B7886),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Chest day",
                                        style: TextStyle(
                                          color: Color(0xff1D2733),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text(
                                    'Weights log',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102A33),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WeightsScreen()),
                                    );
                                  },
                                ),
                                const Divider(
                                    height: 1, indent: 16, endIndent: 16),
                                ListTile(
                                  title: const Text(
                                    'My orders',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF102A33),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xffFF7F73),
            unselectedItemColor: const Color(0xff6B7886),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center), label: "Train"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_bar), label: "Bar"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Coach"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Profile"),
            ],
          ),
        );
      },
    );
  }
}
