import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';

/// 서버가 메뉴가 없는 날에 채워 보내는 값. 백엔드 `MealServiceImpl` 의
/// `DEFAULT_EMPTY_MENU` 와 같은 문자열이다.
const String _emptyMenuMark = '식단 정보 없음';

/// 되풀이로 볼 최소 비율. 5일 중 4일이면 되풀이로 본다.
const double _stapleRatio = 0.8;

/// 셀 수 있는 최소 급식일 수. 두 날뿐이면 `2/2 = 100%` 가 너무 쉽게 나온다.
const int _minServedDays = 3;

/// 되풀이를 내리고도 위에 남아야 하는 최소 항목 수.
const int _minVisibleItems = 2;

/// 급식이 없는 날인지.
///
/// 예전에는 `koreanMenu.length < 10` 으로 판정했는데, 서버가 보내는
/// `식단 정보 없음` 이 마침 9자라서 우연히 맞고 있었다. 짧은 메뉴가
/// 하루라도 오면 그날이 통째로 휴무가 된다.
bool isMealEmpty(String menu) {
  final trimmed = menu.trim();
  return trimmed.isEmpty || trimmed == '-' || trimmed == _emptyMenuMark;
}

/// 하루치 메뉴 문자열을 항목으로 끊는다.
///
/// 서버는 `백미밥, 떡갈비구이&부추겉절이, 달걀야채찜` 처럼 쉼표로 이어 붙여
/// 준다. 실제 응답을 확인해 쓰이는 두 글자만 끊는다 — 쓰이지도 않는 구분자를
/// 넣어 두면 그런 데이터가 오는 줄 알게 된다.
///
/// `&` 를 살려 두지 않는 이유는 학교가 무엇을 한 접시로 묶어 적는지 기준이
/// 없어서다. 끊는다고 같은 항목이 두 번 생기지도 않는다.
List<String> splitMealMenu(String menu) {
  if (isMealEmpty(menu)) return const [];

  return menu
      .split(RegExp(r'[,&]'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}

/// 그 주에 되풀이돼 뒤로 물릴 항목.
///
/// 대표 메뉴를 뽑지 않는다. 어떤 메뉴가 앞에 올지 서버가 보장하지 않으므로
/// 앞자리를 주메뉴로 올리면 엉뚱한 게 대표가 된다. 대신 **등장 일수만** 세서
/// 매일 똑같이 끼는 것을 아래로 내린다. 순서도 이름도 보지 않는다.
///
/// 고정 목록을 박아 두지 않는 이유는 그 목록이 곧 틀리기 때문이다. 밥은
/// 비빔밥이 나오는 날 이름이 바뀌고(그날은 `백미밥` 이 아니므로 내려가면 안
/// 된다) 김치도 주에 따라 깍두기·총각김치가 된다. 그 주를 세면 따라간다.
List<String> findMealStaples(List<DailyMealEntity> weekMeals) {
  final servedDays = weekMeals
      .map((meal) => splitMealMenu(meal.koreanMenu))
      .where((items) => items.isNotEmpty)
      .toList(growable: false);

  if (servedDays.length < _minServedDays) return const [];

  final dayCount = <String, int>{};
  for (final items in servedDays) {
    // 한 날에 같은 이름이 두 번 적혀도 하루로 센다
    for (final item in items.toSet()) {
      dayCount[item] = (dayCount[item] ?? 0) + 1;
    }
  }

  final threshold = servedDays.length * _stapleRatio;
  final staples = dayCount.entries
      .where((entry) => entry.value >= threshold)
      .map((entry) => entry.key)
      .toSet();

  if (staples.isEmpty) return const [];

  // 내리고 나면 위가 비다시피 하는 날이 있으면 아무것도 내리지 않는다.
  // 잘못 내리느니 예전처럼 전부 한 무게로 보여주는 편이 낫다
  final leavesTooLittle = servedDays.any(
    (items) =>
        items.where((item) => !staples.contains(item)).length <
        _minVisibleItems,
  );
  if (leavesTooLittle) return const [];

  return staples.toList(growable: false);
}
