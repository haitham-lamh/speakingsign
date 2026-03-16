import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/favorite/favoritewordscontroller.dart';
import 'package:speaking_sign/controller/transulate/translate_controller.dart';

class TheModelViewer extends StatelessWidget {
  TheModelViewer({super.key, this.borderColor, required this.hasFavBtn});

  final Color? borderColor;
  final bool hasFavBtn;

  final TranslateController controller = Get.find<TranslateController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? colors.wordCardText!),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Obx(
              () => ModelViewer(
                src: controller.activeGlbPath.value,
                alt: 'Custom Model',
                id: 'model-viewer',
                backgroundColor: Colors.transparent,

                autoRotate: false,
                cameraControls: controller.cameraEnabled.value,
                disableZoom: !controller.cameraEnabled.value,
                disablePan: !controller.cameraEnabled.value,

                shadowIntensity: 1.0,
                shadowSoftness: 0.0,
                exposure: 1.0,

                cameraOrbit: "0deg 90deg 2.5m",
                minCameraOrbit: "auto 90deg 1m",
                maxCameraOrbit: "auto 90deg 4m",

                animationCrossfadeDuration: 500,

                onWebViewCreated: (webViewController) {
                  controller.setWebViewController(webViewController);
                },
              ),
            ),
          ),
        ),

        Positioned(
          top: 40,
          left: 40,
          child:
              hasFavBtn
                  ? Obx(() {
                    final translateController = Get.find<TranslateController>();
                    // Observe currentWord.value instead of textController.text directly to ensure Rx reaction
                    final word = translateController.currentWord.value; 
                    final favController = Get.put(FavoriteWordsController());

                    final isFav = favController.isFavorite(word);

                    return IconButton(
                      alignment: Alignment.center,
                      onPressed: () {
                        if (word.isNotEmpty) {
                          favController.toggleFavorite(word);
                        } else {
                          Get.snackbar(
                            "تنبيه",
                            "الرجاء إدخال كلمة وتشغيل الحركة أولاً",
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : colors.wordCardIcon,
                        size: 32,
                      ),
                    );
                  })
                  : Container(),
        ),

        Positioned(
          bottom: 40,
          left: 40,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: colors.navigaionBar,
                radius: 25,
                child: Obx(
                  () => IconButton(
                    alignment: Alignment.center,
                    onPressed: controller.togglePlay,
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: colors.wordCardIcon,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: colors.navigaionBar,
                radius: 25,
                child: Obx(
                  () => IconButton(
                    alignment: Alignment.center,
                    onPressed: controller.toggleCamera,
                    icon: Icon(
                      controller.cameraEnabled.value
                          ? Icons.videocam_rounded
                          : Icons.videocam_off_rounded,
                      color: colors.wordCardIcon,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
