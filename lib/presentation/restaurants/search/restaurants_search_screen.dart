import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_tag.dart';
import 'package:dongsoop/presentation/restaurants/widgets/restaurants_list.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/restaurants_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantsSearchScreen extends HookConsumerWidget {

  const RestaurantsSearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userSessionProvider);
    final viewModel = ref.read(restaurantsSearchViewModelProvider.notifier);
    final state = ref.watch(restaurantsSearchViewModelProvider);

    final searchTextController = useTextEditingController();
    final tags = RestaurantsTag.values;
    final selectedTag = useState<RestaurantsTag?>(null);

    final hasRestaurants = state.restaurants?.isNotEmpty == true;

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
      appBar: _searchBar(
        context: context,
        onTap: () async {
          // TODO: 검색 API 연결
          print('search API');
        },
        textController: searchTextController,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              if (!hasRestaurants) ...[
                SizedBox(height: 16,),
                Text(
                  '어떤 가게를 찾고 있나요?',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                _searchTag(
                  tags: tags,
                  selectedTag: selectedTag.value,
                  onTagTap: (tag) async {
                    selectedTag.value = tag;
                    // TODO: 태그로 검색
                    print('selected tag: $tag');
                    await viewModel.search();
                  },
                ),
              ],

              // 카드 리스트
              if (hasRestaurants)
              Expanded(
                child:  RestaurantList(
                  data: state.restaurants ?? [],
                  onTap: () async {
                    // TODO: 좋아요
                    await viewModel.like();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchTag({
    required List<RestaurantsTag> tags,
    required RestaurantsTag? selectedTag,
    required Future<void> Function(RestaurantsTag tag) onTagTap,
  }) {
    final tags1 = tags.sublist(0, 4);
    final tags2 = tags.sublist(4, 8);

    return Column(
      spacing: 8,
      children: [
        _tagRow(tags: tags1, selectedTag: selectedTag, onTagTap: onTagTap),
        _tagRow(tags: tags2, selectedTag: selectedTag, onTagTap: onTagTap),
      ],
    );
  }

  Widget _tagRow({
    required List<RestaurantsTag> tags,
    required RestaurantsTag? selectedTag,
    required Future<void> Function(RestaurantsTag tag) onTagTap,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
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
                    color: ColorStyles.gray2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                tag.label,
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  PreferredSizeWidget _searchBar({
    required BuildContext context,
    required VoidCallback onTap,
    required TextEditingController textController,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => context.pop(),
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.navigate_before,
                    size: 24,
                    color: ColorStyles.black,
                  ),
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 44,
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  visualDensity: VisualDensity.compact,
                  onPressed: onTap,
                  highlightColor: Colors.transparent,
                  icon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      ColorStyles.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 4,
            color: ColorStyles.gray1,
          ),
        ],
      ),
    );
  }
}