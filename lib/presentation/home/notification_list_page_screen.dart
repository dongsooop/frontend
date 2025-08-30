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

class NotificationPageScreen extends HookConsumerWidget {
  const NotificationPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);
    final notificationController = ref.read(notificationViewModelProvider.notifier);
    final scrollController = useScrollController();

    // 무한 스크롤
    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          notificationController.loadNextPage();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    // 에러 다이얼로그
    useEffect(() {
      final err = state.error;
      if (err != null && err.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: true,
            builder: (_) => CustomConfirmDialog(
              title: '알림 오류',
              content: err,
              confirmText: '확인',
              isSingleAction: true,
              onConfirm: () {},
            ),
          );
        });
      }
      return null;
    }, [state.error]);

    if (state.isLoading && state.items.isEmpty) {
      return Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: '알림',
          onBack: () => context.pop(true),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: ColorStyles.primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: DetailHeader(
        title: '알림',
        onBack: () => context.pop(true),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 목록
            Expanded(
              child: RefreshIndicator(
                onRefresh: notificationController.refresh,
                child: ListView.builder(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.items.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state.isLoading && index == state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorStyles.primaryColor,
                          ),
                        ),
                      );
                    }

                    final NotificationEntity n = state.items[index];

                    return Dismissible(
                      key: ValueKey('notif_${n.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: const Color(0xFFFF3526),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete, color: ColorStyles.white),
                      ),
                      onDismissed: (_) async {
                        await notificationController.delete(n.id);
                      },
                      child: InkWell(
                        onTap: () async {
                          try {
                            await PushRouter.routeFromTypeValue(
                              type: n.type,
                              value: n.value,
                            );
                            await notificationController.read(n.id);
                          } catch (_) {}
                        },
                        child: Container(
                          color: n.isRead ? ColorStyles.white : ColorStyles.primary5,
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
                                      style: TextStyles.smallTextRegular.copyWith(
                                        color: ColorStyles.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatRelativeTime(n.createdAt),
                                      style: TextStyles.smallTextRegular.copyWith(
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

            // 하단 안내문 (항상 고정)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  '30일 전 알림까지 확인할 수 있어요',
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4,
                  ),
                ),
              ),
            ),
          ],
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
