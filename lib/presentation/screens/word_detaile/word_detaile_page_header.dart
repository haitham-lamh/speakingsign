// no controller
import 'package:flutter/material.dart';

class WordDetailePageHeader extends StatelessWidget {
  const WordDetailePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final headerHeight = (screenHeight * 0.4).clamp(250.0, 400.0);
    
    return Container(
      width: double.infinity,
      height: headerHeight,
      decoration: BoxDecoration(
        color: Color(0xff8B3DFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final iconSize = (h * 0.08).clamp(20.0, 30.0);
            
            return Stack(
              children: [
                Positioned(
                  top: h * 0.05,
                  left: w * 0.05,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white30,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: (h * 0.09).clamp(24.0, 34.0),
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: h * 0.28,
                  left: w * 0.1,
                  child: Icon(Icons.back_hand, size: iconSize, color: Colors.white30),
                ),
                Positioned(
                  top: h * 0.47,
                  left: w * 0.08,
                  child: Icon(Icons.spa_outlined, size: iconSize, color: Colors.white30),
                ),
                Positioned(
                  top: h * 0.23,
                  left: w * 0.5,
                  child: Icon(
                    Icons.spatial_audio_off_rounded,
                    size: iconSize,
                    color: Colors.white30,
                  ),
                ),
                Positioned(
                  top: h * 0.17,
                  right: w * 0.28,
                  child: Icon(
                    Icons.hearing_outlined,
                    size: iconSize * 1.07,
                    color: Colors.white30,
                  ),
                ),
                Positioned(
                  top: h * 0.1,
                  right: w * 0.1,
                  child: Icon(Icons.back_hand, size: iconSize, color: Colors.white30),
                ),
                Positioned(
                  bottom: h * 0.4,
                  left: w * 0.35,
                  child: Icon(Icons.back_hand, size: iconSize, color: Colors.white30),
                ),
                Positioned(
                  top: h * 0.13,
                  left: w * 0.33,
                  child: Icon(Icons.spa_outlined, size: iconSize, color: Colors.white30),
                ),
                Positioned(
                  bottom: h * 0.23,
                  left: w * 0.16,
                  child: Icon(
                    Icons.spatial_audio_off_rounded,
                    size: iconSize,
                    color: Colors.white30,
                  ),
                ),
                Positioned(
                  bottom: h * 0.23,
                  right: w * 0.16,
                  child: Icon(
                    Icons.spatial_audio_off_rounded,
                    size: iconSize,
                    color: Colors.white30,
                  ),
                ),
                Positioned(
                  top: h * 0.4,
                  right: w * 0.43,
                  child: Icon(Icons.star, size: iconSize * 0.85, color: Colors.white30),
                ),
                Positioned(
                  top: h * 0.51,
                  right: w * 0.1,
                  child: Icon(Icons.star, size: iconSize * 0.85, color: Colors.white30),
                ),
                Positioned(
                  top: h * 0.34,
                  left: w * 0.3,
                  child: Icon(
                    Icons.hearing_outlined,
                    size: iconSize * 1.07,
                    color: Colors.white30,
                  ),
                ),
                Positioned(
                  bottom: h * 0.4,
                  right: w * 0.28,
                  child: Icon(
                    Icons.hearing_outlined,
                    size: iconSize * 1.07,
                    color: Colors.white30,
                  ),
                ),
                Positioned(
                  top: h * 0.37,
                  right: w * 0.18,
                  child: Icon(Icons.spa_outlined, size: iconSize, color: Colors.white30),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

