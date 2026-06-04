import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class BlindDateOpenUseCase {
  final MypageRepository _mypageRepository;

  BlindDateOpenUseCase(this._mypageRepository,);

  Future<bool> execute(BlindDateOpenRequest request) async {
    return await _mypageRepository.blindOpen(request);
  }
}