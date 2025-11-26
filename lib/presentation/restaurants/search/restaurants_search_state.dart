import 'package:dongsoop/domain/restaurants/model/restaurant.dart';

class RestaurantsSearchState {
  final bool isLoading;
  final String? errorMessage;
  final List<Restaurant>? restaurants;

  RestaurantsSearchState({
    required this.isLoading,
    this.errorMessage,
    this.restaurants,
  });

  RestaurantsSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Restaurant>? restaurants,
  }) {
    return RestaurantsSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      restaurants: restaurants,
    );
  }
}