import 'package:dongsoop/presentation/my_page/widgets/logged_in_user_card.dart';
import 'package:dongsoop/presentation/my_page/widgets/logged_out_prompt_card.dart';
import 'package:flutter/material.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class MyPageScreen extends HookConsumerWidget {
  final VoidCallback onTapSignIn;

  const MyPageScreen({
    super.key,
    required this.onTapSignIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPageState = ref.watch(myPageViewModelProvider);
    final userSession = ref.watch(userSessionProvider);
    final viewModel = ref.read(myPageViewModelProvider.notifier);

    useEffect(() {
      if (userSession != null) {
        Future.microtask(() {
          viewModel.loadUserInfo();
        });
      }
      return null;
    }, [userSession]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            title: Text(
              '마이페이지',
              style: TextStyles.largeTextBold.copyWith(
                color: ColorStyles.black
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // user setting 페이지 이동
                },
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
            ],
            automaticallyImplyLeading: false, // 뒤로가기 버튼 X
          ),
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
                    return LoggedInUserCard(user: user);
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