import 'package:dongsoop/presentation/campus/widgets/campus_map_models.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';

class CampusMapPainter extends CustomPainter {
  const CampusMapPainter({this.selectedBuildingId});

  final String? selectedBuildingId;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / CampusMapGeometry.sourceSize.width;
    final scaleY = size.height / CampusMapGeometry.sourceSize.height;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    final backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFCFCFC);
    canvas.drawRect(
      Offset.zero & CampusMapGeometry.sourceSize,
      backgroundPaint,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFFD8DCE2);
    canvas.drawRect(const Rect.fromLTWH(350, 304, 220, 122), linePaint);
    canvas.drawLine(const Offset(459, 304), const Offset(459, 426), linePaint);
    canvas.drawCircle(const Offset(459, 365), 14, linePaint);
    canvas.drawRect(const Rect.fromLTWH(294, 312, 47, 65), linePaint);

    for (final building in CampusMapGeometry.buildings) {
      final isSelected = selectedBuildingId == building.id;
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isSelected ? ColorStyles.primary100 : Colors.white;
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..color = ColorStyles.primary100;

      for (final path in building.paths) {
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
      }

      final markerPaint = Paint()
        ..color = isSelected ? Colors.white : ColorStyles.primary100;
      canvas.drawCircle(building.label, 15, markerPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: _badgeText(building.id),
          style: TextStyle(
            color: isSelected ? ColorStyles.primary100 : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        building.label - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    _paintLabel(canvas, 'Basketball\nCourt', const Offset(315, 320));
    _paintLabel(canvas, 'Sports Field', const Offset(412, 370));
    _paintLabel(canvas, 'Plaza', const Offset(905, 334));

    canvas.restore();
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

  void _paintLabel(Canvas canvas, String text, Offset position) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF858A91),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      position - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CampusMapPainter oldDelegate) =>
      oldDelegate.selectedBuildingId != selectedBuildingId;
}
