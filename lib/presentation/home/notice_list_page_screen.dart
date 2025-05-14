import 'package:dongsoop/core/presentation/components/common_tag.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/search_bar.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeListPageScreen extends ConsumerStatefulWidget {
  const NoticeListPageScreen({super.key});

  @override
  ConsumerState<NoticeListPageScreen> createState() =>
      _NoticeListPageScreenState();
}

class _NoticeListPageScreenState extends ConsumerState<NoticeListPageScreen> {
  int selectedNoticeIndex = 0;

  final List<Map<String, dynamic>> noticeAllList = [
    {
      "title": "[선관위] 2025학년도 학과대표 보궐선거 선거일정 공고",
      "tags": ["동양공지", "학교생활"]
    },
    {
      "title": "2025학년도 신입생 캠퍼스커넥트 프로그램 토크콘서트 안내",
      "tags": ["동양공지", "학교생활"]
    },
    {
      "title": "2025학년도 신입생 캠퍼스커넥트 프로그램 토크콘서트 안내",
      "tags": ["동양공지", "학교생활"]
    },
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
  ];
  final List<Map<String, dynamic>> noticeDeptList = [
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
  ];

  // 탭 밑줄
  Widget _buildUnderlineTab(String label, bool isSelected) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              label,
              style: isSelected
                  ? TextStyles.largeTextBold
                      .copyWith(color: ColorStyles.primary100)
                  : TextStyles.largeTextRegular
                      .copyWith(color: ColorStyles.gray4),
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: ColorStyles.primary100,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noticeState = ref.watch(noticeListViewModelProvider);

    List<Map<String, dynamic>> localData = [];
    if (selectedNoticeIndex == 0) {
      localData = noticeAllList;
    } else if (selectedNoticeIndex == 2) {
      localData = noticeDeptList;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(title: '공지'),
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SearchBarComponent(),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final labels = ['전체', '학교', '학과'];
                      final isSelected = selectedNoticeIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedNoticeIndex = index;
                            });
                          },
                          child: _buildUnderlineTab(labels[index], isSelected),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: selectedNoticeIndex == 1
                      ? noticeState.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('에러: $e')),
                          data: (notices) => ListView.separated(
                            itemCount: notices.length,
                            separatorBuilder: (_, __) => const Divider(
                                height: 1, color: ColorStyles.gray2),
                            itemBuilder: (context, index) {
                              final item = notices[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyles.largeTextBold.copyWith(
                                        color: ColorStyles.black,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                        // 유저와 연결시 태그 추가
                                        ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : ListView.separated(
                          itemCount: localData.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1, color: ColorStyles.gray2),
                          itemBuilder: (context, index) {
                            final item = localData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyles.largeTextBold.copyWith(
                                      color: ColorStyles.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    children: item['tags']
                                        .asMap()
                                        .entries
                                        .map<Widget>((entry) => CommonTag(
                                              label: entry.value,
                                              index: entry.key,
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
