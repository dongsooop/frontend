import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 기존 홈 응답의 수업 정보로 보여주는 인사말.
class HomeGreeting extends StatelessWidget {
  final int classCount;
  final bool isLoggedOut;

  const HomeGreeting({
    super.key,
    required this.classCount,
    required this.isLoggedOut,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('M월 d일 EEEE', 'ko').format(DateTime.now()),
            style: TextStyles.smallTextBold.copyWith(color: ColorStyles.gray5),
          ),
          const SizedBox(height: 6),
          Text.rich(
            _buildMessage(),
            style: TextStyles.titleTextBold.copyWith(
              color: ColorStyles.black,
              height: 1.32,
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildMessage() {
    if (isLoggedOut) {
      return const TextSpan(text: '오늘의 캠퍼스 소식');
    }
    if (classCount == 0) {
      return const TextSpan(text: '오늘은 수업이 없어요');
    }
    return TextSpan(
      children: [
        const TextSpan(text: '오늘 수업 '),
        TextSpan(
          text: '$classCount개',
          style: const TextStyle(color: ColorStyles.primary100),
        ),
        const TextSpan(text: ' 있어요'),
      ],
    );
  }
}
