import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/report/enum/report_admin_filter.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_state.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_view_model.dart';
import 'package:dongsoop/presentation/my_page/admin/report/widgets/report_admin_card.dart';
import 'package:dongsoop/presentation/my_page/admin/report/widgets/report_admin_detail_bottom_sheet.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportAdminScreen extends HookConsumerWidget {
  final void Function(int reportId, int targetMemberId) onTapReportSanction;

  const ReportAdminScreen({
    super.key,
    required this.onTapReportSanction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final viewModel = ref.read(reportAdminViewModelProvider.notifier);
    final state = ref.watch(reportAdminViewModelProvider);

    useEffect(() {
      Future.microtask(viewModel.loadReports);
      return null;
    }, const []);

    useEffect(() {
      void scrollListener() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          viewModel.fetchNextPage();
        }
      }

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, [scrollController, viewModel]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '신고 관리'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: SizedBox(
                height: 44,
                child: Row(
                  children: ReportAdminFilter.values
                      .map(
                        (filter) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _CategoryTab(
                            label: filter.label,
                            isSelected: state.filter == filter,
                            onTap: () {
                              if (filter == state.filter) return;
                              if (scrollController.hasClients) {
                                scrollController.jumpTo(0);
                              }
                              viewModel.selectFilter(filter);
                            },
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
            Expanded(
              child: _ReportListBody(
                state: state,
                viewModel: viewModel,
                scrollController: scrollController,
                onOpenReport: (report) =>
                    _openReport(context, state.filter, report),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openReport(
    BuildContext context,
    ReportAdminFilter filter,
    ReportAdminSanction report,
  ) {
    final reportType = ReportType.fromString(report.reportType);
    final canReview = filter == ReportAdminFilter.unprocessed &&
        !report.isProcessed &&
        report.targetMemberId != null &&
        reportType != ReportType.UNKNOWN;

    ReportAdminDetailBottomSheet.show(
      context,
      report: report,
      onReview: canReview
          ? () => onTapReportSanction(report.id, report.targetMemberId!)
          : null,
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        key: Key('report-filter-$label'),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(
                        bottom: BorderSide(
                          color: ColorStyles.primaryColor,
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: Text(
                label,
                style: (isSelected
                        ? TextStyles.largeTextBold
                        : TextStyles.largeTextRegular)
                    .copyWith(
                  color:
                      isSelected ? ColorStyles.primaryColor : ColorStyles.gray4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportListBody extends StatelessWidget {
  final ReportAdminState state;
  final ReportAdminViewModel viewModel;
  final ScrollController scrollController;
  final ValueChanged<ReportAdminSanction> onOpenReport;

  const _ReportListBody({
    required this.state,
    required this.viewModel,
    required this.scrollController,
    required this.onOpenReport,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(color: ColorStyles.primaryColor),
      );
    }

    if (state.errorMessage != null && state.reports.isEmpty) {
      return _InitialError(
        message: state.errorMessage!,
        onRetry: viewModel.loadReports,
      );
    }

    return RefreshIndicator(
      color: ColorStyles.primaryColor,
      onRefresh: viewModel.refresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (state.reports.isEmpty) {
            return ListView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Center(
                    child: Text(
                      '해당하는 신고가 없습니다.',
                      key: const Key('report-admin-empty'),
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray4,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final showFooter =
              state.isLoadingMore || state.loadMoreErrorMessage != null;
          return ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: state.reports.length + (showFooter ? 1 : 0),
            separatorBuilder: (_, index) => index < state.reports.length - 1
                ? const SizedBox(height: 12)
                : const SizedBox.shrink(),
            itemBuilder: (context, index) {
              if (index == state.reports.length) {
                return _LoadMoreFooter(
                  isLoading: state.isLoadingMore,
                  errorMessage: state.loadMoreErrorMessage,
                  onRetry: viewModel.fetchNextPage,
                );
              }

              final report = state.reports[index];
              return ReportAdminCard(
                report: report,
                onTap: () => onOpenReport(report),
              );
            },
          );
        },
      ),
    );
  }
}

class _InitialError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InitialError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              key: const Key('report-admin-initial-error'),
              textAlign: TextAlign.center,
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.gray4,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  const _LoadMoreFooter({
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorStyles.primaryColor,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            errorMessage!,
            key: const Key('report-admin-load-more-error'),
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.warning100,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
