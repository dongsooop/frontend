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
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportAdminScreen extends ConsumerStatefulWidget {
  final Future<bool?> Function(ReportAdminSanction report) onTapReportSanction;

  const ReportAdminScreen({
    super.key,
    required this.onTapReportSanction,
  });

  @override
  ConsumerState<ReportAdminScreen> createState() => _ReportAdminScreenState();
}

class _ReportAdminScreenState extends ConsumerState<ReportAdminScreen> {
  int _refreshRevision = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ReportAdminFilter.values.length,
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: const DetailHeader(title: '신고 관리'),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorStyles.gray7,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    overlayColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    splashBorderRadius: BorderRadius.circular(8),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: ColorStyles.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: ColorStyles.white,
                    labelStyle: TextStyles.normalTextBold,
                    unselectedLabelColor: ColorStyles.gray6,
                    unselectedLabelStyle: TextStyles.normalTextRegular,
                    tabs: ReportAdminFilter.values
                        .map(
                          (filter) => Tab(
                            key: Key('report-filter-${filter.label}'),
                            text: filter.label,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: ReportAdminFilter.values
                      .map(
                        (filter) => _ReportTabPage(
                          key: PageStorageKey(filter),
                          filter: filter,
                          refreshRevision: _refreshRevision,
                          onOpenReport: (report) => _openReport(
                            context,
                            filter,
                            report,
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openReport(
    BuildContext context,
    ReportAdminFilter filter,
    ReportAdminSanction report,
  ) async {
    final reportType = ReportType.fromString(report.reportType);
    final isMessageReport = reportType == ReportType.CHAT_MESSAGE ||
        reportType == ReportType.BLINDDATE_MESSAGE;
    final canHandle = filter == ReportAdminFilter.unprocessed &&
        !report.isProcessed &&
        isMessageReport;
    final canReviewSanction = canHandle && report.targetMemberId != null;
    final canDismiss = canHandle;

    final result = await ReportAdminDetailBottomSheet.show(
      context,
      report: report,
      canReviewSanction: canReviewSanction,
      canDismiss: canDismiss,
    );
    if (!context.mounted) return;

    if (result == ReportAdminDetailResult.refresh) {
      _refreshAllTabs();
    } else if (result == ReportAdminDetailResult.reviewSanction) {
      final processed = await widget.onTapReportSanction(report);
      if (processed == true && mounted) _refreshAllTabs();
    }
  }

  void _refreshAllTabs() {
    setState(() => _refreshRevision += 1);
  }
}

class _ReportTabPage extends ConsumerStatefulWidget {
  final ReportAdminFilter filter;
  final int refreshRevision;
  final Future<void> Function(ReportAdminSanction report) onOpenReport;

  const _ReportTabPage({
    super.key,
    required this.filter,
    required this.refreshRevision,
    required this.onOpenReport,
  });

  @override
  ConsumerState<_ReportTabPage> createState() => _ReportTabPageState();
}

class _ReportTabPageState extends ConsumerState<_ReportTabPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.microtask(_loadOrRefresh);
  }

  @override
  void didUpdateWidget(covariant _ReportTabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshRevision != widget.refreshRevision) {
      Future.microtask(_loadOrRefresh);
    }
  }

  void _loadOrRefresh() {
    if (!mounted) return;
    final provider = reportAdminViewModelProvider(widget.filter);
    final state = ref.read(provider);
    final viewModel = ref.read(provider.notifier);
    if (state.hasLoaded) {
      viewModel.refresh();
    } else {
      viewModel.loadReports();
    }
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(reportAdminViewModelProvider(widget.filter).notifier)
          .fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = reportAdminViewModelProvider(widget.filter);
    final viewModel = ref.read(provider.notifier);
    final state = ref.watch(provider);

    return _ReportListBody(
      state: state,
      viewModel: viewModel,
      scrollController: _scrollController,
      onOpenReport: widget.onOpenReport,
    );
  }
}

class _ReportListBody extends StatelessWidget {
  final ReportAdminState state;
  final ReportAdminViewModel viewModel;
  final ScrollController scrollController;
  final Future<void> Function(ReportAdminSanction) onOpenReport;

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
                      switch (state.filter) {
                        ReportAdminFilter.unprocessed => '현재 처리할 신고가 없습니다.',
                        ReportAdminFilter.activeSanctions =>
                          '현재 적용 중인 제재가 없습니다.',
                        ReportAdminFilter.processed => '처리 완료된 신고가 없습니다.',
                      },
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
                onTap: () async {
                  await onOpenReport(report);
                },
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
