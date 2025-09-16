import 'dart:io';

import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/presentation/board/common/components/board_require_label.dart';
import 'package:dongsoop/presentation/board/common/components/board_text_form_field.dart';
import 'package:dongsoop/presentation/board/market/detail/view_model/market_detail_view_model.dart';
import 'package:dongsoop/presentation/board/market/price_formatter.dart';
import 'package:dongsoop/presentation/board/market/write/view_model/market_write_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MarketWritePageScreen extends HookConsumerWidget {
  final bool isEditing;
  final int? marketId;

  const MarketWritePageScreen({
    super.key,
    required this.isEditing,
    this.marketId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmProv =
    marketWriteViewModelProvider(isEditing: isEditing, marketId: marketId);

    final viewModel = ref.watch(vmProv.notifier);
    final state = ref.watch(vmProv);

    final submittingRef = useRef<bool>(false);
    final isSubmitting = ref.watch(vmProv.select((s) => s.isSubmitting));
    final isValid = ref.watch(vmProv.select((s) => s.isValid));

    final titleController = useTextEditingController();
    final contentController = useTextEditingController();
    final priceController = useTextEditingController();
    final isInitialized = useState(false);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (titleController.text != state.title) {
          titleController.text = state.title;
        }
        if (contentController.text != state.content) {
          contentController.text = state.content;
        }
        final formattedPrice = state.price > 0 ? PriceFormatter.format(state.price) : '';
        if (priceController.text != formattedPrice) {
          priceController.text = formattedPrice;
        }
        isInitialized.value = true;
      });
      return null;
    }, [state.title, state.content, state.price]);

    useEffect(() {
      if (!isInitialized.value) return null;

      titleController.addListener(() {
        viewModel.updateTitle(titleController.text);
      });
      contentController.addListener(() {
        viewModel.updateContent(contentController.text);
      });
      priceController.addListener(() {
        final parsed = PriceFormatter.parse(priceController.text);
        viewModel.updatePrice(parsed);
      });
      return null;
    }, [isInitialized.value]);

    Future<void> _pickImage() async {
      if (isSubmitting || submittingRef.value) return;
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await viewModel.compressAndAddImage(pickedFile);
      }
    }

    Future<void> _showDeleteImageActionSheet(int index) async {
      if (isSubmitting || submittingRef.value) return;
      customActionSheet(
        context,
        onDelete: () => viewModel.removeImageAt(index),
      );
    }

    useEffect(() {
      if (state.profanityMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            useRootNavigator: true,
            builder: (dialogContext) => CustomConfirmDialog(
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(title: isEditing ? '장터 수정' : '장터 등록'),
      bottomNavigationBar: isKeyboardVisible
          ? null
          : PrimaryBottomButton(
        label: isEditing ? '수정하기' : '등록하기',
        isEnabled: isValid && !isSubmitting && !submittingRef.value,
        onPressed: () async {
          if (isSubmitting || submittingRef.value) return;
          submittingRef.value = true;
          try {
            final success = await viewModel.submitMarket(context);
            if (!success) return;
            await viewModel.clearTemporaryImages();
            if (success && context.mounted) {
              if (isEditing && marketId != null) {
                ref.invalidate(
                  marketDetailViewModelProvider(
                      MarketDetailArgs(id: marketId!)),
                );
              }
              context.pop(true);
            }
          } catch (e) {
            await showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '장터 오류',
                content:
                '${e.toString()}',
                confirmText: '확인',
                onConfirm: () {},
                isSingleAction: true,
              ),
            );
          } finally {
            submittingRef.value = false;
          }
        },
      ),
    body: SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AbsorbPointer(
            absorbing: isSubmitting || submittingRef.value,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  RequiredLabel('글 유형'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: List.generate(2, (index) {
                      final isSelected = state.type?.index == index;
                      return GestureDetector(
                        onTap: () {
                          if (isSubmitting || submittingRef.value) return;
                          viewModel.updateType(
                            index == 0 ? MarketType.SELL : MarketType.BUY,
                          );
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
                            index == 0
                                ? MarketType.SELL.label
                                : MarketType.BUY.label,
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

                  // 제목
                  RequiredLabel('제목'),
                  const SizedBox(height: 16),
                  BoardTextFormField(
                    controller: titleController,
                    hintText: '글 제목을 입력해 주세요',
                    maxLength: 20,
                  ),
                  const SizedBox(height: 40),

                  // 내용
                  RequiredLabel('내용'),
                  const SizedBox(height: 16),
                  BoardTextFormField(
                    controller: contentController,
                    hintText: '세부 내용을 입력해 주세요',
                    maxLength: 500,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: ColorStyles.gray4,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '부적절하거나 불쾌감을 주는 게시글은 제재받을 수 있어요.',
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 가격
                  RequiredLabel('가격'),
                  const SizedBox(height: 16),
                  BoardTextFormField(
                    controller: priceController,
                    hintText: '희망 가격을 입력해 주세요',
                    keyboardType: TextInputType.number,
                    inputFormatters: [PriceInputFormatter()],
                    errorText: state.priceErrorText,
                  ),
                  const SizedBox(height: 40),

                  // 사진
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RequiredLabel('사진'),
                      const SizedBox(width: 8),
                      Text(
                        '최대 3개까지 첨부 가능해요',
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: [
                      ...List.generate(state.images.length, (index) {
                        return GestureDetector(
                          onTap: () => _showDeleteImageActionSheet(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(state.images[index].path),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                      if (state.images.length < 3)
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorStyles.gray2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 24.0,
                                color: ColorStyles.gray4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}