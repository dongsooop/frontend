import 'package:dongsoop/domain/restaurants/model/restaurant.dart';

class RestaurantsState {
  final bool isLoading;
  final String? errorMessage;
  final List<Restaurant>? restaurants;

  RestaurantsState({
    required this.isLoading,
    this.errorMessage,
    this.restaurants,
  });

  RestaurantsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Restaurant>? restaurants,
  }) {
    return RestaurantsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      restaurants: restaurants,
    );
  }
}