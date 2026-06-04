import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/domain/auth/enum/department_type.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeptSelectBottomSheet extends HookConsumerWidget {
  final DepartmentType? selectedDept;
  final void Function(DepartmentType dept) onSelected;

  const DeptSelectBottomSheet({
    super.key,
    required this.selectedDept,
    required this.onSelected,
  });

  Widget build(BuildContext context, WidgetRef ref) {
    final items = DepartmentTypeExtension.infoMap.entries
        .where((entry) => entry.key != DepartmentType.Unknown)
        .toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
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
                    '학과 선택',
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
                        final deptType = items[idx].key;
                        final deptInfo = items[idx].value;
                        return SizedBox(
                          height: 44,
                          width: double.infinity,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {
                              onSelected(deptType);
                              Navigator.of(context).pop();
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                deptInfo.displayName,
                                style: TextStyles.largeTextRegular.copyWith(
                                  color: ColorStyles.black
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