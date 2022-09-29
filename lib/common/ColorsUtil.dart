import 'dart:ui' show Color;
class ColorsUtil {
  /// Hex color ,
  /// hex, Hexadecimal value , for example ：0xffffff,
  /// alpha, transparency [0.0,1.0]
  static Color hexToColor(String s) {
// If the hexadecimal color value passed in does not meet the requirements , Return default
    if (s == null || s.length != 7 ||
        int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }


}