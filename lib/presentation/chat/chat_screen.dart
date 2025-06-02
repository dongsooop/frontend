import 'dart:ui';

import 'package:dongsoop/presentation/chat/temp/chat_data.dart';
import 'package:dongsoop/presentation/chat/widgets/chat_card.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../main.dart';
import '../../providers/auth_providers.dart';

class ChatScreen extends HookConsumerWidget {
  final VoidCallback onTapChatDetail;

  const ChatScreen({
    super.key,
    required this.onTapChatDetail
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSession = ref.watch(userSessionProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);

    useEffect(() {
      if (userSession != null) {
        Future.microtask(() {
          viewModel.loadChatRooms();
        });
      }
      return null;
    }, [userSession]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: _buildChatBody(context, ref),
            ),
            if (userSession == null) _buildUnauthenticatedBody(),
          ],
        ),
      ),
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
      child: SizedBox(
        width: 44,
        height: 44,
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
  Widget _buildChatCategoryTab({
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

  // 로그인 X 사용자
  Widget _buildUnauthenticatedBody() {
    return Positioned.fill(
      child: Stack(
        children: [
          // 블러 처리
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.6, sigmaY: 1.6),
            child: Container(
              color: ColorStyles.black.withAlpha(0),
            ),
          ),
          Center(
            child: Text(
              '로그인이 필요한 서비스입니다.',
              textAlign: TextAlign.center,
              style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black)
            ),
          )
        ],
      ),
    );
  }

  // 로그인한 사용자
  Widget _buildChatBody(BuildContext context, WidgetRef ref) {
    String selectedMode = '채팅';
    String selectedCategory = '전체';
    final chatState = ref.watch(chatViewModelProvider);

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
                label: '채팅',
                isSelected: selectedMode == '채팅',
                onTap: () {
                  // setState(() {
                  //   selectedMode = '채팅';
                  // });
                },
              ),
              _buildTopTab(
                label: '과팅',
                isSelected: selectedMode == '과팅', // 추후 기능 개발
                onTap: () {
                  // 추후 기능 개발
                  // setState(() {
                  //   selectedMode = '채팅';
                  // });
                },
              ),
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
              _buildChatCategoryTab(
                label: '전체',
                isSelected: selectedCategory == '전체',
                onTap: () {
                  // setState(() {
                  //   selectedCategory = '전체';
                  // });
                },
              ),
              _buildChatCategoryTab(
                label: '모집',
                isSelected: selectedCategory == '모집',
                onTap: () {
                  // setState(() {
                  //   selectedCategory = '모집';
                  // });
                },
              ),
              _buildChatCategoryTab(
                label: '장터',
                isSelected: selectedCategory == '장터',
                onTap: () {
                  // setState(() {
                  //   selectedCategory = '장터';
                  // });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // 채팅방
        Expanded(
          child: chatState.when(
            data: (chatRooms) {
              if (chatRooms == null || chatRooms.isEmpty) {
                return const SizedBox();
              } else {
                return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    final room = chatRooms[index];
                    return GestureDetector(
                      onTap: onTapChatDetail,
                      child: ChatCard(chatRoom: room),
                    );
                  },
                );
              }
            },
            error: (e, _) => Center(child: Text('$e', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),)),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        )
      ],
    );
  }
}
