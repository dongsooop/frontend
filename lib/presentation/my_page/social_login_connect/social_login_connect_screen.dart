import 'package:dongsoop/presentation/my_page/widgets/social_login_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/providers/activity_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';

class SocialLoginConnectScreen extends HookConsumerWidget {
  const SocialLoginConnectScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialLoginState = ref.watch(socialLoginConnectUserViewModelProvider);
    final viewModel = ref.read(socialLoginConnectUserViewModelProvider.notifier);

    final items = socialLoginState.items;

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadList();
      });
      return null;
    }, []);

    // 오류
    useEffect(() {
      if (socialLoginState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '소셜 계정 연동 오류',
              content: socialLoginState.errorMessage!,
              onConfirm: () async {
              },
            ),
          );
        });
      }
      return null;
    }, [socialLoginState.errorMessage]);

    // 로딩 상태 표시
    if (socialLoginState.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.white,
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: ColorStyles.primaryColor,),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '소셜 계정 연동',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 32),
            itemBuilder: (context, index) {
              final item = items[index];
              return SocialLoginCard(
                platform: item.platform,
                isConnected: item.isConnected,
                connectedDate: item.connectedDate,
                onTap: () => viewModel.socialConnect(item.platform),
              );
            },
          ),
        ),
      ),
    );
  }
}
