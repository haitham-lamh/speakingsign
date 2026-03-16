import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/navigation/navigation_controller.dart';
import 'package:speaking_sign/presentation/screens/dictionary/dictionary_view.dart';
import 'package:speaking_sign/presentation/screens/favorite/favorite_view.dart';
import 'package:speaking_sign/presentation/screens/Keyboard/key_view.dart';
import 'package:speaking_sign/presentation/screens/settings/settings_view.dart';
import 'package:speaking_sign/presentation/screens/transulate/transulate_view.dart';

class CustomCurvedBottomNavigationBar extends StatelessWidget {
  CustomCurvedBottomNavigationBar({super.key});

  final NavigationController controller = Get.put(NavigationController());

  final pages = [
    SettingsView(),
    FavoriteView(),
    HomeView(),
    TransulateView(),
    DictionaryView(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    const Color activeColor = Colors.white;
    const Color inactiveColor = Color(0xff8B3DFF);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(() {
        final items = <Widget>[
          Icon(
            Icons.settings,
            size: 30,
            color:
                controller.currentIndex.value == 0
                    ? activeColor
                    : inactiveColor,
          ),
          Icon(
            Icons.bookmark_outline_rounded,
            size: 30,
            color:
                controller.currentIndex.value == 1
                    ? activeColor
                    : inactiveColor,
          ),
          Icon(
            Icons.keyboard_alt_rounded,
            size: 30,
            color:
                controller.currentIndex.value == 2
                    ? activeColor
                    : inactiveColor,
          ),
          Icon(
            Icons.translate_rounded,
            size: 30,
            color:
                controller.currentIndex.value == 3
                    ? activeColor
                    : inactiveColor,
          ),
          Icon(
            Icons.menu_book_rounded,
            size: 30,
            color:
                controller.currentIndex.value == 4
                    ? activeColor
                    : inactiveColor,
          ),
        ];

        return CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Color(0xff8B3DFF),
          color: colors.navigaionBar!,
          items: items,
          index: controller.currentIndex.value,
          animationDuration: const Duration(milliseconds: 400),
          height: 65,
          onTap: (index) => controller.changePage(index),
        );
      }),
    );
  }
}
