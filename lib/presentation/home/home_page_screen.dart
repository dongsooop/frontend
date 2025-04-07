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
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // 홈
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MainHeader(),
          const HomeToday(),
          const HomeNewNotice(),
          const HomePopularRecruits()
        ],
      ),
    ),
    // 모여봐요
    const Center(child: Text('모여봐요 페이지')),
    // 채팅
    const Center(child: Text('채팅 페이지')),
    // 마이페이지
    const Center(child: Text('마이페이지')),
  ];

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
                child: _pages[_currentIndex],
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
