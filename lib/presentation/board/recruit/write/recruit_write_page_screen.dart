import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/presentation/board/common/board_require_label.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/recruit_bottom_sheet.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RecruitWritePageScreen extends StatefulWidget {
  const RecruitWritePageScreen({super.key});

  @override
  State<RecruitWritePageScreen> createState() => _RecruitWritePageScreenState();
}

class _RecruitWritePageScreenState extends State<RecruitWritePageScreen> {
  final List<String> types = ['튜터링', '스터디', '프로젝트'];
  int? selectedIndex;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> selectedMajors = [];
  List<String> tagList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final tagController = TextEditingController();
  bool isFormValid = false;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ko', 'KR'),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _updateFormValidState();
    }
  }

  void _updateFormValidState() {
    final hasType = selectedIndex != null;
    final hasDates = _startDate != null && _endDate != null;
    final hasTitle = titleController.text.trim().isNotEmpty;
    final hasContent = contentController.text.trim().isNotEmpty;
    final hasMajor = selectedMajors.isNotEmpty;

    setState(() {
      isFormValid = hasType && hasDates && hasTitle && hasContent && hasMajor;
    });
  }

  Widget _buildDateBox(DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorStyles.gray2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, size: 24, color: ColorStyles.gray3),
          const SizedBox(width: 8),
          Text(
            date != null
                ? '${date.year}. ${date.month}. ${date.day}.'
                : '${DateTime.now().year}. ${DateTime.now().month}. ${DateTime.now().day}.',
            style:
                TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ],
      ),
    );
  }

  void _addTag(String text) {
    if (text.trim().isNotEmpty && !tagList.contains(text.trim())) {
      setState(() {
        tagList.add(text.trim());
        tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      tagList.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: const DetailHeader(title: '모집 개설'),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          label: '모집 시작하기',
          isEnabled: isFormValid,
          onPressed: () {
            if (isFormValid) {
              // 제출 처리 로직
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '모집이 시작되면 지원자가 작성한',
                    style: TextStyles.largeTextRegular
                        .copyWith(color: ColorStyles.gray4),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '자기소개',
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black),
                        ),
                        TextSpan(
                          text: ' 및 ',
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.gray4),
                        ),
                        TextSpan(
                          text: '지원 동기',
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black),
                        ),
                        TextSpan(
                          text: '를 확인할 수 있어요',
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.gray4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  RequiredLabel('모집 유형'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: List.generate(types.length, (index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          _updateFormValidState();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isSelected
                                  ? ColorStyles.primary100
                                  : ColorStyles.gray2,
                            ),
                          ),
                          child: Text(
                            types[index],
                            style: TextStyles.normalTextRegular.copyWith(
                              color: isSelected
                                  ? ColorStyles.primary100
                                  : ColorStyles.gray4,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 40),

                  RequiredLabel('모집 기간'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(context, true),
                          child: _buildDateBox(_startDate),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('~'),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(context, false),
                          child: _buildDateBox(_endDate),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  RequiredLabel('제목'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    onChanged: (_) => _updateFormValidState(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '모집 글 제목을 입력해 주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.primary100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  RequiredLabel('내용'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contentController,
                    onChanged: (_) => _updateFormValidState(),
                    maxLines: 6,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '모집 세부 내용을 입력해 주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.primary100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  RequiredLabel('모집 학과'),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => RecruitBottomSheet(
                          selected: selectedMajors,
                          onSelected: (value) {
                            setState(() {
                              selectedMajors = value;
                            });
                            _updateFormValidState();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedMajors.isNotEmpty
                                ? ColorStyles.primary100
                                : ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedMajors.isNotEmpty
                                ? '학과 선택하기 (${selectedMajors.length})'
                                : '학과 선택하기',
                            style: TextStyles.normalTextRegular.copyWith(
                              color: selectedMajors.isNotEmpty
                                  ? ColorStyles.primary100
                                  : ColorStyles.gray4,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: selectedMajors.isNotEmpty
                                ? ColorStyles.primary100
                                : ColorStyles.gray4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 태그
                  Row(
                    children: [
                      Text('태그', style: TextStyles.largeTextBold),
                      const SizedBox(width: 8),
                      Text('작성자의 학과와 모집 학과는 자동으로 입력돼요',
                          style: TextStyles.normalTextRegular
                              .copyWith(color: ColorStyles.gray3)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tagController,
                    onSubmitted: _addTag,
                    decoration: InputDecoration(
                      hintText: '최대 n글자까지 입력 가능해요',
                      hintStyle: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray3,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addTag(tagController.text),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.primary100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tagList.map((tag) {
                      return Chip(
                        label: Text(tag),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () => _removeTag(tag),
                        backgroundColor: ColorStyles.gray3,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
