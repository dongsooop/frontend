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

  const RecruitApplicantListPage({
    Key? key,
    required this.boardId,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantListAsync = ref.watch(
      recruitApplicantListViewModelProvider(boardId: boardId, type: type),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: DetailHeader(
          title: "지원자 확인",
        ),
      ),
      body: SafeArea(
        child: applicantListAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return const Center(child: Text('지원자가 없습니다.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final applicant = list[index];
                final name = applicant.memberName;
                final statusInfo = _statusBadge(applicant.status);

                return Column(
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
                                  name,
                                  style: TextStyles.normalTextBold.copyWith(
                                    color: ColorStyles.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  applicant.departmentName,
                                  style: TextStyles.smallTextRegular.copyWith(
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
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
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
          '불합격', ColorStyles.warning10, ColorStyles.warning100);
    case 'APPLY':
    default:
      return const _StatusInfo('미정', ColorStyles.gray1, ColorStyles.gray3);
  }
}
