import 'package:dongsoop/presentation/my_page/widgets/my_activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class LoggedOutPromptCard extends StatelessWidget {
  final VoidCallback onTapLogin;
  final VoidCallback onTapUserFeedback;

  const LoggedOutPromptCard({
    super.key,
    required this.onTapLogin,
    required this.onTapUserFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: ColorStyles.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '로그인으로 더 많은 동숲을 즐겨봐요',
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onTapLogin,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorStyles.primaryColor,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/logo.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '동숲 로그인하기',
                        style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            decoration: ShapeDecoration(
              color: ColorStyles.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyActivityItem(
              label: '피드백 하러가기',
              onTap: onTapUserFeedback,
            ),
          ),
        ],
      ),
    );
  }
}