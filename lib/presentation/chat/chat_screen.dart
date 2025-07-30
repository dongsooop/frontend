import 'dart:ui';

import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/presentation/chat/widgets/chat_card.dart';
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
  final Future<bool> Function(UiChatRoom room) onTapChatDetail;
  final VoidCallback onTapSignIn;

  const ChatScreen({
    super.key,
    required this.onTapChatDetail,
    required this.onTapSignIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);
    final chatState = ref.watch(chatViewModelProvider);

    final selectedTap = useState('채팅');
    final selectedCategory = useState('전체');

    // 오류
    useEffect(() {
      if (chatState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '채팅 오류',
              content: chatState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [chatState.errorMessage]);

    useEffect(() {
      if (user != null) {
        Future.microtask(() async {
          await viewModel.loadChatRooms();
        });
      }
      return null;
    }, [selectedCategory.value]);

    // 로딩 상태 표시
    if (chatState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorStyles.primaryColor,)
      );
    }

    final allRooms = chatState.chatRooms ?? [];

    final filteredRooms = selectedCategory.value == '1:1 채팅'
      ? allRooms.where((room) => room.isGroupChat == false).toList()
      : selectedCategory.value == '그룹 채팅'
        ? allRooms.where((room) => room.isGroupChat == true).toList()
        : allRooms;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorStyles.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: _buildChatBody(context, filteredRooms, selectedTap, selectedCategory, viewModel),
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

  // 상단 탭
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
              ? TextStyles.titleTextBold.copyWith(
                color: ColorStyles.primaryColor,
              )
              : TextStyles.titleTextRegular.copyWith(
                color: ColorStyles.gray4,
              ),
          ),
        ),
      ),
    );
  }

  // 채팅 카테고리 선택
  Widget _buildCategoryTab({
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
          child: isSelected
            ? IntrinsicWidth(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorStyles.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                label,
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          )
              : Text(
            label,
            style: TextStyles.largeTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBody(BuildContext context, List<UiChatRoom> rooms, selectedTab, selectedCategory, ChatViewModel viewModel,) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              _buildTopTab(
                label: '채팅', isSelected: selectedTab.value == '채팅', onTap: () => selectedCategory.value = '채팅'
              ),
              // _buildTopTab(
              //   label: '과팅',
              //   },
              // ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // chatting category
        SizedBox(
          width: double.infinity,
          height: 44,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              _buildCategoryTab(label: '전체', isSelected: selectedCategory.value == '전체', onTap: () => selectedCategory.value = '전체'),
              _buildCategoryTab(label: '1:1 채팅', isSelected: selectedCategory.value == '1:1 채팅', onTap: () => selectedCategory.value = '1:1 채팅'),
              _buildCategoryTab(label: '그룹 채팅', isSelected: selectedCategory.value == '그룹 채팅', onTap: () => selectedCategory.value = '그룹 채팅'),
            ],
          ),
        ),
        SizedBox(height: 16),
        // 채팅방
        Expanded(
          child: RefreshIndicator(
            color: ColorStyles.primaryColor,
            onRefresh: () async {
              await viewModel.loadChatRooms();
            },
            child: rooms.isEmpty
              ? ListView()
              : ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () async {
                        final isLeaved = await onTapChatDetail(room);
                        if (isLeaved) {
                          await viewModel.loadChatRooms();
                        }
                      },
                      child: ChatCard(chatRoom: room),
                    );
                  }
                ),
          ),
        ),
      ],
    );
  }
}
