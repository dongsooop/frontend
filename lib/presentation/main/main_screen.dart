import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';

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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.primaryColor,
                );
              }
              return TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.gray4,
              );
            }),
          ),
        ),
        child: NavigationBar(
          height: 48,
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
      ),
    );
  }
}