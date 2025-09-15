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

  bool get _isSystem => type.toUpperCase() == 'SYSTEM';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleMaxWidth = screenWidth * 2 / 3;

    final body = _bubbleColumn(bubbleMaxWidth);

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isSystem && !isMe) ...[
          _avatar(),
          const SizedBox(width: 8),
        ],
        Expanded(child: body),
        if (_isSystem && isMe) ...[
          const SizedBox(width: 8),
          _avatar(),
        ],
      ],
    );
  }

  Widget _avatar() {
    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset('assets/images/chatbot.png', fit: BoxFit.cover),
    );
  }

  Widget _bubbleColumn(double bubbleMaxWidth) {
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
        _messageLine(bubbleMaxWidth),
      ],
    );
  }

  Widget _messageLine(double bubbleMaxWidth) {
    final bubble = Flexible(
      fit: FlexFit.loose,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
        child: _messageBubble(),
      ),
    );
    final time = _timestampText();

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: isMe
        ? [time, const SizedBox(width: 8), bubble]
        : [bubble, const SizedBox(width: 8), time],
    );
  }

  Widget _messageBubble() {
    return Container(
      decoration: BoxDecoration(
        color: isMe ? ColorStyles.white : ColorStyles.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        message,
        softWrap: true,
        style: TextStyles.normalTextRegular.copyWith(
          color: isMe ? ColorStyles.black : ColorStyles.white,
        ),
      ),
    );
  }

  Widget _timestampText() {
    return Text(
      timestamp,
      style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray3),
    );
  }
}