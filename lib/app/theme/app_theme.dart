import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Design system Sertech : un seul point d'entrée pour les deux thèmes.
///
/// Tous les écrans consomment ces thèmes. Aucune couleur, graisse ou taille
/// n'est redéfinie localement sans passer par les tokens de `app_theme/`.
class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() => _build(_Tokens.light);

  static ThemeData darkTheme() => _build(_Tokens.dark);

  static ThemeData _build(_Tokens t) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: t.primary,
          brightness: t.brightness,
        ).copyWith(
          primary: t.primary,
          onPrimary: t.onPrimary,
          primaryContainer: t.primaryLight,
          onPrimaryContainer: t.onPrimaryContainer,
          secondary: t.water,
          onSecondary: t.onWater,
          secondaryContainer: t.waterContainer,
          onSecondaryContainer: t.onWaterContainer,
          tertiary: t.teal,
          onTertiary: t.onTeal,
          surface: t.surface,
          onSurface: t.textPrimary,
          surfaceContainerLowest: t.surface,
          surfaceContainerLow: t.surface,
          surfaceContainer: t.surfaceAlt,
          surfaceContainerHigh: t.surfaceAlt,
          surfaceContainerHighest: t.surfaceAlt,
          onSurfaceVariant: t.textSecondary,
          outline: t.border,
          outlineVariant: t.border,
          error: t.error,
          onError: t.onError,
          errorContainer: t.errorContainer,
          onErrorContainer: t.onErrorContainer,
          inverseSurface: t.textPrimary,
          onInverseSurface: t.surface,
          inversePrimary: t.primaryLight,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: scheme,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: t.background,
      canvasColor: t.background,
      textTheme: t.brightness == Brightness.light
          ? AppTypography.lightTextTheme()
          : AppTypography.darkTextTheme(),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      applyElevationOverlayColor: false,
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: t.surface,
        foregroundColor: t.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        iconTheme: IconThemeData(color: t.textPrimary, size: 24),
        actionsIconTheme: IconThemeData(color: t.textSecondary, size: 24),
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.titleSize,
          fontWeight: FontWeight.w600,
          height: 1.16,
          letterSpacing: -0.6,
          color: t.textPrimary,
        ),
        systemOverlayStyle: t.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: t.primary.withValues(alpha: t.isDark ? 0.2 : 0.12),
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? t.navigationSelected : t.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: 'Manrope',
            fontSize: AppTypography.captionSize,
            height: 1.2,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? t.navigationSelected : t.textSecondary,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: t.shadow,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: t.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: t.divider, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: t.surfaceAlt,
        selectedColor: t.primary.withValues(alpha: t.isDark ? 0.2 : 0.12),
        disabledColor: t.surfaceAlt,
        side: BorderSide(color: t.border),
        labelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.captionSize,
          fontWeight: FontWeight.w600,
          color: t.textPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.captionSize,
          fontWeight: FontWeight.w600,
          color: t.primary,
        ),
        checkmarkColor: t.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: t.navigationSelected,
        unselectedLabelColor: t.textSecondary,
        indicatorColor: t.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: t.border,
        labelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.bodySize,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.bodySize,
          fontWeight: FontWeight.w400,
        ),
        overlayColor: WidgetStatePropertyAll(t.primary.withValues(alpha: 0.08)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.titleSize,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
          color: t.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.bodySize,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: t.textSecondary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: t.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: t.isDark ? t.surfaceAlt : t.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: 'Manrope',
          color: t.isDark ? t.textPrimary : t.surface,
          fontSize: AppTypography.bodySize,
          fontWeight: FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.primary,
        foregroundColor: t.onPrimary,
        elevation: 2,
        focusElevation: 2,
        hoverElevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(color: t.border),
        ),
        textStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.bodySize,
          color: t.textPrimary,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(color: t.border)),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return t.primary.withValues(alpha: t.isDark ? 0.2 : 0.12);
            }
            return t.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return t.navigationSelected;
            }
            return t.textSecondary;
          }),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Manrope',
              fontSize: AppTypography.captionSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s20,
          vertical: AppSpacing.s4,
        ),
        minVerticalPadding: AppSpacing.s8,
        iconColor: t.textSecondary,
        textColor: t.textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.bodySize,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          color: t.textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: AppTypography.captionSize,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: t.textSecondary,
        ),
      ),
      inputDecorationTheme: _inputTheme(t),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.primary,
        selectionColor: t.primary.withValues(alpha: 0.24),
        selectionHandleColor: t.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.primary,
        linearTrackColor: t.primaryLight,
        circularTrackColor: t.primaryLight,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: t.primary,
        inactiveTrackColor: t.primaryLight,
        thumbColor: t.primary,
        overlayColor: t.primary.withValues(alpha: 0.12),
        trackHeight: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.onPrimary;
          return t.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primary;
          return t.surfaceAlt;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.isDark ? t.surfaceAlt : t.textPrimary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        textStyle: TextStyle(
          fontFamily: 'Manrope',
          color: t.isDark ? t.textPrimary : t.surface,
          fontSize: AppTypography.captionSize,
          fontWeight: FontWeight.w400,
        ),
        waitDuration: const Duration(milliseconds: 400),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.navigationSelected,
          minimumSize: const Size(AppSpacing.minTouchTarget, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: AppTypography.bodySize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.textPrimary,
          minimumSize: const Size(AppSpacing.minTouchTarget, 48),
          side: BorderSide(color: t.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: AppTypography.bodySize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: t.onPrimary,
          disabledBackgroundColor: t.surfaceAlt,
          disabledForegroundColor: t.textTertiary,
          minimumSize: const Size(AppSpacing.minTouchTarget, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: AppTypography.bodySize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppSpacing.minTouchTarget,
            AppSpacing.minTouchTarget,
          ),
          foregroundColor: t.textSecondary,
        ),
      ),
      extensions: [t.extension],
    );
  }

  static InputDecorationTheme _inputTheme(_Tokens t) {
    return InputDecorationTheme(
      filled: true,
      fillColor: t.surfaceAlt,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s16,
      ),
      border: _inputBorder(t.border),
      enabledBorder: _inputBorder(t.border),
      focusedBorder: _inputBorder(t.primary, width: 1.6),
      errorBorder: _inputBorder(t.error),
      focusedErrorBorder: _inputBorder(t.error, width: 1.6),
      labelStyle: TextStyle(
        fontFamily: 'Manrope',
        color: t.textSecondary,
        fontSize: AppTypography.bodySize,
      ),
      floatingLabelStyle: TextStyle(
        fontFamily: 'Manrope',
        color: t.primary,
        fontSize: AppTypography.captionSize,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Manrope',
        color: t.textSecondary.withValues(alpha: 0.7),
        fontSize: AppTypography.bodySize,
      ),
      helperStyle: TextStyle(
        fontFamily: 'Manrope',
        color: t.textSecondary,
        fontSize: AppTypography.captionSize,
      ),
      errorStyle: TextStyle(
        fontFamily: 'Manrope',
        color: t.error,
        fontSize: AppTypography.captionSize,
        fontWeight: FontWeight.w600,
      ),
      errorMaxLines: 2,
      prefixIconColor: t.textSecondary,
      suffixIconColor: t.textSecondary,
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// Tokens résolus pour une luminosité donnée.
@immutable
class _Tokens {
  final Brightness brightness;
  final bool isDark;
  final Color primary;
  final Color onPrimary;
  final Color primaryDeep;
  final Color primaryLight;
  final Color onPrimaryContainer;
  final Color water;
  final Color onWater;
  final Color waterContainer;
  final Color onWaterContainer;
  final Color teal;
  final Color onTeal;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color divider;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color shadow;
  final Color navigationSelected;
  final AppThemeExtension extension;

  const _Tokens({
    required this.brightness,
    required this.isDark,
    required this.primary,
    required this.onPrimary,
    required this.primaryDeep,
    required this.primaryLight,
    required this.onPrimaryContainer,
    required this.water,
    required this.onWater,
    required this.waterContainer,
    required this.onWaterContainer,
    required this.teal,
    required this.onTeal,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.divider,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.shadow,
    required this.navigationSelected,
    required this.extension,
  });

  static const light = _Tokens(
    brightness: Brightness.light,
    isDark: false,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryDeep: AppColors.primaryDeep,
    primaryLight: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDeep,
    water: AppColors.water,
    onWater: Colors.white,
    waterContainer: Color(0xFFE3F2FA),
    onWaterContainer: Color(0xFF03405F),
    teal: AppColors.teal,
    onTeal: Colors.white,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceAlt: AppColors.surfaceAlt,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    border: AppColors.border,
    divider: AppColors.divider,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: Color(0xFFFBE9E9),
    onErrorContainer: Color(0xFF6E1B1B),
    shadow: Color(0x1413251A),
    navigationSelected: AppColors.primaryDeep,
    extension: AppThemeExtension(
      brandGlow: Color(0x140A723B),
      waterGlow: Color(0x140173AE),
      glassFill: Color(0xB8FFFFFF),
      glassBorder: Color(0x1A0A723B),
      shadow: Color(0x1413251A),
      demo: AppColors.demo,
      heroStart: AppColors.primaryDeep,
      heroEnd: AppColors.primary,
      heroAccent: AppColors.leaf,
    ),
  );

  static const dark = _Tokens(
    brightness: Brightness.dark,
    isDark: true,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkBackground,
    primaryDeep: AppColors.darkPrimaryDeep,
    primaryLight: AppColors.darkPrimaryLight,
    onPrimaryContainer: AppColors.darkTextPrimary,
    water: AppColors.darkWater,
    onWater: AppColors.darkBackground,
    waterContainer: Color(0xFF0B2A3A),
    onWaterContainer: AppColors.darkWater,
    teal: AppColors.darkTeal,
    onTeal: AppColors.darkBackground,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceAlt: AppColors.darkSurfaceAlt,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    border: AppColors.darkBorder,
    divider: AppColors.darkDivider,
    error: AppColors.darkError,
    onError: AppColors.darkBackground,
    errorContainer: Color(0xFF3A1515),
    onErrorContainer: AppColors.darkError,
    shadow: Color(0x66000000),
    navigationSelected: AppColors.darkPrimary,
    extension: AppThemeExtension(
      brandGlow: Color(0x1F6BD16B),
      waterGlow: Color(0x1F5EC6FF),
      glassFill: Color(0x0EFFFFFF),
      glassBorder: Color(0x17FFFFFF),
      shadow: Color(0x66000000),
      demo: AppColors.darkTeal,
      heroStart: Color(0xFF0B2A1A),
      heroEnd: Color(0xFF0F4A2A),
      heroAccent: AppColors.darkPrimary,
    ),
  );
}

/// Extension de thème : halos, surfaces en verre et dégradés de marque.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color brandGlow;
  final Color waterGlow;
  final Color glassFill;
  final Color glassBorder;
  final Color shadow;
  final Color demo;
  final Color heroStart;
  final Color heroEnd;
  final Color heroAccent;

  const AppThemeExtension({
    required this.brandGlow,
    required this.waterGlow,
    required this.glassFill,
    required this.glassBorder,
    required this.shadow,
    required this.demo,
    required this.heroStart,
    required this.heroEnd,
    required this.heroAccent,
  });

  /// Halo ambiant à poser derrière un écran, sans image ni asset.
  LinearGradient get ambientGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandGlow, Colors.transparent, waterGlow],
    stops: const [0, 0.55, 1],
  );

  /// Dégradé des cartes héro (accueil, authentification).
  LinearGradient get heroGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [heroStart, heroEnd],
  );

  @override
  AppThemeExtension copyWith({
    Color? brandGlow,
    Color? waterGlow,
    Color? glassFill,
    Color? glassBorder,
    Color? shadow,
    Color? demo,
    Color? heroStart,
    Color? heroEnd,
    Color? heroAccent,
  }) {
    return AppThemeExtension(
      brandGlow: brandGlow ?? this.brandGlow,
      waterGlow: waterGlow ?? this.waterGlow,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      shadow: shadow ?? this.shadow,
      demo: demo ?? this.demo,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      heroAccent: heroAccent ?? this.heroAccent,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      brandGlow: Color.lerp(brandGlow, other.brandGlow, t) ?? brandGlow,
      waterGlow: Color.lerp(waterGlow, other.waterGlow, t) ?? waterGlow,
      glassFill: Color.lerp(glassFill, other.glassFill, t) ?? glassFill,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t) ?? glassBorder,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      demo: Color.lerp(demo, other.demo, t) ?? demo,
      heroStart: Color.lerp(heroStart, other.heroStart, t) ?? heroStart,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t) ?? heroEnd,
      heroAccent: Color.lerp(heroAccent, other.heroAccent, t) ?? heroAccent,
    );
  }
}
