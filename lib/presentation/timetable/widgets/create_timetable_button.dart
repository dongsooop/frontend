import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CreateTimetableButton extends StatelessWidget {
  final VoidCallback onTapTimetableWrite;

  const CreateTimetableButton({
    super.key,
    required this.onTapTimetableWrite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: ColorStyles.gray2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이번 학기 시간표를 만들어 주세요',
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTapTimetableWrite,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: ColorStyles.primaryColor,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '시간표 만들기',
              style: TextStyles.normalTextBold.copyWith(color: ColorStyles.white),
            ),
          ),
        ],
      ),
    );
  }
}