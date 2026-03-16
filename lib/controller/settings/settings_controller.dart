import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:speaking_sign/config/api_config.dart';
import 'package:speaking_sign/config/theme/theme_controller/theme_controller.dart';
import 'package:speaking_sign/presentation/screens/settings/About_App/about_view.dart';
import 'package:speaking_sign/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/data/models/animation_model.dart';

class SettingsController extends GetxController {
  var speedValue = 0.5.obs;
  var isCheckedCamera = true.obs;
  var isCheckedPlay = true.obs;
  var isCheckedRotate = false.obs;

  void updateSpeed(double value) {
    speedValue.value = value;
  }

  void toggleCamera(bool value) {
    isCheckedCamera.value = value;
  }

  void togglePlay(bool value) {
    isCheckedPlay.value = value;
  }

  void toggleRotate(bool value) {
    isCheckedRotate.value = value;
  }

  void navigateToAboutView() {
    Get.toNamed(AppRoutes.ABOUTAPP);
    print("hesham   hesham *******");
  }

  void navigateToProposals() {
    Get.toNamed(AppRoutes.ProposalsView);
    print("hesham hesham hesham hesham");
  }

  void navigateToConctiontheglavs() {
    Get.toNamed(AppRoutes.Conctiontheglavs);
    print("hesham hesham hesham hesham");
  }

  void navigateToCamera() {
    Get.toNamed(AppRoutes.Camera);
    print("hesham hesham hesham hesham");
  }

  Future<void> checkForUpdates(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xff8B3DFF)),
      ),
    );

    try {
      // التأكد من أن العنوان ينتهي بـ /
      String baseUrl = ApiConfig.dashboardBaseUrl;
      if (!baseUrl.endsWith('/')) baseUrl += '/';
      
      final url = Uri.parse("${baseUrl}api.php?action=active_files");
      
      // استخدام HttpClient مع ضبط وقت انتهاء (Timeout)
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);
      
      final request = await client.getUrl(url);
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData);
        
        if (jsonResponse['success'] == true) {
          List activeFiles = jsonResponse['files'];
          if (activeFiles.isEmpty) {
            Navigator.pop(context);
            _showSnackbar("تحديث", "لا توجد ملفات مفعلة في لوحة التحكم.", Colors.orange);
            return;
          }

          final directory = await getApplicationDocumentsDirectory();
          final dirDir = Directory(directory.path);
          
          List<FileSystemEntity> existingEntities = dirDir.listSync();
          List<String> activeFileNames = activeFiles.map<String>((f) => f['name']).toList();
          int updatedCount = 0;

          // تحميل الملفات الجديدة أولاً قبل الحذف لضمان استقرار التطبيق
          for (var fileData in activeFiles) {
            String downloadUrl = fileData['download_url'];
            String fileName = fileData['name'];
            
            // تصحيح الرابط إذا كان يحتوي على localhost وهو قادم من السيرفر
            if (downloadUrl.contains("localhost")) {
               downloadUrl = downloadUrl.replaceFirst("localhost", Uri.parse(baseUrl).host);
            }

            final savePath = "${directory.path}/$fileName";
            final file = File(savePath);
            
            if (!await file.exists()) {
               try {
                 final fileReq = await client.getUrl(Uri.parse(downloadUrl));
                 final fileRes = await fileReq.close();
                 if (fileRes.statusCode == 200) {
                   final fileSink = file.openWrite();
                   await fileRes.pipe(fileSink);
                   await fileSink.close();
                   updatedCount++;
                 }
               } catch (e) {
                 print("Error downloading $fileName: $e");
               }
            }

            // تحديث إعدادات GLB و Animations
            if (fileName.toLowerCase().endsWith('.glb')) {
               final prefs = await SharedPreferences.getInstance();
               await prefs.setString('active_glb_model', savePath);
               
               if (fileData['animations'] != null) {
                 final box = Hive.box<AnimationModel>(kAnimationBox);
                 Map<String, bool> favStates = {};
                 for (var old in box.values) {
                    favStates[old.animationCode] = old.isFavorite;
                 }
                 await box.clear();
                 Map<String, dynamic> anims = fileData['animations'];
                 for (var entry in anims.entries) {
                    box.add(AnimationModel(
                      nameAr: entry.key,
                      animationCode: entry.value.toString(),
                      category: "عامة",
                      isFavorite: favStates[entry.value.toString()] ?? false,
                    ));
                 }
               }
            }
          }

          // مسح الملفات القديمة التي لم تعد مفعلة (بعد التأكد من تحميل الجديد)
          for (var entity in existingEntities) {
             if (entity is File) {
               final filename = entity.path.split(Platform.pathSeparator).last;
               final ext = filename.split('.').last.toLowerCase();
               if (['glb', 'tflite', 'json'].contains(ext) && !activeFileNames.contains(filename)) {
                  await entity.delete();
               }
             }
          }

          Navigator.pop(context);
          if (updatedCount > 0) {
            _showSnackbar("تم التحديث 🎉", "تم تحميل $updatedCount ملف جديد.", Colors.green);
          } else {
            _showSnackbar("التحديثات", "النماذج لديك محدثة بالفعل.", Colors.blue);
          }
        } else {
          Navigator.pop(context);
          _showSnackbar("خطأ", "استجابة غير صحيحة من السيرفر.", Colors.red);
        }
      } else {
        Navigator.pop(context);
        _showSnackbar("فشل الاتصال", "تأكد من تشغيل السيرفر (XAMPP) وعنوان IP", Colors.red);
      }
    } catch (e) {
      Navigator.pop(context);
      String errorMsg = e.toString();
      if (errorMsg.contains("111")) {
        errorMsg = "تم رفض الاتصال. تأكد من:\n1. تشغيل Apache في XAMPP\n2. أن الهاتف والكمبيوتر على نفس الشبكة\n3. إغلاق جدار الحماية (Firewall) في الكمبيوتر";
      }
      _showSnackbar("تعذر الاتصال ⚠️", errorMsg, Colors.red);
    }
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  var selectedThemeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final themeController = Get.find<ThemeController>();
    selectedThemeIndex.value = _indexFromMode(themeController.themeMode.value);
  }

  void selectThemeOption(int index) {
    selectedThemeIndex.value = index;
  }

  void applySelectedTheme() {
    final themeController = Get.find<ThemeController>();
    themeController.changeTheme(_modeFromIndex(selectedThemeIndex.value));
  }

  int _indexFromMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => 1,
      ThemeMode.light => 2,
      _ => 0,
    };
  }

  ThemeMode _modeFromIndex(int index) {
    return switch (index) {
      1 => ThemeMode.dark,
      2 => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }
}
