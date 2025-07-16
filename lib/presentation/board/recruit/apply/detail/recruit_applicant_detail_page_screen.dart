import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_applicant_detail_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitApplicantDetailPage extends ConsumerWidget {
  final RecruitType type;
  final int boardId;
  final int memberId;

  const RecruitApplicantDetailPage({
    super.key,
    required this.type,
    required this.boardId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      recruitApplicantDetailViewModelProvider(
        RecruitApplicantDetailArgs(
          type: type,
          boardId: boardId,
          memberId: memberId,
        ),
      ),
    );

    return state.when(
      data: (detail) => SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: const DetailHeader(title: "지원자 확인"),
          ),
          body: _ApplicantDetailBody(detail: detail),
          bottomNavigationBar: _DecisionButtons(
            onPass: () {
              // TODO: 합격 처리
            },
            onFail: () {
              // TODO: 불합격 처리
            },
          ),
        ),
      ),
      loading: () => const SafeArea(
        child: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => SafeArea(
        child: Scaffold(
          body: Center(child: Text('에러: $e')),
        ),
      ),
    );
  }
}

class _ApplicantDetailBody extends StatelessWidget {
  final RecruitApplicantDetailEntity detail;

  const _ApplicantDetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/profile.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Text(
                        detail.applierName,
                        style: TextStyles.normalTextBold.copyWith(
                          color: ColorStyles.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              detail.departmentName,
                              style: TextStyles.smallTextRegular.copyWith(
                                color: ColorStyles.gray4,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text(
                          formatFullDateTime(detail.applyTime),
                          style: TextStyles.smallTextRegular.copyWith(
                            color: ColorStyles.gray4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: ColorStyles.gray2, height: 1),
          const SizedBox(height: 32),

          // 자기소개
          Text(
            '자기소개',
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            detail.introduction ?? '',
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 40),

          // 지원 동기
          Text(
            '지원 동기',
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            detail.motivation ?? '',
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecisionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onFail;

  const _DecisionButtons({
    required this.onPass,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: ColorStyles.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: ColorStyles.warning10,
                  foregroundColor: ColorStyles.warning100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: onFail,
                child: Text('불합격', style: TextStyles.largeTextBold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: ColorStyles.primaryColor,
                  foregroundColor: ColorStyles.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: onPass,
                child: Text('합격', style: TextStyles.largeTextBold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
