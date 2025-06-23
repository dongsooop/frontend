import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class ChatBubbleScreen extends StatelessWidget {
  const ChatBubbleScreen(
    this.nickname,
    this.message,
    this.timestamp,
    this.isMe,
    this.type,
    {super.key}
  );

  final String nickname;
  final String message;
  final String timestamp;
  final bool isMe;
  final String type;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleMaxWidth = screenWidth / 3 * 2;
    final bool isInformation = type != 'CHAT' ? true : false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: isInformation ? CrossAxisAlignment.center
        : isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if(!isInformation && !isMe)
          Text(
            nickname,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.black
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: isInformation ? [buildInformationBubble(bubbleMaxWidth)]
            : isMe
            ? [buildTimestampText(), buildMessageBubble(bubbleMaxWidth)]
            : [buildMessageBubble(bubbleMaxWidth), buildTimestampText()]
        ),
      ],
    );
  }

  Widget buildMessageBubble(double bubbleMaxWidth) {
    return Container(
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
