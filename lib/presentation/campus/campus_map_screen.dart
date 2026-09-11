import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_painter.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({
    super.key,
    this.initialBuildingId,
  });

  final String? initialBuildingId;

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  // 빈 화면으로 시작하면 아래 목록 자리가 통째로 비어 무엇을 해야 하는지
  // 알기 어렵다. 들어온 건물이 없으면 1호관을 펴 둔다.
  late String selectedBuildingId = widget.initialBuildingId ?? '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: AppBar(
        backgroundColor: ColorStyles.white,
        elevation: 0,
        title: Text(
          '캠퍼스 지도',
          style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${campusBuildingName(selectedBuildingId)}'
                    '${_objectParticle(campusBuildingName(selectedBuildingId))}'
                    ' 선택했어요',
                    style: TextStyles.largeTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '건물을 누르면 층별 시설을 확인할 수 있어요.',
                    style: TextStyles.normalTextRegular.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  ),
                ],
              ),
            ),
            // 지도는 좌우 여백 밖으로 빼서 화면 너비를 그대로 쓴다.
            _MapStage(
              selectedBuildingId: selectedBuildingId,
              onSelect: (id) => setState(() => selectedBuildingId = id),
            ),
            _BuildingDetail(buildingId: selectedBuildingId),
          ],
        ),
      ),
    );
  }

  /// 받침이 있으면 '을', 없으면 '를'.
  String _objectParticle(String word) {
    final last = word.codeUnitAt(word.length - 1);
    final isHangul = last >= 0xAC00 && last <= 0xD7A3;
    if (!isHangul) return '를';
    return (last - 0xAC00) % 28 == 0 ? '를' : '을';
  }
}

class _MapStage extends StatelessWidget {
  const _MapStage({
    required this.selectedBuildingId,
    required this.onSelect,
  });

  final String selectedBuildingId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorStyles.gray7,
      child: AspectRatio(
        aspectRatio: CampusMapGeometry.sourceSize.aspectRatio,
        child: ClipRect(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            // 여백을 두지 않아야 지도가 화면 밖으로 밀려나지 않는다.
            boundaryMargin: EdgeInsets.zero,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    final point = Offset(
                      details.localPosition.dx /
                          constraints.maxWidth *
                          CampusMapGeometry.sourceSize.width,
                      details.localPosition.dy /
                          constraints.maxHeight *
                          CampusMapGeometry.sourceSize.height,
                    );
                    final id = CampusMapGeometry.hitTest(point);
                    if (id != null) onSelect(id);
                  },
                  child: CustomPaint(
                    painter: CampusMapPainter(
                      selectedBuildingId: selectedBuildingId,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildingDetail extends StatelessWidget {
  const _BuildingDetail({required this.buildingId});

  final String buildingId;

  @override
  Widget build(BuildContext context) {
    final floors = campusBuildingFloors(buildingId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '층별 시설',
                      style: TextStyles.smallTextBold.copyWith(
                        color: ColorStyles.primary100,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      campusBuildingName(buildingId),
                      style: TextStyles.titleTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (floors.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorStyles.gray7,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${floors.length}개 층',
                    style: TextStyles.smallTextBold.copyWith(
                      color: ColorStyles.gray6,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
          if (floors.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                '등록된 층별 시설 정보가 없어요.',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray5,
                ),
              ),
            )
          else
            for (final floor in floors)
              _FloorRow(
                floor: floor,
                isLast: floor == floors.last,
              ),
        ],
      ),
    );
  }
}

class _FloorRow extends StatelessWidget {
  const _FloorRow({required this.floor, required this.isLast});

  final CampusFloor floor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: ColorStyles.gray2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              floor.name,
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.primary100,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final facility in floor.facilities)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      border: Border.all(color: ColorStyles.gray2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      facility,
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray6,
                      ),
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
