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

  /// 홈·캠퍼스의 구획 제목. `학식`, `새로운 공지`, `오늘 뭐 먹지` 같은 것들.
  ///
  /// largeTextBold(17) 를 그대로 쓰다가 화면이 전반적으로 작아 보인다는 말에
  /// 따로 뗐다. largeTextBold 는 버튼·다이얼로그·탭바에도 쓰여서 그 값을
  /// 올리면 제목과 상관없는 곳까지 함께 커진다.
  static TextStyle sectionTitleBold = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
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