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

class ChatScreen extends HookConsumerWidget {
  final void Function(UiChatRoom room) onTapChatDetail;

  const ChatScreen({
    super.key,
    required this.onTapChatDetail
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSession = ref.watch(userSessionProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);
    final chatState = ref.watch(chatViewModelProvider);

    final selectedCategory = useState('전체');

    useEffect(() {
      if (userSession != null) {
        Future.microtask(() {
          viewModel.loadChatRooms();
        });
      }
      return null;
    }, [userSession]);

    if (chatState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorStyles.primaryColor,)
      );
    }

    if (chatState.errorMessage != null) {
      return Center(
        child: Text(
          chatState.errorMessage!,
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        )
      );
    }

    final allRooms = chatState.chatRooms ?? [];

    final filteredRooms = selectedCategory.value == '1:1 채팅'
        ? allRooms.where((room) => room.isGroupChat == false).toList()
        : selectedCategory.value == '그룹 채팅'
          ? allRooms.where((room) => room.isGroupChat == true).toList()
          : allRooms;


    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: _buildChatBody(context, filteredRooms, selectedCategory),
            ),
            SizedBox(height: 16,),
            // local data delete test
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: ColorStyles.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                await viewModel.localDataDelete();
              },
              child: Text('로컬 데이터 삭제', style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white)),
            ),
            if (userSession == null) _buildUnauthenticatedBody(),
          ],
        ),
      ),
    );
  }

  // 상단 탭
  // Widget _buildTopTab({
  //   required String label,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: SizedBox(
  //       width: 44,
  //       height: 44,
  //       child: Center(
  //         child: Text(
  //           label,
  //           style: isSelected
  //               ? TextStyles.titleTextBold.copyWith(
  //             color: ColorStyles.primaryColor,
  //           )
  //               : TextStyles.titleTextRegular.copyWith(
  //             color: ColorStyles.gray4,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
  Widget _buildChatBody(BuildContext context, List<UiChatRoom> rooms, selectedCategory) {
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
              // _buildTopTab(
              //   label: '채팅',
              // ),
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
          child: rooms.isEmpty
            ? const SizedBox()
            : ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return GestureDetector(
                    onTap: () => onTapChatDetail(room),
                    child: ChatCard(chatRoom: room),
                  );
                }
              ),
        ),
      ],
    );
  }
}
