import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:dongsoop/domain/notification/entity/notification_entity.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/presentation/home/state/notification_state.dart';

class NotificationPageScreen extends HookConsumerWidget {
  const NotificationPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);
    final notifier = ref.read(notificationViewModelProvider.notifier);
    final scrollController = useScrollController();
    final prev = state.valueOrNull;
    final isLoadingMore = state.isLoading && prev != null;

    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;
        final position = scrollController.position;
        if (position.pixels >= position.maxScrollExtent - 200) {
          final hasMore =
              (state.valueOrNull ?? const NotificationState()).hasMore;
          if (!isLoadingMore && hasMore) {
            notifier.loadNextPage();
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, isLoadingMore, state.valueOrNull?.hasMore]);

    Widget buildList(
        NotificationState s, {
          bool showPaging = false,
          String? message,
        }) {
      final items = s.items;

      if (items.isEmpty && !showPaging) {
        return const Center(child: Text('알림이 없습니다.'));
      }

      return Column(
        children: [
          if (message != null && message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.black),
                ),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              color: ColorStyles.primaryColor,
              onRefresh: notifier.refresh,
              child: ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length + (showPaging ? 1 : 0),
                itemBuilder: (context, index) {
                  if (showPaging && index == items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: ColorStyles.primaryColor),
                      ),
                    );
                  }

                  final NotificationEntity n = items[index];

                  return Dismissible(
                    key: ValueKey('notif_${n.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: const Color(0xFFFF3526),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: ColorStyles.white),
                    ),
                    confirmDismiss: (_) async {
                      final bool? result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: '알림 삭제',
                          content: '이 알림을 삭제하시겠어요?',
                          cancelText: '취소',
                          confirmText: '삭제',
                          dismissOnConfirm: false,
                          dismissOnCancel: false,
                          onCancel: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop(false);
                          },
                          onConfirm: () async {
                            try {
                              await notifier.delete(n.id);
                              if (context.mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop(true);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop(false);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => CustomConfirmDialog(
                                    title: '삭제 실패',
                                    content: e.toString(),
                                    confirmText: '확인',
                                    isSingleAction: true,
                                    onConfirm: () {},
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                      return result ?? false;
                    },
                    child: InkWell(
                      onTap: () async {
                        if (!n.isRead) {
                          try {
                            await notifier.read(n.id);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$e')),
                              );
                            }
                            return;
                          }
                        }
                        await PushRouter.routeFromTypeValue(
                          type: n.type,
                          value: n.value,
                          fromNotificationList: true,
                        );
                      },
                      child: Container(
                        color: n.isRead
                            ? ColorStyles.white
                            : ColorStyles.primary5,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _LeadingIcon(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.normalTextBold.copyWith(
                                      color: ColorStyles.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    n.body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.smallTextRegular
                                        .copyWith(
                                      color: ColorStyles.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    formatRelativeTime(n.createdAt),
                                    style: TextStyles.smallTextRegular
                                        .copyWith(
                                      color: ColorStyles.gray4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '알림',
        onBack: () => context.pop(true),
      ),
      body: SafeArea(
        child: state.when(
          data: (data) =>
              buildList(data, showPaging: false, message: data.error),
          loading: () {
            if (prev == null) {
              return const Center(
                child:
                CircularProgressIndicator(color: ColorStyles.primaryColor),
              );
            }
            return buildList(prev, showPaging: true, message: prev.error);
          },
          error: (e, _) {
            if (prev == null) {
              return SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '$e',
                      style: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            return buildList(prev, showPaging: false, message: e.toString());
          },
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Align(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset(
            'assets/icons/logo.svg',
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}