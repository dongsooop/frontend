import 'package:dongsoop/data/auth/models/user_model.dart';

abstract class UserRepository {
  /// 테스트용 로그인 - .env에 있는 값으로 로그인 요청 보내기
  Future<UserModel> login();
}
