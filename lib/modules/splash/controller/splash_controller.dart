import 'dart:async';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/modules/home/presentation/home_screen.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimeOut();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  void startTimeOut() {
    cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      Get.offNamed('/login');
      cancelTimer();
    });
  }

  void cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
