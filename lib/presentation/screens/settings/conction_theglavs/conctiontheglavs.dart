import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speaking_sign/controller/settings/conction_theglavs/conctionthglovs_controller.dart';
import 'package:speaking_sign/data/static/static.dart';
import 'package:speaking_sign/presentation/widgets/Keyboard/customkeyboard.dart';
import 'gemini_config.dart';

class Conctiontheglavs extends StatefulWidget {
  const Conctiontheglavs({super.key});

  @override
  State<Conctiontheglavs> createState() => _ConctiontheglavsState();
}

class _ConctiontheglavsState extends State<Conctiontheglavs> {
  final ConctionthglovsController controller = Get.put(ConctionthglovsController());

  // إعدادات UDP
  static const int udpPort = 4444;
  RawDatagramSocket? _udpSocket;
  int _packetsReceived = 0;
  String _localIp = "جاري جلب الـ IP...";

  // إدارة الحركة والتنبؤ
  bool _isListening = false;
  Map<String, List<double>> _latestData = {
    'L': List.filled(14, 0.0),
    'R': List.filled(14, 0.0)
  };
  List<List<double>> _currentSequence = [];
  int _sampleCount = 0;
  Timer? _monitorTimer;

  // إعدادات النموذج (TFLite)
  Interpreter? _interpreter;
  bool _modelLoaded = false;
  String _modelStatus = "جاري تحميل النموذج...";
  List<double> _scalerMean = [];
  List<double> _scalerScale = [];
  int _maxLen = 177;
  int _numFeatures = 28;
  List<String> _classNames = [];

  // إعدادات الواجهة
  String _selectedLanguage = "العربية (بدون ترجمة)";
  String _selectedEmotion = "عادي 😐";
  String _voiceGender = "امرأة";
  bool _ttsEnabled = true;
  bool _sentenceMode = false;
  final TextEditingController _customNameController = TextEditingController();

  int _lastEmotionIndex = -1;
  int _lastLangIndex = -1;

  // عرض النتائج
  String _statusText = "الحالة: في انتظار البدء";
  String _currentPrediction = "---";
  double _currentConfidence = 0.0;
  String _currentTranslation = "";

  // وضع الجملة
  List<String> _sentenceWords = [];
  String? _pendingWord;
  Timer? _wordTimer;
  Timer? _sentenceTimer;
  String _fullSentenceText = "";
  String _sentenceStatusText = "";

  // سجل التنبؤات
  List<String> _historyLog = [];
  final ScrollController _scrollController = ScrollController();

  // أدوات النطق والذكاء الاصطناعي
  final FlutterTts _flutterTts = FlutterTts();
  GenerativeModel? get _geminiModel {
    if (GeminiConfig.apiKey.isNotEmpty && GeminiConfig.apiKey != 'YOUR_API_KEY_HERE') {
      return GenerativeModel(
        model: GeminiConfig.modelName,
        apiKey: GeminiConfig.apiKey,
      );
    }
    return null;
  }

  final Map<String, String> _languages = {
    "العربية (بدون ترجمة)": "ar",
    "English": "en",
    "Français": "fr",
    "Español": "es",
    "Türkçe": "tr",
    "اردو": "ur",
    "Deutsch": "de",
    "Italiano": "it",
    "Português": "pt",
    "中文": "zh",
    "日本語": "ja",
    "한국어": "ko",
    "हिन्दी": "hi",
    "Русский": "ru",
  };

  final Map<String, Map<String, dynamic>> _emotions = {
    "عادي 😐": {"pitch": 1.0, "rate": 0.5, "volume": 1.0, "icon": "😐", "color": Colors.blueGrey},
    "خائف 😨": {"pitch": 1.5, "rate": 0.8, "volume": 0.7, "icon": "😨", "color": Colors.purple},
    "حزين 😢": {"pitch": 0.8, "rate": 0.3, "volume": 0.8, "icon": "😢", "color": Colors.blue},
    "مستعجل 🏃": {"pitch": 1.1, "rate": 0.8, "volume": 1.0, "icon": "🏃", "color": Colors.deepOrange},
    "غاضب 😠": {"pitch": 0.6, "rate": 0.7, "volume": 1.0, "icon": "😠", "color": Colors.red},
    "سعيد 😄": {"pitch": 1.2, "rate": 0.6, "volume": 1.0, "icon": "😄", "color": Colors.green},
    "هامس 🤫": {"pitch": 0.8, "rate": 0.3, "volume": 0.3, "icon": "🤫", "color": Colors.brown},
  };

  @override
  void initState() {
    super.initState();
    _fetchLocalIp();
    _loadModels();
    _startUdpListener();
    _initTts();
  }

  Future<void> _fetchLocalIp() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();
      String? foundIp;
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            foundIp = addr.address;
            // إذا كانت الواجهة بأسماء نقاط الاتصال أو الواي فاي
            if (interface.name.toLowerCase().contains('ap') || interface.name.toLowerCase().contains('wlan')) {
              setState(() { _localIp = foundIp!; });
              return;
            }
          }
        }
      }
      if (foundIp != null) {
        setState(() { _localIp = foundIp!; });
      } else {
        setState(() { _localIp = "غير متصل بالشبكة"; });
      }
    } catch (_) {
      setState(() { _localIp = "خطأ في جلب الـ IP"; });
    }
  }

  @override
  void dispose() {
    _udpSocket?.close();
    _monitorTimer?.cancel();
    _wordTimer?.cancel();
    _sentenceTimer?.cancel();
    _interpreter?.close();
    _flutterTts.stop();
    _scrollController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
  }

  Future<void> _loadModels() async {
    try {
      // 1. تحميل النموذج
      _interpreter = await Interpreter.fromAsset('assets/models/model_cnn1d.tflite');
      
      // 2. تحميل إعدادات النموذج
      String configStr = await rootBundle.loadString('assets/models/flutter_config.json');
      var configJs = json.decode(configStr);
      _maxLen = configJs['max_len'] ?? 177;
      _numFeatures = configJs['num_features'] ?? 28;
      
      List<dynamic> classes = configJs['class_names'];
      _classNames = classes.map((e) => e.toString()).toList();

      // 3. تحميل إعدادات Scaler
      String scalerStr = await rootBundle.loadString('assets/models/scaler_params.json');
      var scalerJs = json.decode(scalerStr);
      _scalerMean = List<double>.from(scalerJs['mean'].map((x) => x.toDouble()));
      _scalerScale = List<double>.from(scalerJs['scale'].map((x) => x.toDouble()));

      setState(() {
        _modelLoaded = true;
        _modelStatus = "النموذج جاهز (CNN1D)";
      });
    } catch (e) {
      setState(() {
        _modelStatus = "خطأ في تحميل النموذج: $e";
      });
      print("Model load error: $e");
    }
  }

  void _startUdpListener() async {
    try {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, udpPort);
      _udpSocket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = _udpSocket?.receive();
          if (dg != null) {
            String line = utf8.decode(dg.data).trim();
            List<String> parts = line.split(',');
            if (parts.length >= 15) {
              String gloveId = parts[0];
              if (gloveId == 'L' || gloveId == 'R') {
                try {
                  List<double> vals = parts.sublist(1, 15).map((e) => double.parse(e)).toList();
                  _latestData[gloveId] = vals;
                  _packetsReceived++;
                  
                  if (gloveId == 'R' && parts.length >= 17) {
                    int emotionIndex = double.parse(parts[parts.length - 2]).toInt();
                    int langIndex = double.parse(parts[parts.length - 1]).toInt();
                    
                    bool changed = false;
                    
                    if (emotionIndex >= 0 && emotionIndex < _emotions.length && emotionIndex != _lastEmotionIndex) {
                      _selectedEmotion = _emotions.keys.elementAt(emotionIndex);
                      _lastEmotionIndex = emotionIndex;
                      changed = true;
                    }
                    
                    if (langIndex >= 0 && langIndex < _languages.length && langIndex != _lastLangIndex) {
                      _selectedLanguage = _languages.keys.elementAt(langIndex);
                      _lastLangIndex = langIndex;
                      changed = true;
                    }
                    
                    if (changed && mounted) {
                      setState(() {});
                    }
                  }

                  if (_packetsReceived % 50 == 0) {
                    if (mounted) setState(() {});
                  }
                } catch (_) {}
              }
            }
          }
        }
      });
    } catch (e) {
      print("UDP setup error: $e");
    }
  }

  void _startListening() {
    if (!_modelLoaded) {
      Get.snackbar("تنبيه", "النموذج لم يتم تحميله بعد!",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    setState(() {
      _isListening = true;
      _currentSequence.clear();
      _sampleCount = 0;
      _statusText = "الحالة: في انتظار الحركة...";
    });

    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      _monitorLoop();
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _statusText = "الحالة: متوقف";
    });
    _monitorTimer?.cancel();
    _cancelSentenceTimers();

    if (_sentenceMode && _pendingWord != null) {
      _sentenceWords.add(_pendingWord!);
      _pendingWord = null;
    }

    if (_sentenceMode && _sentenceWords.isNotEmpty) {
      String finalSentence = _sentenceWords.join(" ");
      setState(() {
        _fullSentenceText = finalSentence;
        _sentenceStatusText = "جاري تصحيح الجملة بالذكاء الاصطناعي...";
      });
      _sentenceWords.clear();
      _correctAndDisplaySentence(finalSentence, manualStop: true);
    }
  }

  void _monitorLoop() {
    List<double> lData = List.from(_latestData['L']!);
    List<double> rData = List.from(_latestData['R']!);

    bool allZeros = lData.every((v) => v == 0.0) && rData.every((v) => v == 0.0);

    if (allZeros) {
      if (_sampleCount > 0) {
        // انتهت الحركة
        _isListening = false;
        _triggerPrediction();
      }
    } else {
      List<double> combined = [...lData, ...rData];
      _currentSequence.add(combined);
      _sampleCount++;

      if (_sampleCount == 1) {
        setState(() {
          _statusText = "الحالة: جاري تسجيل الحركة...";
        });
        _onNewMovementDetected();
      }
    }
  }

  void _onNewMovementDetected() {
    if (_sentenceMode) {
      _sentenceTimer?.cancel();
      if (_pendingWord != null) {
        _wordTimer?.cancel();
        setState(() {
          _sentenceWords.add(_pendingWord!);
          _pendingWord = null;
          _fullSentenceText = _sentenceWords.join(" ");
          _sentenceStatusText = "تسجيل كلمة جديدة... (${_sentenceWords.length} كلمات)";
        });
      }
    }
  }

  void _cancelSentenceTimers() {
    _wordTimer?.cancel();
    _sentenceTimer?.cancel();
  }

  Future<void> _triggerPrediction() async {
    setState(() {
      _statusText = "الحالة: جاري التحليل والتنبؤ...";
    });

    String? predictedLabel;

    if (_currentSequence.length >= 3 && _interpreter != null) {
      // تجهيز الإدخال
      var input = List.generate(1, (i) => List.generate(_maxLen, (j) => List.filled(_numFeatures, 0.0)));
      for (int i = 0; i < _maxLen; i++) {
        for (int j = 0; j < _numFeatures; j++) {
          double val = i < _currentSequence.length ? _currentSequence[i][j] : 0.0;
          input[0][i][j] = (val - _scalerMean[j]) / _scalerScale[j];
        }
      }

      var output = List.generate(1, (i) => List.filled(_classNames.length, 0.0));
      _interpreter!.run(input, output);

      List<double> probs = output[0];
      double maxProb = 0.0;
      int maxIndex = -1;
      for (int i = 0; i < probs.length; i++) {
        if (probs[i] > maxProb) {
          maxProb = probs[i];
          maxIndex = i;
        }
      }

      predictedLabel = maxIndex != -1 ? _classNames[maxIndex] : "---";

      if (predictedLabel == "هيثم" && _customNameController.text.trim().isNotEmpty) {
        predictedLabel = _customNameController.text.trim();
      }

      setState(() {
        _currentPrediction = predictedLabel!;
        _currentConfidence = maxProb;
      });

      if (!_sentenceMode) {
        _addToHistory("[${_timeNow()}] $predictedLabel (${(maxProb * 100).toStringAsFixed(1)}%)");
        
        String targetLangCode = _languages[_selectedLanguage] ?? "ar";
        if (targetLangCode != "ar") {
          setState(() { _currentTranslation = "جاري الترجمة..."; });
          String? translated = await _translateTextWithGemini(predictedLabel, _selectedLanguage);
          if (translated != null) {
            setState(() { _currentTranslation = translated; });
            _addToHistory("    [${_timeNow()}] ترجمة: $translated");
            _speakText(translated, targetLangCode);
          } else {
            setState(() { _currentTranslation = "تعذرت الترجمة"; });
            _speakText(predictedLabel, "ar");
          }
        } else {
          setState(() { _currentTranslation = ""; });
          _speakText(predictedLabel, "ar");
        }
      }
    } else {
      setState(() {
        _statusText = "حركة قصيرة جداً، تم تجاهلها";
      });
    }

    if (_sentenceMode) {
      if (predictedLabel != null) {
        _pendingWord = predictedLabel;
        _cancelSentenceTimers();
        
        setState(() {
          var preview = List<String>.from(_sentenceWords)..add("[$predictedLabel]");
          _fullSentenceText = preview.join(" ");
          _sentenceStatusText = "في انتظار الكلمة التالية...";
        });

        _wordTimer = Timer(const Duration(seconds: 2), _onWordTimeout);
      }
      Future.delayed(const Duration(milliseconds: 500), _autoRestartListening);
    } else {
      Future.delayed(const Duration(milliseconds: 2000), _autoRestartListening);
    }
  }

  void _onWordTimeout() {
    if (_pendingWord != null) {
      setState(() {
        _sentenceWords.add(_pendingWord!);
        _pendingWord = null;
        _fullSentenceText = _sentenceWords.join(" ");
        _sentenceStatusText = "تمت الإضافة (${_sentenceWords.length} كلمات) - انتظار 3 ثوانٍ للإنهاء...";
      });
      _sentenceTimer = Timer(const Duration(seconds: 3), _onSentenceTimeout);
    }
  }

  void _onSentenceTimeout() {
    if (_sentenceWords.isNotEmpty) {
      String finalSentence = _sentenceWords.join(" ");
      setState(() {
        _fullSentenceText = finalSentence;
        _sentenceStatusText = "جاري تصحيح الجملة بالذكاء الاصطناعي (Gemini)...";
      });
      _sentenceWords.clear();
      _correctAndDisplaySentence(finalSentence);
    }
  }

  Future<void> _correctAndDisplaySentence(String originalSentence, {bool manualStop = false}) async {
    String corrected = await _correctSentenceWithGemini(originalSentence) ?? originalSentence;

    String targetLangCode = _languages[_selectedLanguage] ?? "ar";
    String? translated;
    if (targetLangCode != "ar") {
      translated = await _translateTextWithGemini(corrected, _selectedLanguage);
    }

    if (!mounted) return;

    setState(() {
      _fullSentenceText = corrected;
      _currentTranslation = translated ?? "";
      
      String status = "تم إنهاء الجملة وتصحيحها";
      if (translated != null) status += " وترجمتها";
      if (manualStop) status += " (إيقاف يدوي)";
      _sentenceStatusText = status;
    });

    String logData = "[${_timeNow()}] [جملة] $corrected";
    if (corrected != originalSentence) logData += "\n    (الأصل: $originalSentence)";
    if (translated != null) logData += "\n    (الترجمة: $translated)";
    _addToHistory(logData);

    String textToSpeak = translated ?? corrected;
    _speakText(textToSpeak, targetLangCode);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _sentenceMode) {
        setState(() {
          _fullSentenceText = "";
          _sentenceStatusText = "جاهز لجملة جديدة - قم بأداء الإشارة";
        });
      }
    });
  }

  Future<String?> _correctSentenceWithGemini(String sentence) async {
    if (_geminiModel == null) {
      Get.snackbar("تنبيه", "مفتاح API غير مكوّن. يرجى إضافته في gemini_config.dart",
          backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 4));
      return null;
    }
    try {
      final prompt = "أنت مصحح لغوي عربي متخصص تعمل داخل قفاز يقوم بترجمة وتحويل لغة الاشارة الى لغة منطوقة ومقرءة. مهمتك الوحيدة هي تصحيح الأخطاء النحوية والصرفية والإملائية في الجملة المُعطاة, مثلا : انا اسم , تصبح , انا اسمي .\n"
          "القواعد: لا تضف كلمات جديدة، لا تحذف كلمات. أعد الجملة المصححة فقط بدون أي شرح. إذا كانت صحيحة، أعدها كما هي . لن تصلك حروف الجر يجب ان تضيفها انت وصحح الجملة بالكامل , مثلا : شكرا لكم حسن استماع , تصبح , شكرا لكم على حسن الاستماع .\n\n"
 	          "صحح هذه الجملة: $sentence";
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content);
      return response.text?.trim() ?? sentence;
    } catch (e) {
      print("Gemini Correction Error: $e");
      if (e.toString().contains('API key not valid') || e.toString().contains('leaked')) {
        Get.snackbar("خطأ في الذكاء الاصطناعي", "مفتاح API غير صالح أو تم إيقافه. يرجى تغييره في الإعدادات.",
            backgroundColor: Colors.redAccent, colorText: Colors.white, duration: const Duration(seconds: 4));
      } else {
        Get.snackbar("خطأ غير متوقع", "تصحيح النص: ${e.toString()}",
            backgroundColor: Colors.redAccent, colorText: Colors.white, duration: const Duration(seconds: 5));
      }
      return null;
    }
  }

  Future<String?> _translateTextWithGemini(String text, String langName) async {
    if (_geminiModel == null) {
      Get.snackbar("تنبيه", "مفتاح API غير مكوّن. يرجى إضافته في gemini_config.dart",
          backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 4));
      return null;
    }
    try {
      final prompt = "أنت مترجم محترف. ترجم النص العربي التالي إلى $langName.\n"
          "أعد الترجمة فقط بدون أي شرح وحافظ على المعنى.\n\n"
          "ترجم: $text";
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content);
      return response.text?.trim();
    } catch (e) {
      print("Gemini Translation Error: $e");
      if (e.toString().contains('API key not valid') || e.toString().contains('leaked')) {
        Get.snackbar("خطأ في الترجمة", "مفتاح API غير صالح أو تم إيقافه (Leaked). راجع ملف gemini_config.dart",
            backgroundColor: Colors.redAccent, colorText: Colors.white, duration: const Duration(seconds: 4));
      } else {
        Get.snackbar("خطأ الترجمة", "حدث خطأ أثناء الترجمة: ${e.toString()}",
            backgroundColor: Colors.redAccent, colorText: Colors.white, duration: const Duration(seconds: 5));
      }
      return null;
    }
  }

  Future<void> _speakText(String text, String langCode) async {
    if (!_ttsEnabled) return;
    try {
      await _flutterTts.setLanguage(langCode);
      
      // محاولة البحث عن أصوات الذكور أو الإناث الحقيقية في النظام بدلاً من تغيير حدة الصوت فقط
      var voices = await _flutterTts.getVoices;
      bool voiceSet = false;
      
      if (voices != null) {
        for (var voice in voices) {
          if (voice["locale"] != null && voice["locale"].toString().startsWith(langCode.substring(0, 2))) {
            String voiceName = voice["name"].toString().toLowerCase();
            
            // في أنظمة الأندرويد والآيفون، تحتوي الأسماء على كلمات تدل على الجنس أو تنتهي بأحرف محددة في جوجل TTS
            bool isMaleVoice = voiceName.contains("male") || 
                               voiceName.contains("maged") || // صوت ذكر عربي في آيفون
                               voiceName.contains("tarik") || // صوت ذكر عربي في آيفون
                               voiceName.endsWith("-b") ||    // Google TTS للذكور
                               voiceName.endsWith("-c");      // Google TTS للذكور
            
            bool isFemaleVoice = voiceName.contains("female") || 
                                 voiceName.contains("laila") || // صوت أنثى عربي في آيفون
                                 voiceName.contains("noura") || // صوت أنثى عربي 
                                 voiceName.endsWith("-a") ||    // Google TTS للإناث
                                 voiceName.endsWith("-d");      // Google TTS للإناث
            
            if (_voiceGender == "رجل" && isMaleVoice) {
              await _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
              voiceSet = true;
              break;
            } else if (_voiceGender == "امرأة" && isFemaleVoice) {
              await _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
              voiceSet = true;
              break;
            }
          }
        }
      }
      
      var emotion = _emotions[_selectedEmotion]!;

      // إذا لم يجد النظام صوت ذكر/أنثى محدد، سنلجأ لتغيير الـ Pitch (حدة الصوت) كحل احتياطي، ولكن بقيم طبيعية أكثر
      double basePitch = 1.0;
      if (!voiceSet) {
        basePitch = _voiceGender == "رجل" ? 0.85 : 1.15; // قيم أقرب للطبيعي بدلاً من 0.6 التي كانت تجعله آلياً
      }

      double emotionPitch = emotion['pitch'] as double;

      await _flutterTts.setPitch((basePitch * emotionPitch).clamp(0.1, 2.0));
      await _flutterTts.setSpeechRate(emotion['rate'] as double);
      await _flutterTts.setVolume(emotion['volume'] as double);
      await _flutterTts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void _autoRestartListening() {
    if (mounted && !_isListening) {
      _startListening();
    }
  }

  void _addToHistory(String log) {
    setState(() {
      _historyLog.insert(0, log);
    });
  }

  String _timeNow() {
    return "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}";
  }

  void _showCustomKeyboard() {
    FocusScope.of(context).unfocus(); // إخفاء لوحة المفاتيح الافتراضية إذا كانت ظاهرة
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        return Container(
          height: (screenHeight * 0.5).clamp(300.0, 500.0),
          decoration: const BoxDecoration(
            color: Color(0xFFF7F9FC),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 16),
          child: Column(
            children: [
              // زر إغلاق
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ),
              Expanded(
                child: Column(
                  children: [
                    ...keboardlist.map((row) {
                      return Expanded(
                        child: Row(
                          children: row.map((sign) {
                            return KeyboardButton(
                              label: sign.char!,
                              imagePath: sign.assetpath!,
                              onPressed: () {
                                _customNameController.text += sign.char!;
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: (screenHeight * 0.065).clamp(42.0, 60.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_customNameController.text.isNotEmpty) {
                                    _customNameController.text = _customNameController.text.substring(0, _customNameController.text.length - 1);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 181, 115, 115),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                ),
                                child: const Text('مســح', style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Cairo", fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _customNameController.text += " ";
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                ),
                                child: const Text('مسافـــة', style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Cairo", fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 203, 168, 254),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                ),
                                child: const Text('تم', style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Cairo", fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final titleFontSize = (screenWidth * 0.05).clamp(16.0, 24.0);
    final bodyFontSize = (screenWidth * 0.035).clamp(12.0, 16.0);
    final predictionFontSize = (screenWidth * 0.09).clamp(28.0, 42.0);
    
    Color confidenceColor = Colors.grey;
    if (_currentConfidence >= 0.8) confidenceColor = Colors.green;
    else if (_currentConfidence >= 0.5) confidenceColor = Colors.orange;
    else if (_currentConfidence > 0) confidenceColor = Colors.red;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: Column(
          children: [
            // الهيدر
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                right: screenWidth * 0.05,
                left: screenWidth * 0.025,
                bottom: screenHeight * 0.025,
                top: MediaQuery.paddingOf(context).top + 10,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff8B3DFF), Color.fromARGB(255, 174, 143, 220)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("التعرف على لغة الإشارة", style: TextStyle(fontFamily: 'Cairo', fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                  IconButton(
                    onPressed: () => controller.navigateToSetting(),
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // حقل الاسم المخصص
                    TextField(
                      controller: _customNameController,
                      readOnly: true,
                      onTap: _showCustomKeyboard,
                      decoration: InputDecoration(
                        labelText: "اسم ذو الهمة العالية",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    // حالة الاتصال
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text("IP الخاص بالجوال (ضعه في شريحة ESP):", style: TextStyle(color: Colors.blueGrey, fontSize: bodyFontSize, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                          Text(_localIp, style: TextStyle(color: Colors.blue, fontSize: (screenWidth * 0.05).clamp(16.0, 22.0), fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("الشبكة: منفذ $udpPort | حزم البيانات: $_packetsReceived", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(_modelStatus, textAlign: TextAlign.center, style: TextStyle(color: _modelLoaded ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // إعدادات الترجمة والشعور
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("اللغة:", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedLanguage,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    items: _languages.keys.map((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14)));
                                    }).toList(),
                                    onChanged: (val) => setState(() => _selectedLanguage = val!),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("الشعور:", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedEmotion,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    items: _emotions.keys.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Text(_emotions[value]!['icon'], style: const TextStyle(fontSize: 18)),
                                            const SizedBox(width: 8),
                                            Text(value.replaceAll(RegExp(r'[^\w\s]'), '').trim(), style: const TextStyle(fontSize: 50)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) => setState(() => _selectedEmotion = val!),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // خيارات النطق ووضع الجملة
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("🔊 تفعيل النطق", style: TextStyle(fontSize: 13, fontFamily: 'Cairo')),
                            value: _ttsEnabled,
                            onChanged: (val) => setState(() => _ttsEnabled = val!),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("وضع الجملة", style: TextStyle(fontSize: 13, fontFamily: 'Cairo')),
                            value: _sentenceMode,
                            onChanged: (val) {
                              setState(() => _sentenceMode = val!);
                              _cancelSentenceTimers();
                              _sentenceWords.clear();
                              _fullSentenceText = "";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                    
                    // اختيار جنس صوت القارئ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("صوت القارئ:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: "رجل",
                          groupValue: _voiceGender,
                          onChanged: (val) => setState(() => _voiceGender = val!),
                        ),
                        const Text("رجل", style: TextStyle(fontSize: 14, fontFamily: 'Cairo')),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: "امرأة",
                          groupValue: _voiceGender,
                          onChanged: (val) => setState(() => _voiceGender = val!),
                        ),
                        const Text("امرأة", style: TextStyle(fontSize: 14, fontFamily: 'Cairo')),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // أزرار التحكم
                    ElevatedButton(
                      onPressed: _isListening ? _stopListening : _startListening,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isListening ? Colors.redAccent : const Color(0xff8B3DFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        _isListening ? "إيقاف التعرف" : "بدء التعرف على الإشارات",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_statusText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontFamily: 'Cairo')),
                    Text("الإطارات المسجلة: $_sampleCount", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo')),
                    const SizedBox(height: 15),

                    // نتيجة التنبؤ
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Column(
                          children: [
                            const Text("نتيجة التنبؤ", style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Cairo')),
                            const SizedBox(height: 8),
                            Text(
                              _currentPrediction,
                              style: TextStyle(fontSize: predictionFontSize, fontWeight: FontWeight.bold, color: confidenceColor, fontFamily: 'Cairo'),
                            ),
                            if (_currentTranslation.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                "🌐 $_currentTranslation",

                                style: TextStyle(fontSize: (screenWidth * 0.055).clamp(16.0, 24.0), color: Colors.purple, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              "الثقة: ${(_currentConfidence * 100).toStringAsFixed(1)}%",
                              style: TextStyle(fontSize: 14, color: confidenceColor, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // قسم وضع الجملة
                    if (_sentenceMode) ...[
                      const Text("الجملة الحالية:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      Card(
                        elevation: 1,
                        color: const Color(0xFFE3F2FD),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _fullSentenceText.isEmpty ? "..." : _fullSentenceText,
                                style: const TextStyle(fontSize: 22, color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _sentenceStatusText,
                                style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo'),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],

                    // سجل التنبؤات
                    const Text("السجل:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    Container(
                      height: (screenHeight * 0.15).clamp(100.0, 150.0),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _historyLog.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(_historyLog[index], style: const TextStyle(fontSize: 12, fontFamily: 'Cairo')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
