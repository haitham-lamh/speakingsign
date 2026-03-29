import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:speaking_sign/controller/settings/camera/camera_controller.dart';
import 'package:speaking_sign/controller/settings/conction_theglavs/conctionthglovs_controller.dart';

class Camera extends StatelessWidget {
  Camera({super.key});
  final CameraController controller = Get.put(
    CameraController(),
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
              padding: EdgeInsets.only(
                right: MediaQuery.sizeOf(context).width * 0.05,
                left: MediaQuery.sizeOf(context).width * 0.025,
                bottom: 24,
                top: MediaQuery.paddingOf(context).top + 10,
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
                  Flexible(
                    child: Text(
                      "كاميرا التدريب",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: (MediaQuery.sizeOf(context).width * 0.06).clamp(18.0, 28.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
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
