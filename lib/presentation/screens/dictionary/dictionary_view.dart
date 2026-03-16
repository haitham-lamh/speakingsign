import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/presentation/screens/dictionary/dictionary_grid_view.dart';
import 'package:speaking_sign/presentation/widgets/categories_list_view.dart';
import 'package:speaking_sign/presentation/widgets/custom_top_header.dart';
import 'package:speaking_sign/controller/dictionary/dictionary_controller.dart';

class DictionaryView extends StatelessWidget {
  const DictionaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DictionaryController());
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: Column(
        children: [
          CustomTopHeader(text: "قاموس الكلمات"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "ابحث عن كلمة...",
                prefixIcon: Icon(Icons.search, color: colors.wordCardText?.withOpacity(0.5) ?? Colors.grey),
                filled: true,
                fillColor: colors.navigaionBar,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          SizedBox(height: 8),
          CategoriesListView(),
          SizedBox(height: 8),
          Expanded(child: DictionaryGridView()),
        ],
      ),
    );
  }
}
