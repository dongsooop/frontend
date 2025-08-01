import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/presentation/board/common/components/board_require_label.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/recruit_bottom_sheet.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    if (selectedMajors.contains('전체 학과')) {
      return ['전체 학과', ...manualTags];
    }

    final tagSet = <String>{...selectedMajors, writerMajor, ...manualTags};
    return tagSet.toList();
  }

  void handleTagAdd(BuildContext context) {
    final text = tagController.text.trim();

    if (text.isEmpty) return;
    if (text.length > 8) return;
    if (manualTags.contains(text)) return;
    if (manualTags.length >= 3) return;

    onTagAdded(text);
    tagController.clear();
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
          children: [
            RequiredLabel('태그'),
            const SizedBox(width: 8),
            Text(
              '작성자의 학과와 모집 학과는 자동으로 입력돼요',
              style: TextStyles.smallTextRegular
                  .copyWith(color: ColorStyles.gray4),
            ),
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
                  onSubmitted: (_) => handleTagAdd(context),
                  maxLength: 8,
                  style: TextStyles.normalTextRegular,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백 입력 차단
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: '',
                    hintText: '최대 3개, 8글자까지 입력 가능해요',
                    hintStyle: TextStyles.normalTextRegular
                        .copyWith(color: ColorStyles.gray4),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => handleTagAdd(context),
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
              final isStaticTag = tag == writerMajor;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  height: 44,
                  child: CommonTag(
                    label: tag,
                    index: isStaticTag ? -1 : manualTags.indexOf(tag),
                    isDeletable: !isStaticTag,
                    textStyle: TextStyles.normalTextBold,
                    onDeleted: () => onTagRemoved(tag),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
