import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

import '../../../main.dart';

class LoggedInUserCard extends HookConsumerWidget {
  final User user;
  const LoggedInUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final viewModel = ref.read(myPageViewModelProvider.notifier);
    final myPageState = ref.watch(myPageViewModelProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 88,
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
                routePath: 'schedule',
                context: context,
              ),
              _myPageMenuItem(
                icon: Icons.calendar_month_outlined,
                label: '일정 관리',
                routePath: 'calendar',
                context: context,
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
                    routePath: '',
                  ),
                  _myActivityItem(
                    label: '지원한 모집글',
                    routePath: '',
                  ),
                  _myActivityItem(
                    label: '장터 내역',
                    routePath: '',
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 16,),
        // logout test
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            backgroundColor: ColorStyles.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0
          ),
          onPressed: myPageState is AsyncLoading
            ? null
            : () async {
              await viewModel.logout();

              final state = ref.read(myPageViewModelProvider);
              logger.i("state: $state");
              state.whenOrNull(
                data: (_) {
                  logger.i("로그아웃 성공");
                },
                error: (err, _) {
                  logger.i("로그아웃 실패: ${err.toString()}");
                },
              );
            },
          child: myPageState is AsyncLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text('로그아웃', style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white)),
        ),
      ],
    );
  }

  Widget _myPageMenuItem({
    required IconData icon,
    required String label,
    required String routePath,
    required BuildContext context,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.pushNamed(routePath);
        },
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
    // required VoidCallback onTap,
    required String routePath
  }) {
    return GestureDetector(
      onTap: () {

      },
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