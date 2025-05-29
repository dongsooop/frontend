import 'package:dongsoop/domain/auth/model/login_response.dart';

abstract interface class AuthDataSource {
  Future<LoginResponse> login(String email, String password);
}