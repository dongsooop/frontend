import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/presentation/calendar/providers/calendar_filter_provider.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_view_model.dart';
import 'package:dongsoop/presentation/calendar/widget/calendar_member.dart';
import 'package:dongsoop/presentation/calendar/widget/calendar_official.dart';
import 'package:dongsoop/presentation/calendar/widget/pick_month_year_dialog.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarPageScreen extends HookConsumerWidget {
  final Future<bool?> Function(
      CalendarListEntity? event, DateTime selectedDate)? onTapCalendarDetail;

  const CalendarPageScreen({super.key, this.onTapCalendarDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final state = ref.watch(calendarViewModelProvider);
    final viewModel = ref.read(calendarViewModelProvider.notifier);

    final items = ref.watch(filterProvider);

    void goPrev() => viewModel.goToPreviousMonth();
    void goNext() => viewModel.goToNextMonth();
    Future<void> doRefresh() => viewModel.refresh();

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '일정 관리'),
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
            final isPersonalTab = state.tab == CalendarType.member;

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
                          onPressed: () => viewModel.setTab(CalendarType.member),
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
                        onPressed: () => viewModel.setTab(CalendarType.official),
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
                      ? CalendarMemberView(
                    focusedMonth: state.focusedMonth,
                    items: items,
                    onPrevMonth: goPrev,
                    onNextMonth: goNext,
                    onRefresh: doRefresh,
                    onTapCalendarDetail: onTapCalendarDetail,
                  )
                      : CalendarOfficialList(
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