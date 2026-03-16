import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/transulate/translate_controller.dart';
import 'package:speaking_sign/presentation/screens/transulate/the_model_viewer.dart';
import 'package:speaking_sign/presentation/widgets/animated_border_text_field.dart';
import 'package:speaking_sign/presentation/widgets/public/custom_top_header2.dart';

class CustomModelView extends StatelessWidget {
  CustomModelView({super.key});

  final TranslateController controller = Get.put(TranslateController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      children: [
        CustomTopHeader2(text: "ترجــــمة الاشــــــارة"),
        Expanded(flex: 1, child: SizedBox(height: 32)),
        Expanded(flex: 6, child: TheModelViewer(hasFavBtn: true)),
        SizedBox(height: 6),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Obx(
                      () => AvatarGlow(
                        animate: controller.isListening.value,
                        glowColor: colors.wordCardIcon!,
                        duration: Duration(milliseconds: 1200),
                        startDelay: Duration(milliseconds: 500),
                        repeat: true,
                        glowRadiusFactor: 0.2,
                        glowCount: 3,
                        curve: Curves.fastEaseInToSlowEaseOut,
                        child: CircleAvatar(
                          backgroundColor: colors.navigaionBar,
                          radius: 32,
                          child: IconButton(
                            alignment: Alignment.center,
                            onPressed: controller.listen,
                            icon: Icon(
                              controller.isListening.value
                                  ? Icons.mic_rounded
                                  : Icons.mic_off_rounded,
                              color: colors.wordCardText,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: AnimatedBorderTextField(
                        colors: colors,
                        borderRadius: 8,
                        hintText: 'إدخل كلمة',
                        gradientColors: const [
                          Color(0xFFDA22FF),
                          Color(0xFF9733EE),
                          Color(0xFF667EEA),
                        ],
                        onChanged: (text) {
                          // The logic here handles itself via controller's listener
                        },
                        controller: controller.textController,
                        // animationSpeed: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.translateText(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.navigaionBar,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.wordCardIcon!.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: colors.wordCardText,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
