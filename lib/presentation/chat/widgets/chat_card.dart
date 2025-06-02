import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class ChatCard extends StatefulWidget {
  final UiChatRoom chatRoom;

  const ChatCard({
    super.key,
    required this.chatRoom,
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
                      Expanded(
                        child: Text(
                          '채팅방 이름: 추후 백엔드가 줄 거임',
                          style: TextStyles.normalTextBold.copyWith(
                              color: ColorStyles.black
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        widget.chatRoom.participantCount,
                        style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   widget.chat.tag, // 마지막으로 수신된 메시지(미리 보기)
                  //   style: TextStyles.smallTextRegular.copyWith(
                  //       color: ColorStyles.gray4
                  //   ),
                  // )
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
                  widget.chatRoom.lastActivityText,
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
                      '1',
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
