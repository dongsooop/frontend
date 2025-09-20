import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoggedInUserCard extends HookConsumerWidget {
  final User user;
  final VoidCallback onTapAdminReport;
  final VoidCallback onTapAdminBlindDate;
  final VoidCallback onTapMarket;
  final VoidCallback onTapCalendar;
  final VoidCallback onTapTimetable;
  final void Function(bool isApply) onTapRecruit;
  final VoidCallback onTapBlockedUser;

  const LoggedInUserCard({
    super.key,
    required this.user,
    required this.onTapAdminReport,
    required this.onTapAdminBlindDate,
    required this.onTapMarket,
    required this.onTapCalendar,
    required this.onTapTimetable,
    required this.onTapRecruit,
    required this.onTapBlockedUser,
  });

  @override
  Widget build(BuildContext context,  WidgetRef ref) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: ColorStyles.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              _myPageMenuItem(
                icon: Icons.browse_gallery_outlined,
                label: '시간표 관리',
                onTap: onTapTimetable,
              ),
              _myPageMenuItem(
                icon: Icons.calendar_month_outlined,
                label: '일정 관리',
                onTap: onTapCalendar,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
              color: ColorStyles.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _myActivityItem(
                    label: '개설한 모집글',
                    onTap: () => onTapRecruit(false),
                  ),
                  _myActivityItem(
                    label: '지원한 모집글',
                    onTap: () => onTapRecruit(true),
                  ),
                  _myActivityItem(
                    label: '장터 내역',
                    onTap: onTapMarket,
                  ),
                  _myActivityItem(
                    label: '차단 관리',
                    onTap: onTapBlockedUser,
                  ),
                  // 관리자
                  if (user.role == 'ADMIN') ...[
                    _myActivityItem(
                      label: '신고 관리',
                      onTap: onTapAdminReport,
                    ),
                    _myActivityItem(
                      label: '과팅 오픈',
                      onTap: onTapAdminBlindDate,
                    ),
                  ],
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget _myPageMenuItem({
    required IconData icon,
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
              Icon(
                icon,
                size: 24,
                color: ColorStyles.black,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myActivityItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.black,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: ColorStyles.black,
            ),
          ],
        ),
      ),
    );
  }
}