import 'package:dongsoop/presentation/board/common/board_tap_section.dart';
import 'package:dongsoop/presentation/board/common/board_write_button.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_project_data.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_study_data.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_tag_utils.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_tutor_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RecruitListPageScreen extends StatefulWidget {
  const RecruitListPageScreen({super.key});

  @override
  State<RecruitListPageScreen> createState() => _State();
}

class _State extends State<RecruitListPageScreen> {
  int selectedIndex = 0; // 모집(0), 장터(1)
  int selectedRecruitIndex = 0; // 튜터링(0), 스터디(1), 프로젝트(2)

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> recruitData;
    switch (selectedRecruitIndex) {
      case 1:
        recruitData = studyList;
        break;
      case 2:
        recruitData = projectList;
        break;
      default:
        recruitData = tutorList;
        break;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButton: WriteButton(
            onPressed: () => Navigator.pushNamed(context, '/recruit/write')),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: recruitData.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return BoardTabSection(
                selectedCategoryIndex: selectedIndex,
                selectedSubTabIndex: selectedRecruitIndex,
                subTabs: ['튜터링', '스터디', '프로젝트'],
                onCategorySelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    if (index == 1) {
                      // 장터 페이지로 이동
                      Navigator.pushReplacementNamed(context, '/market/list');
                    }
                  });
                },
                onSubTabSelected: (index) {
                  setState(() {
                    selectedRecruitIndex = index;
                  });
                },
              );
            }

            final recruit = recruitData[index - 1];
            final isLastItem = index - 1 == recruitData.length - 1;
            return RecruitListItem(
              recruit: recruit,
              isLastItem: isLastItem,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/recruit/detail',
                  arguments: {'id': recruit['id']},
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RecruitListItem extends StatelessWidget {
  final Map<String, dynamic> recruit;
  final VoidCallback onTap;
  final bool isLastItem;

  const RecruitListItem({
    super.key,
    required this.recruit,
    required this.onTap,
    required this.isLastItem,
  });

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
                        Text(
                          recruit['recruit_state'],
                          style: TextStyles.smallTextBold
                              .copyWith(color: ColorStyles.black),
                        ),
                        SizedBox(width: 8),
                        Text(
                          recruit['recruit_people'],
                          style: TextStyles.smallTextRegular
                              .copyWith(color: ColorStyles.gray4),
                        ),
                      ],
                    ),
                    Text(
                      recruit['recruit_date'],
                      style: TextStyles.smallTextRegular
                          .copyWith(color: ColorStyles.gray4),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  recruit['title'],
                  style: TextStyles.largeTextBold
                      .copyWith(color: ColorStyles.black),
                ),
                Text(
                  recruit['description'],
                  style: TextStyles.smallTextRegular
                      .copyWith(color: ColorStyles.black),
                ),
                SizedBox(height: 24),
                Row(
                  children: recruit['tags']
                      .map<Widget>((tag) => buildTag(tag))
                      .toList(),
                ),
              ],
            ),
          ),
          if (!isLastItem)
            Divider(
              color: ColorStyles.gray2,
              height: 1,
            ),
        ],
      ),
    );
  }
}
