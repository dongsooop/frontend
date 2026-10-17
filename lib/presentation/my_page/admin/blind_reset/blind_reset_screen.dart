import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindResetScreen extends HookConsumerWidget {
  const BlindResetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blindResetViewModelProvider);
    final viewModel = ref.read(blindResetViewModelProvider.notifier);

    useEffect(() {
      final errorMessage = state.errorMessage;
      if (errorMessage == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showDialog<void>(
          context: context,
          builder: (_) => CustomConfirmDialog(
            title: '과팅 참여 정보 리셋 오류',
            content: errorMessage,
            isSingleAction: true,
            confirmText: '확인',
            onConfirm: () {},
          ),
        );
      });
      return null;
    }, [state.errorMessage]);

    useEffect(() {
      if (!state.isSuccess) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomConfirmDialog(
            title: '과팅 참여 정보 리셋 완료',
            content: '과팅 참여 정보를 모두 리셋했어요.',
            isSingleAction: true,
            confirmText: '확인',
            onConfirm: () {
              if (context.mounted) context.pop();
            },
          ),
        );
      });
      return null;
    }, [state.isSuccess]);

    Future<void> confirmReset() async {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomConfirmDialog(
          title: '과팅 참여 정보 리셋',
          content: '저장된 모든 과팅 참여 정보를 삭제할까요?\n삭제한 정보는 되돌릴 수 없어요.',
          cancelText: '취소',
          confirmText: '리셋',
          onConfirm: viewModel.reset,
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '과팅 참여 정보 리셋'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                '과팅 참여 정보를 초기화해요.',
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '현재 저장된 모든 과팅 참여 정보를 삭제합니다. 리셋 후에는 이전 참여 정보를 복구할 수 없어요.',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        label: '리셋하기',
        isLoading: state.isLoading,
        isEnabled: !state.isLoading,
        onPressed: confirmReset,
      ),
    );
  }
}
