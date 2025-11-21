import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantsWriteScreen extends HookConsumerWidget {
  final VoidCallback onTapSearch;

  const RestaurantsWriteScreen({
    super.key,
    required this.onTapSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
      ),
      bottomNavigationBar: PrimaryBottomButton(
        onPressed: () async {
          // TODO: 등록 API 연결
        },
        label: '신고하기',
        isLoading: false,
        isEnabled: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              // 가게 검색(카카오 API 사용)
              _inputSection('가게', true, '학교 주변(1km) 가게만 등록 가능해요'),
              _restaurantsSearchButton(onTab: onTapSearch),

              // 카테고리 입력
              _inputSection('카테고리', true),
              _selectCategory(),
              SizedBox(height: 24,),

              // 태그 입력
              _inputSection('태그', false, '최대 3개까지 선택 가능해요'),
              _selectTag(),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }

  // 가게 검색 버튼
  Widget _restaurantsSearchButton({
    required VoidCallback onTab
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
              color: ColorStyles.gray2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '가게 검색',
                style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
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
  Widget _selectCategory() {
    final categories = [
      '한식',
      '중식',
      '일식',
      '양식',
      '분식',
      '패스트푸드',
      '카페/디저트',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // TODO: 카테고리 선택
            },
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 34,
              ),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: ColorStyles.gray2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                category,
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 태그 버튼
  Widget _selectTag() {
    final tags1 = [
      '양이 많아요',
      '음식이 맛있어요',
      '점심으로 괜찮아요',
      '혼밥하기 좋아요'
    ];
    final tags2 = [
      '가성비가 좋아요',
      '회식하기 좋아요',
      '대화하기 괜찮아요',
      '메뉴가 다양해요'
    ];

    return Column(
      spacing: 8,
      children: [
        _tagRow(tags1),
        _tagRow(tags2),
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

  Widget _tagRow(List<String> tags) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // TODO: 태그 선택
            },
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 34,
              ),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: ColorStyles.gray2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                tag,
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}