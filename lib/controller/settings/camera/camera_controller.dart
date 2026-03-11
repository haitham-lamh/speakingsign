import 'package:get/get.dart';

class CameraController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToSetting();
  }

  void navigateToSetting() {
    Get.back();
  }
}
