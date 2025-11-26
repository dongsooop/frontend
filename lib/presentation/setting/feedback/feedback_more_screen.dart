import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/feedback/enum/feedback_type.dart';
import 'package:dongsoop/presentation/setting/feedback/view_model/feedback_more_view_model.dart';
import 'package:dongsoop/presentation/setting/feedback/widget/feedback_card.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(feedbackMoreViewModelProvider(widget.type).notifier)
          .load();
    });
  }

  String _titleByType(FeedbackType type) {
    switch (type) {
      case FeedbackType.improvement:
        return '개선 의견 전체 보기';
      case FeedbackType.featureRequest:
        return '추가 기능 요청 전체 보기';
    }
  }

  String _csvHeaderByType(FeedbackType type) {
    switch (type) {
      case FeedbackType.improvement:
        return '개선 의견';
      case FeedbackType.featureRequest:
        return '추가 기능 요청';
    }
  }

  String _csvFileNameByType(FeedbackType type) {
    switch (type) {
      case FeedbackType.improvement:
        return 'feedback_improvement.csv';
      case FeedbackType.featureRequest:
        return 'feedback_feature_request.csv';
    }
  }

  Future<void> _exportCsv(List<String> items) async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내보낼 피드백이 없어요.')),
      );
      return;
    }

    final rows = <List<dynamic>>[];

    rows.add([_csvHeaderByType(widget.type)]);

    for (final item in items) {
      rows.add([item]);
    }

    final csv = const ListToCsvConverter().convert(rows);

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${_csvFileNameByType(widget.type)}';

    final file = File(path);
    await file.writeAsString(csv);

    final params = ShareParams(
      files: [XFile(path)],
      text: _csvHeaderByType(widget.type),
    );

    await SharePlus.instance.share(params);
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
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _exportCsv(state.items),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      side: BorderSide(color: ColorStyles.gray3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyles.smallTextRegular,
                      foregroundColor: ColorStyles.black,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.save_alt, size: 16),
                        SizedBox(width: 4),
                        Text('내보내기'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.items.isEmpty
                  ? const _EmptySection(
                message: '등록된 피드백이 없습니다.',
              )
                  : ListView.separated(
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