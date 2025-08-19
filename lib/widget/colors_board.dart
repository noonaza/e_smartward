import 'package:flutter/material.dart';
enum PetStatus { critical, observe, stable } // เหลือง, ฟ้า, เขียว

// map สถานะ -> สีการ์ดเดิม
ColorTone toneOfStatus(PetStatus s) => switch (s) {
  PetStatus.critical => ColorTone.yellow,
  PetStatus.observe  => ColorTone.blue,
  PetStatus.stable   => ColorTone.green,
};

enum ColorTone { yellow, blue, green }

class BedColors {

  static Color borderOf(ColorTone tone) {
    switch (tone) {
      case ColorTone.yellow:
        return const Color.fromARGB(255, 224, 221, 33);
      case ColorTone.blue:
        return const Color.fromARGB(255, 64, 163, 179);
      case ColorTone.green:
              return const Color.fromARGB(255, 63, 189, 59);
    }
  }


  static LinearGradient gradientOf(ColorTone tone) {
    switch (tone) {
      case ColorTone.yellow:
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 228, 228, 41),
            Color.fromARGB(255, 255, 255, 180),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case ColorTone.blue:
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 102, 208, 225),
            Color.fromARGB(255, 200, 245, 255),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case ColorTone.green:
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 136, 244, 133),
            Color.fromARGB(255, 210, 255, 210),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
    }
  }

  
  static Color bgOf(ColorTone tone) {
    switch (tone) {
      case ColorTone.yellow:
        return const Color.fromARGB(255, 228, 228, 41);
      case ColorTone.blue:
        return const Color.fromARGB(255, 117, 222, 239);
      case ColorTone.green:
        return const Color.fromARGB(255, 136, 244, 133);
    }
  }

  static Color bgPtOf(ColorTone tone) {
    switch (tone) {
      case ColorTone.yellow:
        return const Color(0xFFFFF3B5);
      case ColorTone.blue:
        return const Color(0xFFCFEFF4);
      case ColorTone.green:
        return const Color(0xFFCFEFCE);
    }
  }
}
