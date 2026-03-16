import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/dictionary/dictionary_controller.dart';

class CategoriesListView extends StatelessWidget {
  CategoriesListView({super.key});

  final DictionaryController controller = Get.find<DictionaryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: controller.categories.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: CategoryItem(
                text: controller.categories[index],
                isSelected: controller.currentCategoryIndex.value == index,
                color: Color(0xff8B3DFF),
              ),
              onTap: () {
                controller.selectCategory(index);
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.isSelected,
    required this.color,
    required this.text,
  });

  final bool isSelected;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: EdgeInsets.only(
        left: 4,
        right: 4,
        top: isSelected ? 4 : 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? color : colors.wordCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(2, 5),
                  ),
                ]
                : [],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : colors.wordCardText,
          ),
        ),
      ),
    );
  }
}
