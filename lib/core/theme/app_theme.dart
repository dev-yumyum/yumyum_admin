import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      
      // 전체 텍스트 테마 설정 (반응형 폰트 크기로 조정 - 25% 증가)
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w300, color: AppColors.textPrimary),
        displayMedium: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        displaySmall: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        headlineLarge: TextStyle(fontSize: 27.5.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        headlineMedium: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        headlineSmall: TextStyle(fontSize: 22.5.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        titleLarge: TextStyle(fontSize: 22.5.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        titleMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        titleSmall: TextStyle(fontSize: 17.5.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 17.5.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        labelLarge: TextStyle(fontSize: 17.5.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        labelMedium: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        labelSmall: TextStyle(fontSize: 13.75.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22.5.sp, // 반응형 크기로 조정 (25% 증가)
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        color: AppColors.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          textStyle: TextStyle(
            fontSize: 17.5.sp, // 반응형 크기로 조정 (25% 증가)
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          textStyle: TextStyle(
            fontSize: 17.5.sp, // 반응형 크기로 조정 (25% 증가)
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.all(AppSizes.md),
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 17.5.sp, // 반응형 크기로 조정 (25% 증가)
        ),
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 17.5.sp, // 반응형 크기로 조정 (25% 증가)
        ),
      ),
    );
  }
}
