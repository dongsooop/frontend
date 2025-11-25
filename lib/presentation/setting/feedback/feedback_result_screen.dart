import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/setting/feedback/widget/feedback_bar_chart.dart';
import 'package:dongsoop/presentation/setting/feedback/widget/feedback_card.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class FeedbackResultScreen extends StatefulWidget {
  const FeedbackResultScreen({super.key});

  @override
  State<FeedbackResultScreen> createState() => _FeedbackResultScreenState();
}

class _FeedbackResultScreenState extends State<FeedbackResultScreen> {
  static const int _totalRespondents = 65;

  static const List<ServiceStat> _serviceStats = [
    ServiceStat('교내 공지 알림 서비스', 37),
    ServiceStat('학식 정보 확인 서비스', 27),
    ServiceStat('학사 일정 확인 및\n개인 일정 관리', 22),
    ServiceStat('시간표 자동 입력 및 관리', 29),
    ServiceStat('팀원 모집(스터디/\n튜터링/프로젝트)', 16),
    ServiceStat('장터(교재 등 중고 거래)', 20),
    ServiceStat('챗봇을 통한 교내 정보 확인', 33),
  ];

  static const List<String> _filterOptions = [
    '전체',
    '최근 7일',
    '최근 30일',
  ];

  String _selectedFilter = _filterOptions.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailHeader(title: '피드백 결과 확인'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // CSV 내보내기 처리
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      side: BorderSide(color: ColorStyles.gray3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyles.smallTextRegular,
                      foregroundColor: ColorStyles.black,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.save_alt, size: 16),
                        SizedBox(width: 4),
                        Text('내보내기'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterDropdown(),
                  Text(
                    '총 $_totalRespondents명 응답',
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                '선호하는 기능',
                style: TextStyles.normalTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: ColorStyles.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FeedbackBarChart(stats: _serviceStats),
              ),

              const SizedBox(height: 48),

              _SectionHeader(
                title: '개선 요구사항',
                onTapMore: () {
                  // 개선 의견 전체 보기
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  for (int i = 0; i < _mockImproveFeedbacks.length; i++) ...[
                    FeedbackCard(content: _mockImproveFeedbacks[i]),
                    if (i != _mockImproveFeedbacks.length - 1)
                      const SizedBox(height: 16),
                  ],
                ],
              ),
              const SizedBox(height: 48),

              _SectionHeader(
                title: '추가 기능',
                onTapMore: () {
                  // 추가 기능 의견 전체 보기
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  for (int i = 0; i < _mockAdditionalFeedbacks.length; i++) ...[
                    FeedbackCard(content: _mockAdditionalFeedbacks[i]),
                    if (i != _mockAdditionalFeedbacks.length - 1)
                      const SizedBox(height: 16),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 36,
      decoration: BoxDecoration(
        color: ColorStyles.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorStyles.gray3),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          isDense: true,
          items: _filterOptions
              .map(
                (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyles.smallTextRegular.copyWith(
                  color: ColorStyles.black,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onTapMore,
  });

  final String title;
  final VoidCallback onTapMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.normalTextBold.copyWith(
            color: ColorStyles.black,
          ),
        ),
        InkWell(
          onTap: onTapMore,
          child: Row(
            children: [
              Text(
                '더보기',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray5,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 24,
                color: ColorStyles.gray5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const List<String> _mockImproveFeedbacks = [
  '앱의 주요 기능이 더 잘 보이도록 화면 구조가 정리되면 좋겠습니다. 메뉴 이동 과정을 직관적으로 개선하면 원하는 정보를 더 빠르게 찾을 수 있을 것 같습니다.',
  '알림 기능이 가끔 늦게 오거나 중복으로 오는 경우가 있습니다. 알림 설정을 좀 더 세분화할 수 있으면 좋겠습니다.',
  '시간표 자동 입력 기능이 간헐적으로 실패하는 경우가 있어요. 입력 전 미리보기나 오류 메시지가 더 명확했으면 합니다.',
];

const List<String> _mockAdditionalFeedbacks = [
  '학생들이 학교 생활에 필요한 정보를 한곳에서 확인할 수 있는 통합 서비스가 추가되면 좋겠습니다. 교내 행사 일정, 장학금 안내, 주변 맛집 정보 등이 함께 제공되면 더 활용도가 높아질 것 같습니다.',
  '강의별 과제 마감일과 시험 일정을 한눈에 볼 수 있는 캘린더 기능이 있었으면 합니다.',
  '선호도 기반으로 스터디/프로젝트 팀원을 추천해주는 기능이 있으면 좋겠습니다.',
];
