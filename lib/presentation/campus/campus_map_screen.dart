import 'package:dongsoop/core/presentation/components/detail_header.dart';
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
  late String _selectedBuildingId = widget.initialBuildingId ?? '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '캠퍼스 지도'),
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
                    _selectedTitle,
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
              selectedBuildingId: _selectedBuildingId,
              onSelect: (id) => setState(() => _selectedBuildingId = id),
            ),
            _BuildingDetail(buildingId: _selectedBuildingId),
          ],
        ),
      ),
    );
  }

  String get _selectedTitle {
    final name = campusBuildingName(_selectedBuildingId);
    final last = name.codeUnitAt(name.length - 1);
    final isHangul = last >= 0xAC00 && last <= 0xD7A3;
    // 받침이 있으면 '을', 없으면 '를'.
    final particle = isHangul && (last - 0xAC00) % 28 != 0 ? '을' : '를';
    return '$name$particle 선택했어요';
  }
}

/// 정사각형 무대 안에서 배치도를 밀고 확대해서 보는 판.
///
/// 배치도가 가로로 길어 화면 너비에 맞추면 건물이 너무 작다. 무대보다 넓게
/// 두고 좌우로 밀어 보게 하는 대신, 지도가 무대 밖으로 빠지지는 않는다.
class _MapStage extends StatefulWidget {
  const _MapStage({
    required this.selectedBuildingId,
    this.onSelect,
  });

  final String? selectedBuildingId;
  final ValueChanged<String>? onSelect;

  /// 무대 너비에 대한 배치도 너비의 비율.
  static const double boardScale = 1.9;

  @override
  State<_MapStage> createState() => _MapStageState();
}

class _MapStageState extends State<_MapStage> {
  final TransformationController _controller = TransformationController();
  bool _didAlign = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorStyles.gray7,
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stageSide = constraints.maxWidth;
            final boardWidth = stageSide * _MapStage.boardScale;
            // 처음에는 정문 쪽(1호관)이 보이도록 오른쪽 끝에 맞춘다.
            if (!_didAlign) {
              _didAlign = true;
              _controller.value = _controller.value.clone()
                ..translateByDouble(stageSide - boardWidth, 0, 0, 1);
            }

            return ClipRect(
              child: InteractiveViewer(
                transformationController: _controller,
                constrained: false,
                minScale: 1,
                maxScale: 4,
                // 여백을 두지 않아야 지도가 무대 밖으로 밀려나지 않는다.
                boundaryMargin: EdgeInsets.zero,
                child: SizedBox(
                  width: boardWidth,
                  height: stageSide,
                  child: Center(
                    child: SizedBox(
                      width: boardWidth,
                      height: boardWidth /
                          CampusMapGeometry.sourceSize.aspectRatio,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) => _handleTap(
                          details.localPosition,
                          boardWidth,
                        ),
                        child: CustomPaint(
                          painter: CampusMapPainter(
                            selectedBuildingId: widget.selectedBuildingId,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTap(Offset position, double boardWidth) {
    final onSelect = widget.onSelect;
    if (onSelect == null) return;

    final ratio = CampusMapGeometry.sourceSize.width / boardWidth;
    final id = CampusMapGeometry.hitTest(position * ratio);
    if (id != null) onSelect(id);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
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
              _FloorRow(floor: floor, isLast: floor == floors.last),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  floor.name,
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.primary100,
                  ),
                ),
                if (floor.isGround)
                  Text(
                    '지상',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  ),
              ],
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
