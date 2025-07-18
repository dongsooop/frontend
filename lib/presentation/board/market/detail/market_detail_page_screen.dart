import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/presentation/board/market/detail/view_model/market_detail_view_model.dart';
import 'package:dongsoop/presentation/board/market/detail/widget/botton_button.dart';
import 'package:dongsoop/presentation/board/market/list/view_model/market_list_view_model.dart';
import 'package:dongsoop/presentation/board/utils/date_time_formatter.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../main.dart';

class MarketDetailPageScreen extends ConsumerWidget {
  final int id;
  final MarketType type;
  final void Function(String reportType, int targetId) onTapReport;
  final String? status;

  const MarketDetailPageScreen({
    super.key,
    required this.id,
    required this.type,
    required this.onTapReport,
    this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      marketDetailViewModelProvider(MarketDetailArgs(id: id)),
    );
    final user = ref.watch(userSessionProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: type.label,
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              final detailState = ref.read(
                marketDetailViewModelProvider(MarketDetailArgs(id: id)),
              );

              detailState.whenData((data) {
                final viewType = data.marketDetail?.viewType;
                if (viewType == 'OWNER') {
                  customActionSheet(context, onEdit: () {
                    context.push(RoutePaths.marketWrite, extra: {
                      'isEditing': true,
                      'marketId': id,
                    });
                  }, onDelete: () {
                    _showDeleteDialog(context, ref);
                  });
                } else {
                  customActionSheet(
                    context,
                    deleteText: '신고',
                    onDelete: () => onTapReport(type.reportType.name, id),
                  );
                }
              });
            },
          ),
        ),
        bottomNavigationBar: state.when(
          data: (data) {
            final viewType = data.marketDetail?.viewType;
            final market = data.marketDetail!;
            final isComplete = status == 'CLOSED'
                ? true
                : status == 'OPEN'
                ? false
                : data.isComplete;

            // 버튼 라벨 정의
            String label;
            if (viewType == 'OWNER') {
              label = isComplete ? '거래 완료' : '거래 완료';
            } else {
              label = '거래하기';
            }

            // 버튼 활성 여부 정의
            bool isEnabled;
            if (viewType == 'OWNER') {
              isEnabled = !isComplete;
            } else {
              isEnabled = true;
            }

            return BottomButton(
              label: label,
              price: market.price,
              onPressed: isEnabled
                  ? () async {
                      if (viewType == 'OWNER') {
                        _showCompleteDialog(context, ref);
                      } else if (viewType == 'GUEST') {
                        showDialog(
                          context: context,
                          builder: (_) => const LoginRequiredDialog(),
                        );
                      } else if (viewType == 'MEMBER') {
                        final userId = user?.id;

                        if (userId == null) {
                          showDialog(
                            context: context,
                            builder: (_) => const LoginRequiredDialog(),
                          );
                          return;
                        }

                        try {
                          final viewModel = ref.read(
                            marketDetailViewModelProvider(
                                    MarketDetailArgs(id: id))
                                .notifier,
                          );
                          await viewModel.contactMarket(id);

                          // TODO: 채팅방 이동 로직
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) => CustomConfirmDialog(
                              title: '요청 실패',
                              content: '$e',
                              confirmText: '확인',
                              isSingleAction: true,
                              onConfirm: () => context.pop(),
                            ),
                          );
                        }
                      }
                    }
                  : null,
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => const SizedBox.shrink(),
        ),
        body: state.when(
          data: (data) {
            final market = data.marketDetail!;
            final isComplete = status == 'CLOSED'
                ? true
                : status == 'OPEN'
                ? false
                : data.isComplete;
            logger.i('status: ${status} / isComplete: ${isComplete}');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          isComplete ? ColorStyles.gray1 : ColorStyles.primary5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isComplete ? '거래 완료' : '거래 중',
                      style: TextStyles.smallTextBold.copyWith(
                        color: isComplete
                            ? ColorStyles.gray3
                            : ColorStyles.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    market.title,
                    style: TextStyles.largeTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${market.contactCount}명이 연락했어요',
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray4,
                        ),
                      ),
                      Text(
                        formatFullDateTime(market.createdAt),
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: ColorStyles.gray2, height: 1),
                  const SizedBox(height: 24),
                  Text(
                    market.content,
                    style: TextStyles.normalTextRegular,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: market.imageUrlList.length,
                      itemBuilder: (context, index) {
                        final url = market.imageUrlList[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('$err')),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => CustomConfirmDialog(
        title: '게시글 삭제',
        content: '정말로 이 게시글을 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
        onConfirm: () async {
          final viewModel = ref.read(
            marketDetailViewModelProvider(MarketDetailArgs(id: id)).notifier,
          );

          try {
            await viewModel.deleteMarket(id);
            ref.invalidate(MarketListViewModelProvider(type: type));
            context.pop(true);
          } catch (e) {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '삭제 실패',
                content: '게시글 삭제 중 문제가 발생했습니다.\n${e.toString()}',
                confirmText: '확인',
                onConfirm: () => context.pop(),
                isSingleAction: true,
              ),
            );
          }
        },
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => CustomConfirmDialog(
        title: '거래 완료',
        content: '거래가 완료된 글은 다시 거래할 수 없어요.\n거래를 완료할까요?',
        confirmText: '확인',
        cancelText: '취소',
        dismissOnConfirm: false,
        onConfirm: () async {
          context.pop();

          final viewModel = ref.read(
            marketDetailViewModelProvider(MarketDetailArgs(id: id)).notifier,
          );

          try {
            await viewModel.completeMarket(id);
            ref.invalidate(MarketListViewModelProvider(type: type));
          } catch (e) {
            showDialog(
              context: context,
              builder: (_) => CustomConfirmDialog(
                title: '오류 발생',
                content: '$e',
                confirmText: '확인',
                isSingleAction: true,
                onConfirm: () => context.pop(),
                dismissOnConfirm: true,
              ),
            );
          }
        },
      ),
    );
  }
}
