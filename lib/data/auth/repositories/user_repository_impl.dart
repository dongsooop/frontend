import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dongsoop/data/auth/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl {
  final Dio dio;

  UserRepositoryImpl(this.dio);

  Future<UserModel> login() async {
    final email = dotenv.env['LOGIN_EMAIL']!;
    final password = dotenv.env['LOGIN_PWD']!;

    final response = await dio.post('/member/login', data: {
      'email': email,
      'password': password,
    });

    final json = response.data;
    print('로그인 응답 JSON: $json');

    final token = json['accessToken'];
    final userModel = UserModel.fromJson(json);

    final prefs = await SharedPreferences.getInstance();
    print('저장할 accessToken: $token');
    print('저장할 USER_DATA: ${jsonEncode(userModel.toJson())}');

    await prefs.setString('accessToken', token);
    await prefs.setString('USER_DATA', jsonEncode(userModel.toJson()));

    print('accessToken 저장됨');
    print('USER_DATA 저장됨');

    return userModel;
  }
}
