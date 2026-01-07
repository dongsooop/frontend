import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userSessionProvider);
    final NoticeToggle = useState<bool>(true);
    // final deptNoticeToggle = useState<bool>(true);

    final timetableToggle = useState<bool>(true);
    final academicScheduleToggle = useState<bool>(true);
    final personalScheduleToggle = useState<bool>(true);

    final newChatToggle = useState<bool>(true);

    final appliedRecruitToggle = useState<bool>(true);
    final applicantToggle = useState<bool>(true);

    final marketingPushToggle = useState<bool>(true);

    void showSnack(
        String message, {
          String? actionLabel,
          VoidCallback? onAction,
        }) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: ColorStyles.black,
          action: (actionLabel != null && onAction != null)
              ? SnackBarAction(label: actionLabel, onPressed: onAction)
              : null,
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: DetailHeader(
        title: '알림 설정',
        backgroundColor: ColorStyles.gray1,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              _buildSection(
                title: '공지사항',
                subtitle: '교내 공지를 빠르게 확인할 수 있어요',
                children: [
                  _buildToggleRow(
                    label: '공지',
                    value: NoticeToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      NoticeToggle.value = v;
                      // viewModel.setNoticeNotification(v);
                      showSnack(v ? '공지 알림을 켰어요' : '공지 알림을 껐어요');
                    },
                  ),
                  // _buildToggleRow(
                  //   label: '학과 공지',
                  //   value: deptNoticeToggle.value,
                  //   loading: false,
                  //   onChanged: (v) async {
                  //     deptNoticeToggle.value = v;
                  //     // viewModel.setDeptNoticeNotification(v);
                  //     showSnack(v ? '학과 공지 알림을 켰어요' : '학과 공지 알림을 껐어요');
                  //   },
                  // ),
                ],
              ),
              const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),
              _buildSection(
                title: '오늘의 일정',
                subtitle: '매일 아침 8시에 오늘 일정을 확인할 수 있어요',
                children: [
                  _buildToggleRow(
                    label: '시간표',
                    value: timetableToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      timetableToggle.value = v;
                      // viewModel.setTimetableNotification(v);
                      showSnack(v ? '시간표 알림을 켰어요' : '시간표 알림을 껐어요');
                    },
                  ),
                  _buildToggleRow(
                    label: '학사 일정',
                    value: academicScheduleToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      academicScheduleToggle.value = v;
                      // viewModel.setAcademicScheduleNotification(v);
                      showSnack(v ? '학사 일정 알림을 켰어요' : '학사 일정 알림을 껐어요');
                    },
                  ),
                  if (user != null)
                  _buildToggleRow(
                    label: '개인 일정',
                    value: personalScheduleToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      personalScheduleToggle.value = v;
                      // viewModel.setPersonalScheduleNotification(v);
                      showSnack(v ? '개인 일정 알림을 켰어요' : '개인 일정 알림을 껐어요');
                    },
                  ),
                ],
              ),
              const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),
              if (user != null)
              _buildSection(
                title: '모집 알림',
                subtitle: '모집 지원·결과를 빠르게 알려드려요',
                children: [
                  _buildToggleRow(
                    label: '모집 지원자',
                    value: appliedRecruitToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      appliedRecruitToggle.value = v;
                      // viewModel.setNewChatNotification(v);
                      showSnack(v ? '모집 지원자 알림을 켰어요' : '모집 지원자 알림을 껐어요');
                    },
                  ),
                  _buildToggleRow(
                    label: '지원한 모집 결과',
                    value: applicantToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      applicantToggle.value = v;
                      // viewModel.setNewChatNotification(v);
                      showSnack(v ? '지원한 모집 결과 알림을 켰어요' : '지원한 모집 결과 알림을 껐어요');
                    },
                  ),
                ],
              ),
              const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),
              if (user != null)
              _buildSection(
                title: '채팅 알림',
                subtitle: '채팅을 빠르게 확인할 수 있어요',
                children: [
                  _buildToggleRow(
                    label: '새로운 채팅',
                    value: newChatToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      newChatToggle.value = v;
                      // viewModel.setNewChatNotification(v);
                      showSnack(v ? '채팅 알림을 켰어요' : '채팅 알림을 껐어요');
                    },
                  ),
                ],
              ),
              const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),
              // 추후 타입 추가되면 변경
              if (user != null)
              _buildSection(
                title: '기타',
                subtitle: '과팅 오픈 소식을 확인할 수 있어요',
                children: [
                  _buildToggleRow(
                    label: '광고성 푸시 알림 동의',
                    value: marketingPushToggle.value,
                    loading: false,
                    onChanged: (v) async {
                      marketingPushToggle.value = v;
                      // viewModel.setMarketingPushConsent(v);
                      showSnack(v ? '광고성 푸시 알림에 동의했어요' : '광고성 푸시 알림 동의를 해제했어요');
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

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: ColorStyles.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
          ),
          const SizedBox(height: 12),
          ...children,
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    required bool value,
    required bool loading,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: loading ? null : () => onChanged(!value),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            ),
            Row(
              children: [
                if (loading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                const SizedBox(width: 8),

                SwitchTheme(
                  data: SwitchThemeData(
                    trackOutlineColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.transparent,
                    ),
                  ),
                  child: Transform.scale(
                    scale: 0.85,
                    child: Switch(
                      value: value,
                      onChanged: loading ? null : onChanged,
                      inactiveTrackColor: ColorStyles.gray2,
                      inactiveThumbColor: ColorStyles.white,
                      activeTrackColor: ColorStyles.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}