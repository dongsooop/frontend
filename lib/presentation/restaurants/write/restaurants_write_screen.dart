import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestaurantsWriteScreen extends HookConsumerWidget {

  const RestaurantsWriteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '학교 근처 맛집 추천',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('가게 등록'),
        ),
      ),
    );
  }
}