import 'package:dongsoop/domain/auth/model/sign_in_response.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<SignInResponse> signIn(String email, String password) {
    return _authDataSource.signIn(email, password);
  }

  @override
  Future<void> signUp(SignUpRequest request) async {
    return await _authDataSource.signUp(request);
  }

  @override
  Future<bool> checkValidate(String data, String type) async {
    return await _authDataSource.validate(data, type);
  }

  @override
  Future<User?> getUser() async {
    return await _authDataSource.getUser();
  }

  @override
  Future<void> logout() async {
    await _authDataSource.logout();
  }

  @override
  Future<void> deleteUser() async {
    await _authDataSource.deleteUser();
  }

  @override
  Future<void> saveUser(StoredUser storedUser) async {
    String departmentTypeExt = DepartmentTypeExtension.fromCode(storedUser.departmentType).displayName;
    final saveUser = storedUser.copyWith(departmentType: departmentTypeExt);

    await _authDataSource.saveUser(saveUser);
  }

  @override
  Future<bool> checkEmailCode(String userEmail, String code) async {
    return await _authDataSource.checkEmailCode(userEmail, code);
  }

  @override
  Future<bool> sendEmailCode(String userEmail) async {
    return await _authDataSource.sendEmailCode(userEmail);
  }

  @override
  Future<void> userBlock(int blockerId, int blockedMemberId) async {
    await _authDataSource.userBlock(blockerId, blockedMemberId);
  }
}