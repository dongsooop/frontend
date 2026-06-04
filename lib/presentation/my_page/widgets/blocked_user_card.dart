import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class BlockedUserCard extends StatelessWidget {
  final String nickname;

  const BlockedUserCard({
    super.key,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/profile.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            nickname,
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      )
    );
  }
}
