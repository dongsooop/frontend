import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'package:dongsoop/domain/schedule/enum/schedule_type.dart';
import 'package:dongsoop/presentation/schedule/providers/schedule_filter_provider.dart';
import 'package:dongsoop/presentation/schedule/view_models/schedule_view_model.dart';
import 'package:dongsoop/presentation/schedule/widget/schedule_member.dart';
import 'package:dongsoop/presentation/schedule/widget/schedule_official.dart';
import 'package:dongsoop/presentation/schedule/widget/pick_month_year_dialog.dart';
import 'package:dongsoop/presentation/home/providers/home_update_provider.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SchedulePageScreen extends HookConsumerWidget {
  final Future<bool?> Function(
      ScheduleListEntity? event, DateTime selectedDate)? onTapCalendarDetail;

  const SchedulePageScreen({super.key, this.onTapCalendarDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final state = ref.watch(scheduleViewModelProvider);
    final viewModel = ref.read(scheduleViewModelProvider.notifier);

    final items = ref.watch(filterProvider);
    final changed = useState(false);

    void goPrev() => viewModel.goToPreviousMonth();
    void goNext() => viewModel.goToNextMonth();
    Future<void> doRefresh() => viewModel.refresh();

    Future<bool?> handleTapCalendarDetail(
        ScheduleListEntity? event,
        DateTime selectedDate,
        ) async {
      if (onTapCalendarDetail == null) return null;
      final result = await onTapCalendarDetail!(event, selectedDate);
      if (result == true) {
        await viewModel.refresh();
        changed.value = true;
      }
      return result;
    }

    Future<void> _onBack() async {
      if (changed.value) {
        ref.read(homeNeedsRefreshProvider.notifier).state = true;
      }
      context.pop(true);
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '일정 관리',
        onBack: _onBack,
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColorStyles.primaryColor),
          ),
          error: (e, _) => Center(
            child: Text(
              '$e',
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.black,
              ),
            ),
          ),
          data: (state) {
            final month = state.focusedMonth;
            final isPersonalTab = state.tab == ScheduleType.member;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${month.year}년 ${month.month}월',
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '캘린더',
                            style: TextStyles.titleTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          final picked = await pickMonthYearDialog(
                            context,
                            initialMonth: state.focusedMonth,
                            yearStart: 2011,
                            yearEnd: 2030,
                          );
                          if (picked != null) {
                            await viewModel.jumpToMonth(picked);
                          }
                        },
                        icon: const Icon(Icons.calendar_month, size: 24),
                        color: ColorStyles.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),

                      if (user != null)
                        IconButton(
                          onPressed: () => viewModel.setTab(ScheduleType.member),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          constraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                          ),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.person,
                            size: 24,
                            color: isPersonalTab
                                ? ColorStyles.primaryColor
                                : ColorStyles.black,
                          ),
                        ),
                      IconButton(
                        onPressed: () => viewModel.setTab(ScheduleType.official),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.school,
                          size: 24,
                          color: !isPersonalTab
                              ? ColorStyles.primaryColor
                              : ColorStyles.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: (isPersonalTab && user != null)
                      ? ScheduleMemberView(
                    focusedMonth: state.focusedMonth,
                    items: items,
                    onPrevMonth: goPrev,
                    onNextMonth: goNext,
                    onRefresh: doRefresh,
                    onTapCalendarDetail: handleTapCalendarDetail,
                  )
                      : ScheduleOfficialList(
                    events: items,
                    focusedMonth: state.focusedMonth,
                    onPrevMonth: goPrev,
                    onNextMonth: goNext,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}