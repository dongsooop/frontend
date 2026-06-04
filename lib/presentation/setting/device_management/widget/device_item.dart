import 'package:dongsoop/core/utils/time_formatter.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  '${formatYmdDot(device.loginAt)} 로그인',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          if (device.current)
            Container(
              alignment: Alignment.centerRight,
              height: 44,
              child: Text(
                '현재 로그인된 기기',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            InkWell(
              onTap: onTapLogout,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 44,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '로그아웃',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.warning100,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}