class RestaurantsWriteState{
  final bool isLoading;
  final String? errorMessage;
  final bool? checkDuplication;

  RestaurantsWriteState({
    required this.isLoading,
    this.errorMessage,
    this.checkDuplication,
  });

  RestaurantsWriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? checkDuplication,
  }) {
    return RestaurantsWriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      checkDuplication: checkDuplication,
    );
  }
}