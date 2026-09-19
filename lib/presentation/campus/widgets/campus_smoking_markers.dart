import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

/// 무대 안에 세로로 가운데 정렬된 배치도 좌표를 화면 좌표로 변환한다.
Map<CampusSmokingArea, Offset> campusSmokingAreaPositions(
  Size boardSize, {
  required Matrix4 transform,
}) {
  final ratio = boardSize.width / CampusMapGeometry.sourceSize.width;
  final mapTop =
      (boardSize.height - CampusMapGeometry.sourceSize.height * ratio) / 2;

  return {
    for (final area in CampusMapGeometry.smokingAreas)
      area: MatrixUtils.transformPoint(
        transform,
        area.position * ratio + Offset(0, mapTop),
      ),
  };
}

/// 지도와 별도로 배치해 확대·축소해도 아이콘과 터치 영역 크기를 유지한다.
/// 포인터 입력은 아래 지도로 통과시키고, 무대의 탭 처리에서 구역을 선택한다.
class CampusSmokingMarkers extends StatelessWidget {
  const CampusSmokingMarkers({
    super.key,
    required this.positions,
    this.selectedAreaId,
    this.onSelect,
  });

  static const double touchTargetSize = 40;
  static const double markerSize = 28;

  final Map<CampusSmokingArea, Offset> positions;
  final String? selectedAreaId;
  final ValueChanged<CampusSmokingArea>? onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Offset.zero & constraints.biggest;
        final visible = positions.entries
            .where((entry) => viewport.contains(entry.value))
            .toList();

        return Stack(
          children: [
            for (final entry in visible)
              Positioned(
                left: entry.value.dx - touchTargetSize / 2,
                top: entry.value.dy - touchTargetSize / 2,
                width: touchTargetSize,
                height: touchTargetSize,
                child: Semantics(
                  key: ValueKey('smoking-area-${entry.key.id}'),
                  container: true,
                  button: onSelect != null,
                  selected: entry.key.id == selectedAreaId,
                  label: '${entry.key.name}, 흡연구역',
                  onTap: onSelect == null ? null : () => onSelect!(entry.key),
                  excludeSemantics: true,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        width: markerSize,
                        height: markerSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: entry.key.id == selectedAreaId
                              ? ColorStyles.labelColorYellow100
                              : ColorStyles.white,
                          border: Border.all(
                            color: ColorStyles.labelColorYellow100,
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.smoking_rooms,
                          size: 16,
                          color: entry.key.id == selectedAreaId
                              ? ColorStyles.white
                              : ColorStyles.labelColorYellow100,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            for (final entry in visible)
              if (entry.key.id == selectedAreaId)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ExcludeSemantics(
                      child: CustomSingleChildLayout(
                        delegate: _SmokingLabelLayout(entry.value),
                        child: Container(
                          key: const ValueKey('smoking-area-label'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ColorStyles.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ColorStyles.gray2),
                          ),
                          child: Text(
                            entry.key.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _SmokingLabelLayout extends SingleChildLayoutDelegate {
  const _SmokingLabelLayout(this.anchor);

  final Offset anchor;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen().deflate(const EdgeInsets.all(8));

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    const gap = CampusSmokingMarkers.touchTargetSize / 2 + 4;
    final above = anchor.dy - gap - childSize.height;
    return Offset(
      (anchor.dx - childSize.width / 2)
          .clamp(8.0, size.width - childSize.width - 8),
      (above >= 8 ? above : anchor.dy + gap)
          .clamp(8.0, size.height - childSize.height - 8),
    );
  }

  @override
  bool shouldRelayout(_SmokingLabelLayout oldDelegate) =>
      anchor != oldDelegate.anchor;
}
