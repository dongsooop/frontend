import 'package:dongsoop/presentation/my_page/widgets/logged_in_user_card.dart';
import 'package:dongsoop/presentation/my_page/widgets/logged_out_prompt_card.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class MyPageScreen extends HookConsumerWidget {
  final VoidCallback onTapSignIn;
  final VoidCallback onTapSetting;
  final VoidCallback onTapCalendar;
  final VoidCallback onTapAdminReport;
  final VoidCallback onTapMarket;
  final void Function(bool isApply) onTapRecruit;

  const MyPageScreen({
    super.key,
    required this.onTapSignIn,
    required this.onTapSetting,
    required this.onTapCalendar,
    required this.onTapAdminReport,
    required this.onTapMarket,
    required this.onTapRecruit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPageState = ref.watch(myPageViewModelProvider);
    final user = ref.watch(userSessionProvider);
    final viewModel = ref.read(myPageViewModelProvider.notifier);

    useEffect(() {
      if (user != null) {
        Future.microtask(() {
          viewModel.loadUserInfo();
        });
      }
      return null;
    }, [user]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: DetailHeader(
          title: '마이페이지',
          backgroundColor: ColorStyles.gray1,
          trailing: user != null
            ? IconButton(
              onPressed: onTapSetting,
              icon: SvgPicture.asset(
                'assets/icons/setting.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  ColorStyles.black,
                  BlendMode.srcIn,
                ),
              ),
            )
            : null,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: myPageState.when(
                data: (user) {
                  if (user == null) {
                    return LoggedOutPromptCard(onTapLogin: onTapSignIn);
                  } else {
                    return LoggedInUserCard(
                      user: user,
                      onTapAdminReport: onTapAdminReport,
                      onTapMarket: onTapMarket,
                      onTapRecruit: onTapRecruit,
                      onTapCalendar: onTapCalendar,
                    );
                  }
                },
                error: (e, _) => Center(child: Text('$e', style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),)),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}