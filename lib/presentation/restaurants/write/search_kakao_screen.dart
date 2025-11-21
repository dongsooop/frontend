import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchKakaoScreen extends HookConsumerWidget {
  const SearchKakaoScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = [
      {
        'title': '고척돈까스',
        'address': '서울 구로구 경인로 47길 72',
      },
      {
        'title': '고척칼국수',
        'address': '서울 구로구 경인로47가길 5 1층',
      },
    ];

    final restaurantsController = useTextEditingController();

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            children: [
              // 가게 검색(카카오 API 사용)
              _searchField(
                onTab: () {  },
                textController: restaurantsController,
              ),

              // 가게 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final card = data[index];

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        // TODO: 가게 선택 시 restaurantWriteScreen으로 정보 전달
                      },
                      child: _searchInfoCard(
                        title: card['title'] as String,
                        address: card['address'] as String,
                      ),
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField({
    required VoidCallback onTab,
    required TextEditingController textController,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 44,
      ),
      alignment: Alignment.center,
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
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        controller: textController,
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyles.normalTextRegular.copyWith(
          color: ColorStyles.black,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: '가게를 검색해 주세요',
          hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _searchInfoCard({
    required String title,
    required String address,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              SvgPicture.asset(
                'assets/icons/place.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  ColorStyles.gray6,
                  BlendMode.srcIn,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.black),
                  ),
                  Text(
                    address,
                    style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: ColorStyles.gray2, height: 1),
        ],
      )
    );
  }
}