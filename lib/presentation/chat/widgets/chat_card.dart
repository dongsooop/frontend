import 'package:dongsoop/presentation/chat/temp/chat.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class ChatCard extends StatefulWidget {
  final Chat chat;

  const ChatCard({
    super.key,
    required this.chat,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 24),
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/test.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        widget.chat.title,
                        style: TextStyles.normalTextBold.copyWith(
                            color: ColorStyles.black
                        ),
                      ),
                      Text(
                        widget.chat.personnel.toString(),
                        style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.chat.tag,
                    style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray4
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Text(
                  widget.chat.time,
                  style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: ShapeDecoration(
                        color: ColorStyles.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                    child: Text(
                      widget.chat.messegeNum.toString(),
                      style: TextStyles.smallTextBold.copyWith(
                          color: ColorStyles.white
                      ),
                      textAlign: TextAlign.center,
                    )
                )
              ],
            ),
          ],
        )
    );
  }
}
