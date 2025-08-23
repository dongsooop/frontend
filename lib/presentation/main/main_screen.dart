import 'package:flutter/material.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/presentation/main/view_model/main_view_model.dart';

class MainScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(mainViewModelProvider);

    ref.listen<AsyncValue<void>>(mainViewModelProvider, (prev, next) {
      next.whenOrNull(error: (e, st) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.removeCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    });

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
