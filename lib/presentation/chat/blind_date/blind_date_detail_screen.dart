import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_choice.dart';
import 'package:dongsoop/domain/chat/model/blind_date/blind_date_request.dart';
import 'package:dongsoop/presentation/chat/widgets/blind_bubble.dart';
import 'package:dongsoop/presentation/chat/widgets/match_vote_bottom_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindDateDetailScreen extends HookConsumerWidget {
  const BlindDateDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider
    final state = ref.watch(blindDateDetailViewModelProvider);
    final viewModel = ref.read(blindDateDetailViewModelProvider.notifier);

    // message
    final messages = ref.watch(blindDateMessagesProvider);

    // user
    final user = ref.watch(userSessionProvider);
    final int? userId = user?.id;

    final textController = useTextEditingController();
    final scrollController = useScrollController();
    final route = ModalRoute.of(context);
    final isVoteSheetOpen = useRef(false);
    final isVoteExitPending = useRef(false);

    void exitBlindDateIfReady() {
      if (!isVoteExitPending.value ||
          !context.mounted ||
          route?.isCurrent != true) return;

      final lifecycleState = WidgetsBinding.instance.lifecycleState;
      if (lifecycleState != null && lifecycleState != AppLifecycleState.resumed)
        return;

      isVoteExitPending.value = false;
      context.pop(true);
    }

    useEffect(() {
      if (userId != null)
        Future.microtask(() {
          viewModel.connect(userId);
        });

      return () async {
        Future.microtask(() => viewModel.disconnect());
      };
    }, const []);

    useEffect(() {
      final listener = AppLifecycleListener(
        onResume: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            exitBlindDateIfReady();
          });
        },
      );
      return listener.dispose;
    }, [route]);

    useEffect(() {
      if (state.nickname != '') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '과팅은 익명으로 진행돼요',
              content: '당신의 닉네임은 "${state.nickname}"입니다.',
              onConfirm: () {},
              confirmText: '확인',
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [state.nickname]);

    useEffect(() {
      if (!state.isVotePreparing || state.isLoading) return null;
      var cancelled = false;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (cancelled ||
            !context.mounted ||
            route?.isActive == false ||
            !scrollController.hasClients) {
          return;
        }
        FocusScope.of(context).unfocus();
        scrollController.jumpTo(0);
        // Let each scrolled message paint before starting its delay.
        WidgetsBinding.instance.scheduleFrame();
        await WidgetsBinding.instance.endOfFrame;
        if (cancelled || !context.mounted || route?.isActive == false) return;
        // A reversed, shrink-wrapped list can correct its offset when it first
        // lays out the newly visible messages. Keep the full announcement visible.
        if (scrollController.offset != 0) {
          scrollController.jumpTo(0);
          WidgetsBinding.instance.scheduleFrame();
          await WidgetsBinding.instance.endOfFrame;
          if (cancelled || !context.mounted || route?.isActive == false) return;
        }
        viewModel.onVoteIntroDisplayed(state.voteIntroStage);
      });
      return () => cancelled = true;
    }, [state.voteIntroStage, state.isLoading]);

    useEffect(() {
      if (state.isVoteTime && !isVoteSheetOpen.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted ||
              route?.isActive == false ||
              !ref.read(blindDateDetailViewModelProvider).isVoteTime) {
            return;
          }
          isVoteSheetOpen.value = true;
          await MatchVoteBottomSheet.show(
            context,
            participants: state.participants,
            currentUserId: userId!,
            onSubmit: (selected) async {
              try {
                final completed = await viewModel.choice(
                  BlindChoice(choicerId: userId, targetId: selected),
                );
                if (!completed) return;
                isVoteExitPending.value = true;
                exitBlindDateIfReady();
              } catch (error) {
                debugPrint('[BlindDate] CHOICE_END_ERROR error=$error');
                if (!context.mounted || route?.isCurrent != true) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('과팅을 마무리하지 못했어요. 연결 상태를 확인해 주세요.'),
                  ),
                );
              }
            },
            seconds: 10,
          );
          isVoteSheetOpen.value = false;
        });
      }
      return null;
    }, [state.isVoteTime]);

    useEffect(() {
      if (state.ended != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          final isTerminated = state.ended == 'ended';
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '과팅 참여',
              content: isTerminated
                  ? '과팅은 하루에 한 번만 참여 가능해요.\n다음 기회를 노려봐요!'
                  : '과팅 참여에 실패했어요.\n잠시 후 다시 시도해 주세요.',
              onConfirm: () {
                context.pop();
                context.pop();
              },
              confirmText: '확인',
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [state.ended]);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: '',
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            CircularProgressIndicator(
              color: ColorStyles.primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '참여자를 모집하고 있어요...',
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.black,
              ),
            ),
            Text(
              '${state.volunteer}/${state.maxCount}',
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.black,
              ),
            ),
          ],
        )),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorStyles.gray1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          backgroundColor: ColorStyles.gray1,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text(
                '모여봐요 동숲',
                style:
                    TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
              ),
              Text(
                '${state.maxCount}',
                style: TextStyles.largeTextRegular
                    .copyWith(color: ColorStyles.gray3),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              context.pop(true);
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 24,
              color: ColorStyles.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      bottomNavigationBar: state.isFrozen
          ? SafeArea(
              child: Container(
                height: 64,
                width: double.infinity,
                color: ColorStyles.gray2,
                child: Center(
                  child: Text(
                    '동냥이가 얘기하는 중에는 채팅을 할 수 없어요',
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.gray4,
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorStyles.warning10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        '안내',
                        style: TextStyles.smallTextBold.copyWith(
                          color: ColorStyles.warning100,
                        ),
                      ),
                      Text(
                        '과팅은 실시간으로 진행돼요.\n채팅방을 떠나는 동안 도착한 메시지는 볼 수 없어요.',
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.warning100,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final msg = messages[index];
                        return BlindBubble(
                          msg.name,
                          msg.message,
                          formatTimestamp(msg.sendAt),
                          msg.memberId == userId,
                          msg.type,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ),

                // 채팅 입력창
                if (!state.isFrozen) ...[
                  Container(
                    width: double.infinity,
                    height: 52,
                    margin: EdgeInsets.only(top: 16, bottom: 24),
                    padding: EdgeInsets.only(left: 16, right: 8),
                    decoration: ShapeDecoration(
                      color: ColorStyles.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLines: null,
                            cursorColor: ColorStyles.gray4,
                            keyboardType: TextInputType.multiline,
                            controller: textController,
                            style: TextStyles.normalTextRegular
                                .copyWith(color: ColorStyles.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 44,
                          width: 44,
                          child: IconButton(
                            onPressed: () async {
                              final message = textController.text.trim();
                              if (message.isNotEmpty) {
                                final send = BlindDateRequest(
                                  message: message,
                                  senderId: userId!,
                                );
                                viewModel.send(send);
                                textController.clear();
                                // 스크롤 맨 아래로 이동
                                scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/send.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                ColorStyles.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
