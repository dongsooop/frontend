import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/presentation/calendar/common/calendar_text_form.dart';
import 'package:dongsoop/presentation/calendar/util/calendar_date_utils.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_delete_view_model.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_view_model.dart';
import 'package:dongsoop/presentation/calendar/view_models/calendar_write_view_model.dart';
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

  String formatDateTime(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final weekday = weekdays[date.weekday % 7];

    String hour;
    String minute;

    if (date.hour == 23 && date.minute == 59) {
      hour = '24';
      minute = '00';
    } else {
      hour = date.hour.toString().padLeft(2, '0');
      minute = date.minute.toString().padLeft(2, '0');
    }
    return '$year년 $month월 $day일 ($weekday) $hour:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messenger = ScaffoldMessenger.of(context);

    final isEditMode = event != null;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController(text: event?.title ?? '');
    final locationController = useTextEditingController(text: event?.location ?? '');
    final startDate = useState<DateTime>(event?.startAt ?? selectedDate);
    final endDate = useState<DateTime>(event?.endAt ?? selectedDate.add(const Duration(hours: 1)));
    final showStartPicker = useState(false);
    final showEndPicker = useState(false);

    String normalizeText(String raw) {
      final trimmed = raw.trim();
      return trimmed.isEmpty ? "" : trimmed;
    }

    Future<void> invalidateCalendar() async {
      ref.invalidate(calendarViewModelProvider);
    }

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
              onTap: () {
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
                      formatDateTime(startDate.value),
                      style: TextStyles.normalTextRegular,
                    ),
                  ],
                ),
              ),
            ),
            if (showStartPicker.value)
              buildCupertinoDatePicker(
                initialDateTime: startDate.value,
                onDateTimeChanged: (date) => startDate.value = date,
              ),
            const Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
            GestureDetector(
              onTap: () {
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
                      formatDateTime(endDate.value),
                      style: TextStyles.normalTextRegular,
                    ),
                  ],
                ),
              ),
            ),
            if (showEndPicker.value)
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
          if (event?.id == null) return;
          try {
            await ref
                .read(calendarDeleteViewModelProvider.notifier)
                .delete(calendarId: event!.id!);

            await invalidateCalendar();

            if (context.mounted) context.pop(true);
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(content: Text('$e')),
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: AppBar(
          backgroundColor: ColorStyles.gray1,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            isEditMode ? '일정 편집' : '일정 추가',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
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
            TextButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? true)) return;
                if (endDate.value.isBefore(startDate.value)) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('종료 시간이 시작 시간보다 이전입니다.')),
                  );
                  return;
                }

                final original = event == null
                    ? null
                    : CalendarEntity(
                  id: event!.id,
                  title: event!.title,
                  location: event!.location ?? "",
                  startAt: event!.startAt,
                  endAt: event!.endAt,
                );

                final changed = ref
                    .read(calendarWriteViewModelProvider.notifier)
                    .isChanged(
                  original: original,
                  title: titleController.text,
                  location: normalizeText(locationController.text),
                  startAt: startDate.value,
                  endAt: endDate.value,
                );

                if (isEditMode && !changed) {
                  if (context.mounted) context.pop(false);
                  return;
                }

                final entity = CalendarEntity(
                  id: event?.id,
                  title: titleController.text,
                  location: normalizeText(locationController.text),
                  startAt: startDate.value,
                  endAt: endDate.value,
                );

                try {
                  await ref
                      .read(calendarWriteViewModelProvider.notifier)
                      .submit(entity);

                  await invalidateCalendar();

                  if (context.mounted) context.pop(true);
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: ColorStyles.primary100,
                overlayColor: Colors.transparent,
              ),
              child: Text(
                '저장',
                style: TextStyles.normalTextBold
                    .copyWith(color: ColorStyles.primary100),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isEditMode
          ? PrimaryBottomButton(
        label: '일정 삭제',
        onPressed: showDeleteActionSheet,
      )
          : null,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    CalendarTextForm(
                      controller: titleController,
                      hintText: '일정 제목을 입력해주세요.',
                      maxLength: 60,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '제목을 입력해주세요' : null,
                    ),
                    const SizedBox(height: 24),
                    buildTimeRangeSection(),
                    const SizedBox(height: 24),
                    CalendarTextForm(
                      controller: locationController,
                      hintText: '장소를 입력해주세요',
                      maxLength: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}