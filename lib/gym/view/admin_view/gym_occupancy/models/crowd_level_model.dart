import 'package:flutter/material.dart';

class CrowdLevel {
  final String title;
  final Color color;
  int minLimit;
  int maxLimit;

  CrowdLevel({
    required this.title,
    required this.color,
    required this.minLimit,
    required this.maxLimit,
  });

  // زيادة الحد الأقصى للمستوى الحالي
  void incrementLimit() {
    maxLimit++;
  }

  // إنقاص الحد الأقصى للمستوى الحالي (بحيث لا يقل عن الحد الأدنى)
  void decrementLimit() {
    if (maxLimit > minLimit + 1) {
      maxLimit--;
    }
  }
}