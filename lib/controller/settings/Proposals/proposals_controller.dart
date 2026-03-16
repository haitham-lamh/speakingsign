import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:speaking_sign/config/api_config.dart';

class ProposalsController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void navigateToSetting() {
    Get.back();
  }

  Future<void> sendSuggestion(BuildContext context) async {
    final title = titleController.text.trim();
    final text = suggestionController.text.trim();

    if (title.isEmpty || text.isEmpty) {
      _showSnackbar("خطأ", "يرجى تعبئة جميع الحقول", Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse("${ApiConfig.dashboardBaseUrl}api.php?action=add_suggestion");
      
      final request = await HttpClient().postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      
      final body = jsonEncode({
        'title': title,
        'text': text,
      });
      request.add(utf8.encode(body));
      
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final jsonResponse = jsonDecode(stringData);
        
        if (jsonResponse['success'] == true) {
          _showSnackbar("نجاح 🎉", "تم إرسال مقترحك بنجاح، شكراً لك!", Colors.green);
          titleController.clear();
          suggestionController.clear();
        } else {
          _showSnackbar("حدث خطأ", "تعذر الإرسال: ${jsonResponse['message']}", Colors.red);
        }
      } else {
        _showSnackbar("فشل الاتصال", "تأكد من عنوان الـ IP الخاص بلوحة التحكم", Colors.red);
      }
    } catch (e) {
      _showSnackbar("خطأ ⚠️", "تأكد من عنوان الـ IP واتصالك بالشبكة.", Colors.red);
    } finally {
      isLoading.value = false;
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
}
