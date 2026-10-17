import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class ReportSanctionSelectBottomSheet extends StatelessWidget {
  final SanctionType? selectedSanction;
  final ValueChanged<SanctionType> onSelected;
  final List<SanctionType> sanctions;

  const ReportSanctionSelectBottomSheet({
    super.key,
    required this.selectedSanction,
    required this.onSelected,
    this.sanctions = SanctionType.messageReportValues,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제재 유형 선택',
              style: TextStyles.titleTextBold.copyWith(
                color: ColorStyles.black,
              ),
            ),
            const SizedBox(height: 16),
            ...sanctions.map(
              (sanction) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  key: Key('sanction-type-${sanction.name}'),
                  onTap: () {
                    onSelected(sanction);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedSanction == sanction
                          ? ColorStyles.primary5
                          : ColorStyles.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedSanction == sanction
                            ? ColorStyles.primaryColor
                            : ColorStyles.gray2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sanction.message,
                                style: TextStyles.normalTextBold.copyWith(
                                  color: ColorStyles.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sanction.description,
                                style: TextStyles.smallTextRegular.copyWith(
                                  color: ColorStyles.gray4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          size: 20,
                          selectedSanction == sanction
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: selectedSanction == sanction
                              ? ColorStyles.primaryColor
                              : ColorStyles.gray5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
