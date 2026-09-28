import 'dart:ui';
import 'package:dongsoop/core/presentation/components/category_tab_bar.dart';
import 'package:dongsoop/domain/chat/model/chat_room.dart';
import 'package:dongsoop/presentation/chat/widgets/chat_card.dart';
import 'package:dongsoop/providers/activity_context_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'chat_view_model.dart';

class ChatScreen extends HookConsumerWidget {
  final Future<bool> Function(String roomId) onTapChatDetail;
  final VoidCallback onTapBlindDate;
  final VoidCallback onTapSignIn;

  const ChatScreen({
    super.key,
    required this.onTapChatDetail,
    required this.onTapBlindDate,
    required this.onTapSignIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);
    final chatState = ref.watch(chatViewModelProvider);

    useEffect(() {
      bool disposed = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (disposed) return;
        final notifier = ref.read(activeChatListContextProvider.notifier);
        if (notifier.state != true) notifier.state = true;
      });
      return () {
        disposed = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final notifier = ref.read(activeChatListContextProvider.notifier);
          if (notifier.state != false) notifier.state = false;
        });
      };
    }, const []);

    // 오류
    useEffect(() {
      if (chatState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '채팅',
              content: chatState.errorMessage!,
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [chatState.errorMessage]);

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
      if (user != null) {
        Future.microtask(() async {
          await viewModel.loadChatRooms();
          // 웹소켓 연결
          viewModel.connectChatRoom(user.id);
        });
      } else {
        Future.microtask(() {
          viewModel.resetChatRooms();
        });
      }
      return null;
    }, [user]);

    useEffect(() {
      if (user != null) {
        Future.microtask(() async {
          // 웹소켓 연결
          viewModel.connectChatRoom(user.id);
        });
      }
      return () {
        if (user != null) {
          Future.microtask(() {
            viewModel.closeChatList();
          });
        }
      };
    }, [user]);

    // 로딩 상태 표시
    if (chatState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorStyles.primaryColor,)
      );
    }

    final allRooms = chatState.chatRooms ?? [];

    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorStyles.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16,),
              child: _buildChatBody(context, allRooms, viewModel),
            ),
          ),
        ),
        if (user == null) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.6, sigmaY: 1.4),
              child: Container(
                color: Colors.black.withAlpha((255 * 0.3).round()),
              ),
            ),
            Center(
              child: CustomConfirmDialog(
                title: '로그인이 필요해요',
                content: '해당 서비스는 로그인이 필요해요.\n로그인 페이지로 이동할까요?',
                isSingleAction: true,
                confirmText: '확인',
                dismissOnConfirm: false,
                onConfirm: onTapSignIn,
              ),
            ),
          ],
      ]
    );
  }

  Widget _buildChatBody(BuildContext context, List<ChatRoom> rooms, ChatViewModel viewModel,) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: _ChatRoomList(
                rooms: rooms,
                viewModel: viewModel,
                onTapChatDetail: onTapChatDetail,
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Center(
            child: CategoryTabBar(
              tabs: const ['채팅', '과팅'],
              selectedIndex: 0,
              onSelected: (i) {
                if (i == 0) return;

                Future.microtask(() async {
                  final result = await viewModel.isOpened();
                  if (result && context.mounted) {
                    onTapBlindDate();
                  }
                });
              },
              isBoard: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatRoomList extends StatelessWidget {
  final List<ChatRoom> rooms;
  final ChatViewModel viewModel;
  final Future<bool> Function(String roomId) onTapChatDetail;

  const _ChatRoomList({
    required this.rooms,
    required this.viewModel,
    required this.onTapChatDetail,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorStyles.primaryColor,
      onRefresh: () async => viewModel.loadChatRooms(),
      child: rooms.isEmpty
        ? Center(
          child: Text(
            '참여 중인 채팅방이 없어요',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.only(top: 24),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                final isLeaved = await onTapChatDetail(room.roomId);
                if (isLeaved) await viewModel.loadChatRooms();
              },
              child: ChatCard(chatRoom: room),
            );
          },
        ),
    );
  }
}
