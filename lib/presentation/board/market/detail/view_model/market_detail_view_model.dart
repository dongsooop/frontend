import 'package:dongsoop/domain/board/market/use_cases/market_complete_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_contact_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_delete_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_detail_use_case.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/presentation/board/market/state/market_detail_state.dart';
import 'package:dongsoop/presentation/board/providers/market/market_complete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_contact_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_delete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_detail_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/domain/chat/use_case/create_one_to_one_chat_room_use_case.dart';
import 'package:dongsoop/providers/chat_providers.dart';

part 'market_detail_view_model.g.dart';

class MarketDetailArgs {
  final int id;

  const MarketDetailArgs({
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketDetailArgs &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@riverpod
class MarketDetailViewModel extends _$MarketDetailViewModel {
  MarketDetailUseCase get _useCase => ref.watch(marketDetailUseCaseProvider);
  MarketDeleteUseCase get _deleteUseCase =>
      ref.watch(marketDeleteUseCaseProvider);
  MarketCompleteUseCase get _completeUseCase =>
      ref.watch(marketCompleteUseCaseProvider);
  MarketContactUseCase get _contactUseCase =>
      ref.watch(marketContactUseCaseProvider);
  CreateOneToOneChatRoomUseCase get _createOneToOneChatRoomUseCase =>
      ref.watch(createOneToOneChatRoomUseCaseProvider);

  @override
  FutureOr<MarketDetailState> build(MarketDetailArgs args) async {
    try {
      final marketDetail = await _useCase.execute(id: args.id);
      return MarketDetailState(
        marketDetail: marketDetail,
        isLoading: false,
      );
    } catch (e) {
      return MarketDetailState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteMarket(int marketId) async {
    try {
      await _deleteUseCase.execute(marketId: marketId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeMarket(int marketId) async {
    try {
      await _completeUseCase.execute(marketId: marketId);

      final current = state.value;
      if (current != null) {
        state = AsyncData(
          current.copyWith(
            isComplete: true,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> contactMarket(int marketId) async {
    try {
      await _contactUseCase.execute(marketId: marketId);
    } catch (e) {
      rethrow;
    }
  }

  Future<UiChatRoom> createChatRoom(String title, int targetUserId) async {
    try {
      final chatRoom = await _createOneToOneChatRoomUseCase.execute(title, targetUserId);
      return chatRoom;
    } catch (e) {
      rethrow;
    }
  }
}
