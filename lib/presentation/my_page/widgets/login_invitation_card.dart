import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginInvitationCard extends StatelessWidget {
  final VoidCallback onTap;

  const LoginInvitationCard({super.key, required this.onTap});

  static const _background = Color(0xFFFFF7F3);
  static const _wall = Color(0xFFFFDAD0);
  static const _coral = Color(0xFFFF4F57);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final titleSize = (width * 0.062).clamp(18.0, 24.0);
        final contentWidth = width * 0.64;

        return Material(
          color: _background,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  width: width * 0.06,
                  child: const ColoredBox(color: _wall),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: width * 0.40,
                      child: SvgPicture.asset(
                        'assets/icons/mypage_login_mascot.svg',
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomRight,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '로그인하면\n', style: TextStyles.titleTextBold.copyWith(color: ColorStyles.black)),
                              TextSpan(
                                text: '동숲이 ',
                                style: TextStyles.titleTextBold.copyWith(color: _coral)
                              ),
                              TextSpan(text: '더 가까워져요', style: TextStyles.titleTextBold.copyWith(color: ColorStyles.black)),
                            ],
                          ),
                          style: TextStyles.titleTextBold.copyWith(
                            fontSize: titleSize,
                            color: ColorStyles.black,
                            height: 1.35,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '내 시간표와 알림을 한 곳에서',
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray6,
                            height: 1.5,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DecoratedBox(
                          decoration: ShapeDecoration(
                            color: ColorStyles.white,
                            shape: const StadiumBorder(
                              side: BorderSide(color: _wall, width: 1.2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '로그인',
                                    style: TextStyles.normalTextBold.copyWith(color: _coral)
                                  ),
                                  TextSpan(
                                    text: '하고 시작하기',
                                      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray6)
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyles.normalTextBold.copyWith(
                                color: ColorStyles.gray4,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
