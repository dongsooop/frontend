import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/feedback/enum/feedback_type.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/presentation/board/board_page_screen.dart';
import 'package:dongsoop/presentation/board/market/detail/market_detail_page_screen.dart';
import 'package:dongsoop/presentation/board/market/write/market_write_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/apply/detail/recruit_applicant_detail_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/apply/list/recruit_applicant_list_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/apply/recruit_apply_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/detail/recruit_detail_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/write/recruit_write_page_screen.dart';
import 'package:dongsoop/presentation/search/search_screen.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_detail_screen.dart';
import 'package:dongsoop/presentation/chat/blind_date/blind_date_screen.dart';
import 'package:dongsoop/presentation/home/chatbot/chatbot_screen.dart';
import 'package:dongsoop/presentation/my_page/admin/blind/blind_admin_screen.dart';
import 'package:dongsoop/presentation/restaurants/restaurants_screen.dart';
import 'package:dongsoop/presentation/restaurants/search/restaurants_search_screen.dart';
import 'package:dongsoop/presentation/restaurants/write/restaurants_write_screen.dart';
import 'package:dongsoop/presentation/restaurants/write/search_kakao_screen.dart';
import 'package:dongsoop/presentation/my_page/feedback/feedback_result_screen.dart';
import 'package:dongsoop/presentation/my_page/feedback/user_feedback_screen.dart';
import 'package:dongsoop/presentation/schedule/schedule_detail_page_screen.dart';
import 'package:dongsoop/presentation/schedule/schedule_page_screen.dart';
import 'package:dongsoop/presentation/chat/chat_detail_screen.dart';
import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/home/notice_list_page_screen.dart';
import 'package:dongsoop/presentation/home/notification_list_page_screen.dart';
import 'package:dongsoop/presentation/main/main_screen.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_market_screen.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_recruit_screen.dart';
import 'package:dongsoop/presentation/my_page/activity/blocked_user_screen.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_screen.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:dongsoop/presentation/report/report_screen.dart';
import 'package:dongsoop/presentation/my_page/feedback/feedback_more_screen.dart';
import 'package:dongsoop/presentation/setting/notification/notification_screen.dart';
import 'package:dongsoop/presentation/setting/setting_screen.dart';
import 'package:dongsoop/presentation/sign_in/password_reset_screen.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_screen.dart';
import 'package:dongsoop/presentation/sign_up/sign_up_screen.dart';
import 'package:dongsoop/presentation/splash/splash_screen.dart';
import 'package:dongsoop/presentation/timetable/list/timetable_list_screen.dart';
import 'package:dongsoop/presentation/timetable/timetable_screen.dart';
import 'package:dongsoop/presentation/timetable/write/lecture_write_screen.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_screen.dart';
import 'package:dongsoop/presentation/web_view/library_banner_web_view_screen.dart';
import 'package:dongsoop/presentation/web_view/mypage_web_view.dart';
import 'package:dongsoop/presentation/web_view/notice_web_view_screen.dart';
import 'package:dongsoop/presentation/web_view/restaurant_web_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.timetable,
      name: 'timetable',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final int? year = extra?['year'] as int?;
        final Semester? semester = extra?['semester'] as Semester?;

        return TimetableScreen(
          year: year,
          semester: semester,
          onTapTimetableList: () => context.push(RoutePaths.timetableList),
          onTapTimetableWrite: () async {
            return await context.push<({int year, Semester semester})>(
              RoutePaths.timetableWrite,
            );
          },
          onTapLectureWrite: (int year, Semester semester, List<Lecture>? lectureList) async {
            final isSucceed = await context.push<bool>(
              RoutePaths.timetableLectureWrite,
              extra: {
                'year': year,
                'semester': semester,
                'lectureList': lectureList,
              },
            );
            return isSucceed ?? false;
          },
          onTapLectureUpdate: (int year, Semester semester, List<Lecture>? lectureList, Lecture? editingLecture) async {
            final isSucceed = await context.push<bool>(
              RoutePaths.timetableLectureWrite,
              extra: {
                'year': year,
                'semester': semester,
                'lectureList': lectureList,
                'editingLecture': editingLecture,
              },
            );
            return isSucceed ?? false;
          },
        );
      }
    ),
    GoRoute(
      path: RoutePaths.timetableList,
      builder: (context, state) => TimetableListScreen(
        onTapTimetable: (year, semester) {
          context.push(
            RoutePaths.timetable,
            extra: {
              'year': year,
              'semester': semester,
            },
          );
        },
        onTapTimetableWrite: () => context.push(RoutePaths.timetableWrite),
      ),
    ),
    GoRoute(
      path: RoutePaths.timetableLectureWrite,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final year = extra?['year'] as int;
          final semester = extra?['semester'] as Semester;
          final lectureList = extra?['lectureList'] as List<Lecture>?;
          final editingLecture = extra?['editingLecture'] as Lecture?;

          return LectureWriteScreen(
            year: year,
            semester: semester,
            lectureList: lectureList,
            editingLecture: editingLecture,
          );
        }
    ),
    GoRoute(
      path: RoutePaths.timetableWrite,
      builder: (context, state) => TimetableWriteScreen(),
    ),
    GoRoute(
      path: RoutePaths.schedule,
      builder: (context, state) => SchedulePageScreen(
        onTapCalendarDetail: (event, selectedDate) async {
          return await context.push<bool?>(
            RoutePaths.scheduleDetail,
            extra: {
              'event': event,
              'selectedDate': selectedDate,
            },
          );
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.scheduleDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final event = extra?['event'];
        final selectedDate = extra?['selectedDate'] as DateTime;

        return ScheduleDetailPageScreen(
          selectedDate: selectedDate,
          event: event,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.signIn,
      builder: (context, state) => SignInScreen(
        onTapSignUp: () => context.push(RoutePaths.signUp),
        onTapPasswordReset: () => context.push(RoutePaths.passwordReset),
      ),
    ),
    GoRoute(
      path: RoutePaths.signUp,
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: RoutePaths.passwordReset,
      builder: (context, state) => PasswordResetScreen(),
    ),
    GoRoute(
      path: RoutePaths.chatbot,
      builder: (context, state) => ChatbotScreen(),
    ),
    GoRoute(
      path: RoutePaths.chatDetail,
      builder: (context, state) {
        final roomId = (state.extra is String) ? state.extra as String : '';

        return ChatDetailScreen(
          roomId: roomId,
        );
      }
    ),
    GoRoute(
      path: RoutePaths.blindDateDetail,
      builder: (context, state) => BlindDateDetailScreen(
        onTapChatDetail: (roomId) {
          context.push (
            RoutePaths.chatDetail,
            extra: roomId,
          );
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.mypageWebView,
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final title = state.uri.queryParameters['title'] ?? '';
        return MypageWebView(url: url, title: title);
      },
    ),
    GoRoute(
      path: RoutePaths.restaurantWebView,
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        return RestaurantWebView(url: url);
      },
    ),
    GoRoute(
      path: RoutePaths.adminBlindDate,
      builder: (context, state) => BlindAdminScreen()
    ),
    GoRoute(
      path: RoutePaths.adminReport,
      builder: (context, state) => ReportAdminScreen(
        onTapReportSanction: (reportId, targetMemberId) {
          context.push(
            RoutePaths.adminReportSanction,
            extra: {
              'reportId': reportId,
              'targetMemberId': targetMemberId,
            },
          );
        },
        onTapRecruit: (targetId, type) {
          context.push(
            RoutePaths.recruitDetail,
            extra: {
              'id': targetId,
              'type': type,
            },
          );
        },
        onTapMarket: (targetId, type) {
          context.push(
            RoutePaths.marketDetail,
            extra: {
              'id': targetId,
              'type': type,
            },
          );
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.mypageMarket,
      builder: (context, state) => ActivityMarketScreen(
        onTapMarketDetail: (targetId, type, status) async {
          final isDeleted = await context.push<bool>(
            RoutePaths.marketDetail,
            extra: {
              'id': targetId,
              'type': type,
              'status': status,
            },
          );
          return isDeleted ?? false;
        },
      ),
    ),
    GoRoute(
        path: RoutePaths.mypageRecruit,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isApply = extra?['isApply'] as bool? ?? false;

          return ActivityRecruitScreen(
            isApply: isApply,
            onTapRecruitDetail: (targetId, type, status) async {
              final isDeleted = await context.push<bool>(
                RoutePaths.recruitDetail,
                extra: {
                  'id': targetId,
                  'type': type,
                  'status': status,
                },
              );
              return isDeleted ?? false;
            },
          );
        }),
    GoRoute(
        path: RoutePaths.adminReportSanction,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final reportId = extra?['reportId'] as int? ?? 0;
          final targetMemberId = extra?['targetMemberId'] as int? ?? 0;

          return ReportAdminSanctionScreen(
            reportId: reportId,
            targetMemberId: targetMemberId,
          );
        }),
    GoRoute(
      path: RoutePaths.setting,
      builder: (context, state) => SettingScreen(
        onTapNotification: () {
          context.push(RoutePaths.notification);
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.notification,
      builder: (context, state) => NotificationScreen(),
    ),
    GoRoute(
      path: RoutePaths.userFeedback,
      builder: (context, state) => UserFeedbackScreen(),
    ),
    GoRoute(
      path: RoutePaths.feedbackResult,
      builder: (context, state) => FeedbackResultScreen(
        onTapImprovementMore: () {
          context.push(
            RoutePaths.feedbackMore,
            extra: FeedbackType.improvement,
          );
        },
        onTapFeatureMore: () {
          context.push(
            RoutePaths.feedbackMore,
            extra: FeedbackType.featureRequest,
          );
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.feedbackMore,
      builder: (context, state) {
        final type = state.extra as FeedbackType? ?? FeedbackType.improvement;
        return FeedbackMoreScreen(type: type);
      },
    ),
    GoRoute(
      path: RoutePaths.mypageBlock,
      builder: (context, state) => BlockedUserScreen(),
    ),
    GoRoute(
      path: RoutePaths.recruitWrite,
      builder: (context, state) => const RecruitWritePageScreen(),
    ),
    GoRoute(
      path: RoutePaths.recruitDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final id = extra?['id'];
        final type = extra?['type'];
        final status = extra?['status'];

        return RecruitDetailPageScreen(
          id: id,
          type: type,
          status: status,
          onTapRecruitApply: () async {
            final result = await GoRouter.of(context).push<bool>(
              RoutePaths.recruitApply,
              extra: {
                'id': id,
                'type': type,
              },
            );
            return result == true;
          },
          onTapReport: (reportType, targetId) {
            context.push(RoutePaths.report, extra: {
              'reportType': reportType,
              'targetId': targetId,
            });
          },
          onTapApplicantList: () async {
            context.push(
              RoutePaths.recruitApplicantList,
              extra: {
                'id': id,
                'type': type,
              },
            );
          },
          onTapApplicantDetail: () {
            context.push(
              RoutePaths.recruitApplicantDetail,
              extra: {
                'viewer': RecruitApplicantViewer.APPLICANT,
                'type': type,
                'id': id,
              },
            );
          },
          onTapChatDetail: (roomId) {
            context.push(RoutePaths.chatDetail, extra: roomId);
          },
        );
      },
    ),
    GoRoute(
      path: RoutePaths.recruitApply,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final id = extra?['id'];
        final type = extra?['type'];
        return RecruitApplyPageScreen(id: id, type: type);
      },
    ),
    GoRoute(
      path: RoutePaths.recruitApplicantList,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final id = extra?['id'];
        final type = extra?['type'];

        return RecruitApplicantListPage(
          boardId: id,
          type: type,
          onTapApplicantDetail: (memberId) async {
            final result = await context.push<String>(
              RoutePaths.recruitApplicantDetail,
              extra: {
                'viewer': RecruitApplicantViewer.OWNER,
                'id': id,
                'type': type,
                'memberId': memberId,
              },
            );
            return result;
          },
        );
      },
    ),
    GoRoute(
      path: RoutePaths.recruitApplicantDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final viewer = extra?['viewer'];
        final boardId = extra?['id'];
        final type = extra?['type'];
        final memberId = extra?['memberId'];

        return RecruitApplicantDetailPage(
          viewer: viewer!,
          type: type!,
          boardId: boardId!,
          memberId: memberId,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.marketWrite,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final isEditing = extra?['isEditing'] as bool? ?? false;
        final marketId = extra?['marketId'] as int?;

        return MarketWritePageScreen(
          isEditing: isEditing,
          marketId: marketId,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.marketDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final id = extra?['id'];
        final type = extra?['type'];
        final status = extra?['status'];

        return MarketDetailPageScreen(
          id: id,
          type: type,
          status: status,
          onTapReport: (reportType, targetId) {
            context.push(
              RoutePaths.report,
              extra: {
                'reportType': reportType,
                'targetId': targetId,
              },
            );
          },
          onTapChatDetail: (roomId) {
            context.push(RoutePaths.chatDetail, extra: roomId);
          },
        );
      },
    ),
    GoRoute(
      path: RoutePaths.search,
      builder: (context, state) {
        final boardType = state.extra as SearchBoardType;
        return SearchScreen(boardType: boardType);
      },
    ),
    GoRoute(
      path: RoutePaths.report,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final reportType = extra?['reportType'] as String? ?? '';
        final targetId = extra?['targetId'] as int? ?? 0;

        return ReportScreen(
          reportType: reportType,
          targetId: targetId,
        );
      }
    ),
    GoRoute(
      path: RoutePaths.restaurantsWrite,
      builder: (context, state) => RestaurantsWriteScreen(
        onTapSearch: () async {
          final result = await context.push<RestaurantsKakaoInfo> (
            RoutePaths.restaurantsWriteSearch,
          );
          return result;
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.restaurantsSearch,
      builder: (context, state) => RestaurantsSearchScreen(),
    ),
    GoRoute(
      path: RoutePaths.restaurantsWriteSearch,
      builder: (context, state) => SearchKakaoScreen(),
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
              builder: (context, state) => HomePageScreen(
                onTapAlarm: () async {
                  // 이름 기반으로 알림 목록 진입
                  final ok = await context.pushNamed<bool>('notificationList');
                  return ok ?? true;
                },
                onTapChatbot: () {
                  context.push(RoutePaths.chatbot);
                },
              ),
              routes: [
                GoRoute(
                  path: RoutePaths.notificationList,
                  name: 'notificationList',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const NotificationPageScreen(),
                    );
                  },
                ),
                GoRoute(
                  path: RoutePaths.noticeList,
                  name: 'noticeList',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const NoticeListPageScreen(),
                    );
                  },
                ),
                GoRoute(
                  path: RoutePaths.noticeWebView,
                  name: 'noticeWebView',
                  pageBuilder: (context, state) {
                    final path = state.uri.queryParameters['path'];
                    return MaterialPage(
                      key: state.pageKey,
                      child: NoticeWebViewScreen(path: path ?? ''),
                    );
                  },
                ),
                GoRoute(
                  path: RoutePaths.restaurants,
                  name: 'restaurants',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: RestaurantScreen(
                        onTapRestaurantsWrite: () async {
                          final result = await context.push<bool>(
                            RoutePaths.restaurantsWrite,
                          );
                          return result;
                        },
                        onTapRestaurantsSearch: () {
                          context.push(RoutePaths.restaurantsSearch);
                        },
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: RoutePaths.libraryWebView,
                  name: 'libraryWebView',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const LibraryBannerWebViewScreen(),
                    );
                  },
                ),
              ]),
        ]),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.board,
              builder: (context, state) => BoardPageScreen(
                onTapRecruitDetail: (id, type) async {
                  final didApply = await context.push<bool>(
                    RoutePaths.recruitDetail,
                    extra: {'id': id, 'type': type},
                  );
                  return didApply ?? false;
                },
                onTapMarketDetail: (id, type) async {
                  final didComplete = await context.push<bool>(
                    RoutePaths.marketDetail,
                    extra: {'id': id, 'type': type},
                  );
                  return didComplete ?? false;
                },
                onTapWrite: (isRecruit) async {
                  if (isRecruit) {
                    return await context.push<bool>(RoutePaths.recruitWrite) ??
                        false;
                  } else {
                    return await context.push<bool>(
                          RoutePaths.marketWrite,
                          extra: {
                            'isEditing': false,
                            'marketId': null,
                          },
                        ) ??
                        false;
                  }
                },
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.chat,
              builder: (context, state) => ChatScreen(
                onTapChatDetail: (roomId) async {
                  final isLeaved = await context.push<bool>(
                    RoutePaths.chatDetail,
                    extra: roomId,
                  );
                  return isLeaved ?? false;
                },
                onTapSignIn: () { context.push(RoutePaths.signIn); },
                onTapBlindDate: () {
                  context.push('${RoutePaths.chat}/${RoutePaths.blindDate}');
                },
              ),
              routes: [
                GoRoute(
                  path: RoutePaths.blindDate,
                  name: 'blindDate',
                  builder: (context, state) => BlindDateScreen(
                    onTapChat: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RoutePaths.chat);
                      }
                    },
                    onTapBlindDateDetail: () {
                      context.push(RoutePaths.blindDateDetail);
                    },
                  ),
                ),
              ],
            ),
          ]
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutePaths.mypage,
            builder: (context, state) => MyPageScreen(
              onTapSignIn: () {
                context.push(RoutePaths.signIn);
              },
              onTapSetting: () {
                context.push(RoutePaths.setting);
              },
              onTapMarket: () {
                context.push(RoutePaths.mypageMarket);
              },
              onTapRecruit: (isApply) {
                context.push(RoutePaths.mypageRecruit, extra: {
                  'isApply': isApply,
                });
              },
              onTapUserFeedback: () {
                context.push(RoutePaths.userFeedback);
              },
              onTapAdminReport: () {
                context.push(RoutePaths.adminReport);
              },
              onTapAdminBlindDate: () {
                context.push(RoutePaths.adminBlindDate);
              },
              onTapAdminFeedback: () {
                context.push(RoutePaths.feedbackResult);
              },
              onTapCalendar: () {
                context.push(RoutePaths.schedule);
              },
              onTapTimetable: () {
                context.push(RoutePaths.timetable);
              },
              onTapBlockedUser: () {
                context.push(RoutePaths.mypageBlock);
              }
            ),
          ),
        ]),
      ],
    ),
  ],
);
