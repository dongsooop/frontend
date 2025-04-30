import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left: logo
          SvgPicture.asset('assets/icons/logo.svg', width: 32, height: 32),
          // right: alarm
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset('assets/icons/alarm.svg', width: 24, height: 24),
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 9),
                  // alarm icon 추후 수정( 텍스트 포함 )
                  child: const Text(
                    '99+',
                    style: TextStyle(
                      color: ColorStyles.white,
                      fontSize: 6,
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
