import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class ChatbotButton extends StatelessWidget{
  final VoidCallback onTap;

  const ChatbotButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: ColorStyles.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '무엇이든\n물어봐요',
            style: TextStyles.smallTextBold.copyWith(color: ColorStyles.white,),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 56,
            height: 56,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(shape: BoxShape.circle,),
            child: Image.asset(
              'assets/images/chatbot.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}