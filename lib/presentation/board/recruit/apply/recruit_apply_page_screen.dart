import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_apply_view_model.dart';
import 'package:dongsoop/presentation/board/common/components/board_filtering_overlay.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecruitApplyPageScreen extends HookConsumerWidget {
  final int id;
  final RecruitType type;

  const RecruitApplyPageScreen({
    required this.id,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final introduceController = useTextEditingController();
    final supportController = useTextEditingController();

    final user = ref.watch(userSessionProvider);
    final writerMajor = user?.departmentType;

    final departmentCode = user != null
        ? DepartmentTypeExtension.fromDisplayName(user.departmentType).code
        : '';

    final viewModel = ref.watch(recruitApplyViewModelProvider.notifier);
    final state = ref.watch(recruitApplyViewModelProvider);

    final submittingRef = useRef<bool>(false);

    final isSubmitting = ref.watch(
      recruitApplyViewModelProvider.select((s) => s.isLoading),
    );
    final isFiltering = ref.watch(
      recruitApplyViewModelProvider.select((s) => s.isFiltering),
    );

    final filteringOverlayRef = useRef<OverlayEntry?>(null);

    final isFormValid = useState(false);

    void updateFormValidState() {
      isFormValid.value = introduceController.text.trim().isNotEmpty &&
          supportController.text.trim().isNotEmpty;
    }

    useEffect(() {
      introduceController.addListener(updateFormValidState);
      supportController.addListener(updateFormValidState);
      return () {
        introduceController.removeListener(updateFormValidState);
        supportController.removeListener(updateFormValidState);
      };
    }, []);

    useEffect(() {
      if (state.profanityMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog(
            context: context,
            useRootNavigator: true,
            builder: (_) => CustomConfirmDialog(
              title: '비속어 감지',
              content: state.profanityMessage!,
              confirmText: '확인',
              onConfirm: () {
                viewModel.clearProfanityMessage();
              },
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [state.profanityMessageTriggerKey]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (isFiltering && filteringOverlayRef.value == null) {
          filteringOverlayRef.value = showBoardFilteringOverlay(
            context,
            useRootOverlay: true,
          );
        } else if (!isFiltering && filteringOverlayRef.value != null) {
          hideBoardFilteringOverlay(filteringOverlayRef.value);
          filteringOverlayRef.value = null;
        }
      });

      return () {
        if (filteringOverlayRef.value != null) {
          hideBoardFilteringOverlay(filteringOverlayRef.value);
          filteringOverlayRef.value = null;
        }
      };
    }, [isFiltering]);

    Future<void> _guardedSubmit() async {
      if (isSubmitting || submittingRef.value || isFiltering) return;
      submittingRef.value = true;
      try {
        final success = await viewModel.submitRecruitApply(
          boardId: id,
          introduction: introduceController.text.trim(),
          motivation: supportController.text.trim(),
          type: type,
          departmentCode: departmentCode,
        );

        if (success) {
          if (context.mounted) context.pop(true);
        } else if (state.profanityMessage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('제출에 실패했어요. 다시 시도해주세요.'),
            ),
          );
        }
      } finally {
        submittingRef.value = false;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorStyles.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: DetailHeader(title: '지원하기'),
      ),
      bottomNavigationBar: PrimaryBottomButton(
        label: '지원하기',
        isEnabled: isFormValid.value && !isSubmitting && !submittingRef.value && !isFiltering,
        onPressed: () {
          if (!isFormValid.value || isSubmitting || submittingRef.value || isFiltering) {
            return;
          }
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '모집 지원',
              content: '제출한 글은 수정할 수 없어요\n글을 제출할까요?',
              cancelText: '취소',
              confirmText: '제출',
              onConfirm: _guardedSubmit,
            ),
          );
        },
      ),
    body: SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AbsorbPointer(
            absorbing: isSubmitting || submittingRef.value || isFiltering,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text('학과',
                        style: TextStyles.largeTextBold
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: false,
                      initialValue: writerMajor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        hintText: writerMajor,
                        hintStyle: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.gray3),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text('자기소개',
                        style: TextStyles.largeTextBold
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: introduceController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        hintText: '자기소개를 적어주세요',
                        hintStyle: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.gray3),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text('지원 동기',
                        style: TextStyles.largeTextBold
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: supportController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        hintText: '지원 동기를 적어주세요',
                        hintStyle: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.gray3),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
