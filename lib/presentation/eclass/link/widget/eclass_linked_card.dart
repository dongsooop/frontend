import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassLinkedCard extends StatelessWidget {
  final EclassLinkEntity link;
  final bool isUnlinking;
  final VoidCallback onViewAssignments;
  final VoidCallback onUnlink;

  const EclassLinkedCard({
    super.key,
    required this.link,
    required this.isUnlinking,
    required this.onViewAssignments,
    required this.onUnlink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: ColorStyles.primary5,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 24,
                  color: ColorStyles.primary100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이클래스 연동 완료',
                      style: TextStyles.largeTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      link.moodleFullname ?? '이클래스 사용자',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ColorStyles.gray7,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  '최근 동기화',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatLastSyncedAt(link.lastSyncedAt),
                  style: TextStyles.smallTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('eclass-view-assignments-button'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              backgroundColor: ColorStyles.primary100,
              disabledBackgroundColor: ColorStyles.gray2,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isUnlinking ? null : onViewAssignments,
            child: Text(
              '과제 확인하기',
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('eclass-unlink-button'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              foregroundColor: ColorStyles.warning100,
              side: const BorderSide(color: ColorStyles.warning100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isUnlinking ? null : onUnlink,
            child: isUnlinking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorStyles.warning100,
                    ),
                  )
                : Text(
                    '연동 해제',
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.warning100,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatLastSyncedAt(DateTime? value) {
    if (value == null) return '동기화 대기 중';

    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}년 ${local.month}월 ${local.day}일 $hour:$minute';
  }
}
