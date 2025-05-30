import 'package:dongsoop/domain/auth/model/user.dart';

abstract interface class LocalAuthDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}