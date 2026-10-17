import 'package:dongsoop/core/presentation/components/category_tab_bar.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/presentation/chat/blind_date/widgets/blind_date_join_card.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
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
          if (!context.mounted) return;
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
          if (!context.mounted) return;
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: BlindDateJoinCard(
                      isLoading: chatState.isLoading,
                      onPressed: (chatState.isLoading || isJoining.value)
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
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
    );
  }
}
