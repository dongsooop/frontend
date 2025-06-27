import 'package:dongsoop/presentation/setting/setting_state.dart';
import 'package:dongsoop/presentation/setting/setting_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// View Model
final settingViewModelProvider =
StateNotifierProvider<SettingViewModel, SettingState>((ref) {
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  final deleteUserUseCase = ref.watch(deleteUserUseCaseProvider);
  final deleteChatDateUseCase = ref.watch(deleteChatDataUseCaseProvider);

  return SettingViewModel(logoutUseCase, deleteUserUseCase,deleteChatDateUseCase, ref);
});