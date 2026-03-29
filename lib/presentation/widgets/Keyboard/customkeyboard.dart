import 'package:flutter/material.dart';
import 'package:speaking_sign/config/theme/app_colors.dart';

class KeyboardButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;
  final bool isSpecial;

  const KeyboardButton({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.onPressed,
    this.isSpecial = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: isSpecial ? Colors.grey[300] : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath.isNotEmpty)
                  Image.asset(
                    imagePath,
                    height: 28,
                    width: 28,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 30);
                    },
                  ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
                    color: isSpecial ? Colors.black : Colors.grey[700],
                    fontFamily: "Cairo",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
