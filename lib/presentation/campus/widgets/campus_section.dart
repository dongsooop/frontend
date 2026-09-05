import 'package:dongsoop/core/presentation/components/section_header.dart';
import 'package:flutter/material.dart';

/// 캠퍼스 탭의 한 구획.
///
/// 구획 레이아웃만 담당한다. 제목 옆/오른쪽 표현은 Widget으로 열어 두어
/// 새로운 배지나 액션이 추가되어도 이 컴포넌트를 수정하지 않는다.
class CampusSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? suffix;
  final Widget? action;

  const CampusSection({
    super.key,
    required this.title,
    required this.child,
    this.suffix,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            suffix: suffix,
            action: action,
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
