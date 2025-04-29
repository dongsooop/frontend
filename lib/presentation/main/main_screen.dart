import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';

class MainScreen extends StatelessWidget {
  final Widget body;
  final int currentPageIndex;
  final void Function(int index) onChangeIndex;

  const MainScreen({
    super.key,
    required this.body,
    required this.currentPageIndex,
    required this.onChangeIndex,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        onDestinationSelected: onChangeIndex,
        selectedIndex: currentPageIndex,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_filled, color: ColorStyles.gray4,),
            selectedIcon: Icon(Icons.home_filled, color: ColorStyles.primaryColor,),
            label: '홈',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined, color: ColorStyles.gray4,),
            selectedIcon: Icon(Icons.grid_view_outlined, color: ColorStyles.primaryColor,),
            label: '모여봐요',
          ),
          const NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: ColorStyles.gray4,),
            selectedIcon: Icon(Icons.chat_bubble_outline, color: ColorStyles.primaryColor,),
            label: '채팅',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person, color: ColorStyles.gray4,),
            selectedIcon: Icon(Icons.person, color: ColorStyles.primaryColor,),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
