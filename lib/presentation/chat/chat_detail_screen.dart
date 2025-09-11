import 'package:dongsoop/presentation/chat/chat_bubble_screen.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class ChatDetailScreen extends HookConsumerWidget {
  final String roomId;

  const ChatDetailScreen({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider
    final messages = ref.watch(chatMessagesProvider);
    final blockStatus = ref.watch(chatBlockProvider);
    final user = ref.watch(userSessionProvider);
    final chatDetailState = ref.watch(chatDetailViewModelProvider);
    final viewModel = ref.read(chatDetailViewModelProvider.notifier);

    // 사용자
    final String? userNickname = user?.nickname;
    final int? userId = user?.id;

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      Future.microtask(() async {
        viewModel.resetLeaveFlag();
        // 채팅방 참여자 정보
        await viewModel.fetchNicknames(roomId);
        // 서버 메시지 저장
        await viewModel.fetchOfflineMessages(roomId);
        // 로컬 정보 불러오기
        await ref.read(chatMessagesProvider.notifier).loadChatInitial(roomId);
        await viewModel.getRoomDetail(roomId);
        // 차단
        final current = ref.read(chatDetailViewModelProvider);
        final isGroup = current.roomDetail?.groupChat ?? false;
        final participantsLength = current.roomDetail?.participants.length ?? 0;
        if (!isGroup && userId != null && participantsLength > 1) viewModel.getOtherUserId(userId);
        // 채팅방 연결
        viewModel.enterRoom(roomId);
      });

      return () {
        Future.microtask(() {
          viewModel.closeChatRoom(roomId);
        });
      };
    }, []);

    useEffect(() {
      if (blockStatus != 'NONE') {
        Future.microtask(() async {
          await viewModel.disconnectSocketOnly(roomId);
        });
      }
      return null;
    }, [blockStatus]);

    useEffect(() {
      if (chatDetailState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '채팅 오류',
              content: chatDetailState.errorMessage!,
              onConfirm: () {
                context.pop();
                context.pop(true);
              },
              confirmText: '확인',
              dismissOnConfirm: false,
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [chatDetailState.errorMessage]);

    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent - 100) {
        ref.read(chatMessagesProvider.notifier).loadMore();
      }
    });

    if (chatDetailState.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: DetailHeader(
          title: '',
          backgroundColor: ColorStyles.gray1,
        ),
        body: Center(
          child: CircularProgressIndicator(color: ColorStyles.primaryColor,),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorStyles.gray1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          backgroundColor: ColorStyles.gray1,
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(
                  chatDetailState.roomDetail?.title ?? '',
                  style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                ),
                Text(
                  chatDetailState.nicknameMap.length.toString(),
                  style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray3),
                ),
              ],
            ),
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
          actions: [
            IconButton(
              onPressed: () {
                customActionSheet(
                  context,
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (_) => CustomConfirmDialog(
                        title: '채팅방 나가기',
                        content: '채팅방을 나가면 다시 참여할 수 없어요.\n정말로 나가시겠어요?',
                        confirmText: '나가기',
                        cancelText: '취소',
                        onConfirm: () async {
                          await viewModel.leaveChatRoom(roomId);
                          context.pop(true);
                        },
                      ),
                    );
                  },
                  deleteText: '채팅방 나가기',
                  onBlock: chatDetailState.otherUserId != null && blockStatus != 'I_BLOCKED'
                    ? () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomConfirmDialog(
                          title: '차단',
                          content: '차단한 사용자와 1:1 채팅 및\n게시글 열람은 불가능해요.\n그래도 차단하시겠어요?',
                          confirmText: '확인',
                          cancelText: '취소',
                          onConfirm: () async {
                            await viewModel.userBlock(userId!, chatDetailState.otherUserId!);
                          },
                        ),
                      );
                    }
                  : null,
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/kebab_menu.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  ColorStyles.black,
                  BlendMode.srcIn,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: blockStatus == 'I_BLOCKED' && !chatDetailState.roomDetail!.groupChat
        ? SafeArea(
          child: Container(
              height: 64,
              width: double.infinity,
              color: ColorStyles.white,
              child: Center(
                child: Text(
                  '차단한 사용자와는 채팅을 할 수 없어요',
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
                        final nickname = viewModel.getNickname(msg.senderId.toString());
                        return ChatBubbleScreen(
                          nickname,
                          msg.senderId,
                          msg.content,
                          formatTimestamp(msg.timestamp),
                          nickname == userNickname,
                          msg.type,
                          () async {
                            if (chatDetailState.roomDetail!.managerId != userId) return;
                            // 채팅 내보내기(관리자 == 사옹자)
                            customActionSheet(
                              context,
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CustomConfirmDialog(
                                    title: '채팅 내보내기',
                                    content: '퇴장한 채팅방은 다시 참여할 수 없어요.\n정말로 내보내시겠어요?',
                                    confirmText: '내보내기',
                                    cancelText: '취소',
                                    onConfirm: () async {
                                      await viewModel.kickUser(msg.roomId, msg.senderId);
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                    },
                                  ),
                                );
                              },
                              deleteText: '채팅 내보내기',
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ),
                if (blockStatus != 'I_BLOCKED') ...[
                  Container(
                    width: double.infinity,
                    height: 52,
                    margin: EdgeInsets.only(top: 16, bottom: 24),
                    padding: EdgeInsets.only(left: 16, right: 8),
                    decoration: ShapeDecoration(
                        color: ColorStyles.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
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
                            onPressed: () {
                              if (blockStatus == 'BLOCKED_BY_OTHER') return;

                              final content = textController.text.trim();
                              if (content.isNotEmpty) {
                                final message = ChatMessageRequest(
                                  roomId: roomId,
                                  content: content,
                                  type: 'CHAT',
                                );
                                viewModel.send(message);
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
                        )
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}