import 'package:get/get.dart';
import 'app_routes.dart';

import '../screens/splash_screen.dart';
import '../screens/login.dart';
import '../screens/regis.dart';
import '../screens/forget_pass.dart';
import '../screens/home.dart';
import '../screens/create_transaction.dart';
import '../screens/show_all_transaction.dart';

class AppPages {
  AppPages._();

  static final routes = [
    // Splash Screen
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Login Page
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Register Page
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Forget Password Page
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // อนาคตสามารถเพิ่ม routes อื่นๆ ได้ที่นี่
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // หน้า Create Transaction สร้างเสร็จแล้ว โดย Sakkarin สามารถเอาไปดูเป้นตัวอย่างได้
    GetPage(
      name: AppRoutes.createTransaction,
      page: () => const CreateTransactionPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // หน้า show all Transaction สร้างเสร็จแล้ว โดย Sakkarin สามารถเอาไปดูเป้นตัวอย่างได้
    GetPage(
      name: AppRoutes.showAllTransaction,
      page: () => const ShowAllTransactionPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
