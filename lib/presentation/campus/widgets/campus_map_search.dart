import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:flutter/material.dart';

/// 하나의 건물, 시설이 있는 층, 또는 흡연구역을 가리킨다.
/// 시설 개수가 아닌 위치 단위로 묶어 같은 층이 여러 번 나오지 않게 한다.
class CampusMapSearchResult {
  const CampusMapSearchResult.building(
    CampusBuildingShape this.building, {
    this.floor,
    this.facilities = const [],
  }) : smokingArea = null;

  const CampusMapSearchResult.smoking(CampusSmokingArea this.smokingArea)
      : building = null,
        floor = null,
        facilities = const [];

  final CampusBuildingShape? building;
  final CampusFloor? floor;
  final List<String> facilities;
  final CampusSmokingArea? smokingArea;

  String get location =>
      smokingArea?.name ??
      [building!.name, if (floor != null) floor!.name].join(' · ');

  Offset get position => smokingArea?.position ?? building!.label;
}

class CampusMapSearch {
  // SVG를 입력할 때마다 다시 해석하지 않고 기존 모델을 검색에 재사용한다.
  static final _buildings = CampusMapGeometry.buildings
    ..sort((a, b) => a.id.compareTo(b.id));

  static String normalize(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'\s+'), '');

  static List<CampusMapSearchResult> find(String query) {
    final normalized = normalize(query);
    if (normalized.isEmpty) return const [];

    final terms = query.trim().toLowerCase().split(RegExp(r'\s+'));
    bool matches(String value) {
      final text = normalize(value);
      return terms.every(text.contains);
    }

    final results = <CampusMapSearchResult>[];
    for (final building in _buildings) {
      // 건물 이름만 검색하면 모든 층을 펼치는 결과 하나를 제공한다.
      if (normalize(building.name).contains(normalized)) {
        results.add(CampusMapSearchResult.building(building));
        continue;
      }

      for (final floor in building.floors) {
        final facilities = floor.facilities
            .where((facility) =>
                matches('${building.name} ${floor.name} $facility'))
            .toList();
        if (facilities.isNotEmpty) {
          results.add(CampusMapSearchResult.building(
            building,
            floor: floor,
            facilities: facilities,
          ));
        }
      }
    }

    for (final area in CampusMapGeometry.smokingAreas) {
      if (matches('${area.name} 흡연구역 ${area.location}')) {
        results.add(CampusMapSearchResult.smoking(area));
      }
    }
    return results;
  }
}
