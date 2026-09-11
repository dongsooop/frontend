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
                '두 손가락으로 지도를 확대하거나 이동할 수 있어요.',
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray5,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    boundaryMargin: const EdgeInsets.all(80),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorStyles.primary5,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    campusBuildingName(selectedBuildingId!),
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.primary100,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
