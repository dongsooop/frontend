import 'package:flutter/material.dart';

abstract class TextStyles {
  static TextStyle titleTextBold = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static TextStyle largeTextBold = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );
  static TextStyle normalTextBold = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static TextStyle smallTextBold = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleTextRegular = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );
  static TextStyle largeTextRegular = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );
  static TextStyle normalTextRegular = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static TextStyle smallTextRegular = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}