import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassAssignmentLinkState extends StatelessWidget {
  final bool isExpired;
  final VoidCallback onTapLink;

  const EclassAssignmentLinkState({
    super.key,
    required this.isExpired,
    required this.onTapLink,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        isExpired ? ColorStyles.warning100 : ColorStyles.primary100;
    final background = isExpired ? ColorStyles.warning10 : ColorStyles.primary5;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isExpired ? Icons.error_outline : Icons.link,
              size: 28,
              color: foreground,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isExpired ? '연동이 끊겨 과제를 가져오지 못했어요' : '이클래스를 연동하면 과제 마감을 챙겨드려요',
            key: Key(
              isExpired
                  ? 'eclass-assignment-expired-message'
                  : 'eclass-assignment-unlinked-message',
            ),
            textAlign: TextAlign.center,
            style: TextStyles.largeTextBold.copyWith(
              color: isExpired ? ColorStyles.warning100 : ColorStyles.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isExpired
                ? '이클래스 계정을 다시 연결하면 과제를 불러올 수 있어요.'
                : '연동 후 마감이 가까운 과제를 한눈에 확인해 보세요.',
            textAlign: TextAlign.center,
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.gray4,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            key: const Key('eclass-assignment-link-button'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 44),
              backgroundColor: ColorStyles.primary100,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onTapLink,
            child: Text(
              isExpired ? '다시 연동하기' : '이클래스 연동하기',
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
