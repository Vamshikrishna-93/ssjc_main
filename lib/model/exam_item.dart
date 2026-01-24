import 'package:flutter/material.dart';

/* ================== MODEL ================== */

class ExamModel {
  final String title;
  final String date;
  final Color color;

  const ExamModel({
    required this.title,
    required this.date,
    required this.color,
  });
}
