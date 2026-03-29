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
          child: SingleChildScrollView(
            child: Column(
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
                          "إرسال مقترح",
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

                const SizedBox(height: 30),



                // Title Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: controller.titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان المقترح',
                      hintText: 'اكتب عنواناً مختصراً',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xff8B3DFF), width: 2),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),

                // Suggestion Body Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: controller.suggestionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'تفاصيل المقترح',
                      hintText: 'اكتب مقترحك أو النقد البناء هنا...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xff8B3DFF), width: 2),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),

                const SizedBox(height: 32),

                // Send Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: Color(0xff8B3DFF)))
                      : CustomButton(
                          text: 'إرسال المقترح',
                          onTap: () {
                            controller.sendSuggestion(context);
                          },
                        )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
