import 'package:dongsoop/presentation/home/widgets/home_header.dart';
import 'package:dongsoop/presentation/home/widgets/home_new_notice.dart';
import 'package:dongsoop/presentation/home/widgets/home_today.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class HomePageScreen extends HookConsumerWidget {
  const HomePageScreen({super.key, required this.onTapAlarm});
  final Future<bool> Function() onTapAlarm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final badge = ref.read(notificationBadgeViewModelProvider.notifier);

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
        body: SafeArea(
          top: false,
          bottom: true,
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              HomeToday(),
              HomeNewNotice(),
              // HomePopularRecruits(),
            ],
          ),
        ),
      ),
    );
  }
}
