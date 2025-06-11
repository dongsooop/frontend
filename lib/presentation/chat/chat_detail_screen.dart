import 'package:dongsoop/presentation/chat/chat_bubble_screen.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/utils/formatter.dart';
import 'package:dongsoop/domain/chat/model/chat_message_request.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';

class ChatDetailScreen extends HookConsumerWidget {
  final UiChatRoom chatRoom;

  const ChatDetailScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider
    final messages = ref.watch(chatMessagesProvider);
    final user = ref.watch(userSessionProvider);
    final viewModel = ref.read(chatDetailViewModelProvider.notifier);
    final chatDetailState = ref.watch(chatDetailViewModelProvider);

    // 사용자 닉네임
    final String? userNickname = user?.nickname;

    // text field controller
    final textController = useTextEditingController();
    // scroll controller
    final scrollController = useScrollController();

    useEffect(() {
      // 채팅방 입장 시: 로컬 정보 가져옴(참여자 정보, 메시지), 소켓 연결
      Future.microtask(() {
        // 채팅방 참여자 정보
        viewModel.fetchNicknames(chatRoom.roomId);
        // 로컬 메시지 불러오기
        viewModel.getAllChatMessages(chatRoom.roomId);
        // 채팅방 연결
        viewModel.enterRoom(chatRoom.roomId);
      });

      return () {
        Future.microtask(() {
          viewModel.leaveRoom();
        });
      };
    }, []);

    if (chatDetailState.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.chevron_left_outlined,
                size: 24,
                color: ColorStyles.black,
              ),
            ),
          )
        ),
        body: Center(
          child: CircularProgressIndicator(color: ColorStyles.primaryColor,),
        ),
      );
    }

    if (chatDetailState.errorMessage != null) {
      return Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.chevron_left_outlined,
                size: 24,
                color: ColorStyles.black,
              ),
            ),
          )
        ),
        body: Center(
          child: Text(
            chatDetailState.errorMessage!,
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 가상 키보드가 나타날 때 Scattold가 자동으로 크기를 조정하여 가상 키보드와 겹치지 않도록 함
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
                    '채팅방 이름', // 채팅방 이름
                    style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                  ),
                  Text(
                    chatRoom.participantCount, // 채팅방 이름
                    style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray3),
                  ),
                ],
              ),
              leading: IconButton(
                onPressed: () {
                  context.pop();
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
                    // 메뉴 선택 메소드 실행
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
            )
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 24),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus(); // 채팅 리스트 터치 시 가상 키보드 숨기기
                  },
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
                          msg.content,
                          formatTimestamp(msg.timestamp),
                          nickname == userNickname,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 52,
                margin: EdgeInsets.only(top: 16),
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
                          // 메시지 전송
                          final content = textController.text.trim();
                          if (content.isNotEmpty) {
                            final roomId = chatRoom.roomId;
                            final message = ChatMessageRequest(
                              roomId: roomId,
                              content: content,
                              type: 'CHAT',
                              senderNickName: user?.nickname,
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
            ],
          ),
        ),
      ),
    );
  }
}