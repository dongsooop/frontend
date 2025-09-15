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
    this.type,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleMaxWidth = screenWidth / 3 * 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if(!isMe)
          Text(
            nickname,
            style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: isMe
            ? [buildTimestampText(), buildMessageBubble(bubbleMaxWidth)]
            : [buildMessageBubble(bubbleMaxWidth), buildTimestampText()],
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

  // timestamp Text widget
  Widget buildTimestampText() {
    return Text(
      timestamp,
      style: TextStyles.smallTextRegular.copyWith(
        color: ColorStyles.gray3,
      ),
    );
  }
}