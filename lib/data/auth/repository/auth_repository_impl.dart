import 'package:dongsoop/data/auth/data_source/local_auth_data_source.dart';
import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/remote_auth_data_source.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

import '../../../domain/auth/model/department_type_ext.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remoteAuthDataSource;
  final LocalAuthDataSource _localAuthDataSource;

  AuthRepositoryImpl(this._remoteAuthDataSource, this._localAuthDataSource);

  @override
  Future<LoginResponse> login(String email, String password) {
    return _remoteAuthDataSource.login(email, password);
  }
  // logout
  // change nickname
  // change password
  // change dept


  @override
  Future<void> saveUser(User user) async {
    final department = DepartmentTypeExtension.fromCode(user.departmentType).displayName;
    final extUser = User(nickname: user.nickname, departmentType: department);

    await _localAuthDataSource.saveUser(extUser);
  }
  @override
  Future<User?> getUser() => _localAuthDataSource.getUser();

  @override
  Future<void> clearUser() => _localAuthDataSource.clearUser();
}