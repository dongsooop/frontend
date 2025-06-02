import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/domain/auth/model/department_type_ext.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<LoginResponse> login(String email, String password) {
    return _authDataSource.login(email, password);
  }

  // change nickname
  // change password
  // change dept

  @override
  Future<User?> getUser() async {
    return await _authDataSource.getUser();
  }

  @override
  Future<void> logout() async {
    await _authDataSource.logout();
  }

  @override
  Future<void> saveUser(StoredUser storedUser) async {
    String departmentTypeExt = DepartmentTypeExtension.fromCode(storedUser.departmentType).displayName;
    final saveUser = storedUser.copyWith(departmentType: departmentTypeExt);

    await _authDataSource.saveUser(saveUser);
  }
}