import 'dart:convert';

import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_credentials_local_data_source.dart';
import 'package:dongsoop/data/eclass/model/eclass_credentials_local_model.dart';

class EclassCredentialsLocalDataSourceImpl
    implements EclassCredentialsLocalDataSource {
  static const storageKey = 'eclassCredentials';

  final SecureStorageService _secureStorage;

  EclassCredentialsLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> save(EclassCredentialsLocalModel credentials) async {
    try {
      await _secureStorage.write(
        storageKey,
        jsonEncode(credentials.toJson()),
      );
    } catch (_) {
      throw const EclassCredentialsStorageException(
        'Eclass 자동 로그인 정보를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    }
  }

  @override
  Future<EclassCredentialsLocalModel?> read() async {
    final String? storedValue;
    try {
      storedValue = await _secureStorage.read(storageKey);
    } catch (_) {
      throw const EclassCredentialsStorageException(
        'Eclass 자동 로그인 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    }

    if (storedValue == null) return null;
    if (storedValue.isEmpty) {
      await _deleteCorruptedValue();
      return null;
    }

    try {
      final decoded = jsonDecode(storedValue);
      if (decoded is! Map) {
        throw const FormatException('Invalid stored Eclass credentials.');
      }
      return EclassCredentialsLocalModel.fromJson(
        decoded.map((key, value) => MapEntry(key.toString(), value)),
      );
    } on FormatException {
      await _deleteCorruptedValue();
      return null;
    } catch (_) {
      await _deleteCorruptedValue();
      return null;
    }
  }

  @override
  Future<void> delete() async {
    try {
      await _secureStorage.deleteByKey(storageKey);
    } catch (_) {
      throw const EclassCredentialsStorageException(
        'Eclass 자동 로그인 정보를 삭제하지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    }
  }

  Future<void> _deleteCorruptedValue() async {
    try {
      await _secureStorage.deleteByKey(storageKey);
    } catch (_) {
      throw const EclassCredentialsStorageException(
        '손상된 Eclass 자동 로그인 정보를 정리하지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    }
  }
}
