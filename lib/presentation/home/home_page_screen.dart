import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/presentation/home/widgets/chatbot_button.dart';
import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_new_notice.dart';
import 'package:dongsoop/presentation/home/widgets/home_popular_recruits.dart';
import 'package:dongsoop/presentation/home/widgets/home_today.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
              } else {
                onTapChatbot(); // 기존 이동/동작
              }
            },
          ),
        ),
        appBar: MainHeader(
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
                  HomeToday(
                    timeTable: homeEntity.timeTable,
                    schedule: homeEntity.schedule,
                    isLoggedOut: user == null,
                  ),
                  HomeNewNotice(notices: homeEntity.notices),
                  HomePopularRecruits(recruits: homeEntity.popularRecruits),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
