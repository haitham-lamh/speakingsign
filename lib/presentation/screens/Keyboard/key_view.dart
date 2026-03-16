// no controller
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/keyboard/keboard_controller.dart';
import 'package:speaking_sign/presentation/screens/Keyboard/keyboard_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final KeyboardController controller = Get.put(KeyboardController());
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: Keyboard(),
    );
  }
}
