import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/theme_controller/theme_controller.dart';
import 'package:speaking_sign/presentation/screens/settings/About_App/about_view.dart';
import 'package:speaking_sign/routes/app_routes.dart';

class SettingsController extends GetxController {
  var speedValue = 0.5.obs;
  var isCheckedCamera = true.obs;
  var isCheckedPlay = true.obs;
  var isCheckedRotate = false.obs;

  void updateSpeed(double value) {
    speedValue.value = value;
  }

  void toggleCamera(bool value) {
    isCheckedCamera.value = value;
  }

  void togglePlay(bool value) {
    isCheckedPlay.value = value;
  }

  void toggleRotate(bool value) {
    isCheckedRotate.value = value;
  }

  void navigateToAboutView() {
    Get.toNamed(AppRoutes.ABOUTAPP);
    print("hesham   hesham *******");
  }

  void navigateToProposals() {
    Get.toNamed(AppRoutes.ProposalsView);
    print("hesham hesham hesham hesham");
  }

  void navigateToConctiontheglavs() {
    Get.toNamed(AppRoutes.Conctiontheglavs);
    print("hesham hesham hesham hesham");
  }

  void navigateToCamera() {
    Get.toNamed(AppRoutes.Camera);
    print("hesham hesham hesham hesham");
  }

  var selectedThemeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final themeController = Get.find<ThemeController>();
    selectedThemeIndex.value = _indexFromMode(themeController.themeMode.value);
  }

  void selectThemeOption(int index) {
    selectedThemeIndex.value = index;
  }

  void applySelectedTheme() {
    final themeController = Get.find<ThemeController>();
    themeController.changeTheme(_modeFromIndex(selectedThemeIndex.value));
  }

  int _indexFromMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => 1,
      ThemeMode.light => 2,
      _ => 0,
    };
  }

  ThemeMode _modeFromIndex(int index) {
    return switch (index) {
      1 => ThemeMode.dark,
      2 => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }
}
