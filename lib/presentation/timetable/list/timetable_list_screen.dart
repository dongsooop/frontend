import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/providers/timetable_providers.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimetableListScreen extends HookConsumerWidget {
  final void Function(int, Semester) onTapTimetable;
  final Future<({int year, Semester semester})?> Function() onTapTimetableWrite;

  const TimetableListScreen({
    super.key,
    required this.onTapTimetable,
    required this.onTapTimetableWrite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableListState = ref.watch(timetableListViewModelProvider);
    final viewModel = ref.read(timetableListViewModelProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await viewModel.getTimetableList();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '시간표 목록',
        trailing: IconButton(
          onPressed: () async {
            final result = await onTapTimetableWrite();
            if (!context.mounted) return;

            if (result != null) {
              context.pop<({int year, Semester semester})?>(result);
            }
          },
          icon: Icon(
            Icons.add_box_outlined,
            size: 24,
            color: ColorStyles.gray4,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.only(top: 24),
          itemCount: timetableListState.localTimetableInfo.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: ColorStyles.gray2),
          itemBuilder: (context, index) {
            final info = timetableListState.localTimetableInfo[index];

            return ListTile(
              onTap: () {
                if (!context.mounted) return;
                context.pop((year: info.year, semester: info.semester,));
              },
              title: Text(
                '${info.year}년 ${info.semester.label}',
                style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (_) => CustomConfirmDialog(
                      title: '시간표 삭제',
                      content: '해당 시간표를 삭제하시겠어요?',
                      onConfirm: () async {
                        await viewModel.deleteTimetable(info.year, info.semester);
                        await viewModel.getTimetableList();
                      },
                    ),
                  );
                },
                child: Text(
                  '삭제',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}