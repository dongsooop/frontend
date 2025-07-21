import 'package:dongsoop/providers/setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class SettingScreen extends HookConsumerWidget {

  const SettingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(settingViewModelProvider.notifier);
    final settingState = ref.watch(settingViewModelProvider);

    const termsOfService = 'https://zircon-football-529.notion.site/Dongsoop-2333ee6f2561800cb85fdc87fbe9b4c2';
    const privacyPolicy = 'https://zircon-football-529.notion.site/Dongsoop-2333ee6f256180a0821fdbf087345a1d';

    if (settingState.errorMessage != null) {
      // error dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomConfirmDialog(
          title: '',
          content: settingState.errorMessage!,
          onConfirm: () async {
            // 로그아웃
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.gray1,
        appBar: DetailHeader(
          title: '설정',
          backgroundColor: ColorStyles.gray1,
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
                        '/mypageWebView?url=$termsOfService&title=서비스 이용약관'
                      );
                    },
                  ),
                  buildSettingsItem(
                    label: '개인정보 처리방침',
                    onTap: () {
                      context.push(
                        '/mypageWebView?url=$privacyPolicy&title=개인정보처리방침'
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
                    label: '채팅 캐시 삭제',
                    onTap: () async {
                      // 채팅 캐시 삭제 다이얼로그
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: '채팅 캐시 삭제',
                          content: '채팅 내역을 삭제하시겠어요?',
                          onConfirm: () async {
                            await viewModel.localDataDelete();
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                        ),
                      );
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
      child: InkWell(
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