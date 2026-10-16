import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/enum/report_chat_room_type.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/use_case/report_admin_sanction_write_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportAdminSanctionViewModel
    extends StateNotifier<ReportAdminSanctionState> {
  final ReportAdminSanctionWriteUseCase _adminSanctionWriteUseCase;
  final ReportChatRoomType? chatRoomType;
  final DateTime Function() _now;

  ReportAdminSanctionViewModel(
    this._adminSanctionWriteUseCase, {
    required this.chatRoomType,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(const ReportAdminSanctionState());

  bool get canSubmit {
    final sanctionType = state.sanctionType;
    final sanctionReason = state.sanctionReason.trim();
    if (state.isSubmitting ||
        sanctionType == null ||
        !sanctionType.isAvailableFor(chatRoomType) ||
        sanctionReason.length > 500 ||
        (sanctionType.requiresReason && sanctionReason.isEmpty)) {
      return false;
    }

    if (!sanctionType.requiresEndAt) return true;
    final sanctionEndAt = state.sanctionEndAt;
    return sanctionEndAt != null && sanctionEndAt.isAfter(_now());
  }

  List<SanctionType> get availableSanctions =>
      SanctionType.availableFor(chatRoomType);

  void selectSanctionType(SanctionType sanctionType) {
    if (!sanctionType.isAvailableFor(chatRoomType)) return;

    state = state.copyWith(
      sanctionType: sanctionType,
      clearSanctionEndAt: !sanctionType.requiresEndAt,
      clearError: true,
    );
  }

  void updateSanctionReason(String sanctionReason) {
    state = state.copyWith(
      sanctionReason: sanctionReason,
      clearError: true,
    );
  }

  void selectSanctionEndAt(DateTime sanctionEndAt) {
    final normalized = DateTime(
      sanctionEndAt.year,
      sanctionEndAt.month,
      sanctionEndAt.day,
      sanctionEndAt.hour,
      sanctionEndAt.minute,
    );
    state = state.copyWith(
      sanctionEndAt: normalized,
      clearError: true,
    );
  }

  Future<bool> sanctionWrite({
    required int reportId,
    required int targetMemberId,
  }) async {
    if (state.isSubmitting) return false;

    if (!canSubmit || reportId <= 0 || targetMemberId <= 0) {
      state = state.copyWith(
        errorMessage: '제재 정보를 다시 확인해 주세요.',
        failure: ReportAdminSanctionFailure.validation,
      );
      return false;
    }

    final sanctionType = state.sanctionType!;
    final sanctionReason = state.sanctionReason.trim();
    final request = ReportAdminSanctionRequest(
      reportId: reportId,
      targetMemberId: targetMemberId,
      sanctionType: sanctionType,
      sanctionReason: sanctionReason.isEmpty ? null : sanctionReason,
      sanctionEndAt: sanctionType.requiresEndAt ? state.sanctionEndAt : null,
    );
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      await _adminSanctionWriteUseCase.execute(request);
      state = state.copyWith(isSubmitting: false, clearError: true);
      return true;
    } on SanctionRequestValidationException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminSanctionFailure.validation,
      );
    } on NoAdminAuthorityException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminSanctionFailure.forbidden,
      );
    } on NotFoundSanctionException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminSanctionFailure.notFound,
      );
    } on AlreadyProcessedException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminSanctionFailure.alreadyProcessed,
      );
    } on SanctionException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        failure: ReportAdminSanctionFailure.unknown,
      );
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: '제재 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
        failure: ReportAdminSanctionFailure.unknown,
      );
    }
    return false;
  }
}
