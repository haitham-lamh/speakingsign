import 'package:get/get.dart';

class ProposalsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToSetting();
  }

  void navigateToSetting() {
    Get.back();
  }
}
