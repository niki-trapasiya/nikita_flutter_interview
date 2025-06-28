import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryGradientStart = Color(0xFF667eea);
  static const Color primaryGradientEnd = Color(0xFF764ba2);


  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF667eea);
  static const Color textLight = Color(0xFF6B7280);


  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundGrey = Color(0xFFF3F4F6);


  static const Color priorityLow = Colors.green;
  static const Color priorityMedium = Colors.orange;
  static const Color priorityHigh = Colors.red;


  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color whiteColor = Colors.white;
  static const Color white70Color = Colors.white70;
  static const Color warning = Colors.orange;
  static const Color info = Color(0xFF667eea);


  static const Color borderLight = Color(0xFFE5E7EB);


  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );
}
