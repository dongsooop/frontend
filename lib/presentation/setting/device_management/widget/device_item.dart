import 'package:dongsoop/domain/device/entity/device_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  final DeviceEntity device;
  final VoidCallback onTapLogout;

  const DeviceItem({
    super.key,
    required this.device,
    required this.onTapLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.type.name,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2024.02.01 로그인', // 임시 고정값
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray3,
                  ),
                ),
              ],
            ),
          ),
          if (device.current)
            Text(
              '현재 로그인된 기기',
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.primaryColor,
              ),
            )
          else
            InkWell(
              onTap: onTapLogout,
              child: Text(
                '로그아웃',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.warning100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}