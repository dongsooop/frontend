import 'package:flutter/material.dart';

class CampusMapPainter extends CustomPainter {
  const CampusMapPainter({this.selectedBuilding});

  final int? selectedBuilding;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CampusMapPainter oldDelegate) =>
      oldDelegate.selectedBuilding != selectedBuilding;
}
