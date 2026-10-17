import 'package:dongsoop/presentation/my_page/widgets/my_activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoggedInUserCard extends HookConsumerWidget {
  final User user;
  final VoidCallback onTapAdminReport;
  final VoidCallback onTapAdminBlindDate;
  final VoidCallback onTapAdminBlindDateReset;
  final VoidCallback onTapAdminFeedback;
  final VoidCallback onTapUserFeedback;
  final VoidCallback onTapCalendar;
  final VoidCallback onTapTimetable;
  final VoidCallback onTapBlockedUser;
  final VoidCallback onTapNotification;
  final VoidCallback onTapSubscribeDepartment;
  final VoidCallback onTapEclass;
  final VoidCallback onTapSocialLoginConnect;

  const LoggedInUserCard({
    super.key,
    required this.user,
    required this.onTapAdminReport,
    required this.onTapAdminBlindDate,
    required this.onTapAdminBlindDateReset,
    required this.onTapAdminFeedback,
    required this.onTapUserFeedback,
    required this.onTapCalendar,
    required this.onTapTimetable,
    required this.onTapBlockedUser,
    required this.onTapNotification,
    required this.onTapSubscribeDepartment,
    required this.onTapEclass,
    required this.onTapSocialLoginConnect,
  });

  @override
  Widget build(BuildContext context,  WidgetRef ref) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: ColorStyles.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/profile.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.nickname,
                      style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: ShapeDecoration(
                        color: ColorStyles.primary5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        user.departmentType,
                        style: TextStyles.smallTextBold.copyWith(color: ColorStyles.primaryColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: ShapeDecoration(
              color: ColorStyles.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _myPageMenuItem(
                iconAsset: 'assets/icons/mypage_timetable.svg',
                label: '시간표 관리',
                onTap: onTapTimetable,
              ),
              _myPageMenuItem(
                iconAsset: 'assets/icons/mypage_schedule.svg',
                label: '일정 관리',
                onTap: onTapCalendar,
              ),
            ],
          ),
        ),
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
            MyActivityItem(
              label: '소셜 계정 연동',
              description: '카카오 · 구글',
              iconAsset: 'assets/icons/mypage_social.svg',
              onTap: onTapSocialLoginConnect,
            ),
            MyActivityItem(
              label: '차단 관리',
              description: '차단한 사용자',
              iconAsset: 'assets/icons/mypage_blocked_user.svg',
              onTap: onTapBlockedUser,
            ),
          ],
        ),
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
        if (user.role.contains('ADMIN'))
          _section(
            items: [
              MyActivityItem(
                label: '신고 관리',
                description: '미처리 신고 확인',
                iconAsset: 'assets/icons/mypage_report.svg',
                onTap: onTapAdminReport,
              ),
              MyActivityItem(
                label: '과팅 오픈',
                description: '오픈 · 참여 정보',
                iconAsset: 'assets/icons/mypage_blind_date.svg',
                onTap: onTapAdminBlindDate,
              ),
              MyActivityItem(
                label: '과팅 참여 정보 리셋',
                description: '테스트 참여 정보 초기화',
                iconAsset: 'assets/icons/mypage_reset.svg',
                onTap: onTapAdminBlindDateReset,
              ),
              MyActivityItem(
                label: '사용자 피드백 결과',
                description: '사용자 의견 확인',
                iconAsset: 'assets/icons/mypage_admin_feedback.svg',
                onTap: onTapAdminFeedback,
              ),
            ],
          ),
      ],
    );
  }

  Widget _myPageMenuItem({
    required String iconAsset,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required List<Widget> items,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: ColorStyles.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(children: items),
      ),
    );
  }
}
