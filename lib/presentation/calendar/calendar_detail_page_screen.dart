import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_delete_view_model.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_view_model.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_write_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarDetailPageScreen extends HookConsumerWidget {
  const CalendarDetailPageScreen({
    super.key,
    required this.selectedDate,
    this.event,
  });

  final DateTime selectedDate;
  final CalendarListEntity? event;

  String formatDateTime(DateTime date, {bool showTime = true}) {
    final weekdayNames = ['일', '월', '화', '수', '목', '금', '토'];
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdayNames[date.weekday % 7];

    String hour;
    String minute;

    if (date.hour == 23 && date.minute == 59) {
      hour = '24';
      minute = '00';
    } else {
      hour = date.hour.toString().padLeft(2, '0');
      minute = date.minute.toString().padLeft(2, '0');
    }

    if (showTime) {
      return '$year년 $month월 $day일 ($weekday) $hour:$minute';
    } else {
      return '$year년 $month월 $day일 ($weekday)';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = event != null;
    final isOfficial = event?.type == CalendarType.official;
    final user = ref.watch(userSessionProvider);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController(text: event?.title ?? '');
    final locationController = useTextEditingController(
      text: isOfficial ? '동양미래대학교' : event?.location ?? '',
    );
    final startDate = useState<DateTime>(event?.startAt ?? selectedDate);
    final endDate = useState<DateTime>(
      event?.endAt ?? selectedDate.add(const Duration(hours: 1)),
    );
    final showStartPicker = useState(false);
    final showEndPicker = useState(false);

    Widget buildCupertinoDatePicker({
      required DateTime initialDateTime,
      required void Function(DateTime) onDateTimeChanged,
    }) {
      return SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: initialDateTime,
          onDateTimeChanged: onDateTimeChanged,
          use24hFormat: true,
          minuteInterval: 5,
        ),
      );
    }

    Widget buildTimeRangeSection() {
      return Container(
        decoration: BoxDecoration(
          color: ColorStyles.white,
          border: Border.all(color: ColorStyles.gray2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: isOfficial
                  ? null
                  : () {
                      showStartPicker.value = !showStartPicker.value;
                      showEndPicker.value = false;
                    },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('시작', style: TextStyles.normalTextRegular),
                    Text(
                      formatDateTime(startDate.value, showTime: !isOfficial),
                      style: TextStyles.normalTextRegular,
                    ),
                  ],
                ),
              ),
            ),
            if (!isOfficial && showStartPicker.value)
              buildCupertinoDatePicker(
                initialDateTime: startDate.value,
                onDateTimeChanged: (date) => startDate.value = date,
              ),
            const Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
            GestureDetector(
              onTap: isOfficial
                  ? null
                  : () {
                      showEndPicker.value = !showEndPicker.value;
                      showStartPicker.value = false;
                    },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('종료', style: TextStyles.normalTextRegular),
                    Text(
                      formatDateTime(endDate.value, showTime: !isOfficial),
                      style: TextStyles.normalTextRegular,
                    ),
                  ],
                ),
              ),
            ),
            if (!isOfficial && showEndPicker.value)
              buildCupertinoDatePicker(
                initialDateTime: endDate.value,
                onDateTimeChanged: (date) => endDate.value = date,
              ),
          ],
        ),
      );
    }

    void showDeleteActionSheet() {
      customActionSheet(
        context,
        onDelete: () async {
          if (event?.id != null) {
            try {
              await ref
                  .read(calendarDeleteViewModelProvider.notifier)
                  .delete(calendarId: event!.id!);
              ref.invalidate(calendarViewModelProvider(user!.id, selectedDate));
              if (context.mounted) context.pop(true);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$e')),
                );
              }
            }
          }
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              isOfficial
                  ? '학사 일정'
                  : isEditMode
                      ? '일정 편집'
                      : '일정 추가',
              style:
                  TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
            ),
            centerTitle: true,
            leading: TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: ColorStyles.primary100,
                overlayColor: Colors.transparent,
              ),
              child: Text(
                '취소',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.primary100,
                ),
              ),
            ),
            actions: [
              isOfficial
                  ? const SizedBox(width: 64)
                  : TextButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        final hasChanged = ref
                            .read(calendarWriteViewModelProvider.notifier)
                            .isChanged(
                              original: event == null
                                  ? null
                                  : CalendarEntity(
                                      id: event!.id,
                                      title: event!.title,
                                      location: event!.location,
                                      startAt: event!.startAt,
                                      endAt: event!.endAt,
                                      isPersonal:
                                          event!.type != CalendarType.official,
                                    ),
                              title: titleController.text,
                              location: locationController.text,
                              startAt: startDate.value,
                              endAt: endDate.value,
                            );

                        if (!hasChanged) {
                          if (context.mounted) context.pop(false);
                          return;
                        }

                        final entity = CalendarEntity(
                          id: event?.id,
                          title: titleController.text,
                          location: locationController.text,
                          startAt: startDate.value,
                          endAt: endDate.value,
                          isPersonal: !isOfficial,
                        );

                        try {
                          await ref
                              .read(calendarWriteViewModelProvider.notifier)
                              .submit(entity);
                          ref.invalidate(calendarViewModelProvider(
                              user!.id, selectedDate));
                          if (context.mounted) context.pop(true);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$e')),
                            );
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: ColorStyles.primary100,
                        overlayColor: Colors.transparent,
                      ),
                      child: Text('저장',
                          style: TextStyles.normalTextBold
                              .copyWith(color: ColorStyles.primary100)),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: isEditMode && !isOfficial
            ? PrimaryBottomButton(
                label: '일정 삭제', onPressed: showDeleteActionSheet)
            : null,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    enabled: !isOfficial,
                    style: TextStyles.normalTextRegular
                        .copyWith(color: ColorStyles.black),
                    validator: (value) =>
                        value == null || value.isEmpty ? '제목을 입력해주세요' : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyles.white,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '일정 제목을 입력해주세요.',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildTimeRangeSection(),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: locationController,
                    enabled: !isOfficial,
                    style: TextStyles.normalTextRegular
                        .copyWith(color: ColorStyles.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyles.white,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '장소를 입력해주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorStyles.gray2),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
