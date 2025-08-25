import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';

class ReportAdminScreen extends HookConsumerWidget {
  final void Function(int reportId, int targetMemberId) onTapReportSanction;

  final void Function(int reportId, RecruitType type) onTapRecruit;
  final void Function(int reportId, MarketType type) onTapMarket;

  const ReportAdminScreen({
    super.key,
    required this.onTapReportSanction,
    required this.onTapRecruit,
    required this.onTapMarket,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final List<String> tabs = ['미처리', '활성 제재', '처리 완료'];
    final List<String> filterTypes = ['UNPROCESSED', 'ACTIVE_SANCTIONS', 'PROCESSED'];
    final scrollController = useScrollController();

    final viewModel = ref.read(reportAdminViewModelProvider.notifier);
    final reportAdminState = ref.watch(reportAdminViewModelProvider);

    final reports = reportAdminState.reports ?? [];

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadReports(filterTypes[selectedIndex.value]);
      });
      return null;
    }, [selectedIndex.value]);

    useEffect(() {
      void scrollListener() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          viewModel.fetchNextPage(filterTypes[selectedIndex.value]);
        }
      }
      scrollController.addListener(scrollListener);

      return () {
        scrollController.removeListener(scrollListener);
      };
    }, [selectedIndex.value, scrollController]);


    // 오류
    useEffect(() {
      if (reportAdminState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '신고 오류',
              content: reportAdminState.errorMessage!,
              onConfirm: () async {
                Navigator.of(context).pop();
              },
            ),
          );
        });
      }
      return null;
    }, [reportAdminState.errorMessage]);

    // 로딩 상태 표시
    if (reportAdminState.isLoading) {
      return Scaffold(
        backgroundColor: ColorStyles.white,
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: ColorStyles.primaryColor,)
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: '신고 관리',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카테고리 탭
              SizedBox(
                width: double.infinity,
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: List.generate(tabs.length, (index) {
                    return _buildCategoryTab(
                      label: tabs[index],
                      isSelected: selectedIndex.value == index,
                      onTap: () {
                        selectedIndex.value = index;
                      },
                    );
                  }),
                ),
              ),
              // 신고 내용
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: selectedIndex.value == 0
                        ? () => customActionSheet(
                            context,
                            editText: '게시글 확인',
                            onEdit: () {
                              final ReportType type = ReportType.fromString(report.reportType);

                              switch (type) {
                                case ReportType.PROJECT_BOARD:
                                case ReportType.STUDY_BOARD:
                                case ReportType.TUTORING_BOARD:
                                  final recruitType = toRecruitType(type);
                                  onTapRecruit(
                                    report.targetId,
                                    recruitType!,
                                  );
                                  break;
                                case ReportType.MARKETPLACE_BOARD:
                                  onTapMarket(
                                    report.targetId,
                                    MarketType.REPORT,
                                  );
                                  break;
                                case ReportType.MEMBER:
                                  break;
                              }
                            },
                            deleteText: '제재',
                            onDelete: () => onTapReportSanction(
                              report.id,
                              report.targetMemberId!,
                            ),
                          )
                        : null,
                      child: _reportCard(report: report),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 신고 카테고리 선택
  Widget _buildCategoryTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        child: Center(
          child: isSelected ? IntrinsicWidth(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorStyles.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                label,
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          )
          : Text(
            label,
            style: TextStyles.largeTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _reportCard({
    required ReportAdminSanction report
  }) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.reporterNickname, // 신고자 닉네임
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              Spacer(),
              Text(
                report.createdAt, // 신고 시간
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          if (report.sanctionReason != null && report.sanctionReason!.isNotEmpty)
            Text(
              report.sanctionReason!, // 제재 사유
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.black,
              ),
            ),
          if (report.description != null && report.description!.isNotEmpty)
            Text(
              report.description!, // 신고 사유
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.black,
              ),
          ),
          if (report.sanctionStartDate != null && report.sanctionStartDate!.isNotEmpty && report.sanctionEndDate != null && report.sanctionEndDate!.isNotEmpty)
            ...[
              SizedBox(height: 8,),
              Text(
                '${report.sanctionStartDate} ~ ${report.sanctionEndDate}',
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ],
          SizedBox(height: 8,),
          _reportTagRow(
            reportType: ReportType.fromString(report.reportType).message,
            reportReason: ReportReason.fromString(report.reportReason).message,
            adminNickname: report.adminNickname,
            sanctionType: report.sanctionType != null
                ? SanctionType.fromString(report.sanctionType!).message
                : null,
          ),
          SizedBox(height: 8,),
          Divider(
            height: 1,
            color: ColorStyles.gray2
          ),
        ],
      ),
    );
  }

  Widget _reportTagRow({
    required String reportType,
    required String reportReason,
    String? adminNickname,
    String? sanctionType,
  }) {
    final tags = <Widget>[
      _tagBadge(
        label: reportType,
        backgroundColor: ColorStyles.primary5,
        textColor: ColorStyles.primaryColor,
      ),
      _tagBadge(
        label: reportReason,
        backgroundColor: ColorStyles.labelColorRed10,
        textColor: ColorStyles.labelColorRed100,
      ),
    ];

    // 선택적 값 추가
    if (adminNickname != null && adminNickname.isNotEmpty) {
      tags.add(_tagBadge(
        label: adminNickname,
        backgroundColor: ColorStyles.primary5,
        textColor: ColorStyles.primaryColor,
      ));
    }
    if (sanctionType != null && sanctionType.isNotEmpty) {
      tags.add(_tagBadge(
        label: sanctionType,
        backgroundColor: ColorStyles.labelColorRed10,
        textColor: ColorStyles.labelColorRed100,
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: tags,
    );
  }
  Widget _tagBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      child: Text(
        label,
        style: TextStyles.smallTextBold.copyWith(
          color: textColor,
        ),
      ),
    );
  }

  RecruitType? toRecruitType(ReportType type) {
    switch (type) {
      case ReportType.PROJECT_BOARD:
        return RecruitType.PROJECT;
      case ReportType.STUDY_BOARD:
        return RecruitType.STUDY;
      case ReportType.TUTORING_BOARD:
        return RecruitType.TUTORING;
      default:
        return null;
    }
  }
}
