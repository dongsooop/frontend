import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';
import 'package:dongsoop/presentation/eclass/link/widget/eclass_credentials_form.dart';
import 'package:dongsoop/presentation/eclass/link/widget/eclass_linked_card.dart';
import 'package:dongsoop/presentation/eclass/link/widget/eclass_security_notice.dart';
import 'package:dongsoop/providers/eclass_link_management_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EclassLinkScreen extends HookConsumerWidget {
  const EclassLinkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(eclassLinkManagementViewModelProvider.notifier);
    final state = ref.watch(eclassLinkManagementViewModelProvider);
    final eclassIdController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final canSubmit = useState(false);

    void updateCanSubmit([String? _]) {
      final next = eclassIdController.text.trim().isNotEmpty &&
          passwordController.text.isNotEmpty;
      if (canSubmit.value != next) canSubmit.value = next;
      viewModel.clearFormError();
    }

    Future<void> submit() async {
      FocusScope.of(context).unfocus();
      final succeeded = await viewModel.link(
        eclassId: eclassIdController.text,
        password: passwordController.text,
      );
      if (!context.mounted || !succeeded) return;
      passwordController.clear();
      updateCanSubmit();
    }

    useEffect(() {
      Future.microtask(viewModel.load);
      return null;
    }, const []);

    useEffect(() {
      final message = state.actionError;
      if (message == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        viewModel.clearActionError();
        showDialog<void>(
          context: context,
          builder: (_) => CustomConfirmDialog(
            title: '안내',
            content: message,
            isSingleAction: true,
            onConfirm: () {},
          ),
        );
      });
      return null;
    }, [state.actionError]);

    final link = state.link;
    final isActive =
        link?.linked == true && link?.status == EclassLinkStatus.active;
    final isExpired =
        link?.linked == true && link?.status == EclassLinkStatus.expired;

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: const DetailHeader(
        title: '이클래스 연동',
        backgroundColor: ColorStyles.gray1,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (state.isInitialLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: ColorStyles.primary100,
                ),
              )
            else if (state.loadError != null)
              _LoadErrorView(
                message: state.loadError!,
                onRetry: viewModel.load,
              )
            else
              AutofillGroup(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    24,
                    16,
                    24 + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  children: [
                    Text(
                      isActive ? '이클래스가 연동되어 있어요' : '이클래스를 연동해 주세요',
                      style: TextStyles.titleTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isActive
                          ? '과제 정보를 동숲에서 편리하게 확인할 수 있어요.'
                          : '연동하면 과제와 마감 일정을 한곳에서 확인할 수 있어요.',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray4,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isActive)
                      EclassLinkedCard(
                        link: link!,
                        isUnlinking: state.isUnlinking,
                        onUnlink: () => _showUnlinkDialog(
                          context,
                          viewModel.unlink,
                        ),
                      )
                    else ...[
                      if (isExpired) ...[
                        _ExpiredNotice(
                          isUnlinking: state.isUnlinking,
                          onUnlink: () => _showUnlinkDialog(
                            context,
                            viewModel.unlink,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      EclassCredentialsForm(
                        eclassIdController: eclassIdController,
                        passwordController: passwordController,
                        obscurePassword: obscurePassword.value,
                        isSubmitting: state.isSubmitting,
                        canSubmit: canSubmit.value,
                        errorMessage: state.formError,
                        onChanged: updateCanSubmit,
                        onTogglePasswordVisibility: () {
                          obscurePassword.value = !obscurePassword.value;
                        },
                        onSubmit: submit,
                      ),
                    ],
                    if (state.localCleanupRequired) ...[
                      const SizedBox(height: 16),
                      _LocalCleanupNotice(
                        isLoading: state.isDeletingLocalCredentials,
                        onRetry: viewModel.retryLocalCredentialDeletion,
                      ),
                    ],
                    if (!isActive) ...[
                      const SizedBox(height: 16),
                      const EclassSecurityNotice(),
                    ],
                  ],
                ),
              ),
            if (state.isBusy && !state.isSubmitting && !state.isUnlinking)
              const Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(
                    color: Color(0x22000000),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorStyles.primary100,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showUnlinkDialog(
    BuildContext context,
    Future<void> Function() onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => CustomConfirmDialog(
        title: '이클래스 연동 해제',
        content: '연동을 해제하면 기기에 저장된 이클래스 아이디와 비밀번호도 함께 삭제돼요. 해제할까요?',
        confirmText: '해제',
        onConfirm: onConfirm,
      ),
    );
  }
}

class _ExpiredNotice extends StatelessWidget {
  final bool isUnlinking;
  final VoidCallback onUnlink;

  const _ExpiredNotice({
    required this.isUnlinking,
    required this.onUnlink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('eclass-expired-notice'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.warning10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                size: 20,
                color: ColorStyles.warning100,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이클래스 연동이 만료됐어요',
                      style: TextStyles.normalTextBold.copyWith(
                        color: ColorStyles.warning100,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '과제 정보를 다시 가져오려면 이클래스 계정으로 재연동해 주세요.',
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.warning100,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: TextButton(
              key: const Key('eclass-expired-unlink-button'),
              onPressed: isUnlinking ? null : onUnlink,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: ColorStyles.warning100,
              ),
              child: Text(
                '연동 정보 삭제',
                style: TextStyles.smallTextBold.copyWith(
                  color: ColorStyles.warning100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalCleanupNotice extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRetry;

  const _LocalCleanupNotice({
    required this.isLoading,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorStyles.warning10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기기에 저장된 자동 재연동 정보를 삭제하지 못했어요.',
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.warning100,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: isLoading ? null : onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorStyles.warning100,
                side: const BorderSide(color: ColorStyles.warning100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '저장 정보 다시 삭제',
                style: TextStyles.smallTextBold.copyWith(
                  color: ColorStyles.warning100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _LoadErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 36,
              color: ColorStyles.gray4,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.normalTextRegular.copyWith(
                color: ColorStyles.gray4,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('eclass-load-retry-button'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 44),
                backgroundColor: ColorStyles.primary100,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onRetry,
              child: Text(
                '다시 시도',
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
