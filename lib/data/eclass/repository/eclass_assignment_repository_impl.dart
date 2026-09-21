import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_assignment_data_source.dart';
import 'package:dongsoop/data/eclass/mapper/eclass_assignment_mapper.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_assignment_list_entity.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_sync_result.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_assignment_repository.dart';

class EclassAssignmentRepositoryImpl implements EclassAssignmentRepository {
  final EclassAssignmentDataSource _dataSource;

  EclassAssignmentRepositoryImpl(this._dataSource);

  @override
  Future<EclassAssignmentListEntity> getAssignments({
    String? fid,
    String? deviceToken,
  }) async {
    final response = await _dataSource.getAssignments(
      fid: fid,
      deviceToken: deviceToken,
    );

    try {
      return response.toEntity();
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        EclassMalformedResponseException(error.message),
        stackTrace,
      );
    }
  }

  @override
  Future<EclassSyncResult> sync({
    String? fid,
    String? deviceToken,
  }) async {
    final result = await _dataSource.sync(
      fid: fid,
      deviceToken: deviceToken,
    );
    return switch (result) {
      EclassSyncRemoteResult.completed => EclassSyncResult.completed,
      EclassSyncRemoteResult.rateLimited => EclassSyncResult.cooldown,
    };
  }
}
