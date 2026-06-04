import 'package:dongsoop/presentation/splash/splash_state.dart';
import 'package:dongsoop/presentation/splash/splash_view_model.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

// View Model
final splashViewModelProvider =
StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  final loadUserUseCase = ref.watch(loadUserUseCaseProvider);
  final getSanctionStatusUseCase = ref.watch(getSanctionStatusUseCaseProvider);

  return SplashViewModel(loadUserUseCase, getSanctionStatusUseCase, ref);
});

final fcmSnackMessageProvider = StateProvider<String?>((_) => null);