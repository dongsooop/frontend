import 'package:dongsoop/presentation/my_page/widgets/login_invitation_card.dart';
import 'package:dongsoop/presentation/my_page/widgets/my_activity_item.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';

class LoggedOutPromptCard extends StatelessWidget {
  final VoidCallback onTapLogin;
  final VoidCallback onTapNotification;
  final VoidCallback onTapSubscribeDepartment;
  final VoidCallback onTapEclass;
  final VoidCallback onTapUserFeedback;

  const LoggedOutPromptCard({
    super.key,
    required this.onTapLogin,
    required this.onTapNotification,
    required this.onTapSubscribeDepartment,
    required this.onTapEclass,
    required this.onTapUserFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginInvitationCard(onTap: onTapLogin),
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
              MyActivityItem(
                label: '이클래스 연동 관리',
                description: '과제 · 연동',
                iconAsset: 'assets/icons/mypage_eclass.svg',
                onTap: onTapEclass,
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
