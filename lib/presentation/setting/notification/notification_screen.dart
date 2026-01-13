import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/setting/notification/view_model/notification_setting_view_model.dart';
import 'package:dongsoop/presentation/setting/notification/view_model/notification_types.dart';
import 'package:dongsoop/presentation/setting/notification/widget/notification_section.dart';
import 'package:dongsoop/presentation/setting/notification/widget/notification_toggle_row.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';

import 'package:dongsoop/domain/notification/enum/notification_target.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends ConsumerState<NotificationScreen> {
  void _showSnack(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.normalTextRegular),
        backgroundColor: ColorStyles.gray3,
      ),
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.month}월 ${now.day}일';
  }

  String _consentMessage({
    required String label,
    required bool enabled,
  }) {
    return '${_todayLabel()} $label 알림 '
        '${enabled ? '동의했어요' : '동의를 거부했어요'}';
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(userSessionProvider);
      final target =
      user != null ? NotificationTarget.user : NotificationTarget.guest;

      final deviceToken =
      await ref.read(getFcmTokenUseCaseProvider).execute();
      if (deviceToken == null || deviceToken.isEmpty) return;

      try {
        await ref
            .read(notificationSettingViewModelProvider.notifier)
            .fetchSettings(
          target: target,
          deviceToken: deviceToken,
        );
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userSessionProvider);
    final target =
    user != null ? NotificationTarget.user : NotificationTarget.guest;

    final isAdmin = user != null && user.role.contains('ADMIN');

    final state = ref.watch(notificationSettingViewModelProvider);
    final vm = ref.read(notificationSettingViewModelProvider.notifier);

    if (state.error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const DetailHeader(
          title: '알림 설정',
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            state.error!,
            style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final getTokenUseCase = ref.read(getFcmTokenUseCaseProvider);

    Future<String?> _requireDeviceToken() async {
      final deviceToken = await getTokenUseCase.execute();
      if (deviceToken == null || deviceToken.isEmpty) {
        _showSnack(context, '오류가 발생했어요. 잠시 후 다시 시도해 주세요.');
        return null;
      }
      return deviceToken;
    }

    Future<void> onToggle({
      required String label,
      required String type,
      required bool nextValue,
    }) async {
      final deviceToken = await _requireDeviceToken();
      if (deviceToken == null) return;

      try {
        await vm.setToggle(
          target: target,
          deviceToken: deviceToken,
          notificationType: type,
          nextValue: nextValue,
        );
        _showSnack(
          context,
          _consentMessage(label: label, enabled: nextValue),
        );
      } catch (e) {
        _showSnack(context, e.toString());
      }
    }

    Future<void> onRecruitApplyToggle(bool nextValue) async {
      final deviceToken = await _requireDeviceToken();
      if (deviceToken == null) return;

      try {
        await vm.setRecruitApplyToggle(
          target: target,
          deviceToken: deviceToken,
          nextValue: nextValue,
        );
        _showSnack(
          context,
          _consentMessage(label: '지원 현황', enabled: nextValue),
        );
      } catch (e) {
        _showSnack(context, e.toString());
      }
    }

    Future<void> onRecruitResultToggle(bool nextValue) async {
      final deviceToken = await _requireDeviceToken();
      if (deviceToken == null) return;

      try {
        await vm.setRecruitResultToggle(
          target: target,
          deviceToken: deviceToken,
          nextValue: nextValue,
        );
        _showSnack(
          context,
          _consentMessage(label: '지원 결과', enabled: nextValue),
        );
      } catch (e) {
        _showSnack(context, e.toString());
      }
    }

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: const DetailHeader(
        title: '알림 설정',
        backgroundColor: ColorStyles.gray1,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            NotificationSection(
              title: '공지사항',
              subtitle: '교내 공지를 빠르게 확인할 수 있어요',
              children: [
                NotificationToggleRow(
                  label: '공지',
                  value: state.isEnabled(NotificationTypes.notice),
                  loading: state.isLoading(NotificationTypes.notice),
                  onChanged: (v) => onToggle(
                    label: '공지',
                    type: NotificationTypes.notice,
                    nextValue: v,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),

            NotificationSection(
              title: '오늘의 일정',
              subtitle: '매일 아침 8시에 오늘 일정을 확인할 수 있어요',
              children: [
                NotificationToggleRow(
                  label: '시간표',
                  value: state.isEnabled(NotificationTypes.timetable),
                  loading: state.isLoading(NotificationTypes.timetable),
                  onChanged: (v) => onToggle(
                    label: '시간표',
                    type: NotificationTypes.timetable,
                    nextValue: v,
                  ),
                ),
                NotificationToggleRow(
                  label: '일정',
                  value: state.isEnabled(NotificationTypes.calendar),
                  loading: state.isLoading(NotificationTypes.calendar),
                  onChanged: (v) => onToggle(
                    label: '일정',
                    type: NotificationTypes.calendar,
                    nextValue: v,
                  ),
                ),
              ],
            ),
            const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),

            if (user != null)
              NotificationSection(
                title: '모집 알림',
                subtitle: '모집 지원·결과를 빠르게 알려드려요.',
                children: [
                  NotificationToggleRow(
                    label: '지원 현황',
                    value: state.recruitApplyEnabled,
                    loading: state.recruitApplyLoading,
                    onChanged: onRecruitApplyToggle,
                  ),
                  const SizedBox(height: 4),
                  NotificationToggleRow(
                    label: '지원 결과',
                    value: state.recruitResultEnabled,
                    loading: state.recruitResultLoading,
                    onChanged: onRecruitResultToggle,
                  ),
                ],
              ),

            const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),

            if (user != null)
              NotificationSection(
                title: '채팅 알림',
                subtitle: '채팅을 빠르게 확인할 수 있어요',
                children: [
                  NotificationToggleRow(
                    label: '새로운 채팅',
                    value: state.isEnabled(NotificationTypes.chat),
                    loading: state.isLoading(NotificationTypes.chat),
                    onChanged: (v) => onToggle(
                      label: '새로운 채팅',
                      type: NotificationTypes.chat,
                      nextValue: v,
                    ),
                  ),
                ],
              ),

            const Divider(thickness: 4, height: 1, color: ColorStyles.gray1),

            NotificationSection(
              title: '기타',
              subtitle: '과팅 오픈 소식을 확인할 수 있어요',
              children: [
                NotificationToggleRow(
                  label: '광고성 푸시 알림',
                  value: state.isEnabled(NotificationTypes.marketing),
                  loading: state.isLoading(NotificationTypes.marketing),
                  onChanged: (v) => onToggle(
                    label: '광고성 푸시 알림',
                    type: NotificationTypes.marketing,
                    nextValue: v,
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(height: 4),
                  NotificationToggleRow(
                    label: '과팅 오픈',
                    value: state.isEnabled(NotificationTypes.blinddate),
                    loading: state.isLoading(NotificationTypes.blinddate),
                    onChanged: (v) => onToggle(
                      label: '과팅 오픈',
                      type: NotificationTypes.blinddate,
                      nextValue: v,
                    ),
                  ),
                ],
                if (isAdmin) ...[
                  const SizedBox(height: 4),
                  NotificationToggleRow(
                    label: '피드백 도착',
                    value: state.isEnabled(NotificationTypes.feedback),
                    loading: state.isLoading(NotificationTypes.feedback),
                    onChanged: (v) => onToggle(
                      label: '피드백 도착',
                      type: NotificationTypes.feedback,
                      nextValue: v,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
