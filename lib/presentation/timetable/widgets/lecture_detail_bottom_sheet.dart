import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

Future<void> showLectureDetailBottomSheet(
    BuildContext context, {
      required Lecture lecture,
      VoidCallback? onEdit,
      VoidCallback? onDelete,
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        minChildSize: 0.3,
        initialChildSize: 0.4,
        maxChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: LectureDetailSheet(
                lecture: lecture,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          );
        },
      );
    }
  );
}

class LectureDetailSheet extends StatelessWidget {
  const LectureDetailSheet({
    super.key,
    required this.lecture,
    this.onEdit,
    this.onDelete,
  });

  final Lecture lecture;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lecture.name,
                style: TextStyles.titleTextBold.copyWith(color: ColorStyles.black),
              ),
              const SizedBox(width: 8),
              Text(
                lecture.professor ?? '',
                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            '${lecture.week.korean}  ${_hhmm(lecture.startAt)} ~ ${_hhmm(lecture.endAt)}',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 8),

          Text(
            lecture.location ?? '',
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 8),

          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
              onEdit?.call();
            },
            child: const _ActionRow(
              icon: Icons.edit_outlined,
              label: '강의 정보 수정',
            ),
          ),
          const SizedBox(height: 8),

          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CustomConfirmDialog(
                  title: '강의 시간표 삭제',
                  content: '해당 강의를 삭제하시겠어요?',
                  onConfirm: () async {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    Navigator.of(context).maybePop(); // 바텀시트 닫기 (열려있다면)
                    onDelete?.call();
                  },
                ),
              );
            },
            child: const _ActionRow(
              icon: Icons.delete_outline,
              label: '강의 시간표 삭제',
            ),
          ),
        ],
      ),
    );
  }

  String _hhmm(String raw) {
    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return raw;
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: Row(
        children: [
          Icon(icon, color: ColorStyles.gray4),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
          ),
        ],
      ),
    );
  }
}