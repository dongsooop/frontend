import 'package:dongsoop/providers/setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';

class SettingScreen extends HookConsumerWidget {

  const SettingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(settingViewModelProvider.notifier);
    final signUpState = ref.watch(settingViewModelProvider);

    const notionUrl = 'https://zircon-football-529.notion.site/DongSoop-1af3ee6f25618080bb7dc4f985eda9c7?pvs=74';

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            title: Text(
              '설정',
              style: TextStyles.largeTextBold.copyWith(
                color: ColorStyles.black,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.chevron_left_outlined,
                size: 24,
                color: ColorStyles.black,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 24, left: 16.0, right: 16),
          child: ListView(
            children: [
              buildSettingsSection(
                title: '이용 안내',
                children: [
                  buildSettingsItem(
                    label: '버전  0.0.0',
                    onTap: () {},
                  ),
                  buildSettingsItem(
                    label: '서비스 이용약관',
                    onTap: () {
                      context.push(
                        '/mypageWebView?url=$notionUrl&title=개인정보처리방침'
                      );
                    },
                  ),
                  buildSettingsItem(
                    label: '개인정보 처리방침',
                    onTap: () {
                      context.push(
                        '/mypageWebView?url=$notionUrl&title=개인정보처리방침'
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 40,),
              buildSettingsSection(
                title: '기타',
                children: [
                  buildSettingsItem(
                    label: '알림 설정',
                    onTap: () {
                      // 알림 설정
                    },
                  ),
                  buildSettingsItem(
                    label: '로그아웃',
                    onTap: () {
                      // 로그아웃 다이얼로그
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: '로그아웃',
                          content: '로그아웃 하시겠어요?',
                          onConfirm: () async {
                            // 로그아웃
                            await viewModel.logout();
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                        ),
                      );
                    },
                  ),
                  buildSettingsItem(
                    label: '탈퇴',
                    onTap: () {
                      // 탈퇴 다이얼로그
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: '동숲 회원 탈퇴',
                          content: '탈퇴한 이메일로는 재가입 할 수 없어요.\n정말로 탈퇴하시겠어요?',
                          confirmText: '탈퇴',
                          onConfirm: () async {
                            // 회원탈퇴
                            await viewModel.deleteUser();
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
  Widget buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical:24, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.largeTextBold.copyWith(
            color: ColorStyles.black,
          )),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget buildSettingsItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 44,
      child: GestureDetector(
        onTap: onTap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyles.normalTextRegular.copyWith(
            color: ColorStyles.black,
          )),
        ),
      ),
    );
  }
}