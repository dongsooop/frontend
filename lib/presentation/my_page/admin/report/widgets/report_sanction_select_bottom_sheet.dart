import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../domain/report/enum/sanction_type.dart';

class ReportSanctionSelectBottomSheet extends HookConsumerWidget {
  final SanctionType? selectedSanction;
  final void Function(SanctionType reason) onSelected;

  const ReportSanctionSelectBottomSheet({
    super.key,
    required this.selectedSanction,
    required this.onSelected,
  });


  Widget build(BuildContext context, WidgetRef ref) {
    final items = SanctionType.values;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.4,
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '제재 사유 선택',
                    style: TextStyles.titleTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                  SizedBox(height: 24,),
                  Divider(color: ColorStyles.gray2,),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: items.length,
                      separatorBuilder: (context, idx) => SizedBox(height: 8),
                      itemBuilder: (context, idx) {
                        final reason = items[idx];
                        return SizedBox(
                          height: 44,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              onSelected(reason);
                              Navigator.of(context).pop();
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                reason.message,
                                style: TextStyles.largeTextRegular.copyWith(
                                  color: ColorStyles.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}