import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/feedback/entity/feature_count_entity.dart';
import 'package:dongsoop/presentation/setting/feedback/view_model/feedback_view_model.dart';
import 'package:dongsoop/presentation/setting/feedback/widget/feedback_bar_chart.dart';
import 'package:dongsoop/presentation/setting/feedback/widget/feedback_card.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackResultScreen extends ConsumerStatefulWidget {
  const FeedbackResultScreen({super.key});

  @override
  ConsumerState<FeedbackResultScreen> createState() =>
      _FeedbackResultScreenState();
}

class _FeedbackResultScreenState extends ConsumerState<FeedbackResultScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => ref.read(feedbackResultViewModelProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackResultViewModelProvider);

    final List<ServiceStat> serviceStats =
    _buildServiceStats(state.serviceFeatures);

    final int totalRespondents = state.improvementSuggestions.isNotEmpty
        ? state.improvementSuggestions.length
        : state.featureRequests.length;

    return Scaffold(
      appBar: DetailHeader(title: '피드백 결과 조회'),
      body: SafeArea(
        child: state.isLoading && !state.hasData
            ? const Center(
            child:
            CircularProgressIndicator(color: ColorStyles.primaryColor))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // CSV 내보내기 처리
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  Text(
                    '총 $totalRespondents명 응답',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                '선호하는 기능',
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: ColorStyles.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: serviceStats.isEmpty
                    ? const _EmptySection(
                  message: '아직 집계된 데이터가 없습니다.',
                )
                    : FeedbackBarChart(stats: serviceStats),
              ),

              const SizedBox(height: 48),

              _SectionHeader(
                title: '개선 요구사항',
                onTapMore: () {
                  // 개선 의견 전체 보기
                },
              ),
              const SizedBox(height: 16),
              if (state.improvementSuggestions.isEmpty)
                const _EmptySection(
                  message: '등록된 개선 의견이 없습니다.',
                )
              else
                Column(
                  children: [
                    for (int i = 0;
                    i < state.improvementSuggestions.length;
                    i++) ...[
                      FeedbackCard(
                        content: state.improvementSuggestions[i],
                      ),
                      if (i != state.improvementSuggestions.length - 1)
                        const SizedBox(height: 16),
                    ],
                  ],
                ),

              const SizedBox(height: 48),

              _SectionHeader(
                title: '추가 기능',
                onTapMore: () {
                  // 추가 기능 의견 전체 보기
                },
              ),
              const SizedBox(height: 16),
              if (state.featureRequests.isEmpty)
                const _EmptySection(
                  message: '등록된 추가 기능 의견이 없습니다.',
                )
              else
                Column(
                  children: [
                    for (int i = 0;
                    i < state.featureRequests.length;
                    i++) ...[
                      FeedbackCard(
                        content: state.featureRequests[i],
                      ),
                      if (i != state.featureRequests.length - 1)
                        const SizedBox(height: 16),
                    ],
                  ],
                ),

              if (state.errMessage != null) ...[
                const SizedBox(height: 24),
                Text(
                  state.errMessage!,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.warning100,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<ServiceStat> _buildServiceStats(List<FeedbackCountEntity> entities) {
    return entities
        .map(
          (e) => ServiceStat(
        e.serviceFeatureName,
        e.count,
      ),
    )
        .toList();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onTapMore,
  });

  final String title;
  final VoidCallback onTapMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.normalTextBold.copyWith(
            color: ColorStyles.black,
          ),
        ),
        InkWell(
          onTap: onTapMore,
          child: Row(
            children: [
              Text(
                '더보기',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray5,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 24,
                color: ColorStyles.gray5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
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
