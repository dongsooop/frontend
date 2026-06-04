import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ChatbotBubble extends StatelessWidget {
  final String text;
  final String? url;
  final bool isMe;
  final bool isLoading;
  final bool isSystem;

  const ChatbotBubble({
    super.key,
    required this.text,
    this.url,
    required this.isMe,
    required this.isLoading,
    this.isSystem = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleMaxWidth = screenWidth * 2 / 3;

    if (isSystem) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorStyles.gray2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: SelectableText(
                text,
                textAlign: TextAlign.center,
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray3),
              ),
            ),
          ),
        ),
      );
    }

    final effectiveIsMe = isLoading ? false : isMe;

    Widget bubble(bool me) => Container(
      decoration: BoxDecoration(
        color: me ? ColorStyles.white : ColorStyles.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child:  isLoading
        ? SizedBox(
          width: 40,
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 16.0,
          ),
        )
        : Column(
          spacing: 16,
          children: [
            SelectableText(
              text,
              style: TextStyles.normalTextRegular.copyWith(
                color: me ? ColorStyles.black : ColorStyles.white,
              ),
            ),
            if (!me && url != null) ...[
              InkWell(
                onTap: () {
                  context.push('/mypageWebView?url=$url&title=챗봇');
                },
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: ShapeDecoration(
                    color: ColorStyles.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: ColorStyles.white,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '사이트 바로가기',
                    textAlign: TextAlign.center,
                    style: TextStyles.normalTextBold.copyWith(color: ColorStyles.primaryColor),
                  ),
                ),
              ),
            ],
          ],
        ),
    );

    if (effectiveIsMe) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: bubble(true)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset('assets/images/chatbot.png', fit: BoxFit.cover),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '동냥이',
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black),
                ),
                const SizedBox(height: 4),
                bubble(false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
