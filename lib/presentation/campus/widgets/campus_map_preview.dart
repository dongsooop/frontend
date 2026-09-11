import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_painter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

/// 캠퍼스 탭에 올라가는 배치도 미리보기. 누르면 지도 화면으로 간다.
///
/// 지도 화면과 같은 페인터를 써서 배치도가 어긋날 일이 없다. 테두리는 두지
/// 않는다 — 모서리를 둥글리면 도면의 네 귀퉁이가 잘려 선이 끊겨 보인다.
class CampusMapPreview extends StatelessWidget {
  const CampusMapPreview({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: ColorStyles.gray7,
          child: AspectRatio(
            aspectRatio: CampusMapGeometry.sourceSize.aspectRatio,
            child: const CustomPaint(painter: CampusMapPainter()),
          ),
        ),
      ),
    );
  }
}
