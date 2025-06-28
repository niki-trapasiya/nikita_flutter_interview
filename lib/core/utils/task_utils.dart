import 'package:flutter/material.dart';
import 'package:nikita_flutter_interview/core/constants/app_colors.dart';

class TaskUtils {

  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 0:
        return AppColors.priorityLow;
      case 1:
        return AppColors.priorityMedium;
      case 2:
        return AppColors.priorityHigh;
      default:
        return Colors.grey;
    }
  }


  static String getPriorityText(int priority) {
    switch (priority) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Unknown';
    }
  }


  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      return 'Overdue';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }


  static bool isOverdue(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    return taskDate.isBefore(today);
  }

  static List<DropdownMenuItem<int>> getPriorityDropdownItems() {
    return [
      DropdownMenuItem(
        value: 0,
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.priorityLow,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Low'),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 1,
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.priorityMedium,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Medium'),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 2,
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.priorityHigh,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('High'),
          ],
        ),
      ),
    ];
  }
}
