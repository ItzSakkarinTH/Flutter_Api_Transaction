abstract class AppRoutes {
  AppRoutes._();

  // กำหนดชื่อ routes ทั้งหมด
  static const splash = '/'; // เปลี่ยนให้ splash เป็น initial route
  static const login = '/login';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const home = '/home'; // สำหรับในอนาคต
  static const profile = '/profile'; // สำหรับในอนาคต
  static const createTransaction = '/create-transaction'; // สำหรับในอนาคต
  static const showAllTransaction = '/show-all-transaction'; // สำหรับในอนาคต
  static const deleteTransaction = '/delete-transaction';
  static const editTransaction = '/edit-transaction';

  // Helper methods สำหรับการนำทาง
  static String getSplashRoute() => splash;
  static String getLoginRoute() => login;
  static String getRegisterRoute() => register;
  static String getForgetPasswordRoute() => forgetPassword;
  static String getHomeRoute() => home;
  static String getProfileRoute() => profile;
  static String getCreateTransactionRoute() => createTransaction;
  static String getShowAllTransactionRoute() => showAllTransaction;
  static String getDeleteTransactionRoute() => deleteTransaction;
  static String getEditTransactionRoute() => editTransaction;
}
