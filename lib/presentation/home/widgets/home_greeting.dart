import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 목록을 읽기 전에 오늘 상태부터 알리는 첫 문장.
///
/// 0 인 항목은 문장에서 뺀다. 둘 다 없으면 다른 문장으로 바꾼다 —
/// "수업 0개, 공지 0개" 는 읽는 사람에게 아무것도 알려주지 않는다.
class HomeGreeting extends StatelessWidget {
  final int classCount;

  const HomeGreeting({
    super.key,
    required this.classCount,
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
    final parts = <TextSpan>[];

    if (classCount > 0) {
      parts.add(_countPhrase('오늘 수업 ', classCount));
    }
    if (parts.isEmpty) {
      return const TextSpan(text: '오늘은 일정이 없어요');
    }

    final children = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) children.add(const TextSpan(text: ',\n'));
      children.add(parts[i]);
    }
    children.add(const TextSpan(text: ' 있어요'));

    return TextSpan(children: children);
  }

  /// 숫자만 강조색으로 띄워 눈이 먼저 가게 한다.
  TextSpan _countPhrase(String label, int count) {
    return TextSpan(
      children: [
        TextSpan(text: label),
        TextSpan(
          text: '$count개',
          style: const TextStyle(color: ColorStyles.primary100),
        ),
      ],
    );
  }
}
