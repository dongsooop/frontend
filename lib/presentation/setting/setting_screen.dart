import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/setting_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingScreen extends HookConsumerWidget {
  final VoidCallback onTapNotification;

  const SettingScreen({
    super.key,
    required this.onTapNotification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(settingViewModelProvider.notifier);
    final settingState = ref.watch(settingViewModelProvider);
    final user = ref.read(userSessionProvider);

    const termsOfService =
        'https://zircon-football-529.notion.site/Dongsoop-2333ee6f2561800cb85fdc87fbe9b4c2';
    const privacyPolicy =
        'https://zircon-football-529.notion.site/Dongsoop-2333ee6f256180a0821fdbf087345a1d';
    const faqPage =
        'https://zircon-football-529.notion.site/Q-A-2803ee6f2561804cb106c6cceedd57ac';
    const licenseInfo =
        'https://zircon-football-529.notion.site/2883ee6f256180a49d5edf214bc61003?pvs=74';

    useEffect(() {
      if (settingState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          viewModel.clearErrorMessage();

          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: settingState.errorTitle ?? '',
              content: settingState.errorMessage!,
              onConfirm: () {
              },
              confirmText: '확인',
            ),
          );
        });
      }
      return null;
    }, [settingState.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: DetailHeader(
        title: '설정',
        backgroundColor: ColorStyles.gray1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 16.0, right: 16),
          child: ListView(
            children: [
              buildSettingsSection(
              title: '이용 안내',
              children: [
                buildSettingsItem(
                  label: '버전  1.6.0',
                  onTap: () {},
                ),
                buildSettingsItem(
                  label: '서비스 이용약관',
                  onTap: () {
                    context.push('/mypageWebView?url=$termsOfService&title=서비스 이용약관');
                  },
                ),
                buildSettingsItem(
                  label: '개인정보 처리방침',
                  onTap: () {
                    context.push('/mypageWebView?url=$privacyPolicy&title=개인정보처리방침');
                  },
                ),
                buildSettingsItem(
                  label: '자주 묻는 질문',
                  onTap: () {
                    context.push('/mypageWebView?url=$faqPage&title=자주 묻는 질문');
                  },
                ),
                buildSettingsItem(
                  label: '오픈소스 라이선스',
                  onTap: () {
                    context.push('/mypageWebView?url=$licenseInfo&title=오픈소스 라이선스');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
              buildSettingsSection(
                title: '앱 설정',
                children: [
                  buildSettingsItem(
                    label: '알림 설정',
                    onTap: onTapNotification
                  ),
                  if (user != null)
                  buildSettingsItem(
                    label: '채팅 캐시 삭제',
                    onTap: () async {
                      // 채팅 캐시 삭제 다이얼로그
                      showDialog(
                        context: context,
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
                ],
              ),
              const SizedBox(height: 40),
              if (user != null)
              buildSettingsSection(
                title: '기타',
                children: [
                  buildSettingsItem(
                    label: '로그아웃',
                    onTap: () {
                      // 로그아웃 다이얼로그
                      showDialog(
                        context: context,
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
                        builder: (_) => CustomConfirmDialog(
                          title: '동숲 회원 탈퇴',
                          content: '탈퇴한 이메일로는 재가입 할 수 없어요.\n정말로 탈퇴하시겠어요?',
                          confirmText: '탈퇴',
                          onConfirm: () async {
                            // 회원탈퇴
                            await viewModel.deleteUser();
                            Navigator.of(context).pop();
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
      ),
    );
  }

  Widget buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyles.largeTextBold.copyWith(
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
          child: Text(label,
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.black,
              )),
        ),
      ),
    );
  }
}