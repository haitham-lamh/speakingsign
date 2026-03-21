import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/data/models/animation_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speaking_sign/presentation/screens/settings/conction_theglavs/gemini_config.dart';

class TranslateController extends GetxController {
  late stt.SpeechToText speech;
  var isListening = false.obs;
  var confidence = 1.0.obs;

  final textController = TextEditingController();

  var isPlaying = false.obs;
  var cameraEnabled = true.obs;
  var currentAnimation = "".obs;
  var speedValue = 0.0.obs;
  var currentWord = "".obs;

  WebViewController? webViewController;

  var activeGlbPath = 'assets/glb/new_charcter2.glb'.obs;
  final Map<String, String> animations = {};

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    textController.addListener(_onTextChanged);
    _loadDynamicData();
  }

  Future<void> _loadDynamicData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString('active_glb_model');
      if (savedPath != null && savedPath.isNotEmpty) {
        activeGlbPath.value = 'file://$savedPath';
      }

      final box = Hive.box<AnimationModel>(kAnimationBox);
      if (box.isNotEmpty) {
        animations.clear();
        for (var anim in box.values) {
          animations[anim.nameAr] = anim.animationCode;
        }
      } else {
        // Fallback or leave empty
        animations.addAll({"انا": "iam", "الان": "now", "مرحبا": "Hello"});
      }
    } catch (e) {
      print("Error loading dynamic data: \$e");
    }
  }

  @override
  void onClose() {
    textController.dispose();
    speech.stop();
    super.onClose();
  }

  Future<void> translateText() async {
    String text = textController.text.trim();
    if (text.isEmpty) return;

    currentWord.value = text;

    if (animations.containsKey(text)) {
      String animationName = animations[text]!;
      currentAnimation.value = animationName;
      setAnimation(animationName);
    } else {
      // Use Gemini to match the word dynamically
      Get.snackbar("جاري البحث", "جاري البحث عن المعنى المطابق بالذكاء الاصطناعي...",
          backgroundColor: Colors.blueAccent, colorText: Colors.white, duration: const Duration(seconds: 2));
      
      String? matchedWord = await _findClosestWordWithGemini(text);
      if (matchedWord != null && animations.containsKey(matchedWord)) {
        textController.text = matchedWord; // Update the UI
        currentWord.value = matchedWord;
        String animationName = animations[matchedWord]!;
        currentAnimation.value = animationName;
        setAnimation(animationName);
        Get.snackbar("تصحيح تلقائي", "تم تحويل '$text' إلى '$matchedWord'", 
            backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 4));
      } else {
        Get.snackbar("غير موجود", "لا توجد إشارة مسجلة للكلمة '$text'", 
            backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 4));
        print("No animation found for word: $text");
      }
    }
  }

  Future<String?> _findClosestWordWithGemini(String inputWord) async {
    if (GeminiConfig.apiKey.isEmpty || GeminiConfig.apiKey == 'YOUR_API_KEY_HERE') {
      return null;
    }
    if (animations.isEmpty) {
      return null;
    }
    try {
      final model = GenerativeModel(
        model: GeminiConfig.modelName,
        apiKey: GeminiConfig.apiKey,
      );
      
      List<String> availableWords = animations.keys.toList();
      String wordsListStr = availableWords.join('، ');

      final prompt = "لدي قائمة من الكلمات المسجلة في القاموس وهي: [$wordsListStr].\n"
          "قام المستخدم بإدخال الكلمة: '$inputWord'.\n"
          "مهمتك هي البحث عن أقرب كلمة من القاموس تطابق الكلمة المدخلة من حيث المعنى أو الجذر أو الاشتقاق (مثلاً إذا أدخل 'يعمل' والقاموس يحتوي على 'عمل' فتكون المطابقة صحيحة).\n"
          "إذا وجدت مطابقة مناسبة، أعد الكلمة المطابقة من القاموس فقط بدون أي إضافات أو نصوص أخرى.\n"
          "إذا لم تجد أي كلمة مناسبة، أعد الكلمة 'null'.";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      String? result = response.text?.trim();
      
      if (result != null && result != 'null' && result.isNotEmpty && availableWords.contains(result)) {
         return result;
      }
      return null;
    } catch (e) {
      print("Gemini Matching Error: \$e");
      return null;
    }
  }

  void _onTextChanged() {
    currentWord.value = textController.text.trim();
  }

  void listen() async {
    if (!isListening.value) {
      bool available = await speech.initialize();
      if (available) {
        isListening.value = true;
        speech.listen(
          onResult: (result) {
            textController.text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              confidence.value = result.confidence;
            }
          },
        );
      }
    } else {
      isListening.value = false;
      speech.stop();
    }
  }

  void togglePlay() {
    if (webViewController == null) return;

    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
      webViewController!.runJavaScript(
        "document.querySelector('#model-viewer').play();",
      );
    } else {
      webViewController!.runJavaScript(
        "document.querySelector('#model-viewer').pause();",
      );
    }
  }

  void toggleCamera() {
    cameraEnabled.value = !cameraEnabled.value;
    if (webViewController != null) {
      if (cameraEnabled.value) {
        webViewController!.runJavaScript("""
          (function() {
            var mv = document.querySelector('#model-viewer');
            if (mv) {
              mv.setAttribute('camera-controls', 'true');
              mv.removeAttribute('disable-zoom');
              mv.removeAttribute('disable-pan');
            }
          })();
        """);
      } else {
        webViewController!.runJavaScript("""
          (function() {
            var mv = document.querySelector('#model-viewer');
            if (mv) {
              mv.removeAttribute('camera-controls');
              mv.setAttribute('disable-zoom', 'true');
              mv.setAttribute('disable-pan', 'true');
            }
          })();
        """);
      }
    }
  }
  void increaseSpeed() {
    speedValue.value += 0.5;
  }

  void decreaseSpeed() {
    speedValue.value -= 0.5;
  }

  void setWebViewController(WebViewController controller) {
    webViewController = controller;
    if (currentAnimation.value.isNotEmpty) {
      isPlaying.value = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        setAnimation(currentAnimation.value);
      });
    } else {
      isPlaying.value = false;
    }
  }

  void setAnimation(String name) {
    if (webViewController == null || name.isEmpty) return;

    isPlaying.value = true;

    webViewController!.runJavaScript("""
      (function checkAndPlay() {
        var mv = document.querySelector('#model-viewer');
        if (mv) {
          if (!mv.modelIsVisible) {
            setTimeout(checkAndPlay, 200);
            return;
          }
          mv.animationName = "$name";
          mv.currentTime = 0;
          mv.play();
        }
      })();
    """);
  }
}
