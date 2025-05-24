import 'dart:convert';

import 'package:flutter/services.dart';

class DepartmentMapper {
  static final Map<String, String> _map = {};

  static Future<void> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/department.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _map.addAll(jsonMap.map((key, value) => MapEntry(key, value.toString())));
  }

  static String? getName(String department) => _map[department];
}
