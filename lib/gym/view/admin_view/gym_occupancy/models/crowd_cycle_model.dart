import 'package:flutter/material.dart';

class crowd_circle extends StatelessWidget {
  // 1. عرّفي المتغيرات هنا
  final double percentage;
  final int currentPeople;
  final int maxPeople;
  final Color statusColor;
  final String statusTitle;

  const crowd_circle({
    Key? key,
    required this.percentage,
    required this.currentPeople,
    required this.maxPeople,
    required this.statusColor,
    required this.statusTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: percentage, // هيشوفها صح
            strokeWidth: 14,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor), // هيشوف اللون صح
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$currentPeople', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text('of $maxPeople max', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}