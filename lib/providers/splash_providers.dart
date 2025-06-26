import 'package:dongsoop/presentation/splash/splash_state.dart';
import 'package:dongsoop/presentation/splash/splash_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

// View Model
final splashViewModelProvider =
StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  final loadUserUseCase = ref.watch(loadUserUseCaseProvider);

  return SplashViewModel(loadUserUseCase, ref);
});