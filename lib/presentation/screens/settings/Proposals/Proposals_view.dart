import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speaking_sign/controller/settings/Proposals/proposals_controller.dart';
import 'package:speaking_sign/presentation/widgets/custom_button.dart';
import 'package:speaking_sign/presentation/widgets/custom_text_field.dart';

class ProposalsView extends StatelessWidget {
  ProposalsView({super.key});

  final ProposalsController controller = Get.put(ProposalsController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
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
                      "المقترحـــــات",
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

              const SizedBox(height: 20),

              CustomTextField(
                colors: Colors.white,
                lableText: 'الكلمة عربي',
                hintText: 'إدخل كلمة بالعربي',
                onSaved: (value) {},
                validator: (value) {},
              ),

              CustomTextField(
                colors: Colors.white,
                lableText: 'الفئة',
                hintText: 'إدخل الفئة',
                onSaved: (value) {},
                validator: (value) {},
              ),

              CustomTextField(
                colors: Colors.white,
                lableText: 'شرح الحركة',
                hintText: 'شـــرح الحركة',
                onSaved: (value) {},
                validator: (value) {},
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: 'إضافة الحركة',
                  onTap: () {
                    print("هشام هشام هشام ");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
