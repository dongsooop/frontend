import 'package:dongsoop/core/presentation/components/notice_setting_link.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/providers/read_notice_provider.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 홈의 새로운 공지 세 건.
class HomeNoticeList extends StatelessWidget {
  final List<Notice> notices;

  const HomeNoticeList({super.key, required this.notices});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '새로운 공지',
                  style: TextStyles.sectionTitleBold.copyWith(color: ColorStyles.black),
                ),
              ),
              InkWell(
                onTap: () => context.goNamed('noticeList'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '더보기',
                        style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray5),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: ColorStyles.gray5),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (notices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '새 공지가 없어요',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            )
          else
            for (var i = 0; i < notices.length; i++)
              _NoticeRow(
                notice: notices[i],
                isLast: i == notices.length - 1,
              ),
          const SizedBox(height: 12),
          // 관심 학과를 안 고르면 학과 공지가 아예 안 온다.
          // 목록을 다 본 자리에 두어야 "학과 공지가 왜 없지" 하는 순간 바로 닿는다
          NoticeSettingLink(
            icon: Icons.bookmark,
            label: '학과 구독 설정',
            onTap: () => context.push(RoutePaths.subscribeDepartmentSetting),
          ),
        ],
      ),
    );
  }
}

class _NoticeRow extends ConsumerWidget {
  final Notice notice;
  final bool isLast;

  const _NoticeRow({
    required this.notice,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // id 를 주지 않는 서버에서는 읽음을 기록할 키가 없다. 그 경우 예전처럼
    // 늘 안 읽음으로 두고, 여는 것만 그대로 동작한다
    final id = notice.id;
    final isRead = id != null && ref.watch(readNoticeProvider).contains(id);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (id != null) {
          ref.read(readNoticeProvider.notifier).markAsRead(id);
        }
        context.pushNamed(
          'noticeWebView',
          queryParameters: {'path': notice.link},
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: isLast
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
                // 지금까지는 조건 없이 파랑이라 모든 공지가 늘 안 읽음으로
                // 보였다. 읽은 공지는 점을 흐리게 둔다
                color: isRead ? ColorStyles.gray2 : ColorStyles.primary100,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.black,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notice.type == NoticeType.department ? '학과공지' : '동양공지',
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
}
