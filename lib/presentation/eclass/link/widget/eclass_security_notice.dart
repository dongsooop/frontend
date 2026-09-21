import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class EclassSecurityNotice extends StatelessWidget {
  const EclassSecurityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.primary5,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 20,
            color: ColorStyles.primary100,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '계정 정보는 기기에만 안전하게 보관돼요',
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '아이디와 비밀번호는 이클래스 로그인에만 사용되며 동숲 서버로 전송되지 않습니다. '
                  '자동 재연동을 위해 이 기기의 보안 저장소에 보관하고, 연동을 해제하면 함께 삭제합니다.',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray6,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
