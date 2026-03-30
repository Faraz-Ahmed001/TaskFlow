import 'package:flutter/material.dart';
import 'enums.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF7B68EE);
  static const Color primaryDark = Color(0xFF5E4DBD);
  static const Color primaryLight = Color(0xFF9D8EF5);

  // Background Colors
  static const Color background = Color(0xFFF5F6FA);
  static const Color cardBackground = Colors.white;
  static const Color dialogBackground = Color(0xFF5E4DBD);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textWhite = Colors.white;

  // Priority Colors
  static const Color priorityHigh = Color(0xFFFF6B6B);
  static const Color priorityMedium = Color(0xFFFFA726);
  static const Color priorityLow = Color(0xFF4CAF50);

  // Category Colors
  static const Color categoryWork = Color(0xFF2196F3);
  static const Color categoryPersonal = Color(0xFF9C27B0);
  static const Color categoryShopping = Color(0xFFFF9800);
  static const Color categoryHealth = Color(0xFFE91E63);
  static const Color categoryEducation = Color(0xFF3F51B5);
  static const Color categoryFinance = Color(0xFF4CAF50);
  static const Color categoryHome = Color(0xFF795548);
  static const Color categoryOther = Color(0xFF607D8B);

  // Status Colors
  static const Color completed = Color(0xFF4CAF50);
  static const Color pending = Color(0xFFFFA726);
  static const Color overdue = Color(0xFFFF6B6B);

  // UI Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x1A000000);
  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);

  // Get priority color
  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return priorityHigh;
      case TaskPriority.medium:
        return priorityMedium;
      case TaskPriority.low:
        return priorityLow;
    }
  }

  // Get category color
  static Color getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return categoryWork;
      case TaskCategory.personal:
        return categoryPersonal;
      case TaskCategory.shopping:
        return categoryShopping;
      case TaskCategory.health:
        return categoryHealth;
      case TaskCategory.education:
        return categoryEducation;
      case TaskCategory.finance:
        return categoryFinance;
      case TaskCategory.home:
        return categoryHome;
      case TaskCategory.other:
        return categoryOther;
    }
  }
}
