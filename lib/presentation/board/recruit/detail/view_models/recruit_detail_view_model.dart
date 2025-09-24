import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_delete_use_case.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:dongsoop/domain/chat/model/chat_room_request.dart';
import 'package:dongsoop/domain/chat/use_case/chat/create_QNA_chat_room_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_delete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_detail_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/detail/states/recruit_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/domain/auth/use_case/user_block_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';

part 'recruit_detail_view_model.g.dart';

class RecruitDetailArgs {
  final int id;
  final RecruitType type;

  const RecruitDetailArgs({
    required this.id,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecruitDetailArgs &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

@riverpod
class RecruitDetailViewModel extends _$RecruitDetailViewModel {
  RecruitDetailUseCase get _useCase => ref.watch(recruitDetailUseCaseProvider);
  RecruitDeleteUseCase get _deleteUseCase =>
      ref.watch(recruitDeleteUseCaseProvider);
  CreateQnaChatRoomUseCase get _createQNAChatRoomUseCase =>
      ref.watch(createQNAChatRoomUseCaseProvider);
  UserBlockUseCase get _userBlockUseCase => ref.watch(userBlockUseCaseProvider);

  @override
  FutureOr<RecruitDetailState> build(RecruitDetailArgs args) async {
    try {
      final recruitDetail = await _useCase.execute(
        id: args.id,
        type: args.type,
      );

      return RecruitDetailState(
        recruitDetail: recruitDetail,
        isLoading: false,
      );
    } catch (e) {
      rethrow;
    }
  }

  void setButtonEnabled(bool enabled) {
    final current = state.value;
    if (current == null) return;
  }

  Future<void> deleteRecruit(int id, RecruitType type) async {
    try {
      await _deleteUseCase.execute(id: id, type: type);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createChatRoom(ChatRoomRequest request) async {
    try {
      final chatRoom = await _createQNAChatRoomUseCase.execute(request);
      return chatRoom;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> userBlock(int blockerId, int blockedMemberId) async {
    try {
      await _userBlockUseCase.execute(blockerId, blockedMemberId);
    } catch (e) {
      rethrow;
    }
  }
}
