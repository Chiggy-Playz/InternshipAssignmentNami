import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE43E3A),
    primary: const Color(0xFFE43E3A),
    tertiary: const Color(0xFFDADADA),
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFFDADADA),
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      side: const WidgetStatePropertyAll(
        BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(
        color: Color(0xFF979797),
        width: 1,
      ),
    ),
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          color: Colors.black,
          width: 1,
        )),
  ),
  menuTheme: const MenuThemeData(
    style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
  ),
  dialogBackgroundColor: Colors.white,
  extensions: [
    CustomColors(
      success: successColor.value,
      successContainer: successColor.light.colorContainer,
    ),
  ],
);

ThemeData updateTextTheme(ThemeData baseTheme) {
  final baseTextTheme = baseTheme.textTheme;

  return baseTheme.copyWith(
    textTheme: GoogleFonts.inriaSansTextTheme(lightTheme.textTheme).copyWith(
      headlineLarge: baseTextTheme.headlineLarge!.copyWith(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.bold,
      ),
      titleLarge: baseTextTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleMedium: baseTextTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      titleSmall: baseTextTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      labelLarge: baseTextTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      labelMedium: baseTextTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      labelSmall: baseTextTheme.labelSmall!.copyWith(
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? successContainer;

  const CustomColors({required this.success, required this.successContainer});

  @override
  CustomColors copyWith({
    Color? success,
    Color? successContainer,
  }) {
    return CustomColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      covariant ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
    );
  }
}

const successColor = ExtendedColor(
  seed: Color(0xff129c07),
  value: Color(0xff129c07),
  light: ColorFamily(
    color: Color(0xff406836),
    onColor: Color(0xffffffff),
    colorContainer: Color(0xFFCDFFCC),
    onColorContainer: Color(0xff012200),
  ),
  lightMediumContrast: ColorFamily(
    color: Color(0xff406836),
    onColor: Color(0xffffffff),
    colorContainer: Color(0xffc0efaf),
    onColorContainer: Color(0xff012200),
  ),
  lightHighContrast: ColorFamily(
    color: Color(0xff406836),
    onColor: Color(0xffffffff),
    colorContainer: Color(0xffc0efaf),
    onColorContainer: Color(0xff012200),
  ),
  dark: ColorFamily(
    color: Color(0xffa5d395),
    onColor: Color(0xff11380b),
    colorContainer: Color(0xff295020),
    onColorContainer: Color(0xffc0efaf),
  ),
  darkMediumContrast: ColorFamily(
    color: Color(0xffa5d395),
    onColor: Color(0xff11380b),
    colorContainer: Color(0xff295020),
    onColorContainer: Color(0xffc0efaf),
  ),
  darkHighContrast: ColorFamily(
    color: Color(0xffa5d395),
    onColor: Color(0xff11380b),
    colorContainer: Color(0xff295020),
    onColorContainer: Color(0xffc0efaf),
  ),
);

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
