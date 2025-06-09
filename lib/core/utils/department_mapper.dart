import 'dart:convert';

import 'package:flutter/services.dart';

class DepartmentMapper {
  static final Map<String, String> _codeToName = {};
  static final Map<String, String> _nameToCode = {};

  static Future<void> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/department.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    jsonMap.forEach((key, value) {
      _codeToName[key] = value.toString();
      _nameToCode[value.toString()] = key;
    });
  }

  static String? getName(String code) => _codeToName[code];
  static String? getCode(String name) => _nameToCode[name];
}
