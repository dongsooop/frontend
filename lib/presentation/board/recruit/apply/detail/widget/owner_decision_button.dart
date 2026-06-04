import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';

class OwnerDecisionButton extends StatelessWidget {
  final String status;
  final Future<void> Function() onPass;
  final Future<void> Function() onFail;

  const OwnerDecisionButton({
    super.key,
    required this.status,
    required this.onPass,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'PASS' || status == 'FAIL') {
      final label = status == 'PASS' ? '합격' : '불합격';
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          color: ColorStyles.white,
          width: double.infinity,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                backgroundColor: ColorStyles.gray1,
                foregroundColor: ColorStyles.gray4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(label, style: TextStyles.largeTextBold),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: ColorStyles.white,
        child: Row(
          children: [
            // 불합격
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (_) => CustomConfirmDialog(
                        title: '지원 결과',
                        content: '한번 결정하면 되돌릴 수 없어요.\n해당 지원자를 불합격 처리할까요?',
                        cancelText: '취소',
                        confirmText: '확인',
                        onConfirm: () async => onFail(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorStyles.warning10,
                    foregroundColor: ColorStyles.warning100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('불합격', style: TextStyles.largeTextBold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 합격
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (_) => CustomConfirmDialog(
                        title: '지원 결과',
                        content: '한번 결정하면 되돌릴 수 없어요.\n해당 지원자를 합격 처리할까요?',
                        cancelText: '취소',
                        confirmText: '확인',
                        onConfirm: () async => onPass(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorStyles.primaryColor,
                    foregroundColor: ColorStyles.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('합격', style: TextStyles.largeTextBold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
