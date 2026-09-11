import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/home/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository repository;
  HomeUseCase(this.repository);

  Future<HomeEntity> execute({
    String? departmentCode,
    String? fid,
    String? deviceToken,
  }) {
    return repository.fetchHome(
      departmentCode: departmentCode,
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
