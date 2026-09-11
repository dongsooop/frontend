import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class CampusMapPainter extends CustomPainter {
  const CampusMapPainter({this.selectedBuildingId});

  final String? selectedBuildingId;

  static const Color _siteLine = Color(0xFFD0D4DD);
  static const Color _detailLine = Color(0xFFC4C9D5);
  static const Color _hatchLine = Color(0xFFBFC5D0);
  static const Color _treeLine = Color(0xFFC5CAD5);
  static const Color _gateLine = Color(0xFF151515);
  static const Color _areaLabel = Color(0xFF858A91);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(
      size.width / CampusMapGeometry.sourceSize.width,
      size.height / CampusMapGeometry.sourceSize.height,
    );

    canvas.drawRect(
      Offset.zero & CampusMapGeometry.sourceSize,
      Paint()..color = ColorStyles.gray7,
    );

    _paintSite(canvas);
    _paintDetail(canvas);
    _paintBuildings(canvas);

    for (final (text, position) in CampusMapGeometry.areaLabels) {
      _paintText(
        canvas,
        text,
        position,
        const TextStyle(
          color: _areaLabel,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    canvas.restore();
  }

  void _paintSite(Canvas canvas) {
    final sitePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..color = _siteLine;

    for (final data in CampusMapGeometry.sitePaths) {
      canvas.drawPath(parseSvgPath(data), sitePaint);
    }
  }

  void _paintDetail(Canvas canvas) {
    final fillPaint = Paint()..color = ColorStyles.white;
    final detailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = _detailLine;

    for (final data in CampusMapGeometry.filledDetailPaths) {
      final path = parseSvgPath(data);
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, detailPaint);
    }
    for (final (center, radius) in CampusMapGeometry.filledDetailCircles) {
      canvas.drawCircle(center, radius, fillPaint);
      canvas.drawCircle(center, radius, detailPaint);
    }
    for (final data in CampusMapGeometry.strokedDetailPaths) {
      canvas.drawPath(parseSvgPath(data), detailPaint);
    }

    final hatchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = _hatchLine;
    for (final data in CampusMapGeometry.hatchPaths) {
      canvas.drawPath(parseSvgPath(data), hatchPaint);
    }

    final treePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = _treeLine;
    for (final (center, radius) in CampusMapGeometry.treeCircles) {
      canvas.drawCircle(center, radius, treePaint);
    }

    final gatePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = _gateLine;
    for (final data in CampusMapGeometry.gatePaths) {
      canvas.drawPath(parseSvgPath(data), gatePaint);
    }
  }

  void _paintBuildings(Canvas canvas) {
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.miter
      ..color = ColorStyles.primary100;

    for (final building in CampusMapGeometry.buildings) {
      final isSelected = selectedBuildingId == building.id;
      final fillPaint = Paint()
        ..color = isSelected ? ColorStyles.primary100 : ColorStyles.white;

      for (final path in building.paths) {
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
      }

      canvas.drawCircle(
        building.label,
        24,
        Paint()
          ..color = isSelected ? ColorStyles.white : ColorStyles.primary100,
      );
      _paintText(
        canvas,
        _badgeText(building.id),
        building.label,
        TextStyle(
          color: isSelected ? ColorStyles.primary100 : ColorStyles.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
        ),
      );
    }
  }

  String _badgeText(String id) {
    switch (id) {
      case 'lib':
        return '도';
      case 'dmmc':
        return 'D';
      case 'dorm':
        return '기';
      default:
        return id;
    }
  }

  void _paintText(Canvas canvas, String text, Offset center, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CampusMapPainter oldDelegate) =>
      oldDelegate.selectedBuildingId != selectedBuildingId;
}
