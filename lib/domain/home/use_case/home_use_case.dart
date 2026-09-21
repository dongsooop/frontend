import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_assignment_repository.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/home/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository _homeRepository;
  final EclassAssignmentRepository _eclassAssignmentRepository;

  HomeUseCase(
    this._homeRepository,
    this._eclassAssignmentRepository,
  );

  Future<HomeEntity> execute({
    String? departmentCode,
    String? fid,
    String? deviceToken,
  }) async {
    if (_hasDeviceIdentity(fid: fid, deviceToken: deviceToken)) {
      try {
        await _eclassAssignmentRepository.sync(
          fid: fid,
          deviceToken: deviceToken,
        );
      } on EclassException {
        // Eclass 동기화 장애가 시간표, 학식 등 홈 전체 조회를 막지 않게 한다.
      }
    }

    return _homeRepository.fetchHome(
      departmentCode: departmentCode,
      fid: fid,
      deviceToken: deviceToken,
    );
  }

  bool _hasDeviceIdentity({
    required String? fid,
    required String? deviceToken,
  }) {
    return (fid?.trim().isNotEmpty ?? false) ||
        (deviceToken?.trim().isNotEmpty ?? false);
  }
}
