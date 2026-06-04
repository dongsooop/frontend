import 'package:dongsoop/presentation/my_page/widgets/blocked_user_card.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/providers/activity_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class BlockedUserScreen extends HookConsumerWidget {
  const BlockedUserScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final blockedUserState = ref.watch(blockedUserViewModelProvider);
    final viewModel = ref.read(blockedUserViewModelProvider.notifier);

    final list = blockedUserState.list ?? [];

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadList();
      });
      return null;
    }, []);

    // 오류
    useEffect(() {
      if (blockedUserState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '마이페이지 오류',
              content: blockedUserState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [blockedUserState.errorMessage]);

    // 로딩 상태 표시
    if (blockedUserState.isLoading) {
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
        title: '차단 관리',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: list.isEmpty
          ? Center(
            child: Text(
              '차단한 사용자가 없어요',
              style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            ),
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final blockedUser = list[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () async {
                        customActionSheet(
                          context,
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (_) => CustomConfirmDialog(
                                title: '차단 해제',
                                content: '해당 사용자의 차단을 해제할까요?',
                                confirmText: '확인',
                                cancelText: '취소',
                                onConfirm: () async {
                                  if (user == null) return;
                                  await viewModel.unBlock(user.id, blockedUser.blockedMemberId);
                                  await viewModel.loadList();
                                },
                              ),
                            );
                          },
                          deleteText: '차단 해제',
                        );
                      },
                      child: BlockedUserCard(nickname: blockedUser.memberName),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
