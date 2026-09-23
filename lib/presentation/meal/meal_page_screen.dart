import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/meal_menu_view.dart';
import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';
import 'package:dongsoop/presentation/home/state/cafeteria_state.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/presentation/meal/providers/meal_price_provider.dart';
import 'package:dongsoop/presentation/meal/widgets/meal_day_selector.dart';
import 'package:dongsoop/presentation/meal/widgets/meal_menu_section.dart';
import 'package:dongsoop/presentation/meal/widgets/meal_notice_card.dart';
import 'package:dongsoop/presentation/meal/widgets/meal_price_section.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// 학식 한 화면.
///
/// 홈·캠퍼스 카드는 오늘 한식만 좁게 보여준다. 여기서는 그 주 닷새를 골라
/// 가며 한식과 단품을 다 펼치고, 식당 공지와 가격표까지 붙인다.
class MealPageScreen extends ConsumerStatefulWidget {
  const MealPageScreen({super.key});

  @override
  ConsumerState<MealPageScreen> createState() => _MealPageScreenState();
}

class _MealPageScreenState extends ConsumerState<MealPageScreen> {
  /// 고른 날. 처음에는 오늘이고, 오늘이 급식일이 아니면 월요일이다.
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cafeteriaViewModelProvider);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '학식'),
      body: SafeArea(
        child: state.when(
          data: _buildBody,
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColorStyles.primary100),
          ),
          error: (_, __) => _MealMessage(
            '학식을 불러오지 못했어요',
            onRetry: () => ref.invalidate(cafeteriaViewModelProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CafeteriaState state) {
    if (!state.hasWeekMeals) {
      return const _MealMessage('이번 주 학식 정보가 없어요');
    }

    final index = _resolveIndex(state.weekMeals);
    final meal = state.weekMeals[index];
    // 가격표를 못 받아도 메뉴 카드는 값 없이 그대로 그린다
    final prices = ref.watch(mealPriceProvider).valueOrNull;
    final priceByName = {
      for (final category
          in prices?.categories ?? const <MealPriceCategoryEntity>[])
        for (final item in category.items) item.name: item,
    };

    return RefreshIndicator(
      color: ColorStyles.primary100,
      onRefresh: () async {
        ref.invalidate(cafeteriaViewModelProvider);
        ref.invalidate(mealPriceProvider);
        await ref.read(cafeteriaViewModelProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          if (state.notice != null && state.notice!.trim().isNotEmpty) ...[
            MealNoticeCard(state.notice!.trim()),
            const SizedBox(height: 16),
          ],
          MealDaySelector(
            weekMeals: state.weekMeals,
            selectedIndex: index,
            onSelected: (next) => setState(() => _selectedIndex = next),
          ),
          const SizedBox(height: 20),
          Text(
            _dateLabel(meal),
            style: TextStyles.smallTextBold.copyWith(color: ColorStyles.gray5),
          ),
          const SizedBox(height: 16),
          MealMenuSection(
            title: '한식',
            menu: meal.koreanMenu,
            // 서버는 급식을 안 하는 날과 메뉴를 못 받아 온 날을 갈라 주지
            // 않는다. 앱이 `학식을 하지 않아요` 라고 단정하지 않는다
            emptyMessage: '식단 정보가 없어요',
            headerPrice: prices?.ticketPrice,
          ),
          const SizedBox(height: 12),
          MealMenuSection(
            title: '단품',
            menu: meal.specialMenu,
            emptyMessage: '이 날은 단품 메뉴가 없어요',
            priceOf: (name) => priceByName[name],
          ),
          const SizedBox(height: 28),
          _PriceArea(selectedDay: _dayOfWeek(meal)),
        ],
      ),
    );
  }

  /// 고른 날이 없으면 오늘, 오늘이 이번 주 급식일이 아니면 첫 날.
  int _resolveIndex(List<DailyMealEntity> weekMeals) {
    final selected = _selectedIndex;
    if (selected != null && selected < weekMeals.length) return selected;

    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    for (var i = 0; i < weekMeals.length; i++) {
      if (weekMeals[i].date == todayKey) return i;
    }
    return 0;
  }

  String _dateLabel(DailyMealEntity meal) {
    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return meal.date;

    return '${DateFormat('M월 d일', 'ko').format(parsed)}(${_dayOfWeek(meal)})';
  }

  /// 메뉴가 없는 날은 서버가 요일을 비워 보내므로 날짜에서 직접 구한다.
  String _dayOfWeek(DailyMealEntity meal) {
    if (meal.dayOfWeek.isNotEmpty) return meal.dayOfWeek;

    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return '';

    return weekdays[parsed.weekday - 1];
  }
}

/// 가격표 자리.
///
/// 메뉴와 따로 받는다. 가격표를 내려주지 않는 서버에 붙어 있어도 메뉴는
/// 그대로 보여야 해서, 실패하면 이 자리만 조용히 빠진다.
class _PriceArea extends ConsumerWidget {
  final String selectedDay;

  const _PriceArea({required this.selectedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(mealPriceProvider);

    return prices.when(
      data: (data) => MealPriceSection(prices: data, selectedDay: selectedDay),
      loading: () => const MealFrame(muted: true, child: MealSkeletonView()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _MealMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _MealMessage(this.message, {this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyles.normalTextBold.copyWith(color: ColorStyles.gray5),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: Text(
                '다시 시도',
                style: TextStyles.smallTextBold.copyWith(
                  color: ColorStyles.primary100,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
