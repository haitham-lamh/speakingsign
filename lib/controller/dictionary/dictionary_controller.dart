import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/data/models/animation_model.dart';
import 'package:speaking_sign/presentation/screens/word_detaile/word_detaile_view.dart';
import 'package:speaking_sign/routes/app_routes.dart';

class DictionaryController extends GetxController {
  // ================================
  // Categories
  // ================================

  /// قائمة الفئات (Observable لأننا نستخدمها داخل Obx)
  final RxList<String> categories =
      <String>[
        
      ].obs;

  /// الفئة المختارة حاليًا
  final RxInt currentCategoryIndex = 0.obs;

  /// تغيير الفئة
  void selectCategory(int index) {
    if (index == currentCategoryIndex.value) return;
    currentCategoryIndex.value = index;

    // لاحقًا يمكنك فلترة الكلمات هنا
    // filterWordsByCategory(index);
  }

  // ================================
  // Words
  // ================================

  /// كل الكلمات (ثابتة من constants كـ fallback أو من Hive)
  List<String> get _allWords {
    final box = Hive.box<AnimationModel>(kAnimationBox);
    if (box.isNotEmpty) {
      return box.values.map((e) => e.nameAr).toList();
    }
    return animations.keys.toList();
  }

  /// الكلمات المعروضة (ممكن تتغير لاحقًا حسب الفئة)
  final RxList<String> displayedWords = <String>[].obs;

  /// نص البحث
  final RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialWords();
    
    // Listen to Hive box changes to refresh list automatically
    Hive.box<AnimationModel>(kAnimationBox).listenable().addListener(() {
      _loadInitialWords();
    });

    // Listen to search text changes
    debounce(searchText, (_) => filterWords(), time: const Duration(milliseconds: 300));
  }

  /// تحميل الكلمات
  void _loadInitialWords() {
    filterWords();
  }

  /// فلترة الكلمات بناءً على البحث (والفئة مستقبلاً)
  void filterWords() {
    if (searchText.value.isEmpty) {
      displayedWords.assignAll(_allWords);
    } else {
      displayedWords.assignAll(
        _allWords.where((word) => word.contains(searchText.value)).toList(),
      );
    }
  }

  /// تحديث نص البحث
  void onSearchChanged(String value) {
    searchText.value = value;
  }

  /// عدد الكلمات
  int get wordCount => displayedWords.length;

  /// جلب كلمة حسب index
  String getWordAt(int index) {
    if (index >= 0 && index < displayedWords.length) {
      return displayedWords[index];
    }
    return '';
  }

  /// عند الضغط على كلمة
  void onWordTapped(String word) {
    Get.toNamed(AppRoutes.WordDetaileView, arguments: word);
  }

  // ================================
  // Optional Future Enhancement
  // ================================

  /// مثال فلترة حسب الفئة (يمكنك تخصيصه لاحقًا)
  void filterWordsByCategory(int index) {
    // مثال فقط (خصص حسب منطقك)
    filterWords();
  }
}
