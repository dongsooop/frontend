import 'package:dongsoop/presentation/my_page/widgets/my_activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class LoggedOutPromptCard extends StatelessWidget {
  final VoidCallback onTapLogin;
  final VoidCallback onTapNotification;
  final VoidCallback onTapSubscribeDepartment;
  final VoidCallback onTapUserFeedback;

  const LoggedOutPromptCard({
    super.key,
    required this.onTapLogin,
    required this.onTapNotification,
    required this.onTapSubscribeDepartment,
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

          const SizedBox(height: 24),

          _section(
            items: [
              MyActivityItem(
                label: '알림 설정',
                description: '키워드 · 일정',
                iconAsset: 'assets/icons/mypage_notification.svg',
                onTap: onTapNotification,
              ),
              MyActivityItem(
                label: '관심 학과',
                description: '학과 공지 모아보기',
                iconAsset: 'assets/icons/mypage_department.svg',
                onTap: onTapSubscribeDepartment,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _section(
            items: [
              MyActivityItem(
                label: '의견 보내기',
                description: '서비스 개선 제안',
                iconAsset: 'assets/icons/mypage_feedback.svg',
                onTap: onTapUserFeedback,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: ColorStyles.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(children: items),
    );
  }
}
