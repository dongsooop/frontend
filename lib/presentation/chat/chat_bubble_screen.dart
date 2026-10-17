import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class ChatBubbleScreen extends StatelessWidget {
  final String nickname;
  final int senderId;
  final String message;
  final String timestamp;
  final bool isMe;
  final String type;
  final VoidCallback? onNicknameTap;
  final VoidCallback? onLongPress;

  const ChatBubbleScreen({
    super.key,
    required this.nickname,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.isMe,
    required this.type,
    this.onNicknameTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleMaxWidth = screenWidth / 3 * 2;
    final isInformation = type != 'CHAT';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: isInformation
          ? CrossAxisAlignment.center
          : isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        if (!isInformation && !isMe)
          GestureDetector(
            onTap: onNicknameTap,
            behavior: HitTestBehavior.translucent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 32, // Material Guideline 최소 터치영역 권장 크기
                minHeight: 32,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  nickname,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: isInformation
              ? [buildInformationBubble(bubbleMaxWidth)]
              : isMe
                  ? [buildTimestampText(), buildMessageBubble(bubbleMaxWidth)]
                  : [buildMessageBubble(bubbleMaxWidth), buildTimestampText()],
        ),
      ],
    );
  }

  Widget buildMessageBubble(double bubbleMaxWidth) {
    final bubble = Container(
      decoration: BoxDecoration(
        color: isMe ? ColorStyles.white : ColorStyles.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        message,
        style: TextStyles.normalTextRegular.copyWith(
          color: isMe ? ColorStyles.black : ColorStyles.white,
        ),
      ),
    );

    if (onLongPress == null) return bubble;

    return Semantics(
      button: true,
      hint: '길게 눌러 메시지 메뉴 열기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: onLongPress,
        child: bubble,
      ),
    );
  }

  // timestamp Text widgets
  Widget buildTimestampText() {
    return Text(
      timestamp,
      style: TextStyles.smallTextRegular.copyWith(
        color: ColorStyles.gray3,
      ),
    );
  }

  Widget buildInformationBubble(double bubbleMaxWidth) {
    final String information = type == 'DATE'
        ? message
        : type == 'ENTER'
            ? '$nickname님이 입장하셨습니다.'
            : '$nickname님이 채팅방을 나갔습니다.';

    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.gray2,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        information,
        style: TextStyles.smallTextRegular.copyWith(
          color: ColorStyles.gray4,
        ),
      ),
    );
  }
}
