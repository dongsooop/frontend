import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';
import 'package:dongsoop/presentation/board/board_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/detail/recruit_detail_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/write/recruit_write_page_screen.dart';
import 'package:dongsoop/presentation/calendar/calendar_detail_page_screen.dart';
import 'package:dongsoop/presentation/calendar/calendar_page_screen.dart';
import 'package:dongsoop/presentation/chat/chat_detail_screen.dart';
import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/home/notice_list_page_screen.dart';
import 'package:dongsoop/presentation/main/main_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:dongsoop/presentation/schedule/schedule_screen.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_screen.dart';
import 'package:dongsoop/presentation/sign_up/sign_up_screen.dart';
import 'package:dongsoop/presentation/web_view/cafeteria_web_view_page_screen.dart';
import 'package:dongsoop/presentation/web_view/library_banner_web_view_screen.dart';
import 'package:dongsoop/presentation/web_view/notice_web_view_screen.dart';
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
    builder: (context, state) => CalendarPageScreen(
      onTapCalendarDetail: (event, selectedDate) async {
        return await context.push<bool?>(
          RoutePaths.calendarDetail,
          extra: {
            'event': event,
            'selectedDate': selectedDate,
          },
        );
      },
    ),
  ),
  GoRoute(
    path: RoutePaths.calendarDetail,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final event = extra?['event'];
      final selectedDate = extra?['selectedDate'] as DateTime;

      return CalendarDetailPageScreen(
        selectedDate: selectedDate,
        event: event,
      );
    },
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
    builder: (context, state) => ChatDetailScreen(
      chatRoom: state.extra as UiChatRoom,
    ),
  ),
  GoRoute(
    path: RoutePaths.recruitWrite,
    builder: (context, state) => const RecruitWritePageScreen(),
  ),
  GoRoute(
    path: RoutePaths.recruitDetail,
    builder: (context, state) => const RecruitDetailPageScreen(),
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
                GoRoute(
                  path: RoutePaths.cafeteriaWebView,
                  name: 'cafeteriaWebView',
                  builder: (context, state) =>
                      const CafeteriaWebViewPageScreen(),
                ),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutePaths.board,
            builder: (context, state) => BoardPageScreen(
              onTapRecruitDetail: (id, type) {
                context.push(
                  RoutePaths.recruitDetail,
                  extra: {
                    'id': id,
                    'type': type,
                  },
                );
              },
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutePaths.chat,
            builder: (context, state) => ChatScreen(
              onTapChatDetail: (room) {
                context.push(RoutePaths.chatDetail, extra: room);
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
