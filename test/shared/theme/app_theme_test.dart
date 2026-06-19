import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  test('app theme keeps snackbars floating above bottom navigation', () {
    final theme = buildMateyaTheme();
    final snackBarTheme = theme.snackBarTheme;

    expect(snackBarTheme.behavior, SnackBarBehavior.floating);
    expect(
      snackBarTheme.insetPadding,
      const EdgeInsets.fromLTRB(20, 0, 20, 112),
    );
  });
}
