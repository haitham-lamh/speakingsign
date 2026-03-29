// no controller
import 'package:flutter/material.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/presentation/screens/settings/settings_items_list_view.dart';
import 'package:speaking_sign/presentation/screens/settings/settings_page_header.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final logoSize = (screenWidth * 0.55).clamp(160.0, 260.0);
    final titleFontSize = (screenWidth * 0.05).clamp(16.0, 22.0);

    return Scaffold(
      backgroundColor: Color(0xff8B3DFF),
      body: Column(
        children: [
          SettingsPageHeader(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 32, bottom: 32),
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: Column(
                  children: [
                    Text(
                      'الإعــدادات',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: colors.wordCardText,
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SettingsItemsListView(),

                          Positioned(
                            top: -(screenHeight * 0.28).clamp(180.0, 250.0),
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Image.asset(
                                'assets/images/logo3.png',
                                fit: BoxFit.cover,
                                width: logoSize,
                                height: logoSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

