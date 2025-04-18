import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/board/market/detail/widget/botton_button.dart';
import 'package:dongsoop/presentation/board/market/temp/temp_market_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class MarketDetailPageScreen extends StatefulWidget {
  const MarketDetailPageScreen({super.key});

  @override
  State<MarketDetailPageScreen> createState() => _MarketDetailPageScreenState();
}

class _MarketDetailPageScreenState extends State<MarketDetailPageScreen> {
  final market = marketList[0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: DetailHeader(
            title: '판매',
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
          label: '거래하기',
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
                        market['market_state'],
                        style: TextStyles.smallTextBold
                            .copyWith(color: ColorStyles.primaryColor),
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(market['market_title'],
                            style: TextStyles.largeTextBold
                                .copyWith(color: ColorStyles.black)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(market['market_messages'] + '명이 연락했어요',
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
                        Text('''
컴퓨터소프트웨어공학과 2학년 1학기 김희숙 교수님 수업 DB 프로그래밍 교재 판매합니다. 
직거래 희망합니다. 사실 분만 쪽지 주세요

국회는 국가의 예산안을 심의·확정한다. 국가는 대외무역을 육성하며, 이를 규제·조정할 수 있다. 국가는 주택개발정책등을 통하여 모든 국민이 쾌적한 주거생활을 할 수 있도록 노력하여야 한다. 모든 국민은 건강하고 쾌적한 환경에서 생활할 권리를 가지며, 국가와 국민은 환경보전을 위하여 노력하여야 한다. 정당은 법률이 정하는 바에 의하여 국가의 보호를 받으며, 국가는 법률이 정하는 바에 의하여 정당운영에 필요한 자금을 보조할 수 있다. 대통령은 조국의 평화적 통일을 위한 성실한 의무를 진다. 법률안에 이의가 있을 때에는 대통령은 제1항의 기간내에 이의서를 붙여 국회로 환부하고, 그 재의를 요구할 수 있다. 국회의 폐회중에도 또한 같다.'''),
                        SizedBox(height: 32),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: market['market_img'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    market['market_img'][index],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
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
