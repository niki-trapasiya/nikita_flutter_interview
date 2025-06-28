import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import '../../modules/home/presentation/task_form_screen.dart';
import '../../data/models/task.dart';

class NavigationHelper {
  static Future<void> navigateTo(dynamic page, {bool showAd = true}) async {
    if (showAd) {
      final adService = Get.find<AdService>();
      await adService.showInterstitialAdOnNavigation();
    }
    Get.to(() => page);
  }
  
  static Future<void> navigateBack({bool showAd = true}) async {
    if (showAd) {
      final adService = Get.find<AdService>();
      await adService.showInterstitialAdOnNavigation();
    }
    Get.back();
  }
  
  static Future<void> navigateToNamed(String route, {bool showAd = true}) async {
    if (showAd) {
      final adService = Get.find<AdService>();
      await adService.showInterstitialAdOnNavigation();
    }
    Get.toNamed(route);
  }
  
  static Future<void> navigateToTaskForm(BuildContext context, [Task? existingTask]) async {
    final adService = Get.find<AdService>();
    await adService.showInterstitialAdOnTaskEdit();
    Get.to(() => TaskFormScreen(existingTask: existingTask));
  }
} 