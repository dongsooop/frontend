import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/setting/device_management/widget/device_item.dart';
import 'package:dongsoop/providers/device_management_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeviceManagementScreen extends HookConsumerWidget {
  const DeviceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(deviceManagementViewModelProvider.notifier);
    final state = ref.watch(deviceManagementViewModelProvider);

    useEffect(() {
      Future.microtask(() => vm.loadDevices());
      return null;
    }, const []);

    useEffect(() {
      if (state.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          vm.clearError();

          showDialog(
            context: context,
            builder: (_) => CustomConfirmDialog(
              title: state.errorTitle ?? '오류',
              content: state.errorMessage ?? '',
              onConfirm: () {},
              confirmText: '확인',
            ),
          );
        });
      }
      return null;
    }, [state.errorMessage]);

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: DetailHeader(
        title: '기기 관리',
        backgroundColor: ColorStyles.gray1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: vm.loadDevices,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (!state.isLoading && state.devices.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: Text('로그인된 기기가 없습니다.')),
                      ),

                    if (state.devices.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < state.devices.length; i++) ...[
                              DeviceItem(
                                device: state.devices[i],
                                onTapLogout: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => CustomConfirmDialog(
                                      title: '기기 로그아웃',
                                      content: '해당 기기를 강제 로그아웃 할까요?',
                                      confirmText: '확인',
                                      onConfirm: () async {
                                        await vm.forceLogout(state.devices[i].id);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
              if (state.isLoading)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: Center(child: CircularProgressIndicator(color: ColorStyles.primaryColor)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}