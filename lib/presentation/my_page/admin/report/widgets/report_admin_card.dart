import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class ReportAdminCard extends StatelessWidget {
  final ReportAdminSanction report;
  final VoidCallback onTap;

  const ReportAdminCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final reportType = ReportType.fromString(report.reportType);
    final reportReason = ReportReason.fromString(report.reportReason);
    final roomTypeLabel = report.chatRoomType?.label;
    final relatedResolutionLabel = report.relatedResolutionLabel;
    final sanctionType = report.sanctionType == null
        ? null
        : SanctionType.tryFromString(report.sanctionType!);

    return Semantics(
      button: true,
      label: '${reportType.message} 신고 상세 보기',
      child: InkWell(
        key: Key('report-admin-card-${report.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorStyles.white,
            border: Border.all(color: ColorStyles.gray2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      report.targetMemberLabel,
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    report.createdAt,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                report.messageContent ?? '메시지 내용을 확인할 수 없습니다.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.black,
                  height: 1.45,
                ),
              ),
              if (report.messageSentAt != null &&
                  report.messageSentAt!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  '메시지 전송 ${report.messageSentAt}',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _Tag(
                    label: reportType.message,
                    backgroundColor: ColorStyles.primary5,
                    textColor: ColorStyles.primaryColor,
                  ),
                  if (roomTypeLabel != null)
                    _Tag(
                      label: roomTypeLabel,
                      backgroundColor: ColorStyles.gray7,
                      textColor: ColorStyles.gray6,
                    ),
                  _Tag(
                    label: reportReason.message,
                    backgroundColor: ColorStyles.labelColorRed10,
                    textColor: ColorStyles.labelColorRed100,
                  ),
                  if (sanctionType != null)
                    _Tag(
                      label: sanctionType.message,
                      backgroundColor: ColorStyles.amberBg,
                      textColor: ColorStyles.labelColorYellow100,
                    ),
                ],
              ),
              if (relatedResolutionLabel != null) ...[
                const SizedBox(height: 12),
                Container(
                  key: Key('report-related-resolution-${report.id}'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorStyles.primary5,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    relatedResolutionLabel,
                    style: TextStyles.smallTextBold.copyWith(
                      color: ColorStyles.primaryGray,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                '신고자 ${report.reporterNickname}',
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _Tag({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        style: TextStyles.smallTextBold.copyWith(color: textColor),
      ),
    );
  }
}
