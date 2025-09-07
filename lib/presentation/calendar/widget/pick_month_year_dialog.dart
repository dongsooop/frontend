import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

Future<DateTime?> pickMonthYearDialog(
    BuildContext context, {
      required DateTime initialMonth,
      int yearStart = 2011,
      int yearEnd = 2030,
    }) {
  int year = initialMonth.year.clamp(yearStart, yearEnd);
  int month = initialMonth.month;

  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) {
      return Theme(
        data: Theme.of(dialogContext).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            '연도/월 선택',
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          content: StatefulBuilder(
            builder: (dialogContext, setState) {
              return SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: (year > yearStart)
                              ? () => setState(() => year -= 1)
                              : null,
                          icon: Icon(Icons.chevron_left, size: 24.0),
                          color: ColorStyles.black,
                          disabledColor: ColorStyles.gray2,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$year년',
                              style: TextStyles.largeTextBold.copyWith(
                                color: ColorStyles.black,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (year < yearEnd)
                              ? () => setState(() => year += 1)
                              : null,
                          icon: const Icon(Icons.chevron_right, size: 24.0),
                          color: ColorStyles.black,
                          disabledColor: ColorStyles.gray2,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 12,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.6,
                      ),
                      itemBuilder: (gridContext, index) {
                        final int monthValue = index + 1;
                        final bool isSelected = (monthValue == month);

                        return OutlinedButton(
                          onPressed: () {
                            setState(() => month = monthValue);
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 4),
                            ),
                            minimumSize: const WidgetStatePropertyAll(
                              Size(0, 56),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            side: WidgetStatePropertyAll(
                              BorderSide(
                                color: isSelected
                                    ? ColorStyles.primary100
                                    : ColorStyles.gray2,
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              isSelected ? ColorStyles.primary5 : Colors.white,
                            ),
                            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Text(
                            '$monthValue월',
                            style: TextStyles.normalTextRegular.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              style: const ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                '취소',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DateTime(year, month, 1)),
              style: const ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                '확인',
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
