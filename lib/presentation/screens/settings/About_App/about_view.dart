import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/settings/about_app/about_controller.dart';

class AboutView extends StatelessWidget {
  AboutView({Key? key}) : super(key: key);
  final AboutController controller = Get.find<AboutController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  right: screenWidth * 0.05,
                  left: screenWidth * 0.025,
                  bottom: 24,
                  top: 24,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff8B3DFF),
                      Color.fromARGB(255, 174, 143, 220),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "SpeakingSing 🤟",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "منصة ذكية متكاملة تُسهّل التواصل بلغة الإشارة .",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: IconButton(
                        onPressed: () {
                          controller.navigateToSetting();
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff8B3DFF),
                              Color.fromARGB(255, 174, 143, 220),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.flag, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "رسالة التطبيق",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "نسعى في SpeakingSing إلى تمكين الصم والبكم من التواصل بسهولة وفاعلية "
                              "من خلال توفير ترجمة ذكية للغة الإشارة، وقاموس متكامل، "
                              "وأدوات تعليمية تفاعلية باستخدام أحدث التقنيات.",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Colors.white,

                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "مميـــزات التطبيق :",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: Colors.white,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      buildFeatureCard(
                        icon: Icons.accessibility_new,
                        title: "الشخصية ثلاثية الأبعاد",

                        subtitle:
                            "شخصية ثلاثية الأبعاد تفاعلية تجسّد لغة الإشارة بحركات واقعية ودقيقة، لتجعل الترجمة والتعلم تجربة حيوية وسهلة للجميع.",
                      ),

                      buildFeatureCard(
                        icon: Icons.menu_book_rounded,
                        title: "القاموس المتكامل",
                        subtitle:
                            "قاموس متكامل يجمع إشارات لغة الإشارة بطريقة منظمة وسهلة الاستخدام، ليكون دليلك الدائم للتعلم والتواصل بثقة.",
                      ),

                      buildFeatureCard(
                        icon: Icons.favorite,
                        title: "المفضلة",
                        subtitle:
                            "تمنحك القدرة على تحديد وحفظ الإشارات والكلمات المهمة، لتصل إليها بسرعة وتبني تجربة استخدام مخصصة وسلسة.",
                      ),

                      buildFeatureCard(
                        icon: Icons.camera_alt,
                        title: "التعليم عبر الكاميرا",
                        subtitle:
                            "توفّر تجربة تدريب تفاعلية، حيث يتم تحليل حركاتك وتصحيحها فورًا لمساعدتك على إتقان لغة الإشارة باحترافية.",
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Color(0xff8B3DFF).withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff8B3DFF), Color.fromARGB(255, 174, 143, 220)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xffffffff), size: 26),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
