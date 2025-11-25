import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/presentation/board/common/components/board_write_button.dart';
import 'package:dongsoop/presentation/restaurants/widgets/category_tab.dart';
import 'package:dongsoop/presentation/restaurants/widgets/restaurants_list.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/restaurants_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantScreen extends HookConsumerWidget {
  final VoidCallback onTapRestaurantsWrite;

  const RestaurantScreen({
    super.key,
    required this.onTapRestaurantsWrite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = [
      {
        'title': '고척돈까스',
        'distance': 448,
        'likeCount': 20,
        'category': '한식',
        'tag': ['음식이 맛있어요', '점심으로 괜찮아요']
      },
      {
        'title': '고척칼국수',
        'distance': 458,
        'likeCount': 8,
        'category': '한식',
        'tag': ['음식이 맛있어요', '점심으로 괜찮아요', '양이 많아요', '회식하기 좋아요']
      },
      {
        'title': '야꾸미',
        'distance': 45,
        'likeCount': 2,
        'category': '일식',
        'tag': ['음식이 맛있어요', '회식하기 좋아요']
      },
      {
        'title': '이삭 토스트',
        'distance': 120,
        'likeCount': 5,
        'category': '패스트푸드',
        'tag': ['점심으로 괜찮아요']
      },
      {
        'title': '메가커피 동양미래대점',
        'distance': 50,
        'likeCount': 15,
        'category': '카페/디저트',
        'tag': []
      },
      {
        'title': '마라공방',
        'distance': 230,
        'likeCount': 24,
        'category': '중식',
        'tag': ['점심으로 괜찮아요']
      },
      {
        'title': '동대문 엽기 떡볶이',
        'distance': 230,
        'likeCount': 24,
        'category': '분식',
        'tag': ['점심으로 괜찮아요']
      },
    ];

    final categories = [
      '전체',
      '한식',
      '중식',
      '일식',
      '양식',
      '분식',
      '패스트푸드',
      '카페/디저트',
    ];
    final selectedIndex = useState<int>(0);
    final pageController = usePageController(initialPage: 0);

    final user = ref.watch(userSessionProvider);
    final viewModel = ref.read(restaurantsViewModelProvider.notifier);
    final state = ref.watch(restaurantsViewModelProvider);

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadRestaurants();
      });
      return null;
    }, []);

    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '맛집 추천 오류',
              content: state.errorMessage!,
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      floatingActionButton: WriteButton(
        onPressed: () {
          user == null
          ? LoginRequiredDialog(context)
          : onTapRestaurantsWrite();
        }
      ),
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
        trailing: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/icons/search.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ColorStyles.black,
              BlendMode.srcIn,
            ),
          ),
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              // 카테고리(전체/한식/중식...)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 16,
                  children: List.generate(categories.length, (index) {
                    final c = categories[index];
                    final isSelected = index == selectedIndex.value;

                    return CategoryTab(
                      label: c,
                      isSelected: isSelected,
                      onTap: () {
                        selectedIndex.value = index;
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      },
                    );
                  }),
                ),
              ),

              // 카드 리스트
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: categories.length,
                  onPageChanged: (index) {
                    selectedIndex.value = index;
                  },
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final filtered = category == '전체'
                      ? data
                      : data.where((e) => e['category'] == category).toList();

                    return RestaurantList(
                      data: filtered,
                      onTap: () async {
                        await viewModel.like();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}