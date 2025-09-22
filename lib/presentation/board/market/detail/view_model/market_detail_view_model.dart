import 'package:dongsoop/domain/board/market/use_cases/market_complete_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_contact_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_delete_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_detail_use_case.dart';
import 'package:dongsoop/presentation/board/market/state/market_detail_state.dart';
import 'package:dongsoop/presentation/board/providers/market/market_complete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_contact_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_delete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_detail_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/domain/auth/use_case/user_block_use_case.dart';
import 'package:dongsoop/providers/auth_providers.dart';

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
  UserBlockUseCase get _userBlockUseCase => ref.watch(userBlockUseCaseProvider);

  @override
  FutureOr<MarketDetailState> build(MarketDetailArgs args) async {
    try {
      final marketDetail = await _useCase.execute(id: args.id);
      return MarketDetailState(
        marketDetail: marketDetail,
        isLoading: false,
      );
    } catch (e) {
      rethrow;
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

  Future<String> contactMarket(int marketId) async {
    try {
      return await _contactUseCase.execute(marketId: marketId);
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
