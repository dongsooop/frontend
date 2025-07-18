import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/auth/enum/agreement_type.dart';
import '../../../ui/color_styles.dart';
import '../../../ui/text_styles.dart';

class AgreementBottomSheet extends HookConsumerWidget {
  final Map<AgreementType, bool> initialValues;
  final void Function(AgreementType type) onViewDetail; // 약관 상세보기 콜백
  final void Function(Map<AgreementType, bool>) onChanged;

  const AgreementBottomSheet({
    super.key,
    required this.initialValues,
    required this.onViewDetail,
    required this.onChanged,
  });

  Widget build(BuildContext context, WidgetRef ref) {
    final agreementStates = useState<Map<AgreementType, bool>>(Map.from(initialValues));

    // 전체 선택 여부
    final isAllChecked = agreementStates.value.values.every((v) => v);

    void setAll(bool checked) {
      agreementStates.value = {
        for (var key in AgreementType.values) key: checked,
      };
      onChanged(agreementStates.value);
    }

    void setChecked(AgreementType type, bool checked) {
      agreementStates.value = {
        ...agreementStates.value,
        type: checked,
      };
      onChanged(agreementStates.value);
    }

    Widget agreementTile({
      required AgreementType type,
    }) {
      return InkWell(
        onTap: () => onViewDetail(type),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: agreementStates.value[type] ?? false,
              onChanged: (checked) => setChecked(type, checked!),
              activeColor: ColorStyles.primaryColor,
              side: BorderSide(
                width: 2,
                color: ColorStyles.black,
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onViewDetail(type),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    type == AgreementType.termsOfService
                        ? '[필수] 동숲 서비스 이용약관'
                        : '[필수] 개인정보 처리방침',
                    style: TextStyles.largeTextRegular.copyWith(
                        color: ColorStyles.black
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 48),
        decoration: BoxDecoration(
          color: ColorStyles.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '동숲 이용약관',
              style: TextStyles.titleTextBold.copyWith(
                color: ColorStyles.black,
              )
            ),
            const SizedBox(height: 24),
            Divider(color: ColorStyles.gray2,),
            // 전체 선택
            Row(
              children: [
                Checkbox(
                  value: isAllChecked,
                  onChanged: (checked) => setAll(checked!),
                  activeColor: ColorStyles.primaryColor,
                  side: BorderSide(
                    width: 2,
                    color: ColorStyles.black,
                  ),
                ),
                Text(
                  '전체 선택',
                  style: TextStyles.largeTextRegular.copyWith(
                      color: ColorStyles.black
                  ),
                ),
              ],
            ),
            Divider(color: ColorStyles.gray2,),
            const SizedBox(height: 8),
            // 개별 약관
            agreementTile(type: AgreementType.termsOfService),
            agreementTile(type: AgreementType.privacyPolicy),
          ],
        ),
      ),
    );
  }
}