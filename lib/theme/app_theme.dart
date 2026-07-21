import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotiflac_android/models/theme_settings.dart';

class AppTheme {
  static const Color defaultSeedColor = Color(kDefaultSeedColor);
  static const BorderRadius _cardRadius = BorderRadius.all(Radius.circular(28));
  static const BorderRadius _chipRadius = BorderRadius.all(Radius.circular(999));

  // Override Flutter's default page transitions.
  static const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    },
  );

  static ThemeData light({ColorScheme? dynamicScheme, Color? seedColor}) {
    final scheme =
        dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: seedColor ?? defaultSeedColor,
          brightness: Brightness.light,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      pageTransitionsTheme: _pageTransitionsTheme,
      appBarTheme: _appBarTheme(scheme),
      cardTheme: _cardTheme(scheme, Brightness.light),
      elevatedButtonTheme: _elevatedButtonTheme(scheme),
      filledButtonTheme: _filledButtonTheme(scheme),
      outlinedButtonTheme: _outlinedButtonTheme(scheme),
      textButtonTheme: _textButtonTheme(scheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      inputDecorationTheme: _inputDecorationTheme(scheme),
      listTileTheme: _listTileTheme(scheme),
      dialogTheme: _dialogTheme(scheme),
      bottomSheetTheme: _bottomSheetTheme(scheme),
      popupMenuTheme: _popupMenuTheme(scheme),
      navigationBarTheme: _navigationBarTheme(scheme),
      snackBarTheme: _snackBarTheme(scheme),
      progressIndicatorTheme: _progressIndicatorTheme(scheme),
      switchTheme: _switchTheme(scheme),
      chipTheme: _chipTheme(scheme),
      dividerTheme: _dividerTheme(scheme),
      tooltipTheme: _tooltipTheme(scheme),
      fontFamily: 'Google Sans Flex',
      visualDensity: VisualDensity.standard,
    );
  }

  static ThemeData dark({
    ColorScheme? dynamicScheme,
    Color? seedColor,
    bool isAmoled = false,
  }) {
    final scheme =
        dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: seedColor ?? defaultSeedColor,
          brightness: Brightness.dark,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      pageTransitionsTheme: _pageTransitionsTheme,
      appBarTheme: _appBarTheme(scheme, isAmoled: isAmoled),
      cardTheme: _cardTheme(scheme, Brightness.dark),
      elevatedButtonTheme: _elevatedButtonTheme(scheme),
      filledButtonTheme: _filledButtonTheme(scheme),
      outlinedButtonTheme: _outlinedButtonTheme(scheme),
      textButtonTheme: _textButtonTheme(scheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      inputDecorationTheme: _inputDecorationTheme(scheme),
      listTileTheme: _listTileTheme(scheme),
      dialogTheme: _dialogTheme(scheme),
      bottomSheetTheme: _bottomSheetTheme(scheme),
      popupMenuTheme: _popupMenuTheme(scheme),
      navigationBarTheme: _navigationBarTheme(
        scheme,
        isAmoled: isAmoled,
      ),
      snackBarTheme: _snackBarTheme(scheme),
      progressIndicatorTheme: _progressIndicatorTheme(scheme),
      switchTheme: _switchTheme(scheme),
      chipTheme: _chipTheme(scheme),
      dividerTheme: _dividerTheme(scheme),
      tooltipTheme: _tooltipTheme(scheme),
      fontFamily: 'Google Sans Flex',
      visualDensity: VisualDensity.standard,
    );
  }

  static AppBarTheme _appBarTheme(
    ColorScheme scheme, {
    bool isAmoled = false,
  }) =>
      AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleSpacing: 16,
        iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        actionsIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: scheme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarColor: isAmoled
              ? Colors.black
              : scheme.surface.withValues(alpha: 0.92),
          systemNavigationBarIconBrightness:
              scheme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      );

  static CardThemeData _cardTheme(ColorScheme scheme, Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Color.alphaBlend(
            Colors.white.withValues(alpha: 0.06),
            scheme.surface,
          )
        : Color.alphaBlend(
            Colors.black.withValues(alpha: 0.03),
            scheme.surface,
          );
    return CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: _cardRadius),
      color: base,
      surfaceTintColor: Colors.transparent,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme scheme) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: _chipRadius),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        ),
      );

  static FilledButtonThemeData _filledButtonTheme(ColorScheme scheme) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: _chipRadius),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme scheme) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _chipRadius),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme scheme) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _chipRadius),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );

  static FloatingActionButtonThemeData _fabTheme(ColorScheme scheme) =>
      FloatingActionButtonThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: _chipRadius),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme scheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.7), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      );

  static ListTileThemeData _listTileTheme(ColorScheme scheme) =>
      ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
      );

  static DialogThemeData _dialogTheme(ColorScheme scheme) => DialogThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    backgroundColor: scheme.surface.withValues(alpha: 0.92),
    surfaceTintColor: Colors.transparent,
  );

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme scheme) =>
      BottomSheetThemeData(
        backgroundColor: scheme.surface.withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface.withValues(alpha: 0.92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        clipBehavior: Clip.antiAlias,
      );

  static PopupMenuThemeData _popupMenuTheme(ColorScheme scheme) =>
      PopupMenuThemeData(
        color: scheme.surface.withValues(alpha: 0.94),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      );

  static NavigationBarThemeData _navigationBarTheme(
    ColorScheme scheme, {
    bool isAmoled = false,
  }) =>
      NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          );
        }),
      );

  static SnackBarThemeData _snackBarTheme(ColorScheme scheme) =>
      SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: scheme.inverseSurface.withValues(alpha: 0.94),
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      );

  static ProgressIndicatorThemeData _progressIndicatorTheme(
    ColorScheme scheme,
  ) => ProgressIndicatorThemeData(
    color: scheme.primary,
    linearTrackColor: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
    circularTrackColor: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
  );

  static SwitchThemeData _switchTheme(ColorScheme scheme) => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return scheme.onPrimary;
      }
      return scheme.outline;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return scheme.primary;
      }
      return scheme.surfaceContainerHighest;
    }),
    thumbIcon: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Icon(Icons.check, color: scheme.primary);
      }
      return null;
    }),
  );

  static ChipThemeData _chipTheme(ColorScheme scheme) => ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: _chipRadius),
    side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.34)),
    backgroundColor: scheme.surfaceContainerLow.withValues(alpha: 0.62),
    selectedColor: scheme.primary.withValues(alpha: 0.20),
    labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    elevation: 0,
    pressElevation: 0,
  );

  static DividerThemeData _dividerTheme(ColorScheme scheme) =>
      DividerThemeData(color: scheme.outlineVariant.withValues(alpha: 0.18), thickness: 1, space: 1);

  static TooltipThemeData _tooltipTheme(ColorScheme scheme) => TooltipThemeData(
    decoration: BoxDecoration(
      color: scheme.inverseSurface.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: TextStyle(color: scheme.onInverseSurface),
  );
}
