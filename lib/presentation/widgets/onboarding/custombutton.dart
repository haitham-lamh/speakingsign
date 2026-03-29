import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/onboarding/onbording_controller.dart';
import 'package:speaking_sign/data/static/static.dart';
import 'package:speaking_sign/routes/app_routes.dart';

class Custombutton extends StatelessWidget {
  final PageController? pageController;

  const Custombutton({super.key, this.pageController});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final controller = Get.find<OnboardingController>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.28).clamp(60.0, 140.0);

    return MaterialButton(
      textColor: Colors.white,
      onPressed: () {
        final isFinished = controller.next(onbordinglist.length);

        if (isFinished) {
          Get.offAllNamed(AppRoutes.CustomCurvedBottomNavigationBar);
        } else {
          final nextIndex = controller.currentPage.value;

          pageController?.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      color: Color(0xff8B3DFF),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 15),
      child: const Text(
        "استمـــرار",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Cairo",
        ),
      ),
    );
  }
}

