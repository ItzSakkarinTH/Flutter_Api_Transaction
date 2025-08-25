import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../services/api_client.dart';
import '../controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // เปิด Hive box ให้เสร็จก่อนแอปเริ่ม (permanent = ไม่ถูกลบ)
    Get.putAsync<StorageService>(() async => await StorageService().init(), permanent: true);

    // ApiClient จะถูกสร้างหลัง StorageService พร้อมใช้งาน
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<StorageService>()), fenix: true);

    // AuthController ถูก init พร้อมกับ services อื่น
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}