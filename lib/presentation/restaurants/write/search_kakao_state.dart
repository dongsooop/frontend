import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';

class SearchKakaoState {
  final bool isLoading;
  final String? errorMessage;
  final List<RestaurantsKakaoInfo>? result;

  SearchKakaoState({
    required this.isLoading,
    this.errorMessage,
    this.result
  });

  SearchKakaoState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<RestaurantsKakaoInfo>? result,
  }) {
    return SearchKakaoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      result: result,
    );
  }
}