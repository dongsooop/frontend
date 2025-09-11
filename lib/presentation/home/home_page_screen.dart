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
  const HomePageScreen({super.key, required this.onTapAlarm});
  final Future<bool> Function() onTapAlarm;

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
      if (ref.read(homeNeedsRefreshProvider) == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await homeViewModel.refresh();
          if (context.mounted) {
            ref.read(homeNeedsRefreshProvider.notifier).state = false;
          }
        });
      }
      return null;
    }, [departmentCode]);

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
        appBar: MainHeader(
          onTapAlarm: () {
            onTapAlarm().then((changed) {
              if (changed == true) {
                badge.refreshBadge();
              }
            });
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
                    calendar: homeEntity.calendar,
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
