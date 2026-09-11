import 'package:dongsoop/core/presentation/components/admob_banner_ad.dart';
import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_link_card.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_map_preview.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_meal_card.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_restaurant_list.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_search_bar.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_section.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 학교 다니면서 쓰는 것들을 모아둔 탭.
///
/// 게시판이 빠진 자리다. 맛집·학식·도서관·챗봇은 "모임" 이 아니라 "탐색" 에
/// 가까워서 탭 이름도 모여봐요에서 캠퍼스로 바꿨다.
class CampusPageScreen extends ConsumerWidget {
  const CampusPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Text(
                '캠퍼스',
                style: TextStyles.titleTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
            ),
            const CampusSearchBar(),
            CampusSection(
              // `오늘 뭐 먹지` 는 앱이 골라 주는 것처럼 들린다. 실제로는
              // 학생들이 올리고 좋아요로 정렬된 목록이라 그대로 말한다
              title: '학생들이 추천한 맛집',
              // 눈에 잘 띄는 자리를 올리는 쪽에 준다. 전체 목록으로 가는
              // 길은 목록 끝 카드에 남겼다
              action: InkWell(
                onTap: () async {
                  if (user == null) {
                    await LoginRequiredDialog(context);
                    return;
                  }
                  if (!context.mounted) return;
                  context.push(RoutePaths.restaurantsWrite);
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '추천하러 가기',
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.primary100,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios,
                          size: 12, color: ColorStyles.primary100),
                    ],
                  ),
                ),
              ),
              child: const CampusRestaurantList(),
            ),
            // 날짜는 제목이 아니라 판 안에 둔다. 좌우로 넘기면 날짜가 따라
            // 바뀌어야 하는데, 제목에 두면 화면이 페이지 상태를 들고 있어야
            // 한다. 홈도 같은 이유로 판 안에 둔다
            const CampusSection(
              title: '학식',
              child: CampusMealCard(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: AdmobBannerAd(),
            ),
            CampusSection(
              title: '우리 학교 알아보기',
              child: CampusMapPreview(
                onTap: () => context.push(RoutePaths.campusMap),
              ),
            ),
            // 홈과 같은 자리 — 마지막 구획 바로 앞이다. 구획 사이에 두면
            // 스크롤 도중 갑자기 끼어들고, 맨 아래에 두면 거의 안 보인다
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: AdmobBannerAd(),
            ),
            CampusSection(
              title: '캠퍼스 생활',
              // 카드마다 다른 색 면을 준다. 셋이 모두 회색이던 자리라 무엇이
              // 무엇인지 이모지로만 갈렸다. 일정의 민트와 수업의 파랑은 홈
              // 오늘 카드에서 쓰는 뜻을 그대로 가져온다
              child: Column(
                children: [
                  CampusLinkCard(
                    emoji: '🗺️',
                    title: '캠퍼스 지도',
                    description: '교내 건물 위치 확인하기',
                    background: ColorStyles.primary5,
                    onTap: () => context.push(RoutePaths.campusMap),
                  ),
                  const SizedBox(height: 10),
                  CampusLinkCard(
                    emoji: '📚',
                    title: '도서관',
                    description: '열람실 좌석 확인하기',
                    background: ColorStyles.amberBg,
                    onTap: () => context.pushNamed('libraryWebView'),
                  ),
                  const SizedBox(height: 10),
                  CampusLinkCard(
                    emoji: '💬',
                    title: '학사 챗봇',
                    description: '학사일정·수강신청 물어보기',
                    background: ColorStyles.primary5,
                    onTap: () async {
                      if (user == null) {
                        await LoginRequiredDialog(context);
                        return;
                      }
                      context.push(RoutePaths.chatbot);
                    },
                  ),
                  const SizedBox(height: 10),
                  CampusLinkCard(
                    emoji: '🗓️',
                    title: '학사일정',
                    description: '이번 학기 주요 일정 보기',
                    background: ColorStyles.mintBg,
                    onTap: () => context.push(RoutePaths.schedule),
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
