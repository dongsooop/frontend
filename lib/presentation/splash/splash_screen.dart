import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/providers/splash_providers.dart';
import 'package:dongsoop/core/routing/route_paths.dart';

import '../../core/presentation/components/custom_confirm_dialog.dart';
import '../../providers/auth_providers.dart';

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
      });
      return null;
    }, []);

    useEffect(() {
      if (splashState.isSuccessed) {
        Future.microtask(() => context.go(RoutePaths.home));
      }
      return null;
    }, [splashState.isSuccessed]);

    if (splashState.errorMessage != null) {
      return Center(
        child: Text(
          splashState.errorMessage!,
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: Center(
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
                  : SizedBox(height: 0,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}