import 'package:dongsoop/presentation/setting/setting_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// View Model
final settingViewModelProvider =
StateNotifierProvider<SettingViewModel, AsyncValue<void>>((ref) {
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  final deleteUserUseCase = ref.watch(deleteUserUseCaseProvider);

  return SettingViewModel(logoutUseCase, deleteUserUseCase, ref);
});