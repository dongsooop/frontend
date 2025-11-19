import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantScreen extends HookConsumerWidget {
  const RestaurantScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final viewModel = ref.read(restaurantViewModelProvider.notifier);
    // final restaurantsState = ref.watch(restaurantViewModelProvider);

    // useEffect(() {
    //   if (restaurantsState.errorMessage != null) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (_) => CustomConfirmDialog(
    //           title: '맛집 추천 오류',
    //           content: restaurantsState.errorMessage!,
    //           onConfirm: () {},
    //         ),
    //       );
    //     });
    //   }
    //   return null;
    // }, [restaurantsState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Text(
            '맛집 추천'
          ),
        ),
      ),
    );
  }
}