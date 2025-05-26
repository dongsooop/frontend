import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/presentation/board/board_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/write/recruit_write_page_screen.dart';
import 'package:dongsoop/presentation/calendar/calendar_page_screen.dart';
import 'package:dongsoop/presentation/chat/chat_detail_screen.dart';
import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/home/notice_list_page_screen.dart';
import 'package:dongsoop/presentation/main/main_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:dongsoop/presentation/schedule/schedule_screen.dart';
import 'package:dongsoop/presentation/webview/library_banner_webview_screen.dart';
import 'package:dongsoop/presentation/webview/notice_webview_screen.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_screen.dart';
import 'package:dongsoop/presentation/sign_up/sign_up_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(initialLocation: RoutePaths.home, routes: [
  // navbar x 페이지는 따로 분류
  GoRoute(
    path: RoutePaths.schedule,
    name: 'schedule',
    builder: (context, state) => const ScheduleScreen(),
  ),
  GoRoute(
    path: RoutePaths.calendar,
    name: 'calendar',
    builder: (context, state) => const CalendarPageScreen(),
  ),
  GoRoute(
    path: RoutePaths.signIn,
    builder: (context, state) => SignInScreen(
      onTapSignUp: () => context.push(RoutePaths.signUp),
    ),
  ),
  GoRoute(
    path: RoutePaths.signUp,
    builder: (context, state) => SignUpScreen(),
  ),
  GoRoute(
    path: RoutePaths.chatDetail,
    builder: (context, state) => ChatDetailScreen(),
  ),
  GoRoute(
    path: RoutePaths.recruitWrite,
    builder: (context, state) => const RecruitWritePageScreen(),
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
        StatefulShellBranch(routes: [
          GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomePageScreen(),
              routes: [
                GoRoute(
                  path: RoutePaths.noticeList,
                  name: 'noticeList',
                  builder: (context, state) => const NoticeListPageScreen(),
                ),
                GoRoute(
                  path: RoutePaths.noticeWebView,
                  name: 'noticeWebView',
                  builder: (context, state) {
                    final path = state.uri.queryParameters['path'];
                    return NoticeWebViewScreen(path: path ?? '');
                  },
                ),
                GoRoute(
                  path: RoutePaths.libraryWebView,
                  name: 'libraryWebView',
                  builder: (context, state) =>
                  const LibraryBannerWebViewScreen(),
                ),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutePaths.board,
            builder: (context, state) => const BoardPageScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutePaths.chat,
            builder: (context, state) => ChatScreen(
              onTapChatDetail: () {
                context.push(RoutePaths.chatDetail);
              },
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutePaths.mypage,
            builder: (context, state) => MyPageScreen(
              onTapSignIn: () {
                context.push(RoutePaths.signIn);
              },
            ),
          ),
        ]),
      ])
]);