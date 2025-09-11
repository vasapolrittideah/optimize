import 'package:core/src/themes/tokens/borders.dart';
import 'package:core/src/themes/tokens/colors.dart';
import 'package:core/src/themes/tokens/shadows.dart';
import 'package:core/src/themes/tokens/spacing.dart';
import 'package:core/src/themes/tokens/tokens.dart';
import 'package:core/src/themes/tokens/typography/typography.dart';
import 'package:flutter/material.dart';

final class AppTheme extends ThemeExtension<AppTheme> {
  AppTheme({required this.tokens});

  final AppTokens tokens;

  @override
  AppTheme copyWith({AppTokens? tokens}) {
    return AppTheme(tokens: tokens ?? this.tokens);
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) {
      return this;
    }
    return AppTheme(tokens: tokens.lerp(other.tokens, t));
  }
}

extension AppThemeExtension on BuildContext {
  AppTheme get _theme => Theme.of(this).extension<AppTheme>()!;
  AppColors get appColors => _theme.tokens.colors;
  AppTypography get appTypography => _theme.tokens.typography;
  AppBorders get appBorders => _theme.tokens.borders;
  AppShadows get appShadows => _theme.tokens.shadows;
  AppSpacing get appSpacing => _theme.tokens.spacing;
}
