import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindDateScreen extends HookConsumerWidget {
  final VoidCallback onTapChat;
  final VoidCallback onTapBlindDateDetail;

  const BlindDateScreen({
    super.key,
    required this.onTapChat,
    required this.onTapBlindDateDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(blindDateViewModelProvider.notifier);
    final chatState = ref.watch(blindDateViewModelProvider);

    useEffect(() {
      if (chatState.isBlindDateOpened != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '과팅 미오픈',
              content: chatState.isBlindDateOpened!,
              onConfirm: () {},
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [chatState.isBlindDateOpened]);

    useEffect(() {
      if (chatState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '과팅 오류',
              content: chatState.errorMessage!,
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [chatState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              SizedBox(
                width: double.infinity,
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    _buildTopTab(label: '채팅', isSelected: false, onTap: onTapChat),
                    _buildTopTab(label: '과팅', isSelected: true, onTap: () {},),
                  ],
                ),
              ),
              _joinBlindDateButton(
                onTap: () async {
                  final result = await viewModel.isOpened();
                  if (result) onTapBlindDateDetail();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? TextStyles.titleTextBold.copyWith(color: ColorStyles.primaryColor,)
                : TextStyles.titleTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ),
      ),
    );
  }

  Widget _joinBlindDateButton({
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: ColorStyles.gray2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '하루에 한 번, 다양한 친구를 사귀어 봐요',
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: ColorStyles.primaryColor,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '지금 과팅 참여하기',
              style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white),
            ),
          ),
        ],
      ),
    );
  }
}