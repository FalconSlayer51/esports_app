import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff316a42),
      surfaceTint: Color(0xff316a42),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb3f1be),
      onPrimaryContainer: Color(0xff00210c),
      secondary: Color(0xff506352),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd2e8d3),
      onSecondaryContainer: Color(0xff0e1f12),
      tertiary: Color(0xff3a656e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbdeaf5),
      onTertiaryContainer: Color(0xff001f25),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff414941),
      outline: Color(0xff717971),
      outlineVariant: Color(0xffc1c9bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322d),
      inversePrimary: Color(0xff98d5a4),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff00210c),
      primaryFixedDim: Color(0xff98d5a4),
      onPrimaryFixedVariant: Color(0xff16512c),
      secondaryFixed: Color(0xffd2e8d3),
      onSecondaryFixed: Color(0xff0e1f12),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff394b3b),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xffa2ced9),
      onTertiaryFixedVariant: Color(0xff204d56),
      surfaceDim: Color(0xffd7dbd4),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae2),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff114d28),
      surfaceTint: Color(0xff316a42),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff478056),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff354738),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff667a68),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b4952),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff507b85),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff3d453d),
      outline: Color(0xff596159),
      outlineVariant: Color(0xff757d74),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322d),
      inversePrimary: Color(0xff98d5a4),
      primaryFixed: Color(0xff478056),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2e6740),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff667a68),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4d6150),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff507b85),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff37626c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd4),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae2),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002910),
      surfaceTint: Color(0xff316a42),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff114d28),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff142618),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff354738),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00262d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1b4952),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1e261f),
      outline: Color(0xff3d453d),
      outlineVariant: Color(0xff3d453d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322d),
      inversePrimary: Color(0xffbdfbc8),
      primaryFixed: Color(0xff114d28),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003517),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff354738),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1f3123),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1b4952),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00323a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd4),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae2),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff98d5a4),
      surfaceTint: Color(0xff98d5a4),
      onPrimary: Color(0xff003919),
      primaryContainer: Color(0xff16512c),
      onPrimaryContainer: Color(0xffb3f1be),
      secondary: Color(0xffb7ccb7),
      onSecondary: Color(0xff223426),
      secondaryContainer: Color(0xff394b3b),
      onSecondaryContainer: Color(0xffd2e8d3),
      tertiary: Color(0xffa2ced9),
      onTertiary: Color(0xff01363f),
      tertiaryContainer: Color(0xff204d56),
      onTertiaryContainer: Color(0xffbdeaf5),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101510),
      onSurface: Color(0xffdfe4dc),
      onSurfaceVariant: Color(0xffc1c9bf),
      outline: Color(0xff8b938a),
      outlineVariant: Color(0xff414941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff316a42),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff00210c),
      primaryFixedDim: Color(0xff98d5a4),
      onPrimaryFixedVariant: Color(0xff16512c),
      secondaryFixed: Color(0xffd2e8d3),
      onSecondaryFixed: Color(0xff0e1f12),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff394b3b),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xffa2ced9),
      onTertiaryFixedVariant: Color(0xff204d56),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9cd9a8),
      surfaceTint: Color(0xff98d5a4),
      onPrimary: Color(0xff001b09),
      primaryContainer: Color(0xff639d71),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbbd0bc),
      onSecondary: Color(0xff081a0d),
      secondaryContainer: Color(0xff819683),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa6d2dd),
      onTertiary: Color(0xff00191f),
      tertiaryContainer: Color(0xff6d97a2),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xfff8fcf4),
      onSurfaceVariant: Color(0xffc5cdc3),
      outline: Color(0xff9da59c),
      outlineVariant: Color(0xff7d857c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff17522d),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff001506),
      primaryFixedDim: Color(0xff98d5a4),
      onPrimaryFixedVariant: Color(0xff003f1d),
      secondaryFixed: Color(0xffd2e8d3),
      onSecondaryFixed: Color(0xff041508),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff283a2c),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff001418),
      tertiaryFixedDim: Color(0xffa2ced9),
      onTertiaryFixedVariant: Color(0xff0a3c45),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffefffee),
      surfaceTint: Color(0xff98d5a4),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff9cd9a8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffefffee),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbbd0bc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3fcff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa6d2dd),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff5fdf2),
      outline: Color(0xffc5cdc3),
      outlineVariant: Color(0xffc5cdc3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff003215),
      primaryFixed: Color(0xffb7f6c3),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff9cd9a8),
      onPrimaryFixedVariant: Color(0xff001b09),
      secondaryFixed: Color(0xffd7edd7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbbd0bc),
      onSecondaryFixedVariant: Color(0xff081a0d),
      tertiaryFixed: Color(0xffc2eefa),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa6d2dd),
      onTertiaryFixedVariant: Color(0xff00191f),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

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
