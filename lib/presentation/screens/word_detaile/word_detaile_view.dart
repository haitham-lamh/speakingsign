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
    var value = animations[key];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (value != null) {
        controller.currentAnimation.value = value;
      }
    });

    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: Column(
        children: [
          Expanded(child: WordDetailePageHeader()),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 420,
                        height: 470,
                        child: TheModelViewer(
                          hasFavBtn: false,
                          borderColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          // IconButton(
                          //   padding: EdgeInsets.all(12),
                          //   style: ButtonStyle(
                          //     backgroundColor: MaterialStatePropertyAll(
                          //       colors.wordCard,
                          //     ),
                          //   ),
                          //   alignment: Alignment.center,
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.favorite,
                          //     color: colors.wordCardIcon,
                          //     size: 32,
                          //   ),
                          // ),
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
                                size: 32,
                              );
                            }),
                          ),
                          SizedBox(width: 16),
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
                                fontSize: 18,
                                color: colors.wordCardText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
