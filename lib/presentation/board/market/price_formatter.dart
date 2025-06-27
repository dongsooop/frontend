import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PriceFormatter {
  static final _numberFormat = NumberFormat.decimalPattern('ko_KR');
  static const maxPrice = 9999999;

  static String format(int price) {
    return _numberFormat.format(price);
  }

  static int parse(String formatted) {
    final digitsOnly = formatted.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digitsOnly) ?? 0;
  }
}

// 가격 입력 필드에서 사용하는 TextInputFormatter
class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final number = int.tryParse(digitsOnly);
    if (number == null || number > PriceFormatter.maxPrice) {
      return oldValue;
    }

    final formatted = PriceFormatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
