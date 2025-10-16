import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/providers/splash_providers.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SplashScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashViewModelProvider);
    final viewModel = ref.read(splashViewModelProvider.notifier);

    useEffect(() {
      Future(() async {
        await Future.delayed(Duration(seconds: 2));
        // 자동 로그인
        await viewModel.autoLogin();

        // 제재 대상 확인
        final user = ref.watch(userSessionProvider);
        if (user != null) {
          final reportSanction = await viewModel.checkSanction();
          if (reportSanction != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => CustomConfirmDialog(
                  title: '동숲 이용 제재',
                  content: '${reportSanction.reason}\n${reportSanction.description}\n'
                    '${reportSanction.startDate} ~ ${reportSanction.endDate}',
                  isSingleAction: true,
                  confirmText: '확인',
                  onConfirm: () async {
                    Future.microtask(() => context.go(RoutePaths.home));
                  },
                ),
              );
            });
          } else {
            Future.microtask(() => context.go(RoutePaths.home));
          }
        }
        if (user == null) {
          final message = await viewModel.requestDeviceTokenPreAuthOnce(
            tokenTimeout: const Duration(seconds: 2),
          );
          if (message != null && context.mounted) {
            final m = ScaffoldMessenger.of(context);
            m.removeCurrentSnackBar();
            m.showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.white
                  ),
                ),
                backgroundColor: Color(0xFFAC0903),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                elevation: 4,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (!context.mounted) return;
          context.go(RoutePaths.home);
        }
      });
      return null;
    }, []);

    if (splashState.errorMessage != null) {
      return Center(
        child: Text(
          splashState.errorMessage!,
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        ),
      );
    }

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
                  ? CircularProgressIndicator(color: ColorStyles.primaryColor)
                  : SizedBox(height: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
