// no controller
import 'package:flutter/material.dart';

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final headerHeight = (screenHeight * 0.22).clamp(140.0, 220.0);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff8B3DFF), Color(0xff8B3DFF)],
        ),
      ),
      width: double.infinity,
      height: headerHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final iconSize = (h * 0.16).clamp(20.0, 30.0);

          return Stack(
            children: [
              Positioned(
                top: h * 0.17,
                left: w * 0.1,
                child: Icon(Icons.back_hand, size: iconSize, color: Colors.white30),
              ),
              Positioned(
                top: h * 0.5,
                left: w * 0.08,
                child: Icon(Icons.spa_outlined, size: iconSize, color: Colors.white30),
              ),
              Positioned(
                top: h * 0.36,
                left: w * 0.3,
                child: Icon(
                  Icons.spatial_audio_off_rounded,
                  size: iconSize,
                  color: Colors.white30,
                ),
              ),
              Positioned(
                top: h * 0.11,
                right: w * 0.35,
                child: Icon(Icons.star, size: iconSize * 0.85, color: Colors.white30),
              ),
              Positioned(
                top: h * 0.33,
                right: w * 0.28,
                child: Icon(
                  Icons.hearing_outlined,
                  size: iconSize * 1.07,
                  color: Colors.white30,
                ),
              ),
              Positioned(
                top: h * 0.19,
                right: w * 0.1,
                child: Icon(Icons.back_hand, size: iconSize, color: Colors.white30),
              ),
              Positioned(
                top: h * 0.11,
                left: w * 0.33,
                child: Icon(Icons.spa_outlined, size: iconSize, color: Colors.white30),
              ),
              Positioned(
                top: h * 0.44,
                right: w * 0.16,
                child: Icon(
                  Icons.spatial_audio_off_rounded,
                  size: iconSize,
                  color: Colors.white30,
                ),
              ),
              Positioned(
                top: h * 0.67,
                right: w * 0.43,
                child: Icon(Icons.star, size: iconSize * 0.85, color: Colors.white30),
              ),
              Positioned(
                top: h * 0.67,
                left: w * 0.23,
                child: Icon(
                  Icons.hearing_outlined,
                  size: iconSize * 1.07,
                  color: Colors.white30,
                ),
              ),
              Positioned(
                top: h * 0.72,
                right: w * 0.18,
                child: Icon(Icons.spa_outlined, size: iconSize, color: Colors.white30),
              ),
            ],
          );
        },
      ),
    );
  }
}
