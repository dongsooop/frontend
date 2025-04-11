import 'package:flutter/material.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            title: Text(
              '마이페이지',
              style: TextStyles.largeTextBold.copyWith(
                color: ColorStyles.black
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // user setting 페이지 이동
                },
                icon: SvgPicture.asset(
                  'assets/icons/setting.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.black,
                    BlendMode.srcIn,
                  ),
                ),
              )
            ],
            automaticallyImplyLeading: false, // 뒤로가기 버튼 X
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/test.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '익명1',
                          style: TextStyles.largeTextBold.copyWith(
                            color: ColorStyles.black
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: ShapeDecoration(
                            color: ColorStyles.primary5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                            )
                          ),
                          child: Text(
                            '컴퓨터소프트웨어공학과',
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.primaryColor
                            ),
                            textAlign: TextAlign.center,
                          )
                        )
                      ]
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
                      routePath: ''
                    ),
                    _myPageMenuItem(
                      icon: Icons.calendar_month_outlined,
                      label: '일정 관리',
                      routePath: ''
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
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _myPageMenuItem({
    required IconData icon,
    required String label,
    required String routePath,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // context.go(routePath);
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