import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

class MatchVoteBottomSheet extends StatefulWidget {
  final Map<int, String> participants;
  final int currentUserId;
  final ValueChanged<int?> onSubmit;
  final int seconds;
  final String title;
  final String subtitle;

  const MatchVoteBottomSheet({
    super.key,
    required this.participants,
    required this.currentUserId,
    required this.onSubmit,
    this.seconds = 10,
    this.title = '사랑의 작대기',
    this.subtitle = '마음에 드는 상대방을 골라주세요',
  });

  static Future<void> show(
    BuildContext context, {
      required Map<int, String> participants,
      required int currentUserId,
      required ValueChanged<int?> onSubmit,
      int seconds = 10,
      String title = '사랑의 작대기',
      String subtitle = '마음에 드는 상대방을 골라주세요',
    }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => MatchVoteBottomSheet(
        participants: participants,
        currentUserId: currentUserId,
        onSubmit: onSubmit,
        seconds: seconds,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  State<MatchVoteBottomSheet> createState() => _MatchVoteBottomSheetState();
}

class _MatchVoteBottomSheetState extends State<MatchVoteBottomSheet> {
  Timer? _timer;
  late int _remain;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _remain = widget.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _remain--);
      if (_remain <= 0) {
        _finishAndClose();
      }
    });
  }

  void _finishAndClose() {
    _timer?.cancel();
    widget.onSubmit(_selected);
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.participants.entries
        .where((e) => e.key != widget.currentUserId)
        .toList();

    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CountdownCircle(
                  remain: _remain,
                  total: widget.seconds,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyles.titleTextBold.copyWith(color: ColorStyles.black),
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: ColorStyles.gray2, height: 1),

            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final e = entries[index];
                  return RadioListTile<int>(
                    value: e.key,
                    groupValue: _selected,
                    onChanged: (v) => setState(() => _selected = v),
                    activeColor: ColorStyles.primaryColor,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      e.value,
                      style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownCircle extends StatelessWidget {
  final int remain;
  final int total;

  const _CountdownCircle({required this.remain, required this.total});

  @override
  Widget build(BuildContext context) {
    final value = (remain / total).clamp(0.0, 1.0);
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 2,
            color: ColorStyles.primaryColor,
            backgroundColor: ColorStyles.white,
          ),
          Text(
            '$remain',
            style: TextStyles.largeTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
        ],
      ),
    );
  }
}