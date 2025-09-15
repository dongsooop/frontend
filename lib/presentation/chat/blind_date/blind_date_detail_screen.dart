import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
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

  const BlindDateDetailScreen({
    super.key,
  });

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
    final String nickname = '익명 3';

    final textController = useTextEditingController();
    final scrollController = useScrollController();

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
      if (state.nickname != '') {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // 한 프레임 뒤에서 바텀시트 실행 필요
          await MatchVoteBottomSheet.show(
            context,
            participants: state.participants,
            currentUserId: userId!,
            onSubmit: (selected) async {
              print('selected: $selected');
              // selected == null 이면 미선택
              // 서버 전송 로직 작성
              // await repo.sendVote(selected);
            },
            seconds: 10, // 기본 10초
          );
        });
      }
      return null;
    }, [state.participants]);

    // useEffect(() {
    //   if (state.errorMessage != null) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (_) => CustomConfirmDialog(
    //           title: '과팅 오류',
    //           content: state.errorMessage!,
    //           onConfirm: () {
    //             context.pop();
    //             context.pop();
    //           },
    //           confirmText: '확인',
    //           dismissOnConfirm: false,
    //           isSingleAction: true,
    //         ),
    //       );
    //     });
    //   }
    //   return null;
    // }, [state.errorMessage]);

    // if (state.isLoading) {
    //   return Scaffold(
    //     backgroundColor: ColorStyles.white,
    //     appBar: DetailHeader(
    //       title: '',
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         spacing: 8,
    //         children: [
    //           CircularProgressIndicator(color: ColorStyles.primaryColor,),
    //           SizedBox(height: 16,),
    //           Text(
    //             '참여자를 모집하고 있어요...',
    //             style: TextStyles.normalTextRegular.copyWith(
    //               color: ColorStyles.black,
    //             ),
    //           ),
    //           Text(
    //             '${state.participants.toString()}/7',
    //             style: TextStyles.normalTextBold.copyWith(
    //               color: ColorStyles.black,
    //             ),
    //           ),
    //         ],
    //       )
    //     ),
    //   );
    // }

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
                style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
              ),
              Text(
                state.participants.length.toString(),
                style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray3),
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
            margin: EdgeInsets.only(top: 24),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.separated(
                      reverse: true, // 리스트 아이템을 역순으로 배치
                      shrinkWrap: true, // 상단 배치(Align)
                      controller: scrollController, // 스크롤 위치 컨트롤러
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                            decoration: InputDecoration(border: InputBorder.none,),
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
                                  sessionId: state.sessionId!,
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