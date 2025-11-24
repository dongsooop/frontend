import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_request.dart';
import 'package:dongsoop/domain/restaurants/use_case/check_restaurants_duplication_use_case.dart';
import 'package:dongsoop/domain/restaurants/use_case/create_restaurants_use_case.dart';
import 'package:dongsoop/presentation/restaurants/write/restaurants_write_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsWriteViewModel extends StateNotifier<RestaurantsWriteState>{
  final CheckRestaurantsDuplicationUseCase _checkRestaurantsDuplicationUseCase;
  final CreateRestaurantsUseCase _createRestaurantsUseCase;

  RestaurantsWriteViewModel(
    this._checkRestaurantsDuplicationUseCase,
    this._createRestaurantsUseCase,
  ) : super(
    RestaurantsWriteState(isLoading: false)
  );

  Future<void> checkDuplication(String externalMapId) async {
    state = state.copyWith(errorMessage: null);

    try {
      final result = await _checkRestaurantsDuplicationUseCase.execute(externalMapId);
      state = state.copyWith(
        checkDuplication: result,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: '중복 확인 중 오류가 발생했습니다.',
      );
    }
  }

  Future<bool> submit(RestaurantsKakaoInfo info, RestaurantsCategory category, List<String>? tags) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = _createRestaurantsUseCase.execute(
        RestaurantsRequest(
          externalMapId: info.id,
          name: info.place_name,
          placeUrl: info.place_url,
          distance: info.distance,
          category: category,
          tags: tags,
        ),
      );
      state = state.copyWith(
        isLoading: false,
      );
      return result;
    } on RestaurantsDuplicationException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '가게 등록 중 오류가 발생했습니다.',
      );
      return false;
    }
  }
}