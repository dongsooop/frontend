import 'dart:ui' show SemanticsAction;

import 'package:dongsoop/presentation/campus/campus_map_screen.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_painter.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _mapPaint = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is CampusMapPainter,
);

Finder _marker(String id) => find.byKey(ValueKey('smoking-area-$id'));

TransformationController _controller(WidgetTester tester) => tester
    .widget<InteractiveViewer>(find.byType(InteractiveViewer))
    .transformationController!;

Offset _sourceToGlobal(WidgetTester tester, Offset point) {
  final box = tester.renderObject<RenderBox>(_mapPaint);
  return box.localToGlobal(
    point * (box.size.width / CampusMapGeometry.sourceSize.width),
  );
}

Future<void> _pumpMap(
  WidgetTester tester, {
  double width = 400,
  double textScale = 1,
}) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(platform: TargetPlatform.android),
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 900),
          textScaler: TextScaler.linear(textScale),
        ),
        child: const CampusMapScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pinch(
  WidgetTester tester, {
  required Offset center,
  required double from,
  required double to,
}) async {
  final first = await tester.createGesture(pointer: 1);
  final second = await tester.createGesture(pointer: 2);
  await first.down(center - Offset(from, 0));
  await second.down(center + Offset(from, 0));
  await tester.pump();
  for (var step = 1; step <= 12; step++) {
    final radius = from + (to - from) * step / 12;
    await first.moveTo(center - Offset(radius, 0));
    await second.moveTo(center + Offset(radius, 0));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await first.up();
  await second.up();
  await tester.pumpAndSettle();
}

Future<void> _zoomOut(WidgetTester tester) => _pinch(
      tester,
      center: tester.getCenter(find.byType(InteractiveViewer)),
      from: 120,
      to: 12,
    );

void main() {
  final platforms = TargetPlatformVariant.only(TargetPlatform.android);

  testWidgets('두 손가락으로 전체 지도를 축소해도 마커 위치와 크기를 유지한다', (tester) async {
    await _pumpMap(tester);
    await _zoomOut(tester);

    final viewport = tester.getRect(find.byType(InteractiveViewer));
    final map = tester.getRect(_mapPaint);
    expect(map.left, closeTo(viewport.left, 0.1));
    expect(map.right, closeTo(viewport.right, 0.1));
    for (final area in CampusMapGeometry.smokingAreas) {
      expect(tester.getSize(_marker(area.id)), const Size(40, 40));
      expect(
        (tester.getCenter(_marker(area.id)) -
                _sourceToGlobal(tester, area.position))
            .distance,
        lessThan(0.1),
      );
      expect(
        tester.getSize(find.descendant(
          of: _marker(area.id),
          matching: find.byType(Container),
        )),
        const Size(28, 28),
      );
    }

    final before = _controller(tester).value.getMaxScaleOnAxis();
    final area = CampusMapGeometry.smokingAreas.first;
    await _pinch(
      tester,
      center: tester.getCenter(_marker(area.id)),
      from: 30,
      to: 90,
    );
    expect(_controller(tester).value.getMaxScaleOnAxis(), greaterThan(before));
    expect(tester.getSize(_marker(area.id)), const Size(40, 40));
    expect(
      (tester.getCenter(_marker(area.id)) -
              _sourceToGlobal(tester, area.position))
          .distance,
      lessThan(0.1),
    );
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('40×40 터치 영역으로 흡연구역을 선택하고 건물 선택으로 돌아간다', (tester) async {
    await _pumpMap(tester);
    await _zoomOut(tester);
    final target = _marker('sports-field');
    final center = tester.getCenter(target);

    await tester.tapAt(center + const Offset(21, 0));
    await tester.pumpAndSettle();
    expect(find.text('운동장쪽 흡연구역'), findsNothing);

    // 보이는 원 밖이지만 40×40 터치 영역 안인 지점을 누른다.
    await tester.tapAt(center + const Offset(19, 0));
    await tester.pumpAndSettle();
    expect(find.text('운동장쪽 흡연구역'), findsNWidgets(2));
    expect(find.text('운동장 왼편, 농구장 아래'), findsOneWidget);
    expect(find.text('층별 시설'), findsNothing);
    expect(
      (tester.widget<CustomPaint>(_mapPaint).painter! as CampusMapPainter)
          .selectedBuildingId,
      isNull,
    );
    expect(
      tester
          .getSemantics(target)
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      isTrue,
    );

    final building = CampusMapGeometry.buildings
        .firstWhere((building) => building.id == '1');
    await tester.tapAt(_sourceToGlobal(tester, building.label));
    await tester.pumpAndSettle();
    expect(find.text('층별 시설'), findsOneWidget);
    expect(find.byKey(const ValueKey('smoking-area-label')), findsNothing);
    expect(
      (tester.widget<CustomPaint>(_mapPaint).painter! as CampusMapPainter)
          .selectedBuildingId,
      '1',
    );
  }, variant: platforms);

  testWidgets('흡연 마커 위에서 시작한 확대와 드래그가 선택으로 처리되지 않는다', (tester) async {
    await _pumpMap(tester);
    await _pinch(
      tester,
      center: tester.getCenter(_marker('haeutteul')),
      from: 8,
      to: 65,
    );
    expect(_controller(tester).value.getMaxScaleOnAxis(), greaterThan(1));
    expect(find.byKey(const ValueKey('smoking-area-label')), findsNothing);
    expect(find.text('1호관을 선택했어요'), findsOneWidget);

    final before = _controller(tester).value.getTranslation().x;
    final center = tester.getCenter(_marker('haeutteul'));
    final drag = await tester.startGesture(center);
    for (var step = 1; step <= 8; step++) {
      await drag.moveTo(center - Offset(step * 10, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await drag.up();
    await tester.pumpAndSettle();
    expect(_controller(tester).value.getTranslation().x, lessThan(before));
    expect(find.byKey(const ValueKey('smoking-area-label')), findsNothing);
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('큰 글씨에서도 선택한 이름표가 지도 경계 안에 배치된다', (tester) async {
    await _pumpMap(tester, width: 320, textScale: 1.8);
    await _zoomOut(tester);
    await tester.tapAt(tester.getCenter(_marker('sports-field')));
    await tester.pumpAndSettle();

    final viewport = tester.getRect(find.byType(InteractiveViewer));
    final center = tester.getCenter(_marker('sports-field'));
    final delta = viewport.topLeft + const Offset(8, 8) - center;
    final controller = _controller(tester);
    final scale = controller.value.getMaxScaleOnAxis();
    controller.value = controller.value.clone()
      ..translateByDouble(delta.dx / scale, delta.dy / scale, 0, 1);
    await tester.pump();

    final label =
        tester.getRect(find.byKey(const ValueKey('smoking-area-label')));
    expect(label.left, greaterThanOrEqualTo(viewport.left));
    expect(label.right, lessThanOrEqualTo(viewport.right));
    expect(label.top, greaterThanOrEqualTo(viewport.top));
    expect(label.bottom, lessThanOrEqualTo(viewport.bottom));
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('미리보기의 흡연 마커를 눌러도 기존 지도 열기 동작을 유지한다', (tester) async {
    var opened = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: CampusMapPreview(onTap: () => opened = true),
          ),
        ),
      ),
    ));
    await tester.tapAt(tester.getCenter(_marker('haeutteul')));
    expect(opened, isTrue);
    expect(tester.takeException(), isNull);
  }, variant: platforms);
}
