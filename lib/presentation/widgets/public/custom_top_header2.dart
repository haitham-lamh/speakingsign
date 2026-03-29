import 'package:flutter/material.dart';

class CustomTopHeader2 extends StatelessWidget {
  final String text;

  const CustomTopHeader2({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final fontSize = (screenWidth * 0.045).clamp(14.0, 20.0);
    
    return Container(
      width: double.infinity,
      height: 60 + MediaQuery.paddingOf(context).top,
      decoration: const BoxDecoration(
        color: Color(0xff8B3DFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.back_hand, color: Colors.white, size: 26),
                  Icon(Icons.spa_outlined, color: Colors.white, size: 26),
                  Icon(Icons.hearing_outlined, color: Colors.white, size: 26),
                  Icon(
                    Icons.spatial_audio_off_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  Icon(Icons.back_hand, color: Colors.white, size: 26),
                  Icon(Icons.spa_outlined, color: Colors.white, size: 26),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.06),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Cairo",
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

