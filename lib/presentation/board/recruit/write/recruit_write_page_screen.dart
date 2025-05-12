import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/presentation/board/common/board_require_label.dart';
import 'package:dongsoop/presentation/board/recruit/write/providers/date_time_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/date_time_bottom_sheet.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/major_tag_section.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitWritePageScreen extends ConsumerStatefulWidget {
  const RecruitWritePageScreen({super.key});

  @override
  ConsumerState<RecruitWritePageScreen> createState() =>
      _RecruitWritePageScreenState();
}

class _RecruitWritePageScreenState
    extends ConsumerState<RecruitWritePageScreen> {
  // 모집 유형 리스트
  final List<String> types = ['튜터링', '스터디', '프로젝트'];
  int? selectedIndex; // 선택된 모집 유형 인덱스

  // 모집 시작일/마감일
  DateTime? _startDate;
  DateTime? _endDate;

  // 선택된 학과 및 직접 추가한 태그
  List<String> selectedMajors = [];
  List<String> manualTagList = [];

  // 입력 컨트롤러들
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final tagController = TextEditingController();

  // 전체 폼 유효성 여부
  bool isFormValid = false;

  // 작성자의 학과 (자동 포함)
  final String writerMajor = '컴퓨터소프트웨어공학과';

  // 날짜 박스 UI
  Widget buildDateTimeBox(String label, DateTime dateTime) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorStyles.gray2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.normalTextRegular),
          Text(
            '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. ${dateTime.hour.toString().padLeft(2, '0')}'
            ':${dateTime.minute.toString().padLeft(2, '0')}',
            style:
                TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ],
      ),
    );
  }

  // 전체 유효성 검사
  void _updateFormValidState() {
    final hasType = selectedIndex != null;
    final hasDates = _startDate != null && _endDate != null;
    final hasTitle = titleController.text.trim().isNotEmpty;
    final hasContent = contentController.text.trim().isNotEmpty;

    setState(() {
      isFormValid = hasType && hasDates && hasTitle && hasContent;
    });
  }

  // 학과 선택 결과 처리
  void _handleMajorSelection(List<String> selected) {
    setState(() {
      if (selected.contains('전체 학과')) {
        selectedMajors = ['전체 학과'];
      } else {
        selectedMajors = selected;
      }
    });
    _updateFormValidState();
  }

  // 태그 추가 처리
  void _addTag(String text) {
    final trimmed = text.trim();
    if (trimmed.isNotEmpty &&
        !manualTagList.contains(trimmed) &&
        trimmed.length <= 8 &&
        manualTagList.length < 3) {
      setState(() {
        manualTagList.add(trimmed);
        tagController.clear();
      });
    }
  }

  // 태그 삭제 처리
  void _removeTag(String tag) {
    setState(() {
      manualTagList.remove(tag);
      selectedMajors.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dateTimeSelectorProvider);
    final notifier = ref.read(dateTimeSelectorProvider.notifier);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: DetailHeader(title: '모집 개설'),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          label: '모집 시작하기',
          isEnabled: isFormValid,
          onPressed: () {
            showDialog(
              context: context,
              // 제출 확인용 dialog
              builder: (_) => CustomConfirmDialog(
                title: '모집 개설',
                content: '작성한 글은 수정할 수 없어요\n모집 시작할까요?',
                cancelText: '취소',
                confirmText: '제출',
                onConfirm: () {
                  // 제출 처리 로직
                  Navigator.pop(context);
                },
              ),
            );
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
                  // 안내 문구
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
                                .copyWith(color: ColorStyles.black)),
                        TextSpan(
                            text: ' 및 ',
                            style: TextStyles.largeTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                        TextSpan(
                            text: '지원 동기',
                            style: TextStyles.largeTextBold
                                .copyWith(color: ColorStyles.black)),
                        TextSpan(
                            text: '를 확인할 수 있어요',
                            style: TextStyles.largeTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 모집 유형 선택
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

                  // 모집 기간
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RequiredLabel('모집 기간'),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '모집 기간은 최대 4주(28일)까지 가능해요',
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) =>
                              const DateTimeBottomSheet(isStart: true),
                        ),
                        child: buildDateTimeBox('모집 시작일', state.startDateTime),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) =>
                              const DateTimeBottomSheet(isStart: false),
                        ),
                        child: buildDateTimeBox('모집 마감일', state.endDateTime),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 제목 입력
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

                  // 내용 입력
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

                  // 학과 및 태그 섹션
                  MajorTagSection(
                    selectedMajors: selectedMajors,
                    manualTags: manualTagList,
                    onMajorChanged: _handleMajorSelection,
                    onTagAdded: _addTag,
                    onTagRemoved: _removeTag,
                    tagController: tagController,
                    isTutorType: selectedIndex == 0,
                    writerMajor: writerMajor,
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
