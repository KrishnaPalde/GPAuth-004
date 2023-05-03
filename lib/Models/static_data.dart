import 'dart:math';

class StaticData {
  static String username = '';
  static String imageSet = '';
  static List<String> images = [];
  static int otp = 0;
  static void generateOTP() {
    Random r = Random();
    otp = r.nextInt(999999) + 100000;
  }
}
