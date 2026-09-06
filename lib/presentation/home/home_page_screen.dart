import 'package:dongsoop/core/presentation/components/admob_native_ad.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/presentation/home/widgets/chatbot_button.dart';
import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_greeting.dart';
import 'package:dongsoop/presentation/home/widgets/home_meal_section.dart';
import 'package:dongsoop/presentation/home/widgets/home_notice_list.dart';
import 'package:dongsoop/presentation/home/widgets/home_quick_links.dart';
import 'package:dongsoop/presentation/home/widgets/home_today_card.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/presentation/home/view_models/home_view_model.dart';
import 'package:dongsoop/domain/auth/enum/department_type_ext.dart';
import 'package:dongsoop/presentation/home/providers/home_update_provider.dart';

class HomePageScreen extends HookConsumerWidget {
  const HomePageScreen({super.key, required this.onTapAlarm, required this.onTapChatbot});
  final Future<bool> Function() onTapAlarm;
  final VoidCallback onTapChatbot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final badge = ref.read(notificationBadgeViewModelProvider.notifier);

    final departmentCode = user != null
        ? DepartmentTypeExtension.fromDisplayName(user.departmentType).code
        : '';

    final homeProvider = homeViewModelProvider(departmentCode: departmentCode);
    final homeAsyncValue = ref.watch(homeProvider);
    final homeViewModel = ref.read(homeProvider.notifier);

    ref.listen<bool>(homeNeedsRefreshProvider, (prev, next) async {
      if (next == true) {
        await homeViewModel.refresh();
        ref.read(homeNeedsRefreshProvider.notifier).state = false;
      }
    });

    useEffect(() {
      if (user != null) {
        badge.refreshBadge();
      }
      return null;
    }, [user]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 24,),
          child: ChatbotButton(
            onTap: () async {
              if (user == null) {
                await LoginRequiredDialog(context);
                return;
              }
              onTapChatbot();
            },
          ),
        ),
        appBar: MainHeader(
          // 도달 가능한 검색은 공지 검색뿐이다. 모집·장터 모드로 여는 곳은
          // 게시판 화면인데 그 화면은 닫혀 있다
          onTapSearch: () => context.push(
            RoutePaths.search,
            extra: SearchBoardType.notice,
          ),
          onTapAlarm: () async {
            final changed = await onTapAlarm();
            if (changed == true) {
              badge.refreshBadge();
            }
          },
        ),
        body: homeAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor)),
          error: (err, _) => Center(child: Text('$err')),
          data: (homeEntity) => SafeArea(
            top: false,
            bottom: true,
            child: RefreshIndicator(
              onRefresh: homeViewModel.refresh,
              color:  ColorStyles.primary100,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  HomeGreeting(
                    classCount: homeEntity.timeTable.length,
                    // 비회원에게는 개인 일정이 없다. 오늘 카드가 학사 일정만
                    // 보여주므로 인사말도 같은 것을 세야 숫자가 맞는다
                    scheduleCount: user == null
                        ? homeEntity.schedule
                            .where((s) => s.type == ScheduleType.official)
                            .length
                        : homeEntity.schedule.length,
                    isLoggedOut: user == null,
                  ),
                  HomeTodayCard(
                    timeTable: homeEntity.timeTable,
                    schedule: homeEntity.schedule,
                    isLoggedOut: user == null,
                  ),
                  const HomeMealSection(),
                  HomeNoticeList(notices: homeEntity.notices),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                    child: SizedBox(
                      height: 100,
                      child: AdmobNativeAd(
                        templateType: TemplateType.small,
                        height: 100,
                      ),
                    ),
                  ),
                  const HomeQuickLinks(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
