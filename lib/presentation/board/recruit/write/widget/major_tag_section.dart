import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/presentation/board/common/board_require_label.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/recruit_bottom_sheet.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class MajorTagSection extends StatelessWidget {
  final List<String> selectedMajors;
  final List<String> manualTags;
  final Function(List<String>) onMajorChanged;
  final Function(String) onTagAdded;
  final Function(String) onTagRemoved;
  final TextEditingController tagController;
  final bool isTutorType;
  final String writerMajor;

  static const int departmentCount = 24;

  const MajorTagSection({
    super.key,
    required this.selectedMajors,
    required this.manualTags,
    required this.onMajorChanged,
    required this.onTagAdded,
    required this.onTagRemoved,
    required this.tagController,
    required this.isTutorType,
    required this.writerMajor,
  });

  List<String> get allTags {
    final Set<String> tagSet = {writerMajor};
    if (selectedMajors.contains('전체 학과')) {
      tagSet.add('전체 학과');
    } else {
      tagSet.addAll(selectedMajors);
    }
    return [...tagSet, ...manualTags];
  }

  @override
  Widget build(BuildContext context) {
    final isAllSelected = selectedMajors.contains('전체 학과');
    final displayText = isTutorType
        ? '튜터링은 작성자의 학과만 모집 가능해요'
        : isAllSelected
            ? '학과 선택하기 ($departmentCount)'
            : selectedMajors.isNotEmpty
                ? '학과 선택하기 (${selectedMajors.length})'
                : '학과 선택하기';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RequiredLabel('모집 학과'),
          ],
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: isTutorType
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => RecruitBottomSheet(
                      selected: selectedMajors,
                      onSelected: onMajorChanged,
                      writerMajor: writerMajor,
                    ),
                  );
                },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedMajors.isNotEmpty
                    ? ColorStyles.primary100
                    : ColorStyles.gray2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyles.normalTextRegular.copyWith(
                      color: isTutorType
                          ? ColorStyles.gray4
                          : selectedMajors.isNotEmpty
                              ? ColorStyles.primary100
                              : ColorStyles.gray4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: isTutorType
                          ? ColorStyles.gray4
                          : selectedMajors.isNotEmpty
                              ? ColorStyles.primary100
                              : ColorStyles.gray4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RequiredLabel('태그'),
            const SizedBox(width: 8),
            Text(
              '작성자의 학과와 모집 학과는 자동으로 입력돼요',
              style: TextStyles.smallTextRegular
                  .copyWith(color: ColorStyles.gray4),
            )
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: tagController,
                  onSubmitted: onTagAdded,
                  style: TextStyles.normalTextRegular,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '최대 3개, 8글자까지 입력 가능해요',
                    hintStyle: TextStyles.normalTextRegular
                        .copyWith(color: ColorStyles.gray4),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onTagAdded(tagController.text),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.add,
                      size: 24,
                      color: ColorStyles.gray4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: allTags.map((tag) {
              final isDeletable = tag != writerMajor;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  height: 44,
                  child: CommonTag(
                    label: tag,
                    textStyle: TextStyles.normalTextBold,
                    index: manualTags.indexOf(tag),
                    isDeletable: isDeletable,
                    onDeleted: () => onTagRemoved(tag),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
