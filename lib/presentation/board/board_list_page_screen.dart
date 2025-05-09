import 'package:dongsoop/core/presentation/components/common_img_style.dart';
import 'package:dongsoop/core/presentation/components/common_tap_section.dart';
import 'package:dongsoop/presentation/board/common/board_write_button.dart';
import 'package:dongsoop/presentation/board/market/temp/temp_market_data.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_project_data.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_study_data.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_tag_utils.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_tutor_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class BoardListPageScreen extends StatefulWidget {
  const BoardListPageScreen({super.key});

  @override
  State<BoardListPageScreen> createState() => _BoardListPageScreenState();
}

class _BoardListPageScreenState extends State<BoardListPageScreen> {
  int selectedIndex = 0; // 모집(0), 장터(1)
  int selectedSubIndex = 0; // 모집: 튜터링(0), 스터디(1), 프로젝트(2), 장터: 판매(0), 구매(1)

  @override
  Widget build(BuildContext context) {
    final isRecruit = selectedIndex == 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButton: WriteButton(
          onPressed: () {
            final route = isRecruit ? '/recruit/write' : '/market/write';
            Navigator.pushNamed(context, route);
          },
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _getListData().length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return BoardTabSection(
                categoryTabs: ['모집', '장터'],
                selectedCategoryIndex: selectedIndex,
                selectedSubTabIndex: selectedSubIndex,
                subTabs: isRecruit ? ['튜터링', '스터디', '프로젝트'] : ['판매', '구매'],
                onCategorySelected: (catIndex) {
                  setState(() {
                    selectedIndex = catIndex;
                    selectedSubIndex = 0;
                  });
                },
                onSubTabSelected: (subIndex) {
                  setState(() {
                    selectedSubIndex = subIndex;
                  });
                },
              );
            }

            final data = _getListData()[index - 1];
            final isLast = index - 1 == _getListData().length - 1;

            if (isRecruit) {
              return RecruitListItem(
                recruit: data,
                isLastItem: isLast,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/recruit/detail',
                  arguments: {'id': data['id']},
                ),
              );
            } else {
              return MarketListItem(
                market: data,
                isLastItem: isLast,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/market/detail',
                  arguments: {'id': data['id']},
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getListData() {
    if (selectedIndex == 0) {
      switch (selectedSubIndex) {
        case 1:
          return studyList;
        case 2:
          return projectList;
        default:
          return tutorList;
      }
    } else {
      return marketList;
    }
  }
}

class RecruitListItem extends StatelessWidget {
  final Map<String, dynamic> recruit;
  final VoidCallback onTap;
  final bool isLastItem;

  const RecruitListItem(
      {super.key,
      required this.recruit,
      required this.onTap,
      required this.isLastItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(recruit['recruit_state'],
                            style: TextStyles.smallTextBold
                                .copyWith(color: ColorStyles.black)),
                        const SizedBox(width: 8),
                        Text(recruit['recruit_people'],
                            style: TextStyles.smallTextRegular
                                .copyWith(color: ColorStyles.gray4)),
                      ],
                    ),
                    Text(recruit['recruit_date'],
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(recruit['title'],
                    style: TextStyles.largeTextBold
                        .copyWith(color: ColorStyles.black)),
                Text(recruit['description'],
                    style: TextStyles.smallTextRegular
                        .copyWith(color: ColorStyles.black)),
                const SizedBox(height: 24),
                Row(
                  children: recruit['tags']
                      .map<Widget>((tag) => buildTag(tag))
                      .toList(),
                ),
              ],
            ),
          ),
          if (!isLastItem) const Divider(color: ColorStyles.gray2, height: 1),
        ],
      ),
    );
  }
}

class MarketListItem extends StatelessWidget {
  final Map<String, dynamic> market;
  final VoidCallback onTap;
  final bool isLastItem;

  const MarketListItem(
      {super.key,
      required this.market,
      required this.onTap,
      required this.isLastItem});

  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return '방금 전';
    if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
    if (difference.inHours < 24) return '${difference.inHours}시간 전';
    if (difference.inDays < 7) return '${difference.inDays}일 전';

    return '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final imageList = market['images'];
    final hasImage =
        imageList != null && imageList is List && imageList.isNotEmpty;
    final firstImage = hasImage ? imageList.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImgStyle(
                  imagePath: hasImage ? firstImage : null,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(market['market_title'],
                          style: TextStyles.largeTextRegular
                              .copyWith(color: ColorStyles.black)),
                      Text(
                        formatRelativeTime(market['market_created_at']),
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4),
                      ),
                      Text('${market['market_prices']}원',
                          style: TextStyles.largeTextBold
                              .copyWith(color: ColorStyles.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLastItem) const Divider(color: ColorStyles.gray2, height: 1),
        ],
      ),
    );
  }
}
