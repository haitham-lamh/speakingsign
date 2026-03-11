import 'package:get/get.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/presentation/screens/word_detaile/word_detaile_view.dart';
import 'package:speaking_sign/routes/app_routes.dart';

class DictionaryController extends GetxController {
  // ================================
  // Categories
  // ================================

  /// قائمة الفئات (Observable لأننا نستخدمها داخل Obx)
  final RxList<String> categories =
      <String>[
        'الحروف',
        'الأرقام',
        'الضمائر',
        'الألوان',
        'العائلة',
        'الأيام',
        'الترحيب',
        'عامة',
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

  /// كل الكلمات (ثابتة من constants)
  List<String> get _allWords => animations.keys.toList();

  /// الكلمات المعروضة (ممكن تتغير لاحقًا حسب الفئة)
  final RxList<String> displayedWords = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialWords();
  }

  /// تحميل الكلمات أول مرة
  void _loadInitialWords() {
    displayedWords.assignAll(_allWords);
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
    displayedWords.assignAll(_allWords);
  }
}
