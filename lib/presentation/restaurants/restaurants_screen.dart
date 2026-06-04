import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/presentation/board/common/components/board_write_button.dart';
import 'package:dongsoop/presentation/restaurants/widgets/category_tab.dart';
import 'package:dongsoop/presentation/restaurants/widgets/restaurants_list.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/restaurants_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantScreen extends HookConsumerWidget {
  final Future<bool?> Function() onTapRestaurantsWrite;
  final VoidCallback onTapRestaurantsSearch;

  const RestaurantScreen({
    super.key,
    required this.onTapRestaurantsWrite,
    required this.onTapRestaurantsSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      null,
      ...RestaurantsCategory.values,
    ];
    final selectedIndex = useState<int>(0);
    final selectedCategory = categories[selectedIndex.value];
    final pageController = usePageController(initialPage: 0);

    final user = ref.watch(userSessionProvider);
    final isLogin = user != null ? true : false;
    final viewModel = ref.read(restaurantsViewModelProvider.notifier);
    final state = ref.watch(restaurantsViewModelProvider);

    useEffect(() {
      Future.microtask(() async {
        await viewModel.loadRestaurants(isLogin: isLogin);
      });
      return null;
    }, [user]);

    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '맛집 추천 오류',
              content: state.errorMessage!,
              onConfirm: () => context.pop(),
              onCancel: () => context.pop(),
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      floatingActionButton: WriteButton(
        onPressed: () async {
          if (user == null) {
            LoginRequiredDialog(context);
          } else {
            final result = await onTapRestaurantsWrite();
            if (result == true) {
              await viewModel.loadRestaurants(
                isLogin: isLogin,
                category: selectedCategory,
              );
            }
          }
        }
      ),
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
        trailing: IconButton(
          onPressed: onTapRestaurantsSearch,
          icon: SvgPicture.asset(
            'assets/icons/search.svg',
            width: 20,
            height: 20,
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
                    final category = categories[index];
                    final isSelected = index == selectedIndex.value;

                    final label = category == null
                        ? '전체'
                        : category.label;

                    return CategoryTab(
                      label: label,
                      isSelected: isSelected,
                      onTap: () async {
                        selectedIndex.value = index;
                        final category = categories[index];
                        // 카테고리별 조회
                        await viewModel.loadRestaurants(isLogin: isLogin, category: category);
                        pageController.jumpToPage(index);
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
                  onPageChanged: (index) async {
                    selectedIndex.value = index;
                    final category = categories[index];
                    await viewModel.loadRestaurants(isLogin: isLogin, category: category);
                  },
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final restaurants = state.restaurants ?? [];

                    if (state.isLoading && restaurants.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: ColorStyles.primaryColor),
                      );
                    }

                    return RestaurantList(
                      data: restaurants,
                      onTapLike: (id, likedByMe) async {
                        if (user == null) {
                          LoginRequiredDialog(context);
                        } else {
                          await viewModel.like(
                            id: id,
                            likedByMe: likedByMe,
                          );
                        }
                      },
                      onLoadMore: () async {
                        await viewModel.loadNextPage(isLogin: isLogin, category: category);
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