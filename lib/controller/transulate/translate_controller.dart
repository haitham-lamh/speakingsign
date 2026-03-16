import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:speaking_sign/config/constants/constants.dart';
import 'package:speaking_sign/data/models/animation_model.dart';

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

  void translateText() {
    String text = textController.text.trim();
    if (text.isEmpty) return;

    currentWord.value = text;

    if (animations.containsKey(text)) {
      String animationName = animations[text]!;
      currentAnimation.value = animationName;
      setAnimation(animationName);
    } else {
      print("No animation found for word: $text");
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
