import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RecruitBottomSheet extends StatefulWidget {
  final List<String> selected;
  final void Function(List<String>) onSelected;
  final String writerMajor;

  const RecruitBottomSheet({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.writerMajor,
  });

  @override
  State<RecruitBottomSheet> createState() => _RecruitBottomSheetState();
}

class _RecruitBottomSheetState extends State<RecruitBottomSheet> {
  final List<String> departments = [
    '기계공학과',
    '기계설계공학과',
    '자동화공학과',
    '로봇소프트웨어학과',
    '전기공학과',
    '반도체전자공학과',
    '정보통신공학과',
    '소방안전관리과',
    '웹응용소프트웨어공학과',
    '컴퓨터소프트웨어공학과',
    '인공지능소프트웨어학과',
    '생명화학공학과',
    '바이오융합공학과',
    '건축과',
    '실내건축디자인과',
    '시각디자인과',
    'AR·VR콘텐츠디자인과',
    '경영학과',
    '세무회계학과',
    '유통마케팅학과',
    '호텔관광학과',
    '경영정보학과',
    '빅데이터경영과',
    '자유전공학과',
  ];

  late Set<String> selectedDepartments;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    isAllSelected = widget.selected.contains('전체 학과');
    selectedDepartments = isAllSelected
        ? {...departments, widget.writerMajor}
        : {...widget.selected, widget.writerMajor};
  }

  void toggleAll(bool? value) {
    setState(() {
      if (value == true) {
        isAllSelected = true;
        selectedDepartments = {...departments, widget.writerMajor};
      } else {
        isAllSelected = false;
        selectedDepartments = {widget.writerMajor};
      }
    });
  }

  void toggleItem(String item) {
    if (item == widget.writerMajor) return;
    setState(() {
      if (selectedDepartments.contains(item)) {
        selectedDepartments.remove(item);
      } else {
        selectedDepartments.add(item);
      }
      isAllSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = selectedDepartments.length <= 1;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorStyles.gray3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Text(
                  '학과 선택하기',
                  style: TextStyles.titleTextBold
                      .copyWith(color: ColorStyles.black),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(height: 1, color: ColorStyles.gray2),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    CheckboxListTile(
                      value: isAllSelected,
                      onChanged: toggleAll,
                      title: Text('전체 학과',
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.black)),
                      activeColor: ColorStyles.primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(horizontal: -4),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, color: ColorStyles.gray2),
                    ),
                    ...departments.map((dept) {
                      final isWriterMajor = dept == widget.writerMajor;
                      final isSelected = selectedDepartments.contains(dept);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged:
                            isWriterMajor ? null : (_) => toggleItem(dept),
                        title: Text(
                          dept,
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.black),
                        ),
                        activeColor: ColorStyles.primaryColor,
                        checkColor: ColorStyles.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: isEmpty
                      ? null
                      : () {
                          final selected = isAllSelected
                              ? ['전체 학과']
                              : [
                                  widget.writerMajor,
                                  ...selectedDepartments
                                      .where((e) => e != widget.writerMajor)
                                ];
                          widget.onSelected(selected);
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    backgroundColor:
                        isEmpty ? ColorStyles.gray1 : ColorStyles.primary100,
                    foregroundColor:
                        isEmpty ? ColorStyles.gray3 : ColorStyles.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '선택하기',
                    style: isEmpty
                        ? TextStyles.largeTextRegular
                        : TextStyles.largeTextBold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
