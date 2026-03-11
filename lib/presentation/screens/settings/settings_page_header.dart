// no controller
import 'package:flutter/material.dart';

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff8B3DFF), Color(0xff8B3DFF)],
        ),
      ),
      width: double.infinity,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 40,
            child: Icon(Icons.back_hand, size: 28, color: Colors.white30),
          ),
          Positioned(
            top: 90,
            left: 30,
            child: Icon(Icons.spa_outlined, size: 28, color: Colors.white30),
          ),
          Positioned(
            top: 65,
            left: 120,
            child: Icon(
              Icons.spatial_audio_off_rounded,
              size: 28,
              color: Colors.white30,
            ),
          ),
          Positioned(
            top: 20,
            right: 140,
            child: Icon(Icons.star, size: 24, color: Colors.white30),
          ),
          Positioned(
            top: 60,
            right: 110,
            child: Icon(
              Icons.hearing_outlined,
              size: 30,
              color: Colors.white30,
            ),
          ),
          Positioned(
            top: 35,
            right: 40,
            child: Icon(Icons.back_hand, size: 28, color: Colors.white30),
          ),
          Positioned(
            top: 20,
            left: 130,
            child: Icon(Icons.spa_outlined, size: 28, color: Colors.white30),
          ),
          Positioned(
            top: 80,
            right: 65,
            child: Icon(
              Icons.spatial_audio_off_rounded,
              size: 28,
              color: Colors.white30,
            ),
          ),
          Positioned(
            top: 120,
            right: 170,
            child: Icon(Icons.star, size: 24, color: Colors.white30),
          ),
          Positioned(
            top: 120,
            left: 90,
            child: Icon(
              Icons.hearing_outlined,
              size: 30,
              color: Colors.white30,
            ),
          ),
          Positioned(
            top: 130,
            right: 70,
            child: Icon(Icons.spa_outlined, size: 28, color: Colors.white30),
          ),
        ],
      ),
    );
  }
}
