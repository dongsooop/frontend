import 'package:dongsoop/core/presentation/components/admob_native_ad.dart';
import 'package:dongsoop/providers/read_notice_provider.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// 공지 목록.
///
/// 홈의 새로운 공지와 같은 모양으로 읽힌다 — 읽음을 알리는 점, 두 줄까지의
/// 제목, 그 아래 출처와 날짜 한 줄.
class CommonNoticeList<T> extends StatelessWidget {
  const CommonNoticeList({
    super.key,
    required this.items,
    required this.controller,
    required this.isLoading,
    required this.hasMore,
    required this.titleOf,
    required this.isDepartmentOf,
    required this.onTap,
    this.idOf,
    this.createdAtOf,
  });

  final List<T> items;
  final ScrollController controller;
  final bool isLoading;
  final bool hasMore;
  final String Function(T) titleOf;
  final bool Function(T) isDepartmentOf;
  final void Function(T) onTap;

  /// 읽음을 기록할 키. 없으면 점이 늘 안 읽음으로 남는다.
  final int Function(T)? idOf;

  /// 없으면 출처만 적는다.
  final DateTime Function(T)? createdAtOf;

  @override
  Widget build(BuildContext context) {
    const adInterval = 10;

    return ListView.builder(
      controller: controller,
      itemCount: items.length + (items.length ~/ adInterval) + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index > 0 && index % (adInterval + 1) == adInterval) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AdmobNativeAd(),
          );
        }

        final int adCount = index ~/ (adInterval + 1);
        final int actualIndex = index - adCount;

        if (actualIndex == items.length) {
          return isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorStyles.primaryColor,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }

        final item = items[actualIndex];
        final idGetter = idOf;
        final createdAtGetter = createdAtOf;

        return CommonNoticeListItem(
          title: titleOf(item),
          isDepartment: isDepartmentOf(item),
          noticeId: idGetter == null ? null : idGetter(item),
          createdAt: createdAtGetter == null ? null : createdAtGetter(item),
          onTap: () => onTap(item),
          isLastItem: actualIndex == items.length - 1,
        );
      },
    );
  }
}

/// 공지 한 줄.
///
/// 예전에는 제목 아래에 `동양공지` + `학교생활` 두 태그를 달았다. 둘 다
/// `isDepartment` 하나에서 나오는 값이라 둘째 태그는 아무것도 더 말해 주지
/// 않았고, 태그 두 개와 위아래 24 여백이 한 줄을 매우 두껍게 만들었다.
/// 출처 하나만 남기고 그 자리에 날짜를 붙인다.
class CommonNoticeListItem extends ConsumerWidget {
  const CommonNoticeListItem({
    super.key,
    required this.title,
    required this.isDepartment,
    required this.onTap,
    required this.isLastItem,
    this.noticeId,
    this.createdAt,
  });

  final String title;
  final bool isDepartment;
  final VoidCallback onTap;
  final bool isLastItem;

  /// 읽음을 기록할 키. 없으면 점이 늘 안 읽음으로 남는다.
  final int? noticeId;

  final DateTime? createdAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = noticeId;
    final isRead = id != null && ref.watch(readNoticeProvider).contains(id);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (id != null) {
          ref.read(readNoticeProvider.notifier).markAsRead(id);
        }
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: isLastItem
              ? null
              : const Border(
                  bottom: BorderSide(color: ColorStyles.gray1, width: 1),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 8, right: 10),
              decoration: BoxDecoration(
                color: isRead ? ColorStyles.gray2 : ColorStyles.primary100,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.black,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _meta(),
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _meta() {
    final source = isDepartment ? '학과공지' : '동양공지';
    final date = createdAt;
    if (date == null) return source;

    return '$source · ${_dateLabel(date)}';
  }

  /// 공지의 날짜는 서버에서 날짜만 내려온다. 시각을 적을 것이 없으므로
  /// `N시간 전` 같은 상대 표기는 쓰지 않는다.
  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year != now.year) {
      return DateFormat('yyyy년 M월 d일', 'ko').format(date);
    }
    return DateFormat('M월 d일', 'ko').format(date);
  }
}
