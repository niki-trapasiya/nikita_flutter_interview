import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/modules/splash/controller/splash_controller.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_string.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageAssets.todoLogo, height: 100),
             SizedBox(height: 20),
             Text(
              AppString.splashText,
               textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
