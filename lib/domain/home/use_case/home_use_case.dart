import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/home/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository repository;
  HomeUseCase(this.repository);

  /// 회원/비회원 구분 없이 디바이스(fid/deviceToken) 기준으로 홈을 조회한다.
  /// 구독 학과가 없어도 서버가 대학 공지 기본 홈으로 폴백한다.
  Future<HomeEntity> execute({String? fid, String? deviceToken}) {
    return repository.fetchHome(fid: fid, deviceToken: deviceToken);
  }
}
