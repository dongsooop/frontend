import 'package:dongsoop/presentation/board/common/board_tap_section.dart';
import 'package:dongsoop/presentation/board/common/board_write_button.dart';
import 'package:dongsoop/presentation/board/market/temp/temp_market_data.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListPageScreen extends StatefulWidget {
  const MarketListPageScreen({super.key});

  @override
  State<MarketListPageScreen> createState() => _MarketListPageScreenState();
}

String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) return '방금 전';
  if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
  if (difference.inHours < 24) return '${difference.inHours}시간 전';
  if (difference.inDays < 7) return '${difference.inDays}일 전';

  return '${dateTime.year}. ${dateTime.month}. ${dateTime.day}. ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

class _MarketListPageScreenState extends State<MarketListPageScreen> {
  int selectedMarketIndex = 0; // 판매(0), 구매(1)

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> marketData;
    switch (selectedMarketIndex) {
      case 1:
        marketData = marketList;
        break;
      default:
        marketData = marketList;
        break;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        floatingActionButton: WriteButton(
            onPressed: () => Navigator.pushNamed(context, '/market/write')),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: marketData.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return BoardTabSection(
                selectedCategoryIndex: 1,
                selectedSubTabIndex: selectedMarketIndex,
                subTabs: ['판매', '구매'],
                onCategorySelected: (categoryIndex) {
                  if (categoryIndex == 0) {
                    // 모집 페이지로 이동
                    Navigator.pushReplacementNamed(context, '/recruit/list');
                  }
                },
                onSubTabSelected: (subIndex) {
                  setState(() {
                    selectedMarketIndex = subIndex;
                  });
                },
              );
            }

            final market = marketData[index - 1];
            final isLastItem = index - 1 == marketData.length - 1;
            return MarketListItem(
              market: market,
              isLastItem: isLastItem,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/market/detail',
                  arguments: {'id': market['id']},
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MarketListItem extends StatelessWidget {
  final Map<String, dynamic> market;
  final VoidCallback onTap;
  final bool isLastItem;

  const MarketListItem({
    super.key,
    required this.market,
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
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: market['market_img'] == null ||
                                    market['market_img'].isEmpty
                                ? ColorStyles.gray1
                                : null,
                          ),
                          child: market['market_img'] == null ||
                                  market['market_img'].isEmpty
                              ? Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/image_not_supported.svg',
                                    width: 32,
                                    height: 32,
                                    colorFilter: const ColorFilter.mode(
                                      ColorStyles.gray3,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    market['market_img'],
                                    width: 88,
                                    height: 88,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                market['market_title'],
                                style: TextStyles.largeTextRegular.copyWith(
                                  color: ColorStyles.black,
                                ),
                              ),
                              Text(
                                formatRelativeTime(market['market_created_at']),
                                style: TextStyles.smallTextRegular.copyWith(
                                  color: ColorStyles.gray4,
                                ),
                              ),
                              Text(
                                '${market['market_prices']}원',
                                style: TextStyles.largeTextBold.copyWith(
                                  color: ColorStyles.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (market['market_messages'] != 0)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Icon(Icons.textsms_outlined,
                                color: ColorStyles.gray4, size: 24),
                            const SizedBox(width: 4),
                            Text(
                              market['market_messages'].toString(),
                              style: TextStyles.smallTextRegular
                                  .copyWith(color: ColorStyles.gray4),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (!isLastItem)
            const Divider(
              color: ColorStyles.gray2,
              height: 1,
            ),
        ],
      ),
    );
  }
}
