import 'dart:ui' show SemanticsAction;

import 'package:dongsoop/presentation/campus/campus_map_screen.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_painter.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_preview.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_search.dart';
import 'package:dongsoop/ui/color_styles.dart';
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
    expect(find.text(CampusMapGeometry.smokingAreas.last.location),
        findsOneWidget);
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
    expect(
      (tester.widget<CustomPaint>(_mapPaint).painter! as CampusMapPainter)
          .selectedBuildingId,
      '1',
    );

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

  test('검색은 띄어쓰기와 대소문자를 무시하고 중복 시설을 건물과 층으로 구분한다', () {
    for (final query in ['DM Lab', 'dmlab', ' D M LAB ']) {
      final result = CampusMapSearch.find(query).single;
      expect(result.building!.id, '5');
      expect(result.floor!.name, '3F');
      expect(result.facilities, ['DM Lab']);
    }
    final duplicates = CampusMapSearch.find('실험실습실');
    expect(duplicates.length, 17);
    expect(duplicates.map((result) => result.building!.id).toSet(),
        {'3', '4', '5', '6', '7'});
    expect(duplicates.map((result) => result.location).toSet().length, 17);
    final filtered = CampusMapSearch.find('5호관 실험실습실').single;
    expect(filtered.location, '5호관 · 2F');
    expect(CampusMapSearch.find('  '), isEmpty);
    expect(CampusMapSearch.find('없는시설이름'), isEmpty);
    expect(CampusMapSearch.find('DMMC').single.floor, isNull);
    expect(CampusMapSearch.find('해우뜰').single.smokingArea!.id, 'haeutteul');
  });

  testWidgets('빈 검색창과 공백은 지도를 표시하고 검색어를 지워도 지도 배율을 유지한다', (tester) async {
    await _pumpMap(tester);
    await _zoomOut(tester);
    final controller = _controller(tester);
    final transform = controller.value.clone();
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);

    await tester.enterText(find.byType(TextField), '없는시설이름');
    await tester.pumpAndSettle();
    expect(find.text('일치하는 시설이 없어요'), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsNothing);
    await tester.tap(find.byTooltip('검색어 지우기'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(_controller(tester), same(controller));
    expect(_controller(tester).value, transform);

    await tester.enterText(find.byType(TextField), 'DM Lab');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('단일 검색을 확정하면 건물을 가운데 표시하고 해당 시설과 층을 강조한다', (tester) async {
    await _pumpMap(tester);
    await tester.enterText(find.byType(TextField), 'dmlab');
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
    expect(find.text('DM Lab'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('5호관 · 3F'), findsOneWidget);
    final building =
        CampusMapGeometry.buildings.firstWhere((item) => item.id == '5');
    final center = tester.getCenter(find.byType(InteractiveViewer));
    expect((_sourceToGlobal(tester, building.label) - center).distance,
        lessThan(0.1));
    expect(find.byKey(const ValueKey('campus-floor-3F')), findsOneWidget);
    expect(find.byKey(const ValueKey('campus-floor-2F')), findsNothing);
    final facility = tester.widget<Container>(
        find.byKey(const ValueKey('campus-facility-3F-DM Lab')));
    expect((facility.decoration! as BoxDecoration).border!.top.color,
        ColorStyles.primary100);

    await tester.ensureVisible(find.text('전체 4개 층 보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('전체 4개 층 보기'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('campus-floor-2F')), findsOneWidget);
    await tester.ensureVisible(find.text('검색한 층만 보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('검색한 층만 보기'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('campus-floor-2F')), findsNothing);

    await tester.tap(find.byTooltip('검색어 지우기'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byKey(const ValueKey('campus-floor-2F')), findsOneWidget);
    expect(find.text('검색 목록'), findsNothing);
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('중복 결과는 건물별 층을 선택하고 검색 목록에서 다시 고를 수 있다', (tester) async {
    await _pumpMap(tester);
    await tester.enterText(find.byType(TextField), '실험실습실');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
    expect(find.text('5개 건물 · 17개 층'), findsOneWidget);
    final secondFloor = find.byKey(const ValueKey('campus-search-5-2F'));
    await tester.ensureVisible(secondFloor);
    await tester.pumpAndSettle();
    await tester.tap(secondFloor);
    await tester.pumpAndSettle();
    expect(find.text('5호관 · 2F'), findsOneWidget);
    expect(find.byKey(const ValueKey('campus-floor-2F')), findsOneWidget);
    expect(find.byKey(const ValueKey('campus-floor-3F')), findsNothing);
    await tester.tap(find.text('검색 목록'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '실험실습실');
    final fifthFloor = find.byKey(const ValueKey('campus-search-3-5F'));
    await tester.ensureVisible(fifthFloor);
    await tester.pumpAndSettle();
    await tester.tap(fifthFloor);
    await tester.pumpAndSettle();
    expect(find.text('3호관 · 5F'), findsOneWidget);
    expect(
        (tester.widget<CustomPaint>(_mapPaint).painter! as CampusMapPainter)
            .selectedBuildingId,
        '3');
    expect(find.byKey(const ValueKey('campus-floor-5F')), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('흡연구역과 층 정보가 없는 건물도 검색해서 지도에서 선택한다', (tester) async {
    await _pumpMap(tester);
    await tester.enterText(find.byType(TextField), '해우뜰');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('smoking-area-label')), findsOneWidget);
    expect(find.text(CampusMapGeometry.smokingAreas.first.location),
        findsOneWidget);
    expect(tester.getSize(_marker('haeutteul')), const Size(40, 40));
    expect(find.text('층별 시설'), findsNothing);

    await tester.enterText(find.byType(TextField), 'dmmc');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('등록된 층별 시설 정보가 없어요.'), findsOneWidget);
    expect(
        (tester.widget<CustomPaint>(_mapPaint).painter! as CampusMapPainter)
            .selectedBuildingId,
        'dmmc');
    expect(find.byKey(const ValueKey('smoking-area-label')), findsNothing);
    expect(tester.takeException(), isNull);
  }, variant: platforms);

  testWidgets('좁은 화면과 큰 글씨에서도 검색 결과와 시설 정보를 표시한다', (tester) async {
    await _pumpMap(tester, width: 320, textScale: 1.8);
    await tester.enterText(find.byType(TextField), '실험실습실');
    await tester.pumpAndSettle();
    expect(find.text('5개 건물 · 17개 층'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), '생활환경공학부사무실');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('7호관 · 3F'), findsOneWidget);
    expect(find.text('생활환경공학부사무실(건축,실내,시각,AR·VR)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, variant: platforms);
}
