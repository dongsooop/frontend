import 'package:dongsoop/domain/auth/model/login_response.dart';

abstract interface class RemoteAuthDataSource {
  Future<LoginResponse> login(String email, String password);
}