import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_type.dart';
import 'package:dongsoop/presentation/notice/keyword/providers/notice_keyword_providers.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeKeywordScreen extends HookConsumerWidget {
  const NoticeKeywordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(userSessionProvider) != null;
    final state = ref.watch(noticeKeywordViewModelProvider);
    final viewModel = ref.read(noticeKeywordViewModelProvider.notifier);

    useEffect(() {
      if (isLoggedIn) {
        Future.microtask(() => viewModel.loadKeywords());
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted && ref.read(userSessionProvider) == null) {
            LoginRequiredDialog(context);
          }
        });
      }
      return null;
    }, [isLoggedIn]);

    ref.listen(noticeKeywordViewModelProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        viewModel.clearError();
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: DetailHeader(
          title: '공지 키워드 알림',
          backgroundColor: ColorStyles.gray1,
          bottom: TabBar(
            labelColor: ColorStyles.primary100,
            unselectedLabelColor: ColorStyles.gray4,
            indicatorColor: ColorStyles.primary100,
            dividerColor: ColorStyles.gray2,
            tabs: const [
              Tab(text: '알림 키워드'),
              Tab(text: '제외 키워드'),
            ],
          ),
        ),
        body: SafeArea(
          child: state.isLoading && state.keywords.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _KeywordSection(
                      description: '해당 키워드가 포함된 공지가 올라오면 알림을 받아요.',
                      type: NoticeKeywordType.include,
                      keywords: state.includeKeywords,
                      isLoading: state.isLoading,
                      onAdd: (keyword) =>
                          viewModel.addKeyword(keyword, NoticeKeywordType.include),
                      onDelete: viewModel.deleteKeyword,
                    ),
                    _KeywordSection(
                      description: '해당 키워드가 포함된 공지는 알림을 받지 않아요.',
                      type: NoticeKeywordType.exclude,
                      keywords: state.excludeKeywords,
                      isLoading: state.isLoading,
                      onAdd: (keyword) =>
                          viewModel.addKeyword(keyword, NoticeKeywordType.exclude),
                      onDelete: viewModel.deleteKeyword,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _KeywordSection extends HookWidget {
  final String description;
  final NoticeKeywordType type;
  final List<NoticeKeywordEntity> keywords;
  final bool isLoading;
  final Future<void> Function(String keyword) onAdd;
  final Future<void> Function(int keywordId) onDelete;

  const _KeywordSection({
    required this.description,
    required this.type,
    required this.keywords,
    required this.isLoading,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    Future<void> submit() async {
      final text = controller.text.trim();
      if (text.isEmpty) return;
      if (keywords.any((k) => k.keyword == text)) return;
      controller.clear();
      focusNode.unfocus();
      await onAdd(text);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        Text(
          description,
          style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
        ),
        const SizedBox(height: 16),
        _KeywordInput(
          controller: controller,
          focusNode: focusNode,
          type: type,
          isLoading: isLoading,
          onSubmit: submit,
        ),
        const SizedBox(height: 16),
        if (keywords.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '등록된 키워드가 없어요.',
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.gray4,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords
                .map((k) => _KeywordChip(
                      keyword: k.keyword,
                      type: type,
                      onDelete: () => onDelete(k.id),
                    ))
                .toList(),
          ),
      ],
    );
  }
}

class _KeywordInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final NoticeKeywordType type;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _KeywordInput({
    required this.controller,
    required this.focusNode,
    required this.type,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            maxLength: 20,
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
            ),
            decoration: InputDecoration(
              hintText: '키워드를 입력하세요',
              hintStyle: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.gray4,
              ),
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: ColorStyles.gray2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: ColorStyles.primary100),
              ),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: isLoading ? null : onSubmit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: isLoading
                  ? ColorStyles.gray2
                  : type == NoticeKeywordType.include
                      ? ColorStyles.primary100
                      : ColorStyles.gray3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '추가',
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String keyword;
  final NoticeKeywordType type;
  final VoidCallback onDelete;

  const _KeywordChip({
    required this.keyword,
    required this.type,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isInclude = type == NoticeKeywordType.include;
    final bgColor = isInclude ? ColorStyles.primary5 : ColorStyles.gray1;
    final textColor = isInclude ? ColorStyles.primary100 : ColorStyles.gray3;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => CustomConfirmDialog(
          title: '키워드 삭제',
          content: '"$keyword" 키워드를\n삭제하시겠습니까?',
          confirmText: '삭제',
          cancelText: '취소',
          onConfirm: onDelete,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              keyword,
              style: TextStyles.normalTextRegular.copyWith(color: textColor),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.close,
              size: 16,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
