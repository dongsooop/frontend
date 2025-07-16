import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/auth/model/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/detail/widget/botton_button.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/components/custom_action_sheet.dart';
import '../../../../providers/auth_providers.dart';

class RecruitDetailPageScreen extends ConsumerWidget {
  final int id;
  final RecruitType type;
  final Future<bool?> Function() onTapRecruitApply;
  final void Function(String reportType, int targetId) onTapReport;

  const RecruitDetailPageScreen({
    required this.id,
    required this.type,
    required this.onTapRecruitApply,
    required this.onTapReport,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);

    final detailState = ref.watch(
      recruitDetailViewModelProvider(
        RecruitDetailArgs(id: id, type: type),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: type.label,
            trailing: user != null
              ? IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    customActionSheet(
                      context,
                      onReport: () => onTapReport(type.reportType.name, id),
                      onDelete: () {},
                    );
                  },
                )
              : null,
          ),
        ),
        bottomNavigationBar: detailState.maybeWhen(
          data: (data) {
            final detail = data.recruitDetail;
            if (detail == null) return const SizedBox.shrink();

            final viewType = detail.viewType; // 'OWNER' | 'MEMBER' | 'GUEST'
            final isAuthor = viewType == 'OWNER';
            final isGuest = viewType == 'GUEST';

            String buttonLabel;
            bool isEnabled = true;

            if (isAuthor) {
              buttonLabel = '지원자 확인';
            } else if (viewType == 'MEMBER' && detail.isAlreadyApplied) {
              buttonLabel = '지원 완료';
              isEnabled = false;
            } else {
              buttonLabel = '지원하기';
            }

            return RecruitBottomButton(
              label: buttonLabel,
              isEnabled: isEnabled,
              onPressed: () async {
                if (isAuthor) {
                  // TODO: 지원자 확인 화면 이동
                } else if (isGuest) {
                  showDialog(
                    context: context,
                    builder: (_) => LoginRequiredDialog(),
                  );
                } else {
                  final didApply = await onTapRecruitApply();
                  if (didApply == true) {
                    ref.invalidate(
                      recruitDetailViewModelProvider(
                        RecruitDetailArgs(id: id, type: type),
                      ),
                    );
                  }
                }
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
        body: detailState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (data) {
            final detail = data.recruitDetail;
            if (detail == null) {
              return const Center(child: Text('상세정보가 없습니다.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: ColorStyles.primary5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '모집 중',
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          detail.title,
                          style: TextStyles.largeTextBold.copyWith(
                            color: ColorStyles.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${detail.volunteer}명이 지원했어요',
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                        Text(formatFullDateTime(detail.createdAt),
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: ColorStyles.gray2, height: 1),
                    const SizedBox(height: 24),
                    Text('모집 기간',
                        style: TextStyles.normalTextBold
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 8),
                    Text(
                      '${formatFullDateTime(detail.startAt)} ~ ${formatFullDateTime(detail.endAt)}',
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.black),
                    ),
                    const SizedBox(height: 32),
                    Text(detail.content,
                        style: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.black)),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            ...detail.tags
                                .split(',')
                                .map((tag) => tag.trim())
                                .where((tag) => tag.isNotEmpty)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (entry) => CommonTag(
                                    label: entry.value,
                                    index: entry.key,
                                  ),
                                ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          children: [
                            ...detail.departmentTypeList.map(
                              (dep) => CommonTag(
                                label: DepartmentTypeExtension.fromCode(dep)
                                    .displayName,
                                index: -1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
