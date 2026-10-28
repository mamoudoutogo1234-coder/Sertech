import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sertech/app/theme/app_colors.dart';
import 'package:sertech/app/theme/app_spacing.dart';
import 'package:sertech/app/theme/app_theme.dart';
import 'package:sertech/app/theme/app_typography.dart';

void main() {
  group('Design system', () {
    test('palette is derived from the logo', () {
      expect(AppColors.primary, const Color(0xFF0A723B));
      expect(AppColors.primaryDeep, const Color(0xFF044B2D));
      expect(AppColors.leaf, const Color(0xFF4EB427));
      expect(AppColors.water, const Color(0xFF0173AE));
      expect(AppColors.teal, const Color(0xFF0A868D));
      expect(AppColors.background, const Color(0xFFF7FAF5));
      expect(AppColors.darkBackground, const Color(0xFF07110C));
    });

    test('typography holds in four sizes and two weights', () {
      expect(AppTypography.scale, [48.0, 24.0, 16.0, 12.0]);

      for (final theme in [AppTheme.lightTheme(), AppTheme.darkTheme()]) {
        final styles = [
          theme.textTheme.displayLarge,
          theme.textTheme.headlineLarge,
          theme.textTheme.bodyLarge,
          theme.textTheme.labelSmall,
        ];
        expect(
          styles.map((style) => style?.fontSize).toSet(),
          AppTypography.scale.toSet(),
        );
        expect(styles.map((style) => style?.fontWeight).toSet(), {
          FontWeight.w600,
          FontWeight.w400,
        });
        expect(theme.textTheme.bodyMedium?.fontFamily, 'Manrope');
      }
    });

    test('light and dark themes share the same component language', () {
      final light = AppTheme.lightTheme();
      final dark = AppTheme.darkTheme();

      expect(light.scaffoldBackgroundColor, AppColors.background);
      expect(dark.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(light.colorScheme.brightness, Brightness.light);
      expect(dark.colorScheme.brightness, Brightness.dark);
      expect(light.colorScheme.primary, AppColors.primary);
      expect(dark.colorScheme.primary, AppColors.darkPrimary);

      for (final theme in [light, dark]) {
        final cardShape = theme.cardTheme.shape;
        expect(cardShape, isA<RoundedRectangleBorder>());
        expect(
          (cardShape! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(AppSpacing.radiusLg),
        );
        expect(theme.extension<AppThemeExtension>(), isNotNull);
        expect(
          theme.extension<AppThemeExtension>()!.ambientGradient.colors.length,
          3,
        );
      }
    });

    testWidgets('status colors switch with the brightness', (tester) async {
      late StatusPalette lightPalette;
      late StatusPalette darkPalette;

      await tester.pumpWidget(
        Theme(
          data: AppTheme.lightTheme(),
          child: Builder(
            builder: (context) {
              lightPalette = context.statusPalette;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpWidget(
        Theme(
          data: AppTheme.darkTheme(),
          child: Builder(
            builder: (context) {
              darkPalette = context.statusPalette;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(lightPalette.demo, AppColors.demo);
      expect(darkPalette.demo, AppColors.darkTeal);
    });
  });
}
