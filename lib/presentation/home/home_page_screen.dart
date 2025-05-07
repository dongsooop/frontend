import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_new_notice.dart';
import 'package:dongsoop/presentation/home/widgets/home_popular_recruits.dart';
import 'package:dongsoop/presentation/home/widgets/home_today.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // 상태바 아이콘 검정
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
                    children: const [
                      MainHeader(),
                      HomeToday(),
                      HomeNewNotice(),
                      HomePopularRecruits(),
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
