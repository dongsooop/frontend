import 'dart:math' as math;

import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BlindDateJoinCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const BlindDateJoinCard({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  static const _imageAspectRatio = 1046 / 1503;
  static const _buttonLabel = '지금 과팅 참여하기';
  static const _buttonSidePadding = 20.0;
  static const _iconSpace = 36.0;
  static const _cardSidePadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxWidth / _imageAspectRatio;
        final titleSize = (constraints.maxWidth * 0.064).clamp(20.0, 26.0);
        final largeTextSpacing = MediaQuery.textScalerOf(context).scale(16) > 20
            ? imageHeight * 0.08
            : 0.0;
        final buttonTextStyle = TextStyles.largeTextBold.copyWith(
          color: ColorStyles.white,
          height: 1.35,
        );

        // Allow the button to wrap at large text sizes without covering the art.
        final buttonText = TextPainter(
          text: TextSpan(text: _buttonLabel, style: buttonTextStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(
            maxWidth: math.max(
              1,
              constraints.maxWidth -
                  2 * (_cardSidePadding + _buttonSidePadding + _iconSpace),
            ),
          );
        final buttonHeight = math.max(54.0, buttonText.height + 28);
        buttonText.dispose();
        final footerHeight = math.max(imageHeight * 0.18, buttonHeight + 24);
        final extraFooterHeight = footerHeight - imageHeight * 0.18;

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD9E8FC),
                  Color(0xFFF0E7FC),
                  Color(0xFFF9E6F3),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: extraFooterHeight,
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        extraFooterHeight > 0
                            ? Colors.transparent
                            : Colors.black,
                      ],
                      stops: const [0, 0.04, 0.96, 1],
                    ).createShader(bounds),
                    child: Image.asset(
                      'assets/images/blind_date_hero_background.png',
                      width: constraints.maxWidth,
                      height: imageHeight,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: imageHeight * 0.4),
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(24, 28, 24, largeTextSpacing),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: ColorStyles.primary100
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'TODAY',
                                style: TextStyles.smallTextBold.copyWith(
                                  color: ColorStyles.primary100,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Semantics(
                              header: true,
                              child: Text(
                                '하루에 한 번,\n다양한 친구를 사귀어 봐요',
                                style: TextStyles.titleTextBold.copyWith(
                                  fontSize: titleSize,
                                  color: const Color(0xFF151C3B),
                                  height: 1.35,
                                  letterSpacing: -0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '지금, 새로운 인연이\n기다리고 있어요',
                              style: TextStyles.normalTextRegular.copyWith(
                                fontSize: 16,
                                color: ColorStyles.gray6,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: imageHeight * 0.42),
                    SizedBox(
                      height: footerHeight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          _cardSidePadding,
                          0,
                          _cardSidePadding,
                          24,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : onPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyles.primary100,
                                foregroundColor: ColorStyles.white,
                                disabledBackgroundColor: ColorStyles.primary100
                                    .withValues(alpha: 0.65),
                                disabledForegroundColor: ColorStyles.white,
                                elevation: 6,
                                shadowColor: ColorStyles.primary100
                                    .withValues(alpha: 0.3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: _buttonSidePadding,
                                  vertical: 14,
                                ),
                                shape: const StadiumBorder(),
                                textStyle: buttonTextStyle,
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: _iconSpace),
                                  const Expanded(
                                    child: Text(
                                      _buttonLabel,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _iconSpace,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: isLoading
                                          ? const SizedBox.square(
                                              dimension: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: ColorStyles.white,
                                                semanticsLabel: '참여 가능 여부 확인 중',
                                              ),
                                            )
                                          : const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 24,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
