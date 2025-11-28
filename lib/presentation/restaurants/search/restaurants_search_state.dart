import 'package:dongsoop/domain/restaurants/model/restaurant.dart';

class RestaurantsSearchState {
  final bool isLoading;
  final String? errorMessage;
  final List<Restaurant>? restaurants;
  final bool? isNoSearchResult;

  RestaurantsSearchState({
    required this.isLoading,
    this.errorMessage,
    this.restaurants,
    this.isNoSearchResult,
  });

  RestaurantsSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Restaurant>? restaurants,
    bool? isNoSearchResult,
  }) {
    return RestaurantsSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      restaurants: restaurants ?? this.restaurants,
      isNoSearchResult: isNoSearchResult ?? this.isNoSearchResult,
    );
  }
}