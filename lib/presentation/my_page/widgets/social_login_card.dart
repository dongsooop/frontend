import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class SocialLoginCard extends StatelessWidget {
  final LoginPlatform platform;
  final bool isConnected;
  final String? connectedDate;
  final VoidCallback onTap;

  const SocialLoginCard({
    super.key,
    required this.platform,
    required this.isConnected,
    this.connectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final socialImg = switch (platform) {
      LoginPlatform.kakao => 'assets/images/kakao_symbol.png',
      LoginPlatform.google => 'assets/images/google_symbol.png',
      LoginPlatform.apple => 'assets/images/apple_symbol.png',
    };

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              socialImg,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 24,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  platform.label,
                  style: TextStyles.largeTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                if (isConnected && connectedDate != null)
                  Text(
                    connectedDate! + ' 연동됨',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isConnected ? null : ColorStyles.primaryColor,
                border: isConnected ? Border.all(color: ColorStyles.warning100) : null,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                isConnected ? '연동 해제' : '연동하기',
                style: TextStyles.smallTextBold.copyWith(
                  color: isConnected ? ColorStyles.warning100 : ColorStyles.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
