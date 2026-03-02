# speaking_sign


نظام ذكي لمساعدة الصم والبكم باستخدام **لغة الإشارة + الذكاء الاصطناعي + إنترنت الأشياء**، مع تطبيق موبايل مبني باستخدام Flutter.

---

## 🚀 فكرة المشروع

يهدف المشروع إلى تطوير نظام شامل يساعد الصم والبكم على التواصل بسهولة مع الآخرين، من خلال:

* **قفاز ذكي** مزوّد بحساسات لالتقاط لغة الإشارة.
* **وحدة Raspberry Pi** لمعالجة البيانات وتشغيل نماذج الذكاء الاصطناعي.
* **اتصال Wi‑Fi** لإرسال بيانات الإشارات إلى تطبيق الموبايل.
* **تطبيق موبايل Flutter:** يقوم باستقبال الكلمة المترجمة من القفاز عبر Wi-Fi، وعرضها كنص وصوت، والعكس بالعكس (من النص إلى حركة عبر نموذج ثلاثي الأبعاد).
* **ملف GLB موحد:** يحتوي على جميع حركات لغة الإشارة، يتم تشغيل الحركة المناسبة داخل التطبيق عند استقبال الكلمة.
* **تطبيق Flutter** يعرض الترجمة ويحوّل صوت الشخص المتحدث إلى نص.

النظام يعمل باتجاهين:

1. **من الصم إلى السامع**: القفاز → RPi → Wi‑Fi → Flutter → نص وصوت.
2. **من السامع إلى الصم**: صوت المتحدث → Flutter STT → نص واضح.

---

## 🧩 مكوّنات المشروع

### 1. القفاز الذكي

* حساسات Flex Sensors
* MPU6050
* ESP32 أو اتصال مباشر مع Raspberry Pi
* إرسال البيانات عبر Wi‑Fi على شكل JSON

### 2. جهاز Raspberry Pi

* تشغيل خوارزميات AI لمعالجة الإشارات
* اكتشاف نوع الإشارة (Gesture Classification)
* إرسال النتيجة إلى تطبيق Flutter

### 3. تطبيق الموبايل (Flutter)

* استقبال بيانات الإشارات عبر Socket/Wi‑Fi
* تحويل الكلام إلى نص (Speech to Text)
* تحويل النص إلى كلام (TTS)
* واجهة حديثة وسهلة الاستخدام
* نظام تخزين محلي باستخدام Hive
* استخدام Cubit لإدارة الحالة

---

## 🏗️ بنية المشروع

```
lib/
│
├─ config/                 ← إعدادات وتكوينات المشروع العامة
│   ├─ theme/              ← ألوان + ثيمات التطبيق (Light/Dark)
│   ├─ router/             ← إدارة التوجيه والتنقل بين الصفحات
│   ├─ localization/       ← ملفات الترجمة (AR / EN)
│   └─ constants/          ← ثوابت عامة (كلمات، مفاتيح Hive، IP …)
│
├─ core/                   ← أدوات أساسية يمكن استخدامها في أي مكان
│   ├─ errors/             ← التعامل مع الأخطاء والاستثناءات
│   ├─ network/            ← إعدادات الاتصال بالإنترنت / WiFi Socket
│   ├─ utils/              ← دوال مساعدة عامة (formatters, validators …)
│   └─ services/           ← خدمات مشتركة (TTS, STT, GLB Player …)
│
├─ data/                   ← الطبقة المسؤولة عن البيانات (Data Layer)
│   ├─ models/             ← تعريف الكيانات (Classes) مثل HistoryItem, UserPref
│   ├─ repositories/       ← واجهات + تنفيذ مصادر البيانات (Hive, API, ESP32)
│   ├─ datasources/
│   │   ├─ local/          ← عمليات التخزين المحلية (Hive)
│   │   └─ remote/         ← عمليات الشبكة (ESP32 عبر WiFi)
│   └─ adapters/           ← محولات Hive TypeAdapters
│
├─ domain/                 ← منطق الأعمال (Business Logic Layer)
│   ├─ entities/           ← الكيانات المجردة (Abstract)
│   ├─ repositories/       ← واجهات مجردة للـ Repositories
│   └─ usecases/           ← وظائف التطبيق (GetHistory, SaveMessage …)
│
├─ presentation/            ← واجهات المستخدم (UI Layer)
│   ├─ cubits/             ← إدارة الحالة Cubit لكل شاشة/وحدة
│   │   ├─ connection_cubit/
│   │   ├─ speech_cubit/
│   │   ├─ animation_cubit/
│   │   ├─ history_cubit/
│   │   └─ settings_cubit/
│   ├─ screens/            ← واجهات المستخدم (كل شاشة في مجلد)
│   │   ├─ splash/
│   │   ├─ home/
│   │   ├─ deaf_mode/
│   │   ├─ normal_mode/
│   │   ├─ dictionary/
│   │   ├─ settings/
│   │   └─ history/
│   └─ widgets/            ← Widgets عامة (Buttons, Inputs, Cards …)
│
├─ injection_container/     ← Dependency Injection (لتجميع الـ Cubits والخدمات)
│
└─ main.dart                ← نقطة الدخول الرئيسية للتطبيق
```

---

## 📱 واجهات المستخدم
- **Splash Screen:** فحص الاتصال بالـ ESP32 عند بدء التشغيل.
- **Home Screen:** اختيار وضع المستخدم (سليم / مصاب).
- **Normal Mode:** إدخال نص أو صوت وتحويله إلى حركة ثلاثية الأبعاد.
- **Deaf Mode:** استقبال الكلمة من القفاز عبر Wi-Fi وعرضها كنص وصوت.
- **Dictionary:** استعراض جميع الكلمات المدعومة وتجربة حركاتها.
- **History:** عرض سجل المحادثات السابقة.
- **Settings:** ضبط اللغة، الصوت، الشبكة، والمظهر العام.

## 📱 شاشات التطبيق الأساسية

* شاشة البداية (Splash)
* شاشة تسجيل الدخول
* الشاشة الرئيسية
* شاشة الترجمة من القفاز
* شاشة تحويل الكلام إلى نص
* شاشة الإعدادات

---

## 🛠️ التقنيات المستخدمة

### في العتاد (Hardware):

* Raspberry Pi 4
* Flex Sensors
* MPU6050
* ESP32 أو Wi‑Fi Module

### في البرمجيات (Software):

* Flutter
* Dart
* Hive Database
* Bloc/Cubit
* Socket Communication (TCP/UDP)
* TensorFlow Lite

---

## 📡 طريقة الاتصال بين القفاز والتطبيق

1. القفاز يرسل بيانات الحساسات إلى Raspberry Pi.
2. Raspberry Pi يشغّل نموذج AI ويكتشف الإشارة.
3. يتم إرسال النتيجة إلى تطبيق الهاتف عبر Wi‑Fi باستخدام Socket.
4. التطبيق يعرض الترجمة (نص + صوت).
5. في الاتجاه المعاكس، المستخدم السليم يمكنه إدخال جملة ليتم تحويلها إلى حركة أيضًا.

---

## 💾 قاعدة البيانات Hive
- **Box 1: preferences** → لغة، إعدادات الصوت، عنوان IP.  
- **Box 2: history** → سجل المحادثات (النصوص والتواريخ).  
- **Box 3: dictionary** → الكلمات المدعومة والأنيميشن المقابلة.

---

## ✅ خطوات تشغيل المشروع

### 1. تشغيل خادم Raspberry Pi

```
python3 server.py
```

### 2. تشغيل التطبيق

```
flutter pub get
flutter run
```

---

## 👥 فريق العمل

* مصطفى الأبرقي
* هشام عقلان
* هيثم لمح
* صلاح الدين البعلول
* أحمد الهندي
* زكريا محمد عبداللّه

| الاسم | المهمة |
|-------|---------|
| 👨‍💻 **الزملاء هشام عقلان وهيثم لمح** | تصميم الواجهات، إدارة المشروع، تكامل ESP32 |
| 👩‍💻 **[الزميل مصطفى الأبرقي]** | برمجة Cubit + Hive |
| 👨‍💻 **[الزميل هيثم لمح]** | تطوير خوارزمية ESP32 ومعالجة البيانات |
| 👩‍💻 **[الزملاء مصطفى الأبرقي وهشام عقلان]** | تصميم الحركات في Blender وتصدير ملف GLB |
| 👨‍💻 **[الزميل هشام عقلان ]** | الاختبار والتوثيق الفني |

---

## 🎯 أهداف المشروع

* مساعدة الصم والبكم على التواصل بسهولة.
* دمج AI مع IoT في مشروع واقعي.
* بناء نظام متكامل Hardware + Software.
* توفير تجربة تواصل إنسانية مباشرة وفعّالة.

---

## 🧩 مميزات النظام
- 🔁 **اتصال ثنائي الاتجاه:** من القفاز إلى التطبيق، ومن النص/الصوت إلى الحركة.
- ⚡ **Wi-Fi Communication:** الاتصال بين القفاز والتطبيق يتم عبر شبكة Wi-Fi (بدون إنترنت).
- 🎙️ **Speech-to-Text / Text-to-Speech:** دعم تحويل الصوت إلى نص والعكس.
- 🖐️ **عرض ثلاثي الأبعاد للحركات (GLB):** باستخدام مكتبة `model_viewer_plus`.
- 💾 **تخزين محلي (Hive):** حفظ سجل المحادثات والتفضيلات والقاموس.
- 🧱 **إدارة حالة احترافية (Cubit):** لضمان الأداء العالي وسهولة الصيانة.
- 🎨 **تصميم Responsive:** يعمل بسلاسة على جميع أحجام الشاشات.

---

## 📝 رخصة الاستخدام

المشروع مفتوح للتطوير للأغراض التعليمية والبحثية.
حقوق النشر © 2025 فريق Speaking Sign .

---

## 💬 للمساهمة

نرحّب بأي مساهمة في تحسين النظام أو إضافة لغات جديدة للترجمة.

---

## 📬 تواصل

لأي استفسارات:
**Email:** [mostafaalabraqi@gmail.com](mailto:mostafaalabraqi@gmail.com)
**Email:** [hishamaqlan@gmail.com](mailto:hishamaqlan@gmail.com)
**Email:** [haithemlamh@gmail.com](mailto:haithemlamh@gmail.com)




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.