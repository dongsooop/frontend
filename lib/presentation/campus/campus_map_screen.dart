import 'dart:math' as math;

import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_painter.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_search.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_search_results.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_smoking_markers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _mapScrollController = ScrollController();
  List<CampusMapSearchResult> _results = const [];
  CampusMapSearchResult? _searchSelection;
  bool _showResults = false;
  late String _selectedBuildingId = widget.initialBuildingId ?? '1';
  CampusSmokingArea? _selectedSmokingArea;
  Offset? _focusPosition;
  int _focusRevision = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _mapScrollController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _results = CampusMapSearch.find(query);
      _showResults = query.trim().isNotEmpty;
      if (!_showResults) _searchSelection = null;
    });
    if (!_showResults && _mapScrollController.hasClients) {
      _mapScrollController.jumpTo(0);
    }
  }

  void _submitSearch() {
    _searchFocus.unfocus();
    if (_results.length == 1) {
      _selectResult(_results.single);
    } else {
      setState(() => _showResults = _searchController.text.trim().isNotEmpty);
    }
  }

  void _selectResult(CampusMapSearchResult result) {
    _searchFocus.unfocus();
    setState(() {
      _showResults = false;
      _searchSelection = result;
      _selectedSmokingArea = result.smokingArea;
      if (result.building != null) _selectedBuildingId = result.building!.id;
      _focusPosition = result.position;
      // 같은 결과를 다시 선택해도 사용자가 이동한 지도를 다시 맞춘다.
      _focusRevision++;
    });
    if (_mapScrollController.hasClients) _mapScrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '캠퍼스 지도'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      textInputAction: TextInputAction.search,
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.black),
                      onChanged: _search,
                      onSubmitted: (_) => _submitSearch(),
                      onTap: () {
                        if (_searchController.text.trim().isNotEmpty) {
                          setState(() => _showResults = true);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '건물·시설 검색',
                        hintStyle: TextStyles.normalTextRegular
                            .copyWith(color: ColorStyles.gray5),
                        filled: true,
                        fillColor: ColorStyles.gray7,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: SvgPicture.asset(
                            'assets/icons/search.svg',
                            colorFilter: const ColorFilter.mode(
                              ColorStyles.gray5,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: '검색어 지우기',
                                icon: const Icon(Icons.close, color: ColorStyles.gray5, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  _search('');
                                  _searchFocus.unfocus();
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // 검색 중에도 지도 배율과 이동 위치를 보존한다.
              child: IndexedStack(
                index: _showResults ? 1 : 0,
                children: [
                  ListView(
                    controller: _mapScrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.zero,
                    children: [
                      if (_searchController.text.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _searchSelection?.location ??
                                      _selectedSmokingArea?.name ??
                                      campusBuildingName(_selectedBuildingId),
                                  style: TextStyles.smallTextBold.copyWith(color: ColorStyles.primary100),
                                ),
                              ),
                              TextButton(
                                onPressed: () => setState(() => _showResults = true),
                                style: TextButton.styleFrom(
                                  foregroundColor: ColorStyles.gray4,
                                ),
                                child: Text(
                                  '검색 목록',
                                  style: TextStyles.smallTextRegular.copyWith(
                                    color: ColorStyles.gray4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      _MapStage(
                        key: const ValueKey('campus-map-stage'),
                        selectedBuildingId: _selectedSmokingArea == null
                            ? _selectedBuildingId
                            : null,
                        selectedSmokingAreaId: _selectedSmokingArea?.id,
                        focusPosition: _focusPosition,
                        focusRevision: _focusRevision,
                        onSelect: (id) => setState(() {
                          _selectedBuildingId = id;
                          _selectedSmokingArea = null;
                          _searchSelection = null;
                        }),
                        onSelectSmokingArea: (area) => setState(() {
                          _selectedSmokingArea = area;
                          _searchSelection = null;
                        }),
                      ),
                      if (_selectedSmokingArea case final area?)
                        _SmokingAreaDetail(area: area)
                      else
                        _BuildingDetail(
                          key:
                              ValueKey((_selectedBuildingId, _searchSelection)),
                          buildingId: _selectedBuildingId,
                          searchSelection: _searchSelection,
                        ),
                    ],
                  ),
                  CampusMapSearchResults(
                      results: _results, onSelect: _selectResult),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 정사각형 무대 안에서 배치도를 밀고 확대해서 보는 판.
///
/// 배치도가 가로로 길어 화면 너비에 맞추면 건물이 너무 작다. 무대보다 넓게
/// 두고 좌우로 밀어 보게 하는 대신, 지도가 무대 밖으로 빠지지는 않는다.
class _MapStage extends StatefulWidget {
  const _MapStage({
    super.key,
    required this.selectedBuildingId,
    required this.selectedSmokingAreaId,
    this.focusPosition,
    this.focusRevision = 0,
    this.onSelect,
    this.onSelectSmokingArea,
  });

  final String? selectedBuildingId;
  final String? selectedSmokingAreaId;
  final Offset? focusPosition;
  final int focusRevision;
  final ValueChanged<String>? onSelect;
  final ValueChanged<CampusSmokingArea>? onSelectSmokingArea;

  /// 무대 너비에 대한 배치도 너비의 비율.
  static const double boardScale = 1.9;

  @override
  State<_MapStage> createState() => _MapStageState();
}

class _MapStageState extends State<_MapStage> {
  final TransformationController _controller = TransformationController();
  bool _didAlign = false;
  int _focusedRevision = 0;

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
            final boardSize = Size(boardWidth, stageSide);
            // 최대한 축소하면 지도 가로 전체가 무대 너비에 맞는다.
            const minMapWidthRatio = 1.0;
            const minMapScale = minMapWidthRatio / _MapStage.boardScale;
            // 음수 여백으로 지도 양끝의 이동 범위가 잘리지 않도록 한다.
            final horizontalMargin = math.max(
              0.0,
              (stageSide / minMapScale - boardWidth) / 2,
            );
            final verticalMargin = math.max(
              0.0,
              (stageSide / minMapScale - stageSide) / 2,
            );

            // 처음에는 정문 쪽(1호관)이 보이도록 오른쪽 끝에 맞춘다.
            if (!_didAlign) {
              _didAlign = true;
              _controller.value = _controller.value.clone()
                ..translateByDouble(stageSide - boardWidth, 0, 0, 1);
            }

            if (_focusedRevision != widget.focusRevision &&
                widget.focusPosition != null) {
              _focusedRevision = widget.focusRevision;
              final ratio = boardWidth / CampusMapGeometry.sourceSize.width;
              final mapTop =
                  (stageSide - CampusMapGeometry.sourceSize.height * ratio) / 2;
              final target = widget.focusPosition! * ratio + Offset(0, mapTop);
              // 검색한 위치를 기본 배율로 맞추되 기존 지도 경계를 지킨다.
              final dx = (stageSide / 2 - target.dx).clamp(
                  stageSide - boardWidth - horizontalMargin, horizontalMargin);
              final dy = (stageSide / 2 - target.dy)
                  .clamp(-verticalMargin, verticalMargin);
              _controller.value = Matrix4.identity()
                ..translateByDouble(dx, dy, 0, 1);
            }

            return ClipRect(
              // 탭이 확정된 뒤 선택해 두 손가락 조작 중에는 선택하지 않는다.
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) => _handleTap(
                  details.localPosition,
                  boardSize,
                ),
                child: Stack(
                  children: [
                    InteractiveViewer(
                      transformationController: _controller,
                      constrained: false,
                      minScale: minMapScale,
                      maxScale: 4,
                      // 최소 배율에 필요한 만큼만 경계 여백을 허용한다.
                      boundaryMargin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: verticalMargin,
                      ),
                      child: SizedBox(
                        width: boardWidth,
                        height: stageSide,
                        child: Center(
                          child: SizedBox(
                            width: boardWidth,
                            height: boardWidth /
                                CampusMapGeometry.sourceSize.aspectRatio,
                            child: CustomPaint(
                              painter: CampusMapPainter(
                                selectedBuildingId: widget.selectedBuildingId,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => CampusSmokingMarkers(
                          positions: campusSmokingAreaPositions(
                            boardSize,
                            transform: _controller.value,
                          ),
                          selectedAreaId: widget.selectedSmokingAreaId,
                          onSelect: widget.onSelectSmokingArea,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTap(Offset position, Size boardSize) {
    final positions = campusSmokingAreaPositions(
      boardSize,
      transform: _controller.value,
    );
    final viewport = Offset.zero & Size.square(boardSize.height);
    for (final entry in positions.entries) {
      if (!viewport.contains(entry.value)) continue;
      final target = Rect.fromCenter(
        center: entry.value,
        width: CampusSmokingMarkers.touchTargetSize,
        height: CampusSmokingMarkers.touchTargetSize,
      );
      if (target.contains(position)) {
        widget.onSelectSmokingArea?.call(entry.key);
        return;
      }
    }

    final onSelect = widget.onSelect;
    if (onSelect == null) return;

    final ratio = CampusMapGeometry.sourceSize.width / boardSize.width;
    final mapTop = (boardSize.height -
            boardSize.width / CampusMapGeometry.sourceSize.aspectRatio) /
        2;
    final sourcePoint =
        (_controller.toScene(position) - Offset(0, mapTop)) * ratio;
    final id = CampusMapGeometry.hitTest(sourcePoint);
    if (id != null) onSelect(id);
  }
}

class _SmokingAreaDetail extends StatelessWidget {
  const _SmokingAreaDetail({required this.area});

  final CampusSmokingArea area;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColorStyles.labelColorYellow10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.smoking_rooms,
              color: ColorStyles.labelColorYellow100,
              size: 24,
              semanticLabel: '흡연구역',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '흡연구역',
                  style: TextStyles.smallTextBold.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  area.name,
                  style: TextStyles.largeTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  area.location,
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.gray4,
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

class _BuildingDetail extends StatefulWidget {
  const _BuildingDetail(
      {super.key, required this.buildingId, this.searchSelection});

  final String buildingId;
  final CampusMapSearchResult? searchSelection;

  @override
  State<_BuildingDetail> createState() => _BuildingDetailState();
}

class _BuildingDetailState extends State<_BuildingDetail> {
  bool _showAllFloors = false;

  @override
  Widget build(BuildContext context) {
    final floors = campusBuildingFloors(widget.buildingId);
    final selectedFloor = widget.searchSelection?.floor?.name;
    final visibleFloors = selectedFloor == null || _showAllFloors
        ? floors
        : floors.where((floor) => floor.name == selectedFloor).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      campusBuildingName(widget.buildingId),
                      style: TextStyles.titleTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (floors.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
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
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
          if (floors.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                '등록된 층별 시설 정보가 없어요.',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            )
          else
            for (final floor in visibleFloors)
              _FloorRow(
                floor: floor,
                isLast: floor == visibleFloors.last,
                highlightedFacilities: floor.name == selectedFloor
                    ? widget.searchSelection!.facilities
                    : const [],
              ),
          if (selectedFloor != null && floors.length > 1) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: ColorStyles.gray4,
                  backgroundColor: ColorStyles.gray7,
                  minimumSize: const Size(44, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () =>
                    setState(() => _showAllFloors = !_showAllFloors),
                child: Text(
                    _showAllFloors ? '검색한 층만 보기' : '전체 ${floors.length}개 층 보기'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FloorRow extends StatelessWidget {
  const _FloorRow(
      {required this.floor,
      required this.isLast,
      this.highlightedFacilities = const []});

  final CampusFloor floor;
  final bool isLast;
  final List<String> highlightedFacilities;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('campus-floor-${floor.name}'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: highlightedFacilities.isEmpty ? null : ColorStyles.primary5,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: ColorStyles.gray2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  floor.name,
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.primary100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final facility in floor.facilities)
                  Semantics(
                    selected:
                        highlightedFacilities.contains(facility) ? true : null,
                    child: Container(
                      key: ValueKey('campus-facility-${floor.name}-$facility'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorStyles.white,
                        border: Border.all(
                            color: highlightedFacilities.contains(facility)
                                ? ColorStyles.primary100
                                : ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        facility,
                        style: TextStyles.normalTextRegular.copyWith(
                          color: highlightedFacilities.contains(facility)
                              ? ColorStyles.primary100
                              : ColorStyles.gray4,
                        ),
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
