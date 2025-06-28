import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/core/constants/app_colors.dart';

class SnackbarUtils {

  static void showSuccess(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      borderRadius: 12,
      duration: const Duration(seconds: 4),
    );
  }

  static void showWarning(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  static void showLoading(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      borderRadius: 12,
      duration: const Duration(days: 1),
      isDismissible: false,
    );
  }

  static void closeAll() {
    Get.closeAllSnackbars();
  }
}
