import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:speaking_sign/controller/settings/conction_theglavs/conctionthglovs_controller.dart';

class Conctiontheglavs extends StatelessWidget {
  Conctiontheglavs({super.key});
  final ConctionthglovsController controller = Get.put(
    ConctionthglovsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                right: 24,
                left: 10,
                bottom: 24,
                top: 40,
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
                children: [
                  const Text(
                    "الاتصال بالقفاز",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.navigateToSetting();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Text("هيثم القفاز "),
            Text("هيثم القفاز "),
            Text("هيثم القفاز "),
            Text("هيثم القفاز "),
            Text("هيثم القفاز "),
            Text("هيثم القفاز "),
          ],
        ),
      ),
    );
  }
}
