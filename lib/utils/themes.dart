import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const scaffoldLight = Colors.white;
  static const scaffoldDark = Colors.black;
  static const textLight = Colors.black;
  static const textDark = Colors.white;
  //colors
  static const featuredLight = Color(0xFFFFB3C6);
  static const featuredDark = Color(0xFFD48296);

  static const catLight = Color(0xFFB8E0D2);
  static const catDark = Color(0xFF76AFA1);

  static const likeLight = Color(0xFFFFC09F);
  static const likeDark = Color(0xFFCC7E64);

  static const setLight = Color(0xFFFFEE93);
  static const setDark = Color(0xFFCCBB64);
}

abstract class LightColors {
  static const scafColor = AppColors.scaffoldLight;
  static const textColor = AppColors.textLight;
  static const featuredColor = AppColors.featuredLight;
  static const catColor = AppColors.catLight;
  static const likeColor = AppColors.likeLight;
  static const setColor = AppColors.setLight;
}

abstract class DarkColors {
  static const scafColor = AppColors.scaffoldDark;
  static const textColor = AppColors.textDark;
  static const featuredColor = AppColors.featuredDark;
  static const catColor = AppColors.catDark;
  static const likeColor = AppColors.likeDark;
  static const setColor = AppColors.setDark;
}

abstract class AppTheme {
  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: const Color(0xFFD8571C),
      useMaterial3: true,
      textTheme: GoogleFonts.karlaTextTheme());
  static ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFFD8571C),
      useMaterial3: true,
      textTheme: GoogleFonts.karlaTextTheme());
}

class AppThemeChange with ChangeNotifier {
  static bool isDark = true;

  ThemeMode currentTheme() {
    return !isDark ? ThemeMode.light : ThemeMode.dark;
  }

  void switchTheme() {
    if (isDark) {
      isDark = false;
    } else {
      isDark = true;
    }
    notifyListeners();
  }
}
