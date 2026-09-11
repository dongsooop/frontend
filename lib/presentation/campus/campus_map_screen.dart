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
  String? selectedBuildingId;

  @override
  void initState() {
    super.initState();
    selectedBuildingId = widget.initialBuildingId;
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedBuildingId == null
                    ? '건물을 눌러 위치를 확인해보세요.'
                    : '${campusBuildingName(selectedBuildingId!)} 위치',
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '지도를 확대하거나 상하좌우로 움직여 볼 수 있어요.',
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray5,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 3,
                child: Center(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    // 여백을 두지 않아야 지도가 화면 밖으로 밀려나지 않는다.
                    boundaryMargin: EdgeInsets.zero,
                    child: AspectRatio(
                      aspectRatio: CampusMapGeometry.sourceSize.aspectRatio,
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
                              if (id != null) {
                                setState(() => selectedBuildingId = id);
                              }
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
              ),
              if (selectedBuildingId != null) ...[
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: _BuildingFloors(buildingId: selectedBuildingId!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildingFloors extends StatelessWidget {
  const _BuildingFloors({required this.buildingId});

  final String buildingId;

  @override
  Widget build(BuildContext context) {
    final floors = campusBuildingFloors(buildingId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.primary5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            campusBuildingName(buildingId),
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.primary100,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: floors.isEmpty
                ? Text(
                    '등록된 층별 시설 정보가 없어요.',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: floors.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _FloorRow(floor: floors[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FloorRow extends StatelessWidget {
  const _FloorRow({required this.floor});

  final CampusFloor floor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            floor.name,
            style: TextStyles.smallTextBold.copyWith(
              color: ColorStyles.primary100,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: floor.facilities
                .map(
                  (facility) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      facility,
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.gray6,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
