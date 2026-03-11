import 'package:flutter/material.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.colors,
    this.onChanged,
    required this.hintText,
    required this.lableText,
    this.validator,
    this.onSaved,
    this.textcolor = Colors.black,
  });

  final Color colors;
  final Color textcolor;

  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String lableText;
  final String hintText;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            lableText,
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: colors,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              hintText: hintText,
            ),
            onChanged: onChanged,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }
}
