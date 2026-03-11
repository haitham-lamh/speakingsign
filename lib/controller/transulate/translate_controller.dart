import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:webview_flutter/webview_flutter.dart';

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

  final animations = {"انا": "iam", "الان": "now", "مرحبا": "Hello"};

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    textController.addListener(_onTextChanged);
  }

  @override
  void onClose() {
    textController.dispose();
    speech.stop();
    super.onClose();
  }

  void _onTextChanged() {
    String text = textController.text.trim();
    currentWord.value = text;
    if (animations.containsKey(text)) {
      String animationName = animations[text]!;

      if (currentAnimation.value != animationName || !isPlaying.value) {
        currentAnimation.value = animationName;
        setAnimation(animationName);
      }
    }
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
      Future.delayed(const Duration(milliseconds: 500), () {
        setAnimation(currentAnimation.value);
      });
    }
  }

  void setAnimation(String name) {
    if (webViewController == null || name.isEmpty) return;

    isPlaying.value = true;

    webViewController!.runJavaScript("""
    const mv = document.querySelector('#model-viewer');
    mv.animationName = "$name";
    mv.currentTime = 0; // إعادة الحركة للبداية (ثانية 0)
    mv.play();
  """);
  }
}
