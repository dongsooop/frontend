import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/social_connect_item.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';
import 'package:dongsoop/domain/mypage/use_case/get_social_state_use_case.dart';
import 'package:dongsoop/domain/mypage/use_case/link_social_use_case.dart';
import 'package:dongsoop/domain/mypage/use_case/unlink_social_use_case.dart';
import 'package:dongsoop/presentation/my_page/social_login_connect/social_login_connect_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialLoginConnectViewModel extends StateNotifier<SocialLoginConnectState> {
  final GetSocialStateUseCase _getSocialStateUseCase;
  final LinkSocialUseCase _linkSocialUseCase;
  final UnlinkSocialUseCase _unlinkSocialUseCase;

  SocialLoginConnectViewModel(
    this._getSocialStateUseCase,
    this._linkSocialUseCase,
    this._unlinkSocialUseCase,
  ) : super(SocialLoginConnectState(isLoading: false));

  String _providerKey(LoginPlatform p) => p.name.toUpperCase();


  Future<void> loadList() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final list = await _getSocialStateUseCase.execute() ?? [];
      state = state.copyWith(
        isLoading: false,
        list: list,
        items: _buildItems(list),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '소셜 계정 연동 정보를 불러오는 중\n오류가 발생했습니다.',
      );
    }
  }

  List<SocialConnectItem> _buildItems(List<SocialState> list) {
    SocialState? find(LoginPlatform p) {
      final key = _providerKey(p);
      for (final s in list) {
        if (s.providerType.toUpperCase() == key) return s;
      }
      return null;
    }

    SocialConnectItem item(LoginPlatform p) {
      final s = find(p);
      return SocialConnectItem(
        platform: p,
        isConnected: s != null,
        connectedDate: s == null ? null : formatYmdDot(s.createdAt),
      );
    }

    return [
      item(LoginPlatform.kakao),
      item(LoginPlatform.google),
      item(LoginPlatform.apple),
    ];
  }

  Future<void> socialLink(LoginPlatform platform) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 소셜 로그인 & 연동
      final createdAt = await _linkSocialUseCase.execute(platform);

      // 유저가 취소한 경우 or 오류
      if (createdAt == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final updatedItems = state.items.map((e) => e.platform == platform
        ? e.copyWith(
          isConnected: true,
          connectedDate: formatYmdDot(createdAt),
        )
        : e).toList();

      final updatedList = [
        ...? state.list?.where((s) => s.providerType.toUpperCase() != _providerKey(platform)),
        SocialState(
          providerType: _providerKey(platform),
          createdAt: createdAt,
        ),
      ];

      state = state.copyWith(
        isLoading: false,
        items: updatedItems,
        list: updatedList,
      );
    } on OAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '소셜 계정 연동 중 오류가 발생했습니다.');
    }
  }

  Future<void> socialUnlink(LoginPlatform platform) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 소셜 로그인 & 연결 해제
      final isSuccess = await _unlinkSocialUseCase.execute(platform);

      // 유저가 취소한 경우 or 오류
      if (isSuccess == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final updatedItems = state.items.map((e) => e.platform == platform
        ? e.copyWith(
          isConnected: false,
          connectedDate: null,
        )
        : e).toList();

      final updatedList = state.list
          ?.where((s) => s.providerType.toUpperCase() != _providerKey(platform))
          .toList();

      state = state.copyWith(
        isLoading: false,
        items: updatedItems,
        list: updatedList,
      );
    } on OAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '소셜 계정 연동 중 오류가 발생했습니다.');
    }
  }
}
