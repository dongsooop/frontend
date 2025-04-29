import 'package:dongsoop/presentation/board/board_list_page_screen.dart';
import 'package:dongsoop/presentation/chat/chat_detail_screen.dart';
import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/main/main_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/core/routing/route_paths.dart';

final router = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.chatDetail,
      builder: (context, state) => ChatDetailScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(
          body: navigationShell,
          currentPageIndex: navigationShell.currentIndex,
          onChangeIndex: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomePageScreen(),
            ),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.board,
              builder: (context, state) => const BoardListPageScreen()
            ),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.chat,
              builder: (context, state) => ChatScreen(
                onTapChatDetail: () {
                  context.push(RoutePaths.chatDetail);
                }
              ),
            ),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.mypage,
              builder: (context, state) => const MyPageScreen(),
            ),
          ]
        )
      ]
    )
  ]
);