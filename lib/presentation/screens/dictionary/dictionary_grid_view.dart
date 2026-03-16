import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/controller/dictionary/dictionary_controller.dart';
import 'package:speaking_sign/presentation/widgets/word_card.dart';

/// DictionaryGridView - displays a grid of dictionary words
/// Connected to DictionaryController for data and navigation logic
class DictionaryGridView extends StatelessWidget {
  const DictionaryGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DictionaryController>();

    return Obx(
      () => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (MediaQuery.sizeOf(context).width / 160).clamp(2, 6).floor(),
          crossAxisSpacing: 24,
          mainAxisSpacing: 16,
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.paddingOf(context).bottom + 100,
        ),
        itemCount: controller.wordCount,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final word = controller.getWordAt(index);

          return GestureDetector(
            child: WordCard(text: word),
            onTap: () => controller.onWordTapped(word),
          );
        },
      ),
    );
  }
}
