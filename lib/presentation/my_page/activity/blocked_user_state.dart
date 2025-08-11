import 'package:dongsoop/domain/mypage/model/blocked_user.dart';

class BlockedUserState {
  final bool isLoading;
  final String? errorMessage;
  final List<BlockedUser>? list;

  BlockedUserState({
    required this.isLoading,
    this.errorMessage,
    this.list = const [],
  });

  BlockedUserState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BlockedUser>? list,
  }) {
    return BlockedUserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      list: list ?? this.list,
    );
  }
}
