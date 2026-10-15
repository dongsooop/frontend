import 'package:dongsoop/core/routing/utils/push_router_helper.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/storage/notification_permission_service.dart';
import 'package:dongsoop/presentation/app/marketing_push_dialog.dart';
import 'package:dongsoop/presentation/app/marketing_push_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/providers/splash_providers.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/core/app_scaffold_messenger.dart';
import 'package:flutter/scheduler.dart';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/model/report_sanction_status.dart';

class SplashScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashViewModelProvider);
    final viewModel = ref.read(splashViewModelProvider.notifier);

    void _goNext() {
      if (PushRouter.hasPendingRoute) {
        PushRouterHelper.goNextOrHome(context);
      } else {
        context.go(RoutePaths.home);
      }
    }

    useEffect(() {
      final container = ProviderScope.containerOf(context, listen: false);
      bool cancelled = false;

      Future<void> runMarketingConsentIfNeeded() async {
        if (cancelled || !context.mounted) return;

        try {
          await ref.read(notificationPermissionServiceProvider).requestOnce();
        } catch (_) {}

        if (cancelled || !context.mounted) return;

        await SchedulerBinding.instance.endOfFrame;
        await Future.delayed(const Duration(milliseconds: 200));

        if (cancelled || !context.mounted) return;

        try {
          final guard = ref.read(marketingPushGuardProvider);
          final shouldShow = await guard.shouldShowDialog();
          if (!shouldShow) return;

          if (cancelled || !context.mounted) return;

          await showMarketingPushDialog(context, ref);
        } catch (_) {}
      }

      Future<void> goNextWithConsent() async {
        await runMarketingConsentIfNeeded();
        if (cancelled || !context.mounted) return;
        _goNext();
      }

      Future<void> showSanctionStatusRetryDialog(Object error) async {
        if (cancelled || !context.mounted) return;

        final message = error is SanctionStatusException
            ? error.message
            : '제재 상태를 확인하지 못했습니다. 잠시 후 다시 시도해 주세요.';
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomConfirmDialog(
            title: '제재 상태 확인 오류',
            content: message,
            isSingleAction: true,
            confirmText: '다시 시도',
            onConfirm: () {},
          ),
        );
      }

      Future<void> showSanctionDialog(
        ReportSanctionStatus reportSanction,
      ) async {
        if (cancelled || !context.mounted) return;

        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomConfirmDialog(
            title: '동숲 이용 제재',
            content: '제재 유형: ${reportSanction.sanctionType.message}\n'
                '${reportSanction.reason}\n${reportSanction.description}\n'
                '${reportSanction.periodLabel}',
            isSingleAction: true,
            confirmText: '확인',
            onConfirm: () {},
          ),
        );
      }

      Future(() async {
        await Future.delayed(const Duration(seconds: 2));
        // 자동 로그인
        if (cancelled || !context.mounted) return;

        await viewModel.autoLogin();
        if (cancelled || !context.mounted) return;

        // 회원/비회원 구분 없이 앱 실행마다(첫 설치·업데이트 포함) fid/deviceToken을 등록한다.
        // 로그인 상태여도 등록해야 기존 회원 기기에 fid가 백필된다.
        final message = await viewModel.requestDeviceTokenPreAuthOnce(
          tokenTimeout: const Duration(seconds: 3),
        );
        if (cancelled || !context.mounted) return;

        viewModel.restoreExpiredEclassLinkInBackground();

        if (message != null) {
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: TextStyles.normalTextRegular
                    .copyWith(color: ColorStyles.white),
              ),
              backgroundColor: ColorStyles.gray3,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              elevation: 4,
              duration: const Duration(seconds: 3),
            ),
          );
          await SchedulerBinding.instance.endOfFrame;
          await Future.delayed(const Duration(milliseconds: 200));
        }
        if (cancelled || !context.mounted) return;

        // 제재 대상 확인
        final user = container.read(userSessionProvider);
        if (cancelled || !context.mounted) return;

        if (user != null) {
          while (!cancelled && context.mounted) {
            ReportSanctionStatus? reportSanction;
            try {
              reportSanction = await viewModel.checkSanction();
            } on SessionExpiredException {
              // 전역 세션 만료 안내가 로그아웃과 화면 전환을 담당한다.
              return;
            } catch (error) {
              await showSanctionStatusRetryDialog(error);
              continue;
            }

            if (cancelled || !context.mounted) return;
            if (reportSanction != null) {
              await showSanctionDialog(reportSanction);
            }
            if (cancelled || !context.mounted) return;
            await goNextWithConsent();
            return;
          }
          return;
        }

        if (cancelled || !context.mounted) return;
        await goNextWithConsent();
      });

      return () {
        cancelled = true;
      };
    }, const []);

    useEffect(() {
      if (splashState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '동숲 오류',
              content: splashState.errorMessage!,
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [splashState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 64,
            children: [
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 128,
                height: 128,
                colorFilter: const ColorFilter.mode(
                  ColorStyles.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: splashState.isLoading
                    ? const CircularProgressIndicator(
                        color: ColorStyles.primaryColor)
                    : const SizedBox(height: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
