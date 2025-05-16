import 'package:dongsoop/core/provider/auth_provider.dart';
import 'package:dongsoop/core/provider/dio.provider.dart';
import 'package:dongsoop/data/users/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends StateNotifier<bool> {
  final Ref ref;

  UserNotifier(this.ref) : super(false);

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) return;

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/user/me');
      final user = UserModel.fromJson(response.data);
      ref.read(userProvider.notifier).state = user.toEntity();
      state = true;
    } catch (_) {
      state = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    ref.read(userProvider.notifier).state = null;
    state = false;
  }
}
