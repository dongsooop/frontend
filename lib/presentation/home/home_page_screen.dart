import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_new_notice.dart';
import 'package:dongsoop/presentation/home/widgets/home_today.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key, required this.onTapAlarm});
  final VoidCallback onTapAlarm;

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: MainHeader(onTapAlarm: widget.onTapAlarm),
        body: SafeArea(
          top: false,
          bottom: true,
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              HomeToday(),
              HomeNewNotice(),
              // HomePopularRecruits(),
            ],
          ),
        ),
      ),
    );
  }
}
