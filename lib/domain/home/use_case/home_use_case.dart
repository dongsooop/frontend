import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/home/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository repository;
  HomeUseCase(this.repository);

  Future<HomeEntity> execute({String? departmentType}) {
    final code = departmentType?.trim();
    return (code == null || code.isEmpty)
        ? repository.fetchGuestHome()
        : repository.fetchHome(departmentType: code);
  }
}
