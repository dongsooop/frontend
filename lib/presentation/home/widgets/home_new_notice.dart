import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNewNotice extends StatelessWidget {
  const HomeNewNotice({super.key, required this.notices});
  final List<Notice> notices;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorStyles.gray1,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '새로운 공지',
                style: TextStyles.titleTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              GestureDetector(
                onTap: () => context.goNamed('noticeList'),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.gray3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: ColorStyles.gray3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: _buildNoticeList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeList(BuildContext context) {
    if (notices.isEmpty) {
      return Center(
        child: Text(
          '새 공지가 없어요',
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(notices.length, (index) {
        final item = notices[index];
        final tags = (item.type == NoticeType.department)
            ? const ['학과공지', '학부']
            : const ['동양공지', '학교생활'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pushNamed(
                'noticeWebView',
                queryParameters: {'path': item.link},
              ),
              child: Text(
                item.title,
                style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              children: tags
                  .asMap()
                  .entries
                  .map((entry) => CommonTag(
                  label: entry.value,
                  index: entry.key,
                ))
                  .toList(),
            ),
            if (index != notices.length - 1)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                width: double.infinity,
                height: 1,
                color: ColorStyles.gray2,
              ),
          ],
        );
      }),
    );
  }
}
