import 'package:dongsoop/core/presentation/components/notice_setting_link.dart';
import 'package:dongsoop/core/presentation/components/section_header.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 홈의 새로운 공지 세 건.
///
/// 앞의 점은 읽음 여부 자리다. 지금은 서버 응답(`HomeNotice`)에 공지 id 가 없어
/// 로컬 읽음 기록과 대조할 수 없으므로 전부 안 읽음으로 둔다.
/// 백엔드에서 id 가 내려오면 [isUnread] 만 채우면 된다.
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
          SectionHeader(
            title: '새로운 공지',
            action: SectionHeaderAction(
              label: '더보기',
              onTap: () => context.goNamed('noticeList'),
            ),
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

class _NoticeRow extends StatelessWidget {
  final Notice notice;
  final bool isLast;

  /// 서버가 공지 id 를 내려주기 전까지는 모두 안 읽음으로 본다.
  final bool isUnread;

  const _NoticeRow({
    required this.notice,
    required this.isLast,
    this.isUnread = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(
        'noticeWebView',
        queryParameters: {'path': notice.link},
      ),
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
                color: isUnread ? ColorStyles.primary100 : ColorStyles.gray2,
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
                      color: isUnread ? ColorStyles.black : ColorStyles.gray6,
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
