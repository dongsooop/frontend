import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SVG path 를 닫힌 도형으로 푼다', () {
    final path = parseSvgPath('M10 10H30V40H10Z');

    expect(path.getBounds(), const Rect.fromLTRB(10, 10, 30, 40));
    expect(path.contains(const Offset(20, 20)), isTrue);
    expect(path.contains(const Offset(40, 20)), isFalse);
  });

  test('건물 도형이 모두 도면 안에 들어온다', () {
    final board = Offset.zero & CampusMapGeometry.sourceSize;

    for (final building in CampusMapGeometry.buildings) {
      for (final path in building.paths) {
        final bounds = path.getBounds();
        expect(bounds.isEmpty, isFalse, reason: '${building.id} 도형이 비었다');
        expect(board.contains(bounds.topLeft), isTrue, reason: building.id);
        expect(board.contains(bounds.bottomRight), isTrue, reason: building.id);
      }
    }
  });

  test('번호 위치를 누르면 그 건물이 잡힌다', () {
    for (final building in CampusMapGeometry.buildings) {
      expect(
        CampusMapGeometry.hitTest(building.label),
        building.id,
        reason: '${building.id} 번호 자리가 다른 건물에 잡힌다',
      );
    }
  });
}
