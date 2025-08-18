import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class NotificationPageScreen extends HookConsumerWidget {
  const NotificationPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    // mock data
    final items = useState<List<_Notify>>([
      _Notify(title: 'SQLD 자격증 취득 스터디', body: '김동양 : 안녕하세요!', time: '10분 전', unread: true),
      _Notify(title: '컴활 2급', body: '동양킴 : 컴퓨터소프트웨어공학과 2학년 어쩌고', time: '1시간 전', unread: true),
      _Notify(title: 'DB 프로그래밍 교재', body: '동양킴 : 아직 판매중이신가요?', time: '5일 전'),
      _Notify(title: 'SCU 족보', body: '[판매] 게시글에 거래 요청이 들어왔어요!', time: '7일 전'),
      _Notify(title: 'SQLD 자격증 취득 스터디', body: '새로운 [스터디] 지원이 들어왔어요!', time: '10일 전'),
      _Notify(title: '운영체제 실습', body: '새로운 [튜터링] 지원이 들어왔어요!', time: '13일 전'),
      _Notify(title: '웹 프로젝트 실습', body: '새로운 [프로젝트] 지원이 들어왔어요!', time: '17일 전'),
      _Notify(title: '웹 프로젝트 실습', body: '지원 결과가 나왔어요, 지금 확인해보세요!', time: '27일 전'),
    ]);

    void markAllRead() {
      items.value = [for (final n in items.value) n.copyWith(unread: false)];
    }

    final hasUnread = items.value.any((e) => e.unread);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: const DetailHeader(title: '알림'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(minHeight: 44),
              child: TextButton(
                onPressed: hasUnread ? markAllRead : null,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 44),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '모두 읽음',
                  style: TextStyles.normalTextRegular.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: items.value.length + 1,
                itemBuilder: (context, index) {
                  if (index == items.value.length) {
                    return Container(
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
                    );
                  }

                  final n = items.value[index];

                  return InkWell(
                    onTap: () {
                      items.value = [
                        for (int i = 0; i < items.value.length; i++)
                          i == index ? items.value[i].copyWith(unread: false) : items.value[i],
                      ];
                    },
                    child: Container(
                      color: n.unread ? ColorStyles.primary5 : ColorStyles.white,
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
                                // 제목
                                Text(
                                  n.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.normalTextBold.copyWith(
                                    color: ColorStyles.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 본문
                                Text(
                                  n.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.smallTextRegular.copyWith(
                                    color: ColorStyles.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 시간
                                Text(
                                  n.time,
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
                  );
                },
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

class _Notify {
  const _Notify({
    required this.title,
    required this.body,
    required this.time,
    this.unread = false,
  });

  final String title;
  final String body;
  final String time;
  final bool unread;

  _Notify copyWith({String? title, String? body, String? time, bool? unread}) {
    return _Notify(
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      unread: unread ?? this.unread,
    );
  }
}
