import 'package:flutter/material.dart';

class CampusBuildingShape {
  const CampusBuildingShape({
    required this.id,
    required this.name,
    required this.paths,
    required this.label,
  });

  final String id;
  final String name;
  final List<Path> paths;
  final Offset label;
}

String? campusBuildingIdFromLocation(String? location) {
  if (location == null || location.trim().isEmpty) return null;

  final normalized = location.replaceAll(' ', '').toLowerCase();
  final match = RegExp(r'([1-8])호관').firstMatch(normalized);
  if (match != null) return match.group(1);
  if (normalized.contains('dmmc')) return 'dmmc';
  if (normalized.contains('기숙사')) return 'dorm';
  return null;
}

String campusBuildingName(String id) {
  if (id == 'dmmc') return 'DMMC';
  if (id == 'dorm') return '기숙사';
  return '$id호관';
}

class CampusMapGeometry {
  static const Size sourceSize = Size(1284, 579);

  static List<CampusBuildingShape> get buildings => [
        CampusBuildingShape(
          id: '7',
          name: '7호관',
          paths: [_path([const Offset(262, 73), const Offset(300, 221), const Offset(308, 168), const Offset(325, 163), const Offset(300, 64)])],
          label: const Offset(294, 120),
        ),
        CampusBuildingShape(
          id: '6',
          name: '6호관',
          paths: [_path([const Offset(306, 214), const Offset(317, 264), const Offset(573, 264), const Offset(573, 216)])],
          label: const Offset(444, 241),
        ),
        CampusBuildingShape(
          id: '5',
          name: '5호관',
          paths: [_path([const Offset(604, 206), const Offset(604, 246), const Offset(674, 246), const Offset(675, 233), const Offset(719, 233), const Offset(719, 200), const Offset(646, 200), const Offset(644, 204)])],
          label: const Offset(655, 224),
        ),
        CampusBuildingShape(
          id: '3',
          name: '3호관',
          paths: [_path([const Offset(949, 199), const Offset(669, 265), const Offset(680, 319), const Offset(960, 254)])],
          label: const Offset(815, 259),
        ),
        CampusBuildingShape(
          id: '2',
          name: '2호관',
          paths: [_path([const Offset(962, 178), const Offset(971, 208), const Offset(1051, 189), const Offset(1051, 169), const Offset(1073, 163), const Offset(1080, 181), const Offset(1065, 194), const Offset(1104, 290), const Offset(1136, 275), const Offset(1083, 149)])],
          label: const Offset(1065, 175),
        ),
        CampusBuildingShape(
          id: '4',
          name: '4호관',
          paths: [_path([const Offset(624, 275), const Offset(618, 285), const Offset(600, 294), const Offset(638, 455), const Offset(687, 441), const Offset(648, 277), const Offset(630, 280)])],
          label: const Offset(644, 364),
        ),
        CampusBuildingShape(
          id: '8',
          name: '8호관',
          paths: [_path([const Offset(536, 435), const Offset(536, 470), const Offset(585, 469), const Offset(584, 434)])],
          label: const Offset(560, 453),
        ),
        CampusBuildingShape(
          id: '1',
          name: '1호관',
          paths: [
            _path([const Offset(924, 387), const Offset(824, 410), const Offset(833, 458), const Offset(854, 455), const Offset(860, 480), const Offset(938, 462)]),
            _path([const Offset(1077, 325), const Offset(995, 342), const Offset(1003, 377), const Offset(1016, 383), const Offset(1086, 368)]),
            _path([const Offset(1038, 385), const Offset(1017, 388), const Offset(1015, 405), const Offset(998, 411), const Offset(986, 400), const Offset(988, 385), const Offset(960, 392), const Offset(964, 430), const Offset(1045, 418), const Offset(1041, 401)]),
            _path([const Offset(947, 385), const Offset(930, 389), const Offset(938, 429), const Offset(954, 425)]),
          ],
          label: const Offset(1001, 394),
        ),
        CampusBuildingShape(
          id: 'dmmc',
          name: 'DMMC',
          paths: [
            _path([const Offset(147, 471), const Offset(142, 464), const Offset(136, 465), const Offset(133, 462), const Offset(76, 505), const Offset(144, 528), const Offset(149, 511), const Offset(129, 503), const Offset(145, 488)]),
            _path([const Offset(188, 422), const Offset(148, 450), const Offset(175, 486), const Offset(204, 464), const Offset(197, 455), const Offset(197, 450), const Offset(207, 444)]),
          ],
          label: const Offset(140, 410),
        ),
        CampusBuildingShape(
          id: 'dorm',
          name: '기숙사',
          paths: [_path([const Offset(274, 495), const Offset(271, 494), const Offset(268, 496), const Offset(240, 504), const Offset(239, 505), const Offset(245, 521), const Offset(280, 514), const Offset(276, 499)])],
          label: const Offset(292, 470),
        ),
      ];

  static Path _path(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  static String? hitTest(Offset sourcePoint) {
    for (final building in buildings.reversed) {
      if (building.paths.any((path) => path.contains(sourcePoint))) {
        return building.id;
      }
    }
    return null;
  }
}
