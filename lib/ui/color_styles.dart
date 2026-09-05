import 'dart:ui';

abstract class ColorStyles {
  static const Color black = Color(0xFF252525);
  static const Color gray1 = Color(0xFFF2F2F2);
  static const Color gray2 = Color(0xFFDADADC);
  static const Color gray3 = Color(0xFF6E6E6E);
  static const Color gray4 = Color(0xFF767676);
  static const Color gray5 = Color(0xFF8B8C92);
  static const Color gray6 = Color(0xFF545961);
  static const Color gray7 = Color(0xFFF3F5F8);
  static const Color white = Color(0xFFFFFFFF);

  static const Color primary100 = Color(0xFF006DFF);
  static const Color primary5 = Color(0xFFEBF3FF);
  static const Color primaryGray = Color(0xFF00439C);

  static const Color labelColorRed100 = Color(0xFF804640);
  static const Color labelColorRed10 = Color(0xFFFCEEED);
  static const Color labelColorYellow100 = Color(0xFFAA8339);
  static const Color labelColorYellow10 = Color(0xFFF4ECDD);

  static const Color warning100 = Color(0xFFC70000);
  static const Color warning10 = Color(0xFFF3DADA);

  // 기능 구분용 옅은 배경. 아이콘을 새로 그리지 않고 색 면으로 나눌 때 쓴다
  static const Color mintBg = Color(0xFFE4F7EE);
  static const Color amberBg = Color(0xFFFFF6E0);

  static const Color primaryColor = primary100;
}