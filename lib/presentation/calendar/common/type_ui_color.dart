import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

extension CalendarTypeUi on CalendarType {
  Color get color {
    switch (this) {
      case CalendarType.official:
        return ColorStyles.primary100;
      case CalendarType.member:
        return ColorStyles.warning100;
    }
  }
}
