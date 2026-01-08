import 'package:dongsoop/core/routing/utils/push_router_helper.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
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

      Future(() async {
        await Future.delayed(const Duration(seconds: 2));
        // 자동 로그인
        if (cancelled || !context.mounted) return;

        await viewModel.autoLogin();
        if (cancelled || !context.mounted) return;

        // 제재 대상 확인
        final user = container.read(userSessionProvider);
        if (cancelled || !context.mounted) return;

        if (user != null) {
          final reportSanction = await viewModel.checkSanction();
          if (cancelled || !context.mounted) return;

          if (reportSanction != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (cancelled || !context.mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => CustomConfirmDialog(
                  title: '동숲 이용 제재',
                  content: '${reportSanction.reason}\n${reportSanction.description}\n'
                    '${reportSanction.startDate} ~ ${reportSanction.endDate}',
                  isSingleAction: true,
                  confirmText: '확인',
                  onConfirm: () {
                    if (cancelled || !context.mounted) return;
                    _goNext();
                  },
                ),
              );
            });
          } else {
            if (cancelled || !context.mounted) return;
            _goNext();
          }
          return;
        }

          final message = await viewModel.requestDeviceTokenPreAuthOnce(
            tokenTimeout: const Duration(seconds: 3),
          );
          if (cancelled || !context.mounted) return;

          if (message != null) {
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.white
                  ),
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
        _goNext();
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
                    ? const CircularProgressIndicator(color: ColorStyles.primaryColor)
                    : const SizedBox(height: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
