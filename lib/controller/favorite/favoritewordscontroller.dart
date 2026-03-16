import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/core/services/shared_prefs_service.dart';
import 'package:speaking_sign/data/models/animation_model.dart';
import 'package:speaking_sign/presentation/screens/word_detaile/word_detaile_view.dart';
import 'package:speaking_sign/routes/app_routes.dart';

class FavoriteWordsController extends GetxController {
  var currentItemIndex = 0.obs;

  RxList<String> favoriteWords = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await SharedPrefsService.getFavorites();
    favoriteWords.assignAll(favorites);
  }

  void toggleFavorite(String word) {
    if (word.isEmpty) return;

    if (favoriteWords.contains(word)) {
      favoriteWords.remove(word);
      SharedPrefsService.saveFavorites(favoriteWords.toList());

      Get.snackbar(
        "",
        "",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),

        backgroundColor: const Color.fromARGB(255, 247, 229, 251),
        colorText: Colors.black,
        borderRadius: 15,

        icon: const Icon(Icons.delete, color: Color(0xff8B3DFF)),

        titleText: const Text(
          "المفضلة",
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        messageText: const Text(
          "تم إزالة الكلمة من المفضلة",
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      );
    } else {
      String? animationName;
      try {
        final box = Hive.box<AnimationModel>(kAnimationBox);
        for (var anim in box.values) {
          if (anim.nameAr == word) {
            animationName = anim.animationCode;
            break;
          }
        }
      } catch (e) {
        print("Error reading from hive: $e");
      }

      if (animationName == null || animationName.isEmpty) {
        animationName = animations[word];
      }

      if (animationName == null || animationName.isEmpty) {
        Get.snackbar(
          "",
          "",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),

          backgroundColor: const Color.fromARGB(
            255,
            255,
            235,
            238,
          ), // أحمر فاتح جداً
          colorText: Colors.black,
          borderRadius: 15,

          icon: const Icon(Icons.error_outline, color: Colors.red),

          titleText: const Text(
            "تنبيه",
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          messageText: const Text(
            "عذراً، هذه الكلمة ليس لها حركة حتى الآن.",
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        );
        return; // الخروج وعدم إضافتها للمفضلة
      }

      favoriteWords.add(word);
      SharedPrefsService.saveFavorites(favoriteWords.toList());
      Get.snackbar(
        "",
        "",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),

        backgroundColor: const Color.fromARGB(255, 247, 229, 251),
        colorText: Colors.black,
        borderRadius: 15,

        icon: const Icon(Icons.check_circle, color: Color(0xff8B3DFF)),

        titleText: const Text(
          "المفضلة",
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        messageText: const Text(
          "تمت إضافة الكلمة إلى المفضلة",
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      );
    }
  }

  bool isFavorite(String word) {
    return favoriteWords.contains(word);
  }

  void selectWord(int index, String key, BuildContext context) {
    currentItemIndex.value = index;

    Get.toNamed(AppRoutes.WordDetaileView, arguments: key);
  }
}
