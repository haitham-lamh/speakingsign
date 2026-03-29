import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/favorite/favoritewordscontroller.dart';
import 'package:speaking_sign/controller/transulate/translate_controller.dart';
import 'package:speaking_sign/presentation/screens/transulate/the_model_viewer.dart';
import 'package:speaking_sign/presentation/screens/word_detaile/word_detaile_page_header.dart';

class WordDetaileView extends StatelessWidget {
  WordDetaileView({super.key});

  // static String routeName = '/wordDetaile';
  final favoriteController = Get.find<FavoriteWordsController>();
  @override
  Widget build(BuildContext context) {
    final TranslateController controller = Get.put(TranslateController());

    final key = ModalRoute.of(context)!.settings.arguments as String;
    var value = controller.animations[key]; // Use dynamic map from controller

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.textController.text = key;
      if (value != null) {
        controller.currentAnimation.value = value;
        // Trigger translation manually to start animation since auto-trigger is disabled
        controller.translateText();
      } else {
        print("Warning: Animation for '$key' not found in dynamic map");
      }
    });

    final colors = Theme.of(context).extension<AppColors>()!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final modelWidth = (screenWidth * 0.95).clamp(280.0, 500.0);
    final modelHeight = (screenHeight * 0.5).clamp(300.0, 520.0);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: Column(
        children: [
          Expanded(child: WordDetailePageHeader()),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: constraints.maxHeight * 0.08,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: modelWidth,
                            height: modelHeight,
                            child: TheModelViewer(
                              hasFavBtn: false,
                              borderColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.all(12),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      colors.wordCard,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    favoriteController.toggleFavorite(key);
                                  },
                                  icon: Obx(() {
                                    final isFav = favoriteController.isFavorite(key);
                                    return Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.red : colors.wordCardIcon,
                                      size: (screenWidth * 0.08).clamp(24.0, 34.0),
                                    );
                                  }),
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.wordCard,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.cardShadow,
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        offset: Offset(4, 6),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      fontSize: (screenWidth * 0.045).clamp(14.0, 20.0),
                                      color: colors.wordCardText,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}

