import 'dart:async';

import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_assignment_entity.dart';
import 'package:dongsoop/presentation/eclass/assignment/widget/eclass_assignment_card.dart';
import 'package:dongsoop/presentation/eclass/assignment/widget/eclass_assignment_empty_state.dart';
import 'package:dongsoop/presentation/eclass/assignment/widget/eclass_assignment_link_state.dart';
import 'package:dongsoop/providers/eclass_assignment_list_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EclassAssignmentScreen extends HookConsumerWidget {
  final Future<void> Function() onTapLinkManagement;
  final Future<bool> Function(String url) onOpenAssignment;

  const EclassAssignmentScreen({
    super.key,
    required this.onTapLinkManagement,
    required this.onOpenAssignment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(eclassAssignmentListViewModelProvider.notifier);
    final state = ref.watch(eclassAssignmentListViewModelProvider);
    final isAssignmentLaunchPending = useRef(false);
    final didAssignmentLaunchSucceed = useRef(false);
    final didLeaveForeground = useRef(false);
    final didReturnToForeground = useRef(false);

    void clearAssignmentLaunchState() {
      isAssignmentLaunchPending.value = false;
      didAssignmentLaunchSucceed.value = false;
      didLeaveForeground.value = false;
      didReturnToForeground.value = false;
    }

    void refreshAfterAssignmentReturn() {
      clearAssignmentLaunchState();
      unawaited(viewModel.refresh());
    }

    useEffect(() {
      Future.microtask(viewModel.load);
      return null;
    }, const []);

    useEffect(() {
      final listener = AppLifecycleListener(
        onStateChange: (lifecycleState) {
          if (!isAssignmentLaunchPending.value) return;

          final leftForeground = lifecycleState == AppLifecycleState.hidden ||
              lifecycleState == AppLifecycleState.paused ||
              lifecycleState == AppLifecycleState.detached;
          if (leftForeground) {
            didLeaveForeground.value = true;
            return;
          }

          if (lifecycleState != AppLifecycleState.resumed ||
              !didLeaveForeground.value) {
            return;
          }

          didReturnToForeground.value = true;
          if (didAssignmentLaunchSucceed.value) {
            refreshAfterAssignmentReturn();
          }
        },
      );
      return listener.dispose;
    }, [viewModel]);

    useEffect(() {
      final message = state.actionError;
      if (message == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        viewModel.clearActionError();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      });
      return null;
    }, [state.actionError]);

    Future<void> openLinkManagement() async {
      await onTapLinkManagement();
      if (!context.mounted) return;
      await viewModel.load();
    }

    Future<void> openAssignment(EclassAssignmentEntity assignment) async {
      isAssignmentLaunchPending.value = true;
      didAssignmentLaunchSucceed.value = false;
      didLeaveForeground.value = false;
      didReturnToForeground.value = false;

      final opened = await onOpenAssignment(assignment.link);
      if (opened) {
        didAssignmentLaunchSucceed.value = true;
        if (didReturnToForeground.value) {
          refreshAfterAssignmentReturn();
        }
        return;
      }

      clearAssignmentLaunchState();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('이클래스 과제 페이지를 열지 못했어요.')),
        );
    }

    return Scaffold(
      backgroundColor: ColorStyles.gray1,
      appBar: const DetailHeader(
        title: '이클래스 과제',
        backgroundColor: ColorStyles.gray1,
      ),
      body: SafeArea(
        child: state.isInitialLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorStyles.primary100,
                ),
              )
            : state.loadError != null
                ? _LoadErrorView(
                    message: state.loadError!,
                    onRetry: viewModel.load,
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final result = state.result!;
                      final assignments = result.assignments;
                      final showAssignments = !result.isUnlinked &&
                          !result.isExpired &&
                          assignments.isNotEmpty;

                      return RefreshIndicator(
                        onRefresh: viewModel.refresh,
                        color: ColorStyles.primary100,
                        child: ListView(
                          key: const Key('eclass-assignment-list'),
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                          children: [
                            if (showAssignments) ...[
                              Text(
                                '과제가 ${assignments.length}개 남았어요',
                                style: TextStyles.titleTextBold.copyWith(
                                  color: ColorStyles.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '마감이 가까운 순서예요.',
                                style: TextStyles.normalTextRegular.copyWith(
                                  color: ColorStyles.gray4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              for (var index = 0;
                                  index < assignments.length;
                                  index++) ...[
                                EclassAssignmentCard(
                                  assignment: assignments[index],
                                  onTap: () =>
                                      openAssignment(assignments[index]),
                                ),
                                if (index != assignments.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            ] else
                              SizedBox(
                                height: constraints.maxHeight > 48
                                    ? constraints.maxHeight - 48
                                    : 0,
                                child: result.isUnlinked
                                    ? EclassAssignmentLinkState(
                                        isExpired: false,
                                        onTapLink: openLinkManagement,
                                      )
                                    : result.isExpired
                                        ? EclassAssignmentLinkState(
                                            isExpired: true,
                                            onTapLink: openLinkManagement,
                                          )
                                        : const EclassAssignmentEmptyState(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
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
              key: const Key('eclass-assignment-retry-button'),
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
