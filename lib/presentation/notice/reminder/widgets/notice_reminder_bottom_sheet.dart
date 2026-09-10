import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeReminderBottomSheet extends StatefulWidget {
  final int noticeId;
  final String title;
  final Future<void> Function(DateTime remindAt) onSubmit;

  const NoticeReminderBottomSheet({
    super.key,
    required this.noticeId,
    required this.title,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required int noticeId,
    required String title,
    required Future<void> Function(DateTime remindAt) onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: ColorStyles.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => NoticeReminderBottomSheet(
        noticeId: noticeId,
        title: title,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<NoticeReminderBottomSheet> createState() =>
      _NoticeReminderBottomSheetState();
}

class _NoticeReminderBottomSheetState extends State<NoticeReminderBottomSheet> {
  DateTime? _selected;
  bool _isSubmitting = false;
  bool _showCustomPicker = false;

  DateTime get _now => DateTime.now();

  DateTime get _evening {
    final now = _now;
    final todayEvening = DateTime(now.year, now.month, now.day, 18);
    if (todayEvening.isAfter(now)) {
      return todayEvening;
    }
    return DateTime(now.year, now.month, now.day + 1, 18);
  }

  String get _eveningLabel {
    final now = _now;
    final todayEvening = DateTime(now.year, now.month, now.day, 18);
    return todayEvening.isAfter(now) ? '오늘 저녁' : '내일 저녁';
  }

  DateTime get _tomorrow {
    final now = _now;
    return DateTime(now.year, now.month, now.day + 1, 9);
  }

  Future<void> _submit(DateTime remindAt) async {
    if (_isSubmitting) return;

    setState(() {
      _selected = remindAt;
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(remindAt);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('리마인더 설정에 실패했어요. 잠시 후 다시 시도해주세요.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final minimum = _now.add(const Duration(minutes: 1));
    final customInitial = _selected != null && _selected!.isAfter(minimum)
        ? _selected!
        : minimum.add(const Duration(minutes: 9));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '언제 리마인드 해드릴까요?',
            style: TextStyles.largeTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.gray5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _QuickOption(
            label: '1시간 후',
            onTap: () => _submit(_now.add(const Duration(hours: 1))),
          ),
          _QuickOption(
            label: _eveningLabel,
            onTap: () => _submit(_evening),
          ),
          _QuickOption(
            label: '내일 오전 9시',
            onTap: () => _submit(_tomorrow),
          ),
          _QuickOption(
            label: '직접 설정',
            onTap: () => setState(() => _showCustomPicker = true),
          ),
          if (_showCustomPicker) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: true,
                minimumDate: minimum,
                initialDateTime: customInitial,
                onDateTimeChanged: (value) {
                  _selected = value;
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSubmitting
                    ? null
                    : () => _submit(_selected ?? customInitial),
                style: FilledButton.styleFrom(
                  backgroundColor: ColorStyles.primary100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorStyles.white,
                        ),
                      )
                    : Text(
                        '리마인더 설정',
                        style: TextStyles.normalTextBold.copyWith(
                          color: ColorStyles.white,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickOption({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              size: 20,
              color: ColorStyles.primary100,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.black,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ColorStyles.gray4,
            ),
          ],
        ),
      ),
    );
  }
}
