import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_applicant_list_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitApplicantListPage extends ConsumerWidget {
  final int boardId;
  final RecruitType type;
  final Future<String?> Function(int memberId) onTapApplicantDetail;

  const RecruitApplicantListPage({
    Key? key,
    required this.boardId,
    required this.type,
    required this.onTapApplicantDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantListAsync = ref.watch(
      recruitApplicantListViewModelProvider(boardId: boardId, type: type),
    );

    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: DetailHeader(title: "지원자 확인"),
        ),
        body: applicantListAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return const Center(child: Text('지원자가 없습니다.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final applicant = list[index];
                final statusInfo = _statusBadge(applicant.status);

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    final result =
                        await onTapApplicantDetail(applicant.memberId);
                    if (result == 'PASS' || result == 'FAIL') {
                      ref.invalidate(
                        recruitApplicantListViewModelProvider(
                          boardId: boardId,
                          type: type,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    // 전체 터치 영역 확보
                    child: Column(
                      children: [
                        SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/profile.png',
                                width: 48,
                                height: 48,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      applicant.memberName,
                                      style: TextStyles.normalTextBold.copyWith(
                                        color: ColorStyles.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      applicant.departmentName,
                                      style:
                                          TextStyles.smallTextRegular.copyWith(
                                        color: ColorStyles.gray4,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusInfo.backgroundColor,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Text(
                                  statusInfo.label,
                                  style: TextStyles.smallTextBold.copyWith(
                                    color: statusInfo.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(
              child:
                  CircularProgressIndicator(color: ColorStyles.primaryColor)),
          error: (e, _) => Center(child: Text('에러: $e')),
        ),
      ),
    );
  }
}

class _StatusInfo {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _StatusInfo(this.label, this.backgroundColor, this.textColor);
}

_StatusInfo _statusBadge(String status) {
  switch (status) {
    case 'PASS':
      return const _StatusInfo(
          '합격', ColorStyles.primary5, ColorStyles.primaryColor);
    case 'FAIL':
      return const _StatusInfo(
          '불합격', ColorStyles.labelColorRed10, ColorStyles.labelColorRed100);
    case 'APPLY':
    default:
      return const _StatusInfo('미정', ColorStyles.gray1, ColorStyles.gray3);
  }
}
