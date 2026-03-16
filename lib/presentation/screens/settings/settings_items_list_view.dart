// no controller
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/settings/settings_controller.dart';
import 'package:speaking_sign/data/models/settings_item_model.dart';
import 'package:speaking_sign/presentation/screens/settings/select_theme_dialog.dart';
import 'package:speaking_sign/presentation/widgets/setting_item_card.dart';

class SettingsItemsListView extends StatelessWidget {
  SettingsItemsListView({super.key});
  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    List<SettingsItemModel> settingItems = [
      SettingsItemModel(
        title: 'مظهر التطبيق',
        icon: Icons.light_mode_rounded,
        isEnabled: true,
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.wordCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SelectThemeBottomSheet(),
                  ),
                ),
              );
            },
          );
        },
      ),

      SettingsItemModel(
        title: 'المقترحات',
        icon: Icons.add_circle_outline_rounded,
        onTap: () {
          // Navigator.pushNamed(context, AddAnimationView.routeName);
          controller.navigateToProposals();
        },
      ),
      SettingsItemModel(
        title: 'الاتصال بقفاز الترجمة',
        icon: Icons.phonelink_rounded,
        onTap: () {
          controller.navigateToConctiontheglavs();
        },
      ),
      SettingsItemModel(
        title: 'كاميرا التدريب',
        icon: Icons.phonelink_rounded,
        onTap: () {
          controller.navigateToCamera();
        },
      ),

      SettingsItemModel(
        title: 'حول التطبيق',
        icon: Icons.info_rounded,
        onTap: () {
          controller.navigateToAboutView();
        },
      ),

      SettingsItemModel(
        title: 'تحديث النماذج والملفات',
        icon: Icons.system_update_alt_rounded,
        onTap: () {
          controller.checkForUpdates(context);
        },
      ),
    ];
    return ListView.builder(
      itemCount: settingItems.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return SettingItemCard(settingsItemModel: settingItems[index]);
      },
    );
  }
}
