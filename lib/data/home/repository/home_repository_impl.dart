import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/network/error_handler_mixin.dart';
import 'package:dongsoop/data/home/data_source/home_data_source.dart';
import 'package:dongsoop/data/home/mapper/home_mapper.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/home/repository/home_repository.dart';

class HomeRepositoryImpl with ErrorHandlerMixin implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<HomeEntity> fetchHome({required String departmentType}) async {
    return _handle(() async {
      final response = await _dataSource.fetchHome(departmentType: departmentType);
      return response.toEntity();
    });
  }

  @override
  Future<HomeEntity> fetchGuestHome() async {
    return _handle(() async {
      final response = await _dataSource.fetchGuestHome();
      return response.toEntity();
    });
  }

  Future<T> _handle<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e, st) {
      final converted = convertError(e);

      if (converted is SessionExpiredException) {
        throw converted;
      }
      Error.throwWithStackTrace(HomeException(), st);
    }
  }
}
