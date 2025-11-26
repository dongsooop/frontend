import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/feedback/enum/feedback_type.dart';
import 'package:dongsoop/presentation/setting/feedback/view_model/feedback_more_view_model.dart';
import 'package:dongsoop/presentation/setting/feedback/widget/feedback_card.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackMoreScreen extends ConsumerStatefulWidget {
  final FeedbackType type;

  const FeedbackMoreScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<FeedbackMoreScreen> createState() =>
      _FeedbackMoreScreenState();
}

class _FeedbackMoreScreenState extends ConsumerState<FeedbackMoreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(feedbackMoreViewModelProvider(widget.type).notifier)
          .load();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        ref
            .read(feedbackMoreViewModelProvider(widget.type).notifier)
            .loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _titleByType(FeedbackType type) {
    switch (type) {
      case FeedbackType.improvement:
        return '개선 의견 전체 보기';
      case FeedbackType.featureRequest:
        return '추가 기능 요청 전체 보기';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackMoreViewModelProvider(widget.type));

    return Scaffold(
      appBar: DetailHeader(title: _titleByType(widget.type)),
      body: SafeArea(
        child: state.isLoading && !state.hasData
            ? const Center(
          child: CircularProgressIndicator(
            color: ColorStyles.primaryColor,
          ),
        )
            : Column(
          children: [
            Expanded(
              child: state.items.isEmpty
                  ? const _EmptySection(
                message: '등록된 피드백이 없습니다.',
              )
                  : ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return FeedbackCard(content: item);
                },
                separatorBuilder: (_, __) =>
                const SizedBox(height: 16),
                itemCount: state.items.length,
              ),
            ),

            if (state.isLoadingMore) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: CircularProgressIndicator(color: ColorStyles.primaryColor,),
              ),
            ] else if (state.hasMore && state.items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(
                        feedbackMoreViewModelProvider(widget.type)
                            .notifier,
                      )
                          .loadMore();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorStyles.gray3),
                      textStyle: TextStyles.smallTextRegular,
                      foregroundColor: ColorStyles.black,
                    ),
                    child: const Text('더 보기'),
                  ),
                ),
              ),
            ],

            if (state.errMessage != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  state.errMessage!,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.warning100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: TextStyles.smallTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}