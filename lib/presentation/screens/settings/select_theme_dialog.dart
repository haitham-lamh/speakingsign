import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/settings/settings_controller.dart';
import 'package:speaking_sign/presentation/widgets/custom_button.dart';

class SelectThemeBottomSheet extends StatelessWidget {
  SelectThemeBottomSheet({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.wordCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            width: 45,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildOption(
                context: context,
                index: 0,
                label: "أوتوماتيك",
                image: "assets/images/mode_auto.jpg",
                textColor: colors.wordCardText!,
              ),
              buildOption(
                context: context,
                index: 1,
                label: "ليل",
                image: "assets/images/mode_dark.jpg",
                textColor: colors.wordCardText!,
              ),
              buildOption(
                context: context,
                index: 2,
                label: "نهار",
                image: "assets/images/mode_light.jpg",
                textColor: colors.wordCardText!,
              ),
            ],
          ),

          const SizedBox(height: 25),

          CustomButton(
            text: "تطبيق المظهر",
            onTap: () {
              controller.applySelectedTheme();
              Navigator.pop(context, controller.selectedThemeIndex.value);
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildOption({
    required BuildContext context,
    required int index,
    required String label,
    required String image,
    required Color textColor,
  }) {
    return Obx(() {
      final isSelected = controller.selectedThemeIndex.value == index;

      return GestureDetector(
        onTap: () => controller.selectThemeOption(index),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 16, color: textColor)),

            const SizedBox(height: 12),

            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: (MediaQuery.sizeOf(context).width * 0.26).clamp(80.0, 120.0),
              height: (MediaQuery.sizeOf(context).height * 0.28).clamp(160.0, 240.0),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xff8B3DFF) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xff8B3DFF) : Colors.grey,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Color(0xff8B3DFF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      );
    });
  }
}
