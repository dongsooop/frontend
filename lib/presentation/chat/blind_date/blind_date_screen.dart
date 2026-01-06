import 'package:dongsoop/core/presentation/components/category_tab_bar.dart';
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

    final isJoining = useRef(false);

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
          padding: EdgeInsets.only(top: 24,),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: _joinBlindDateButton(
                  onTap: (chatState.isLoading || isJoining.value)
                    ? null
                    : () async {
                      if (isJoining.value) return;
                      isJoining.value = true;

                      try {
                        final result = await viewModel.isOpened();
                        if (result && context.mounted) {
                          onTapBlindDateDetail();
                        }
                      } finally {
                        isJoining.value = false;
                      }
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Center(
                  child: CategoryTabBar(
                    tabs: const ['채팅', '과팅'],
                    selectedIndex: 1,
                    onSelected: (i) {
                      if (i == 1) return;

                      Future.microtask(() async {
                        onTapChat();
                      });
                    },
                    isBoard: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _joinBlindDateButton({
    required VoidCallback? onTap,
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