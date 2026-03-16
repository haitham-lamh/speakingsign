import 'package:flutter/material.dart';

class CustomTopHeader extends StatelessWidget {
  const CustomTopHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: (MediaQuery.sizeOf(context).height * 0.22).clamp(180.0, 250.0).toDouble() + MediaQuery.paddingOf(context).top,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff8B3DFF),
              Color(0xff9d4edd),
            ],
          ),
        ),

        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: h * 0.16,
                    left: w * 0.1,
                    child: const Icon(Icons.back_hand, size: 28, color: Colors.white30),
                  ),
                  Positioned(
                    top: h * 0.63,
                    left: w * 0.08,
                    child: const Icon(Icons.spa_outlined, size: 28, color: Colors.white30),
                  ),
                  Positioned(
                    top: h * 0.3,
                    left: w * 0.3,
                    child: const Icon(
                      Icons.spatial_audio_off_rounded,
                      size: 28,
                      color: Colors.white30,
                    ),
                  ),
                  Positioned(
                    top: h * 0.22,
                    right: w * 0.45,
                    child: const Icon(Icons.star, size: 24, color: Colors.white30),
                  ),
                  Positioned(
                    top: h * 0.33,
                    right: w * 0.27,
                    child: const Icon(
                      Icons.hearing_outlined,
                      size: 30,
                      color: Colors.white30,
                    ),
                  ),

                  // ------- العنوان ---------
                  Positioned(
                    left: w * 0.04,
                    top: h * 0.4,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // ------- زر البحث ---------
                  /*
                  عند الضرورة فقط
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0xff8B3DFF),
                        radius: 26,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              size: 32,
                              color: Color(0xff8B3DFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
