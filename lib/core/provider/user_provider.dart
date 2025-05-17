import 'dart:convert';

import 'package:dongsoop/core/provider/dio.provider.dart';
import 'package:dongsoop/data/auth/models/user_model.dart';
import 'package:dongsoop/data/auth/repositories/user_repository_impl.dart';
import 'package:dongsoop/domain/auth/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateProvider<UserEntity?>((ref) => null);

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, bool>((ref) => UserNotifier(ref));

class UserNotifier extends StateNotifier<bool> {
  final Ref ref;

  UserNotifier(this.ref) : super(false);

  Future<void> login(UserEntity user, String token, UserModel rawModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setString('USER_DATA', jsonEncode(rawModel.toJson()));
    ref.read(userProvider.notifier).state = user;
    state = true;
  }

  Future<void> restoreUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final userJson = prefs.getString('USER_DATA');

    print('저장된 accessToken: $token');
    print('저장된 USER_DATA: $userJson');

    if (token != null && userJson != null) {
      final userModel = UserModel.fromJson(jsonDecode(userJson));
      ref.read(userProvider.notifier).state = userModel.toEntity();
      state = true;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('USER_DATA');
    ref.read(userProvider.notifier).state = null;
    state = false;
  }
}

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final dio = ref.read(dioWithAuthProvider);
  return UserRepositoryImpl(dio);
});
