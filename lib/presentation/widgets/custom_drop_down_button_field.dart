import 'package:flutter/material.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';

class CustomDropDownButtonField extends StatelessWidget {
  const CustomDropDownButtonField({
    super.key,
    this.category,
    required this.hintText,
    required this.label,
    this.onChanged,
    this.onSaved,
    required this.colors,
  });

  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;

  final Color colors;

  final String? category;

  final String hintText;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonFormField(
              value: category,
              onChanged: onChanged,
              onSaved: onSaved,
              items: const [
                DropdownMenuItem(
                  value: 'الحروف',
                  alignment: Alignment.center,
                  child: Text('الحروف'),
                ),
                DropdownMenuItem(
                  value: 'الأرقام',
                  alignment: Alignment.center,
                  child: Text('الأرقام'),
                ),
                DropdownMenuItem(
                  value: 'الضمائر',
                  alignment: Alignment.center,
                  child: Text('الضمائر'),
                ),
                DropdownMenuItem(
                  value: 'الألوان',
                  alignment: Alignment.center,
                  child: Text('الألوان'),
                ),
                DropdownMenuItem(
                  value: 'العائلة',
                  alignment: Alignment.center,
                  child: Text('العائلة'),
                ),
                DropdownMenuItem(
                  value: 'الأيام',
                  alignment: Alignment.center,
                  child: Text('الأيام'),
                ),
                DropdownMenuItem(
                  value: 'الترحيب',
                  alignment: Alignment.center,
                  child: Text('الترحيب'),
                ),
                DropdownMenuItem(
                  value: 'عامة',
                  alignment: Alignment.center,
                  child: Text('عامة'),
                ),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'يرجى تحديد الفئة';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: colors,
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                hintTextDirection: TextDirection.rtl,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder buildBorder([color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
