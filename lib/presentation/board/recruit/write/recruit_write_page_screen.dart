import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/common/components/board_require_label.dart';
import 'package:dongsoop/presentation/board/common/components/board_text_form_field.dart';
import 'package:dongsoop/presentation/board/recruit/write/state/recruit_write_state.dart';
import 'package:dongsoop/presentation/board/recruit/write/view_models/date_time_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/write/view_models/recruit_write_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/date_time_bottom_sheet.dart';
import 'package:dongsoop/presentation/board/recruit/write/widget/major_tag_section.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecruitWritePageScreen extends HookConsumerWidget {
  const RecruitWritePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(recruitWriteViewModelProvider.notifier);
    final state = ref.watch(recruitWriteViewModelProvider);
    final titleController = useTextEditingController(text: state.title);
    final contentController = useTextEditingController(text: state.content);
    final tagController = useTextEditingController();

    final user = ref.watch(userSessionProvider);
    final writerMajor = user?.departmentType ?? '';

    void updateField(RecruitFormState Function(RecruitFormState) update) {
      viewModel.updateForm(update(state));
    }

    void addTag(String text) {
      final trimmed = text.trim();
      if (trimmed.isEmpty || state.tags.contains(trimmed)) return;
      final updatedTags = [...state.tags, trimmed];
      updateField((s) => s.copyWith(tags: updatedTags));
      tagController.clear();
    }

    void removeTag(String tag) {
      if (tag == writerMajor) return;
      updateField((s) => s.copyWith(
            tags: s.tags.where((t) => t != tag).toList(),
            majors: s.majors.where((m) => m != tag).toList(),
          ));
    }

    void handleMajorSelection(List<String> selected) {
      final majors = selected.contains('전체 학과') ? ['전체 학과'] : selected;
      updateField((s) => s.copyWith(majors: majors));
    }

    Future<void> onSubmit() async {
      final typeIndex = state.selectedTypeIndex;
      if (typeIndex == null) return;

      final type = RecruitType.values[typeIndex];
      final baseMajor =
          DepartmentTypeExtension.fromDisplayName(writerMajor).code;

      final deptList = typeIndex == 0
          ? [baseMajor]
          : state.majors.contains('전체 학과')
              ? DepartmentType.values
                  .where((e) => e != DepartmentType.Unknown)
                  .map((e) => e.code)
                  .toList()
              : {
                  baseMajor,
                  ...state.majors.map(
                      (e) => DepartmentTypeExtension.fromDisplayName(e).code)
                }.whereType<String>().toSet().toList();

      final dateState = ref.read(dateTimeViewModelProvider);

      final entity = RecruitWriteEntity(
        title: state.title.trim(),
        content: state.content.trim(),
        tags: state.tags.join(','),
        startAt: dateState.startDateTime,
        endAt: dateState.endDateTime,
        departmentTypeList: deptList,
      );

      try {
        await viewModel.submit(type: type, entity: entity, userId: user!.id);
        context.pop(true);
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => CustomConfirmDialog(
            title: '오류 발생',
            content: '$e',
            confirmText: '확인',
            onConfirm: () => context.pop(),
          ),
        );
      }
    }

    Widget buildDateTimeBox(String label, DateTime dateTime, bool isStart) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => DateTimeBottomSheet(isStart: isStart),
          );
        },
        child: Container(
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
                '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. '
                '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                style: TextStyles.normalTextRegular
                    .copyWith(color: ColorStyles.gray4),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const DetailHeader(title: '모집 개설'),
        bottomNavigationBar: PrimaryBottomButton(
          label: '모집 시작하기',
          isEnabled: viewModel.isFormValid,
          onPressed: () => showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '모집 개설',
              content: '작성한 글은 수정할 수 없어요\n모집 시작할까요?',
              cancelText: '취소',
              confirmText: '제출',
              onConfirm: onSubmit,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '모집이 시작되면 지원자가 작성한 자기소개 및 지원 동기를 확인할 수 있어요',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 40),
                RequiredLabel('모집 유형'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  children: List.generate(3, (index) {
                    final types = ['튜터링', '스터디', '프로젝트'];
                    final isSelected = state.selectedTypeIndex == index;
                    return GestureDetector(
                      onTap: () {
                        updateField((s) => s.copyWith(
                              selectedTypeIndex: index,
                              majors: index == 0 ? [] : s.majors,
                              tags: index == 0 ? [] : s.tags,
                            ));
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
                Row(
                  children: [
                    RequiredLabel('모집 기간'),
                    const SizedBox(width: 8),
                    const Text('모집 기간은 최대 4주(28일)까지 가능해요',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                buildDateTimeBox('모집 시작일',
                    ref.watch(dateTimeViewModelProvider).startDateTime, true),
                const SizedBox(height: 8),
                buildDateTimeBox('모집 마감일',
                    ref.watch(dateTimeViewModelProvider).endDateTime, false),
                const SizedBox(height: 40),

                // 제목
                RequiredLabel('제목'),
                const SizedBox(height: 16),
                BoardTextFormField(
                  controller: titleController,
                  maxLength: 20,
                  hintText: '모집 글 제목을 입력해 주세요',
                  onChanged: (value) =>
                      updateField((s) => s.copyWith(title: value)),
                ),

                const SizedBox(height: 40),

                // 내용
                RequiredLabel('내용'),
                const SizedBox(height: 16),
                BoardTextFormField(
                  controller: contentController,
                  maxLength: 500,
                  maxLines: 5,
                  hintText: '모집 세부 내용을 입력해 주세요',
                  onChanged: (value) =>
                      updateField((s) => s.copyWith(content: value)),
                ),
                const SizedBox(height: 40),
                MajorTagSection(
                  selectedMajors: state.majors,
                  manualTags: state.tags,
                  onMajorChanged: handleMajorSelection,
                  onTagAdded: addTag,
                  onTagRemoved: removeTag,
                  tagController: tagController,
                  isTutorType: state.selectedTypeIndex == 0,
                  writerMajor: writerMajor,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
