import 'package:flutter/material.dart';
import 'package:nikita_flutter_interview/core/constants/app_colors.dart';
import 'package:nikita_flutter_interview/core/utils/task_utils.dart';

class CommonWidgets {
  static Widget gradientContainer({
    required Widget child,
    double borderRadius = 30,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: child,
    );
  }

  static Widget formFieldContainer({
    required Widget child,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }

  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    double height = 56,
    double borderRadius = 16,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradientStart.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  static Widget iconButtonWithBackground({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
    double size = 24,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white, size: size),
        onPressed: onPressed,
      ),
    );
  }

  static Widget emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    double iconSize = 80,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  static Widget loadingIndicator({Color? color}) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primaryGradientStart,
        ),
      ),
    );
  }

  static Widget priorityBadge(int priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: TaskUtils.getPriorityColor(priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        TaskUtils.getPriorityText(priority),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: TaskUtils.getPriorityColor(priority),
        ),
      ),
    );
  }

  static Widget syncButton({
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Icon(Icons.sync, color: Colors.white, size: 24),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}
