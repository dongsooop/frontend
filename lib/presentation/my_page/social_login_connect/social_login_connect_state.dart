import 'package:dongsoop/domain/mypage/model/social_connect_item.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';

class SocialLoginConnectState {
  final bool isLoading;
  final String? errorMessage;
  final List<SocialState>? list;
  final List<SocialConnectItem> items; // view

  SocialLoginConnectState({
    required this.isLoading,
    this.errorMessage,
    this.list = const [],
    this.items = const [],
  });

  SocialLoginConnectState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<SocialState>? list,
    List<SocialConnectItem>? items,
  }) {
    return SocialLoginConnectState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      list: list ?? this.list,
      items: items ?? this.items,
    );
  }
}
