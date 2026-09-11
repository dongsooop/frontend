import 'package:flutter/material.dart';

/// 건물의 한 층.
///
/// [isGround] 는 그 층에 지상 출입구가 있다는 뜻이다. 경사지에 지어져
/// 4층이나 지하 2층에서도 밖으로 바로 나가는 건물이 있어 따로 표시한다.
class CampusFloor {
  const CampusFloor(this.name, this.facilities, {this.isGround = false});

  final String name;
  final List<String> facilities;
  final bool isGround;
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

/// 배치도 좌표는 전부 SVG path 문자열로 들고 있다.
///
/// 도면을 손으로 옮겨 적으면 선 하나 고칠 때마다 좌표 배열을 다시 세야 해서,
/// 원본 도면의 path 를 그대로 두고 그릴 때만 [parseSvgPath] 로 푼다.
class CampusMapGeometry {
  static const Size sourceSize = Size(2048, 928);

  /// 부지 경계·도로.
  static const List<String> sitePaths = [
    'M385 76Q389 65 417 57Q500 53 576 53L596 56 618 53V310H1282L1563 235 1642 195 1634 172 1636 141Q1634 122 1655 130L1694 138Q1700 139 1704 151L1873 493Q1886 512 1869 541L1848 573Q1838 589 1816 576L1798 562',
    'M385 76L394 162 380 166 476 425 372 581 607 727Q645 752 699 755L986 765 986 747 1041 745 1185 773 1263 783 1311 780 1320 786V748L1353 761 1355 796 1393 812 1499 771 1757 634Q1787 618 1775 589L1757 554',
    'M1634 172L1670 156 1696 191Q1714 211 1730 215L1850 496Q1863 514 1852 530L1837 555 1824 520',
    'M76 807L304 641 381 775 458 750 476 829 376 854 245 861 168 838Z',
    'M618 310H958M1152 374L1580 265 1742 225',
    'M957 442L939 456 984 692Q987 715 1002 723L1200 674',
    'M1002 723L1239 661M1239 661L1232 655Q1226 637 1249 630L1362 603 1368 624 1582 572 1572 547Q1562 530 1580 526L1705 499Q1724 494 1730 510L1760 579',
    'M1607 521L1599 504Q1594 492 1608 489L1704 467Q1753 456 1777 500L1805 558',
  ];

  /// 운동장·주차장처럼 면이 있는 구조물.
  static const List<String> filledDetailPaths = [
    'M503 97L531 90 541 128 514 136Z',
    'M546 67H590V110H576V96H546Z',
    'M470 474H542V600H470Z',
    'M440 538H463V597H440Z',
    'M562 480H908V680H562Z',
    'M863 447H919V479H863Z',
    'M1410 592L1467 578 1471 597 1414 612Z M1500 590L1495 579 1526 571 1530 583Z',
  ];

  /// 면 없이 선만 있는 구조물 — 계단, 경계선, 트랙 같은 것들.
  static const List<String> strokedDetailPaths = [
    'M501 422V436H561V423M582 423V445H837V423M582 455H837',
    'M456 600V611H554M470 537H542',
    'M555 650V472H694V480M725 480V472H919V681M733 488V557M733 601V672',
    'M562 680L604 698H669V713H863M756 715Q768 733 762 754',
    'M952 324V402H1061V394',
    'M1080 611L1100 603 1122 713 1193 695 1184 659 1128 673',
    'M1122 521L1168 511 1176 541 1130 552Z M1127 538L1154 532 1151 516',
    'M1673 302L1687 337 1710 331M1537 343L1554 403 1585 394 1565 330',
  ];

  /// 계단 빗금.
  static const List<String> hatchPaths = [
    'M1393 284L1403 321M1398 282L1408 319M1403 281L1413 317M1532 254L1540 280M1537 252L1545 278M1542 251L1550 277M1675 218L1684 244M1680 216L1689 242M1685 214L1694 240',
    'M475 355H488M475 360H488M475 365H488M475 370H488M475 375H488M475 380H488M804 736V750M810 736V750M816 736V750M822 736V750M828 736V750M834 736V750M840 736V750M846 736V750',
  ];

  /// 출입구 기둥.
  static const List<String> gatePaths = [
    'M920 303V316M957 303V316M763 750V762M790 750V762M1517 758L1523 770M1550 745L1556 757M1756 572L1763 582M1801 551L1808 563',
  ];

  /// 조경수. (중심, 반지름)
  static const List<(Offset, double)> treeCircles = [
    (Offset(597, 142), 10),
    (Offset(558, 272), 8),
    (Offset(599, 261), 9),
    (Offset(1654, 225), 9),
    (Offset(1586, 335), 9),
    (Offset(1621, 378), 9),
    (Offset(647, 719), 9),
    (Offset(703, 733), 10),
    (Offset(687, 739), 5),
    (Offset(427, 574), 7),
    (Offset(417, 591), 5),
    (Offset(1442, 770), 8),
    (Offset(1461, 773), 7),
    (Offset(1622, 695), 9),
  ];

  /// 면이 있는 원형 구조물 — 농구장 센터서클, 운동장 센터서클.
  static const List<(Offset, double)> filledDetailCircles = [
    (Offset(506, 537), 10),
    (Offset(733, 579), 22),
  ];

  static const List<(String, Offset)> areaLabels = [
    ('Basketball\nCourt', Offset(502, 510)),
    ('Sports Field', Offset(657, 590)),
    ('Plaza', Offset(1443, 533)),
  ];

  static List<CampusBuildingShape> get buildings => [
        CampusBuildingShape(
          id: '7',
          name: '7호관',
          paths: [
            parseSvgPath(
                'M413 108L483 91 525 260 497 267 500 283 490 284 494 301 487 301 483 351 475 351Z'),
          ],
          label: const Offset(469, 191),
          floors: const [
            CampusFloor('5F', ['실험실습실', '통합설계실', '전산실습실']),
            CampusFloor('4F', ['강의실', '설계실', '동아리실', '실험실습실']),
            CampusFloor('3F', ['생활환경공학부사무실(건축,실내,시각,AR·VR)', '교수연구실']),
            CampusFloor('2F', ['동아리실', '강의실', '실험실습실']),
            CampusFloor('1F', ['전산실습실', '실험실습실', '강의실'], isGround: true),
            CampusFloor('B1F', ['실험실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '6',
          name: '6호관',
          paths: [
            parseSvgPath('M486 332H504V340L919 335V422H502V389H490V343H486Z'),
          ],
          label: const Offset(708, 384),
          floors: const [
            CampusFloor('5F', ['교수연구실']),
            CampusFloor('4F', ['강의실', '실험실습실', '촬영스튜디오', '전산실습실']),
            CampusFloor('3F', ['강의실', '실험실습실', '전산실습실']),
            CampusFloor('2F', ['강의실', '체력측정실', '원격강의공용실습실']),
            CampusFloor('1F', ['갤러리', '강의실', '실험실습실', '전산실습실'],
                isGround: true),
            CampusFloor('B1F', ['DM Gallery', '강의실']),
            CampusFloor('B2F', ['동창회사무실', '실험실습실', '공동장비운영센터']),
            CampusFloor('B3F', ['휘트니스센터', '다목적실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '5',
          name: '5호관',
          paths: [
            parseSvgPath('M959 320L1031 318V310H1152V372H1080V393H959Z'),
          ],
          label: const Offset(1045, 357),
          floors: const [
            CampusFloor('3F', ['DM Lab']),
            CampusFloor('2F', ['실험실습실']),
            CampusFloor('1F', ['튜터링카페', '실습실', 'PD Lab Star'], isGround: true),
            CampusFloor('B1F', ['스마트융합제작 실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '3',
          name: '3호관',
          paths: [
            parseSvgPath('M1062 416L1518 308 1540 403 1083 511Z'),
          ],
          label: const Offset(1300, 413),
          floors: const [
            CampusFloor('5F', ['실험실습실', '강의실', '전산실습실']),
            CampusFloor('4F', ['전기전자통신공학부사무실', '실험실습실', '전산실습실']),
            CampusFloor('3F', ['전산실습실', 'PD Lab']),
            CampusFloor('2F', ['컴퓨터공학부사무실', '전산실습실']),
            CampusFloor(
              '1F',
              [
                '총학생회',
                '대의원회',
                '보건실',
                '학생상담센터',
                '장애학생지원실',
                '여학생휴게실',
                '부트캠프클린룸',
                'P-Tech 사무실',
                '전산실습실',
              ],
              isGround: true,
            ),
          ],
        ),
        CampusBuildingShape(
          id: '2',
          name: '2호관',
          paths: [
            parseSvgPath(
                'M1537 280L1728 234 1737 254 1733 256 1811 433 1788 444 1789 450 1776 457 1773 451 1763 456 1757 441 1764 437 1694 292 1549 326Z'),
          ],
          label: const Offset(1699, 279),
          floors: const [
            CampusFloor('7F', ['교수연구실']),
            CampusFloor('6F', ['교수연구실']),
            CampusFloor('5F', ['교수연구실']),
            CampusFloor('4F', ['교수연구실', '교수학습지원센터', '스튜디오실']),
            CampusFloor('3F', ['경영학부사무실', '스마트강의실']),
            CampusFloor('2F', ['전산실습실', '강의실'], isGround: true),
            CampusFloor('1F', ['전산실습실', '칵테일 실습실']),
            CampusFloor('B1F', ['강의실']),
            CampusFloor('B2F', ['강의실'], isGround: true),
          ],
        ),
        CampusBuildingShape(
          id: '4',
          name: '4호관',
          paths: [
            parseSvgPath(
                'M952 456L985 445V435L1000 428V442L1038 431 1102 706 1015 727Z'),
          ],
          label: const Offset(1027, 581),
          floors: const [
            CampusFloor('6F', ['C.I Lab(취미동아리)']),
            CampusFloor('5F', ['실험실습실', '전산실습실']),
            CampusFloor('4F', ['전산실습실']),
            CampusFloor('3F', ['생명화학공학과사무실', '바이오융합공학과사무실', '실험실습실', '전산실습실']),
            CampusFloor('2F', ['기계공학부사무실', '로봇자동화공학부사무실', '부트캠프사업단', '실험실습실']),
            CampusFloor('1F', ['실험실습실'], isGround: true),
            CampusFloor('B1F', ['실험실습실']),
          ],
        ),
        CampusBuildingShape(
          id: '8',
          name: '8호관',
          paths: [
            parseSvgPath('M857 690H933V744H857Z'),
          ],
          label: const Offset(893, 723),
          floors: const [
            CampusFloor('3F', ['식당', '강의실', 'XR스튜디오', '전산실습실']),
            CampusFloor('2F', ['글로세움(서점)', '모닝글로리(문구점)', '제주몰빵(카페)']),
            CampusFloor(
              '1F',
              [
                '대강당',
                'CU',
                '써브웨이',
                'KB금융은행 및 ATM',
                '여행사(GHRC)',
                '유료(택배)사물함',
              ],
              isGround: true,
            ),
            CampusFloor('B1F', ['주차장']),
          ],
        ),
        // 1호관과 도서관은 이어진 건물이다. 외곽선은 그대로 두고 왼쪽 동만
        // 도서관으로 나눴고, 연결 통로는 1호관에 포함된다.
        CampusBuildingShape(
          id: 'lib',
          name: '도서관',
          paths: [
            parseSvgPath(
                'M1308 647L1476 606 1480 614 1495 687 1504 735 1370 767 1360 726 1327 733Z'),
          ],
          label: const Offset(1397, 691),
          floors: const [
            CampusFloor('6F', ['인문사회자료실']),
            CampusFloor('5F', ['중앙전산소', '별별마루(오디토리움, VR룸)', '열린마루', '그룹스터디룸']),
            CampusFloor(
                '4F', ['도서관 사무실', '톡톡마루', '너나마루', '온빛마루', '그룹스터디룸', '대출실']),
            CampusFloor('3F', ['과학기술자료실', '그룹스터디룸']),
            CampusFloor('2F', ['어문학자료실', '그룹스터디룸']),
            CampusFloor(
              '1F',
              [
                'D-Study',
                'D-Culture',
                '그룹스터디룸',
                '디자인홍보센터',
                '홍보대사단실',
                '동양학보기자단실',
              ],
              isGround: true,
            ),
          ],
        ),
        CampusBuildingShape(
          id: '1',
          name: '1호관',
          paths: [
            parseSvgPath(
                'M1514 605L1512 598 1588 579 1583 537 1723 507 1739 586 1697 595Q1692 625 1668 643L1670 660 1530 694 1526 678Z'),
          ],
          label: const Offset(1597, 628),
          floors: const [
            CampusFloor('9F', ['법인사무국']),
            CampusFloor('8F', ['총장실', '학생처장실', '사무처장실', '종합회의실', '부속실']),
            CampusFloor('7F', ['교무입학처', '교무입학처장실', '감사장/대외평가실']),
            CampusFloor('6F', ['산학협력단', '기획혁신처', '기획혁신처장실']),
            CampusFloor('5F', ['사무처', '소강당']),
            CampusFloor(
              '4F',
              [
                '학생서비스센터(휴/복학,수업,장학)',
                '취업지원센터',
                '현장실습지원센터',
                '공학기술교육혁신센터',
                'KB국민 ATM',
                '증명서발급기',
              ],
              isGround: true,
            ),
            CampusFloor('3F', ['강의실', '예비군연대', '교양과사무실', '전산실습실']),
            CampusFloor('2F', ['강의실', '유학생지원실', '국제교류센터', 'HiVE 센터']),
            CampusFloor('1F', ['강의실', '입시지원팀', '웰컴라운지', '웰컴갤러리'],
                isGround: true),
          ],
        ),
        CampusBuildingShape(
          id: 'dmmc',
          name: 'DMMC',
          paths: [
            parseSvgPath(
                'M230 713L302 661 330 708 318 718 334 736 279 778Z M112 803L214 726 220 735 226 730 242 749 202 776 213 781 206 800 244 814 234 843Z'),
          ],
          label: const Offset(278, 718),
        ),
        CampusBuildingShape(
          id: 'dorm',
          name: '기숙사',
          paths: [
            parseSvgPath('M376 797L440 778 450 817 389 835Z'),
          ],
          label: const Offset(413, 806),
        ),
      ];

  static String? hitTest(Offset sourcePoint) {
    for (final building in buildings.reversed) {
      if (building.paths.any((path) => path.contains(sourcePoint))) {
        return building.id;
      }
    }
    return null;
  }
}

/// SVG path 문자열을 [Path] 로 바꾼다.
///
/// 도면에 쓰인 명령(M/L/H/V/Q/Z, 절대 좌표)만 다룬다. 상대 좌표나 곡선
/// 명령이 더 필요해지면 그때 늘리면 된다.
Path parseSvgPath(String data) {
  final path = Path();
  final tokens = RegExp(r'[A-Za-z]|-?\d*\.?\d+')
      .allMatches(data)
      .map((match) => match[0]!)
      .toList();

  var index = 0;
  var command = 'M';
  var current = Offset.zero;
  var start = Offset.zero;

  double number() => double.parse(tokens[index++]);

  while (index < tokens.length) {
    final token = tokens[index];
    if (RegExp(r'[A-Za-z]').hasMatch(token)) {
      index++;
      if (token == 'Z' || token == 'z') {
        path.close();
        current = start;
        continue;
      }
      command = token;
      continue;
    }

    switch (command) {
      case 'M':
        current = Offset(number(), number());
        start = current;
        path.moveTo(current.dx, current.dy);
        // 이어지는 좌표쌍은 SVG 규칙대로 직선으로 본다.
        command = 'L';
      case 'L':
        current = Offset(number(), number());
        path.lineTo(current.dx, current.dy);
      case 'H':
        current = Offset(number(), current.dy);
        path.lineTo(current.dx, current.dy);
      case 'V':
        current = Offset(current.dx, number());
        path.lineTo(current.dx, current.dy);
      case 'Q':
        final control = Offset(number(), number());
        current = Offset(number(), number());
        path.quadraticBezierTo(
          control.dx,
          control.dy,
          current.dx,
          current.dy,
        );
      default:
        index++;
    }
  }

  return path;
}
