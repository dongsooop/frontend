import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/presentation/home/widgets/swipe_deck.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// 홈의 학식 구획.
///
/// 오늘 카드에서 떼어내 따로 세웠다. 수업·일정은 내 것이고 학식은 학교 것이라
/// 한 장에 묶으면 카드가 무슨 카드인지 흐려진다.
///
/// 생김새도 오늘 카드와 갈라 둔다. 오늘 카드는 회색 면에 `40x40 이모지 + 한 줄`
/// 이지만 여기는 따뜻한 면에 이모지 타일 없이 메뉴만 칩으로 편다. 구획 제목이
/// 이미 `학식` 이라 타일이 한 번 더 그걸 말할 이유가 없다.
///
/// 제목의 날짜는 넘긴 쪽을 따라 바뀌므로 구획 안에서 상태를 들고 있는다.
class HomeMealSection extends HookConsumerWidget {
  const HomeMealSection({super.key});

  /// 메뉴 칩이 세 줄까지 들어가는 높이. 칩 한 줄 24.4 + 줄 간격 7.
  static const double _deckHeight = 92;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cafeteriaState = ref.watch(cafeteriaViewModelProvider);
    final meals = cafeteriaState.maybeWhen(
      data: (data) => data.weekMeals,
      orElse: () => const <DailyMealEntity>[],
    );

    final todayIndex = _findTodayIndex(meals);
    final index = useState(todayIndex);

    useEffect(() {
      index.value = todayIndex;
      return null;
    }, [meals]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(_dateLabel(meals, index.value)),
          const SizedBox(height: 12),
          cafeteriaState.when(
            data: (_) => meals.isEmpty
                ? _notice('이번 주 학식 정보가 없어요')
                : _tray(
                    SwipeDeck(
                      itemCount: meals.length,
                      initialPage: index.value,
                      height: _deckHeight,
                      onPageChanged: (page) => index.value = page,
                      itemBuilder: (context, page) =>
                          _MealMenu(menu: meals[page].koreanMenu),
                    ),
                  ),
            loading: () => _notice('학식을 불러오는 중...'),
            error: (_, __) => _notice('학식을 불러오지 못했어요'),
          ),
        ],
      ),
    );
  }

  /// 다른 구획 제목과 같은 크기로 두고, 날짜만 중점 뒤에 흐리게 붙인다.
  Widget _title(String? label) {
    final style = TextStyles.largeTextBold.copyWith(color: ColorStyles.black);

    if (label == null) return Text('학식', style: style);

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          const TextSpan(text: '학식'),
          const TextSpan(text: ' · ', style: TextStyle(color: ColorStyles.gray4)),
          TextSpan(text: label, style: const TextStyle(color: ColorStyles.gray6)),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 학식 판. 요일을 넘겨도 면 색이 깜빡이지 않도록 휴무일까지 같은 색으로 둔다.
  Widget _tray(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.amberBg,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: child,
    );
  }

  /// 불러오는 중·실패·이번 주 자료 없음. 펼칠 메뉴가 없으니 따뜻한 면 대신
  /// 중립 회색으로 두고 높이도 낮춘다.
  Widget _notice(String message) {
    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.gray1,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        style: TextStyles.normalTextBold.copyWith(color: ColorStyles.gray4),
      ),
    );
  }

  int _findTodayIndex(List<DailyMealEntity> meals) {
    if (meals.isEmpty) return 0;

    final now = DateTime.now();
    final index = meals.indexWhere((meal) {
      final date = DateTime.tryParse(meal.date);
      if (date == null) return false;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    });

    return index >= 0 ? index : 0;
  }

  /// 메뉴가 없는 날은 서버 요일이 비어 있으므로 날짜에서 직접 구한다.
  String? _dateLabel(List<DailyMealEntity> meals, int index) {
    if (meals.isEmpty) return null;
    final meal = meals[index.clamp(0, meals.length - 1)];

    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return meal.date;

    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday =
        meal.dayOfWeek.isNotEmpty ? meal.dayOfWeek : weekdays[parsed.weekday - 1];
    return '${DateFormat('M월 d일', 'ko').format(parsed)}($weekday)';
  }
}

/// 하루치 메뉴.
///
/// 한 줄에 밀어 넣으면 `제육볶음 · 미역국 · 계란찜` 처럼 읽어야 할 덩어리가
/// 되므로 반찬 하나를 칩 하나로 끊어 편다. 어느 메뉴가 앞에 올지 서버가
/// 보장하지 않으니 전부 같은 무게로 둔다.
class _MealMenu extends StatelessWidget {
  final String menu;

  const _MealMenu({required this.menu});

  @override
  Widget build(BuildContext context) {
    final items = _split(menu);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: items.length < 2
          // 휴무일 안내처럼 끊을 곳이 없는 문장은 칩으로 만들지 않는다
          ? Text(
              items.isEmpty ? '등록된 메뉴가 없어요' : items.first,
              style:
                  TextStyles.normalTextBold.copyWith(color: ColorStyles.gray6),
            )
          // 반찬이 아주 많은 날은 칩이 세 줄을 넘길 수 있다. PageView 는 장마다
          // 높이를 달리 못 주므로 넘치는 줄은 잘라 낸다. 오버플로 경고 대신
          // 조용히 잘리는 편이 낫고, 전체 메뉴는 학식 화면에서 볼 수 있다
          : ClipRect(
              child: Wrap(
                spacing: 6,
                runSpacing: 7,
                children: [for (final item in items) _chip(item)],
              ),
            ),
    );
  }

  Widget _chip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: TextStyles.smallTextBold.copyWith(
          color: ColorStyles.black,
          height: 1.2,
        ),
      ),
    );
  }

  /// 서버가 구분자를 섞어 내려주므로 쓰이는 기호를 모두 끊어 본다.
  static List<String> _split(String raw) {
    return raw
        .split(RegExp(r'[·•,/\n]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
}
