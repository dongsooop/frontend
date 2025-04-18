import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/board/recruit/detail/widget/botton_button.dart';
import 'package:dongsoop/presentation/board/recruit/temp/temp_tutor_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class RecruitDetailPageScreen extends StatefulWidget {
  const RecruitDetailPageScreen({super.key});

  @override
  State<RecruitDetailPageScreen> createState() =>
      _RecruitDetailPageScreenState();
}

class _RecruitDetailPageScreenState extends State<RecruitDetailPageScreen> {
  final tutor = tutorList[0];

  String formatRecruitDate(String dateRange) {
    const year = 2025;
    final parts = dateRange.split('~');

    final start = parts[0].trim(); // '3. 28.'
    final end = parts[1].trim(); // '3. 31.'

    return '$year. $start ~ $year. $end';
  }

  Widget buildTag(String tag, int index) {
    final bgColor =
        index < tagBgColors.length ? tagBgColors[index] : ColorStyles.gray1;
    final textColor =
        index < tagColors.length ? tagColors[index] : ColorStyles.black;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        tag,
        style: TextStyles.smallTextBold.copyWith(color: textColor),
      ),
    );
  }

  final List<Color> tagBgColors = [
    ColorStyles.primary5,
    ColorStyles.warning10,
    ColorStyles.labelColorYellow10,
    ColorStyles.gray2,
  ];

  final List<Color> tagColors = [
    ColorStyles.primary100,
    ColorStyles.warning100,
    ColorStyles.labelColorYellow100,
    ColorStyles.gray3,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: '튜터링',
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              iconSize: 24.00,
              onPressed: () {
                // 메뉴 클릭 처리
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomButton(
          label: '지원하기',
          onPressed: () {},
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ColorStyles.primary5,
                        border: Border.all(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tutor['recruit_state'],
                        style: TextStyles.smallTextBold
                            .copyWith(color: ColorStyles.primaryColor),
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tutor['title'],
                            style: TextStyles.largeTextBold
                                .copyWith(color: ColorStyles.black)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tutor['recruit_people'],
                                style: TextStyles.smallTextRegular
                                    .copyWith(color: ColorStyles.gray4)),
                            Text('2025. 3. 24. 15:00',
                                style: TextStyles.smallTextRegular
                                    .copyWith(color: ColorStyles.gray4)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(
                      color: ColorStyles.gray2,
                      height: 1,
                    ),
                    SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('모집 기간',
                            style: TextStyles.normalTextBold
                                .copyWith(color: ColorStyles.black)),
                        SizedBox(height: 8),
                        Text(
                          formatRecruitDate(tutor['recruit_date']),
                          style: TextStyles.normalTextRegular
                              .copyWith(color: ColorStyles.black),
                        ),
                        SizedBox(height: 32),
                        Text('''
[DB 프로그래밍 튜터링 모집합니다]
                        
교내 튜터링 인원 모집합니다.

모집 인원: 10명
모집 기간: 3월 28일 ~ 3월 31일
대상: 컴퓨터소프트웨어공학과 2학년

작년 김희숙 교수님 DB 프로그래밍 A+ 입니다. 족보 보유 중입니다.

자기소개는 작성 부탁드리고 지원 동기는 비워주셔도 됩니다.

문의사항은 채팅으로 부탁드립니다.

소프트웨어 산업 분야에 필요한 직업기초능력과 직무수행능력을 갖춘 전문 기술 인력 양성을 목표로 시스템 분석 능력,
시스템 소프트웨어 개발 능력, 서버 운영 능력, 그리고 응용 소프트웨어 개발 능력을 집중 배양한다.
이를 통해 이론과 실무를 겸비하고 지역 사회와 국가 산업 발전에 기여하는 시스템 엔지니어 및 응용 소프트웨어 개발자를 양성한다'''),
                        SizedBox(height: 24),
                        Wrap(
                          spacing: 4,
                          children: (tutor['tags'] as List<dynamic>)
                              .asMap()
                              .entries
                              .map<Widget>((entry) =>
                                  buildTag(entry.value as String, entry.key))
                              .toList(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
