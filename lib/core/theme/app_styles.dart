import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  AppStyles._();

  static TextStyle get heading1 => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  static TextStyle get heading2 => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      );

  static TextStyle get title => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  static TextStyle get labelMedium => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );
}
