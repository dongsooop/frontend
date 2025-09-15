import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BlindBubble extends StatelessWidget {
  final String nickname;
  final String message;
  final String timestamp;
  final bool isMe;
  final String type;

  const BlindBubble(
    this.nickname,
    this.message,
    this.timestamp,
    this.isMe,
    this.type, {
      super.key,
  });

  bool get isSystem => type == 'SYSTEM';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleMaxWidth = screenWidth * 2 / 3;

    // 시스템 메시지 레이아웃 (왼쪽 아바타 + 닉네임 + 버블 + 시간)
    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 40x40 원형 이미지
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                'assets/images/chatbot.png', // 원하는 이미지 경로로
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            // 닉네임 + 버블
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Flexible로 감싸 폭 초과 방지
                  Flexible(child: buildMessageBubble(bubbleMaxWidth, me: false)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 시간 (버블 하단 정렬 느낌)
            Align(
              alignment: Alignment.bottomCenter,
              child: buildTimestampText(),
            ),
          ],
        ),
      );
    }

    // 기존 일반/내 메시지 레이아웃
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe)
          Text(
            nickname,
            style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black),
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: isMe
              ? [buildTimestampText(), const SizedBox(width: 8), buildMessageBubble(bubbleMaxWidth, me: true)]
              : [buildMessageBubble(bubbleMaxWidth, me: false), const SizedBox(width: 8), buildTimestampText()],
        ),
      ],
    );
  }

  Widget buildMessageBubble(double bubbleMaxWidth, {required bool me}) {
    return Container(
      decoration: BoxDecoration(
        color: me ? ColorStyles.white : ColorStyles.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        message,
        style: TextStyles.normalTextRegular.copyWith(
          color: me ? ColorStyles.black : ColorStyles.white,
        ),
      ),
    );
  }

  Widget buildTimestampText() {
    return Text(
      timestamp,
      style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray3),
    );
  }
}
