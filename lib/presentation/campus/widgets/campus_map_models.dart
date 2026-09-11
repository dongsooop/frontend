import 'package:flutter/material.dart';

class CampusFloor {
  const CampusFloor(this.name, this.facilities);

  final String name;
  final List<String> facilities;
}

class CampusBuildingShape {
  const CampusBuildingShape({
    required this.id,
    required this.name,
    required this.paths,
    required this.label,
    this.floors = const [],
  });

  final String id;
  final String name;
  final List<Path> paths;
  final Offset label;
  final List<CampusFloor> floors;
}

String? campusBuildingIdFromLocation(String? location) {
  if (location == null || location.trim().isEmpty) return null;

  final normalized = location.replaceAll(' ', '').toLowerCase();
  final match = RegExp(r'([1-8])호관').firstMatch(normalized);
  if (match != null) return match.group(1);
  if (normalized.contains('도서관')) return 'lib';
  if (normalized.contains('dmmc')) return 'dmmc';
  if (normalized.contains('기숙사')) return 'dorm';
  return null;
}

String campusBuildingName(String id) {
  if (id == 'lib') return '도서관';
  if (id == 'dmmc') return 'DMMC';
  if (id == 'dorm') return '기숙사';
  return '$id호관';
}

List<CampusFloor> campusBuildingFloors(String id) {
  for (final building in CampusMapGeometry.buildings) {
    if (building.id == id) return building.floors;
  }
  return const [];
}

class CampusMapGeometry {
  static const Size sourceSize = Size(1284, 579);

  static List<CampusBuildingShape> get buildings => [
        CampusBuildingShape(
          id: '7',
          name: '7호관',
          paths: [_path([const Offset(262, 73), const Offset(300, 221), const Offset(308, 168), const Offset(325, 163), const Offset(300, 64)])],
          label: const Offset(294, 120),
          floors: const [
            CampusFloor('5F', ['실험실습실', '통합설계실', '전산실습실']),
            CampusFloor('4F', ['강의실', '설계실', '동아리실', '실험실습실']),
            CampusFloor('3F', ['생활환경공학부사무실(건축,실내,시각,AR·VR)', '교수연구실']),
            CampusFloor('2F', ['동아리실', '강의실', '실험실습실']),
            CampusFloor('1F', ['전산실습실', '실험실습실', '강의실']),
            CampusFloor('B1F', ['실험실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '6',
          name: '6호관',
          paths: [_path([const Offset(306, 214), const Offset(317, 264), const Offset(573, 264), const Offset(573, 216)])],
          label: const Offset(444, 241),
          floors: const [
            CampusFloor('5F', ['교수연구실']),
            CampusFloor('4F', ['강의실', '실험실습실', '촬영스튜디오', '전산실습실']),
            CampusFloor('3F', ['강의실', '실험실습실', '전산실습실']),
            CampusFloor('2F', ['강의실', '체력측정실', '원격강의공용실습실']),
            CampusFloor('1F', ['갤러리', '강의실', '실험실습실', '전산실습실']),
            CampusFloor('B1F', ['DM Gallery', '강의실']),
            CampusFloor('B2F', ['동창회사무실', '실험실습실', '공동장비운영센터']),
            CampusFloor('B3F', ['휘트니스센터', '다목적실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '5',
          name: '5호관',
          paths: [_path([const Offset(604, 206), const Offset(604, 246), const Offset(674, 246), const Offset(675, 233), const Offset(719, 233), const Offset(719, 200), const Offset(646, 200), const Offset(644, 204)])],
          label: const Offset(655, 224),
          floors: const [
            CampusFloor('3F', ['DM Lab']),
            CampusFloor('2F', ['실험실습실']),
            CampusFloor('1F', ['튜터링카페', '실습실', 'PD Lab Star']),
            CampusFloor('B1F', ['스마트융합제작 실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '3',
          name: '3호관',
          paths: [_path([const Offset(949, 199), const Offset(669, 265), const Offset(680, 319), const Offset(960, 254)])],
          label: const Offset(815, 259),
          floors: const [
            CampusFloor('5F', ['실험실습실', '강의실', '전산실습실']),
            CampusFloor('4F', ['전기전자통신공학부사무실', '실험실습실', '전산실습실']),
            CampusFloor('3F', ['전산실습실', 'PD Lab']),
            CampusFloor('2F', ['컴퓨터공학부사무실', '전산실습실']),
            CampusFloor('1F', [
              '총학생회',
              '대의원회',
              '보건실',
              '학생상담센터',
              '장애학생지원실',
              '여학생휴게실',
              '부트캠프클린룸',
              'P-Tech 사무실',
              '전산실습실',
            ]),
          ],
        ),
        CampusBuildingShape(
          id: '2',
          name: '2호관',
          paths: [_path([const Offset(962, 178), const Offset(971, 208), const Offset(1051, 189), const Offset(1051, 169), const Offset(1073, 163), const Offset(1080, 181), const Offset(1065, 194), const Offset(1104, 290), const Offset(1136, 275), const Offset(1083, 149)])],
          label: const Offset(1065, 175),
          floors: const [
            CampusFloor('7F', ['교수연구실']),
            CampusFloor('6F', ['교수연구실']),
            CampusFloor('5F', ['교수연구실']),
            CampusFloor('4F', ['교수연구실', '교수학습지원센터', '스튜디오실']),
            CampusFloor('3F', ['경영학부사무실', '스마트강의실']),
            CampusFloor('2F', ['전산실습실', '강의실']),
            CampusFloor('1F', ['전산실습실', '칵테일 실습실']),
            CampusFloor('B1F', ['강의실']),
            CampusFloor('B2F', ['강의실']),
          ],
        ),
        CampusBuildingShape(
          id: '4',
          name: '4호관',
          paths: [_path([const Offset(624, 275), const Offset(618, 285), const Offset(600, 294), const Offset(638, 455), const Offset(687, 441), const Offset(648, 277), const Offset(630, 280)])],
          label: const Offset(644, 364),
          floors: const [
            CampusFloor('6F', ['C.I Lab(취미동아리)']),
            CampusFloor('5F', ['실험실습실', '전산실습실']),
            CampusFloor('4F', ['전산실습실']),
            CampusFloor('3F', ['생명화학공학과사무실', '바이오융합공학과사무실', '실험실습실', '전산실습실']),
            CampusFloor('2F', ['기계공학부사무실', '로봇자동화공학부사무실', '부트캠프사업단', '실험실습실']),
            CampusFloor('1F', ['실험실습실']),
            CampusFloor('B1F', ['실험실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '8',
          name: '8호관',
          paths: [_path([const Offset(536, 435), const Offset(536, 470), const Offset(585, 469), const Offset(584, 434)])],
          label: const Offset(560, 453),
          floors: const [
            CampusFloor('3F', ['식당', '강의실', 'XR스튜디오', '전산실습실']),
            CampusFloor('2F', ['글로세움(서점)', '모닝글로리(문구점)', '제주몰빵(카페)']),
            CampusFloor('1F', [
              '대강당',
              'CU',
              '써브웨이',
              'KB금융은행 및 ATM',
              '여행사(GHRC)',
              '유료(택배)사물함',
            ]),
            CampusFloor('B1F', ['주차장']),
          ],
        ),
        // 1호관과 도서관은 하나로 이어진 건물이라 외곽선은 그대로 두고
        // 왼쪽 동만 도서관으로 분리한다. 연결 통로는 1호관에 포함된다.
        CampusBuildingShape(
          id: 'lib',
          name: '도서관',
          paths: [
            _path([const Offset(924, 387), const Offset(824, 410), const Offset(833, 458), const Offset(854, 455), const Offset(860, 480), const Offset(938, 462)]),
          ],
          label: const Offset(876, 433),
          floors: const [
            CampusFloor('6F', ['인문사회자료실']),
            CampusFloor('5F', ['중앙전산소', '별별마루(오디토리움, VR룸)', '열린마루', '그룹스터디룸']),
            CampusFloor('4F', ['도서관 사무실', '톡톡마루', '너나마루', '온빛마루', '그룹스터디룸', '대출실']),
            CampusFloor('3F', ['과학기술자료실', '그룹스터디룸']),
            CampusFloor('2F', ['어문학자료실', '그룹스터디룸']),
            CampusFloor('1F', [
              'D-Study',
              'D-Culture',
              '그룹스터디룸',
              '디자인홍보센터',
              '홍보대사단실',
              '동양학보기자단실',
            ]),
          ],
        ),
        CampusBuildingShape(
          id: '1',
          name: '1호관',
          paths: [
            _path([const Offset(1077, 325), const Offset(995, 342), const Offset(1003, 377), const Offset(1016, 383), const Offset(1086, 368)]),
            _path([const Offset(1038, 385), const Offset(1017, 388), const Offset(1015, 405), const Offset(998, 411), const Offset(986, 400), const Offset(988, 385), const Offset(960, 392), const Offset(964, 430), const Offset(1045, 418), const Offset(1041, 401)]),
            _path([const Offset(947, 385), const Offset(930, 389), const Offset(938, 429), const Offset(954, 425)]),
          ],
          label: const Offset(1001, 394),
          floors: const [
            CampusFloor('9F', ['법인사무국']),
            CampusFloor('8F', ['총장실', '학생처장실', '사무처장실', '종합회의실', '부속실']),
            CampusFloor('7F', ['교무입학처', '교무입학처장실', '감사장/대외평가실']),
            CampusFloor('6F', ['산학협력단', '기획혁신처', '기획혁신처장실']),
            CampusFloor('5F', ['사무처', '소강당']),
            CampusFloor('4F', [
              '학생서비스센터(휴/복학,수업,장학)',
              '취업지원센터',
              '현장실습지원센터',
              '공학기술교육혁신센터',
              'KB국민 ATM',
              '증명서발급기',
            ]),
            CampusFloor('3F', ['강의실', '예비군연대', '교양과사무실', '전산실습실']),
            CampusFloor('2F', ['강의실', '유학생지원실', '국제교류센터', 'HiVE 센터']),
            CampusFloor('1F', ['강의실', '입시지원팀', '웰컴라운지', '웰컴갤러리']),
          ],
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
