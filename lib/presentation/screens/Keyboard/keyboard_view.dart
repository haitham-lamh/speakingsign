import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';
import 'package:speaking_sign/controller/keyboard/keboard_controller.dart';
import 'package:speaking_sign/data/static/static.dart';
import 'package:speaking_sign/presentation/widgets/Keyboard/customkeyboard.dart';
import 'package:speaking_sign/presentation/widgets/public/custom_top_header2.dart';

class Keyboard extends StatelessWidget {
  Keyboard({Key? key}) : super(key: key);

  final KeyboardController controller = Get.find<KeyboardController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        children: [
          CustomTopHeader2(text: "لوحة المفاتيح الإشارية"),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Obx(
                          () => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              controller.displayText.value,
                              style: const TextStyle(
                                fontFamily: "Cairo",
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        ": النــص",
                        style: TextStyle(
                          fontFamily: "Cairo",
                          color: Colors.purple,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //خطط افقي
                Divider(
                  color: Colors.black.withOpacity(0.2),
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple.shade300, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: (screenHeight * 0.1).clamp(60.0, 100.0),
                  child: Obx(
                    () => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.inputSigns.length,
                      itemBuilder: (context, index) {
                        final sign = controller.inputSigns[index];

                        if (sign.char == " ") {
                          return const SizedBox(width: 20);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Image.asset(sign.assetpath!, height: 70),
                        );
                      },
                    ),
                  ),
                ),

                // الكيبورد
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      children: [
                        ...keboardlist.map((row) {
                          return Expanded(
                            child: Row(
                              children:
                                  row.map((sign) {
                                    return KeyboardButton(
                                      label: sign.char!,
                                      imagePath: sign.assetpath!,
                                      onPressed: () => controller.addSign(sign),
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
                              // مسح
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: controller.deleteLast,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        181,
                                        115,
                                        115,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'مســح',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // مسافة
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: controller.addSpace,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'مسافـــة',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // اذهب
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: controller.submitText,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        203,
                                        168,
                                        254,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'اذهـــب',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: "Cairo",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
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
