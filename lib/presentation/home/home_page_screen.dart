import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_new_notice.dart';
import 'package:dongsoop/presentation/home/widgets/home_today.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Colors.white,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: ColorStyles.white,
              body: SafeArea(
                top: false,
                bottom: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MainHeader(),
                      const HomeToday(),
                      const HomeNewNotice(),

                      /// 추후 개발 기능
                      // const HomePopularRecruits(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.bottom,
            color: ColorStyles.white,
          ),
        ],
      ),
    );
  }
}
