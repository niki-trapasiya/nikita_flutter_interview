import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/modules/splash/presantation/splash_screen.dart';
import 'package:nikita_flutter_interview/core/services/ad_service.dart';
import 'firebase_options.dart';
import 'package:nikita_flutter_interview/modules/auth/presentation/login_screen.dart';
import 'package:nikita_flutter_interview/modules/auth/presentation/signup_screen.dart';
import 'package:nikita_flutter_interview/modules/home/presentation/home_screen.dart';
import 'package:nikita_flutter_interview/modules/auth/presentation/user_profile_screen.dart';
import 'package:nikita_flutter_interview/modules/auth/presentation/rating_screen.dart';
import 'package:nikita_flutter_interview/modules/auth/presentation/change_password_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  Get.put(AdService());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/profile', page: () => UserProfileScreen()),
        GetPage(name: '/rating', page: () => RatingScreen()),
        GetPage(name: '/change-password', page: () => ChangePasswordScreen()),
      ],
    );
  }
}
