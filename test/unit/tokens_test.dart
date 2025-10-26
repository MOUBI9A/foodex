import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/core/theme/app_spacing.dart';
import 'package:food_delivery/core/theme/app_radius.dart';

void main() {
  test('AppSpacing constants are defined', () {
    expect(AppSpacing.xs, 4);
    expect(AppSpacing.lg, 16);
    expect(AppSpacing.xxl, 32);
  });

  test('AppRadius constants are defined', () {
    expect(AppRadius.sm, 8);
    expect(AppRadius.xl, 20);
  });
}
