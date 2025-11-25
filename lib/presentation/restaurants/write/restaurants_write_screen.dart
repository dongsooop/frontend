import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_tag.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/providers/restaurants_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantsWriteScreen extends HookConsumerWidget {
  final Future<RestaurantsKakaoInfo?> Function() onTapSearch;

  const RestaurantsWriteScreen({
    super.key,
    required this.onTapSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(restaurantsWriteViewModelProvider.notifier);
    final state = ref.watch(restaurantsWriteViewModelProvider);

    final selectedRestaurant = useState<RestaurantsKakaoInfo?>(null);
    final categories = RestaurantsCategory.values;
    final selectedCategory = useState<RestaurantsCategory?>(null);
    final tags = RestaurantsTag.values;
    final selectedTags = useState<List<RestaurantsTag>>([]);

    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '맛집 추천 오류',
              content: state.errorMessage!,
              onConfirm: () async {
                context.pop();
              },
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    useEffect(() {
      if (state.checkDuplication == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: '중복 등록',
              content: '해당 가게는 이미 등록되어 있어요\n다른 가게를 추천해 주세요',
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [state.checkDuplication]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '맛집 추천',
              content: '등록 후 정보를 수정할 수 없어요\n이대로 추천할까요?',
              onConfirm: () async {
                final result = await viewModel.submit(selectedRestaurant.value!, selectedCategory.value!, selectedTags.value);
                print('post result: $result');
                context.pop();
              },
            ),
          );
        },
        label: '추천하기',
        isLoading: state.isLoading,
        isEnabled: selectedRestaurant.value != null &&
            selectedCategory.value != null
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              // 가게 검색(카카오 API 사용)
              _inputSection('가게', true, '학교 주변(1km) 가게만 등록 가능해요'),
              _restaurantsSearchButton(
                label: selectedRestaurant.value?.place_name ?? '가게 검색',
                onTab: () async {
                  final result = await onTapSearch();
                  if (result != null) {
                    await viewModel.checkDuplication(result.id);
                    selectedRestaurant.value = result;
                  }
                },
              ),

              // 카테고리 입력
              _inputSection('카테고리', true),
              _selectCategory(
                categories: categories,
                selected: selectedCategory.value,
                onChanged: (value) => selectedCategory.value = value,
              ),
              SizedBox(height: 24,),

              // 태그 입력
              _inputSection('태그', false, '최대 3개까지 선택 가능해요'),
              _selectTag(
                tags: tags,
                selectedTags: selectedTags.value,
                onTagTap: (tag) {
                  final current = List<RestaurantsTag>.from(selectedTags.value);
                  if (current.contains(tag)) {
                    // 이미 선택되어 있으면 해제
                    current.remove(tag);
                  } else {
                    // 새로 선택
                    if (current.length >= 3) {
                      // 3개 꽉 차있으면 가장 먼저 선택한 태그 제거
                      current.removeAt(0);
                    }
                    current.add(tag);
                  }

                  selectedTags.value = current;
                },
              ),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }

  // 가게 검색 버튼
  Widget _restaurantsSearchButton({
    required String label,
    required VoidCallback onTab,
  }) {
    return GestureDetector(
      onTap: onTab,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 44,
        ),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: label == '가게 검색'
                ? ColorStyles.gray2
                : ColorStyles.primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: label == '가게 검색'
                      ? ColorStyles.gray4
                      : ColorStyles.black,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/search.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                ColorStyles.gray5,
                BlendMode.srcIn,
              ),
            ),
          ],
        )
      ),
    );
  }

  // 카테고리 버튼
  Widget _selectCategory({
    required List<RestaurantsCategory> categories,
    required RestaurantsCategory? selected,
    required void Function(RestaurantsCategory) onChanged,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = category == selected;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(category),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 34,
              ),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected
                      ? ColorStyles.primaryColor
                      : ColorStyles.gray2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                category.label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: isSelected
                    ? ColorStyles.primaryColor
                    : ColorStyles.gray4,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 태그 버튼
  Widget _selectTag({
    required List<RestaurantsTag> tags,
    required List<RestaurantsTag> selectedTags,
    required void Function(RestaurantsTag tag) onTagTap,
  }) {
    final tags1 = tags.sublist(0, 3);
    final tags2 = tags.sublist(4, 7);
    // final tags1 = [
    //   '양이 많아요',
    //   '음식이 맛있어요',
    //   '점심으로 괜찮아요',
    //   '혼밥하기 좋아요'
    // ];
    // final tags2 = [
    //   '가성비가 좋아요',
    //   '회식하기 좋아요',
    //   '대화하기 괜찮아요',
    //   '메뉴가 다양해요'
    // ];

    return Column(
      spacing: 8,
      children: [
        _tagRow(tags1, selectedTags, onTagTap),
        _tagRow(tags2, selectedTags, onTagTap),
      ],
    );
  }

  Widget _inputSection(String label, bool requiredField, [String? hint]) {
    final hasHint = hint != null && hint.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 8,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              if (requiredField)
                TextSpan(
                  text: ' *',
                  style: TextStyles.normalTextBold.copyWith(
                    color: ColorStyles.primaryColor,
                  ),
                ),
            ],
          ),
        ),
        if (hasHint)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                hint,
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4,),
              ),
            ),
          ),
      ],
    );
  }

  Widget _tagRow(
    List<RestaurantsTag> tags,
    List<RestaurantsTag> selectedTags,
    void Function(RestaurantsTag tag) onTagTap,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
          final isSelected = selectedTags.contains(tag);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTagTap(tag),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 34,
              ),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected
                      ? ColorStyles.primaryColor
                      : ColorStyles.gray2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                tag.label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: isSelected
                    ? ColorStyles.primaryColor
                    : ColorStyles.gray4,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}