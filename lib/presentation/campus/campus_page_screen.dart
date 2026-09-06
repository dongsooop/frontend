import 'package:dongsoop/core/presentation/components/login_required_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/presentation/campus/widgets/campus_link_card.dart';
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
import 'package:intl/intl.dart';

/// 학교 다니면서 쓰는 것들을 모아둔 탭.
///
/// 게시판이 빠진 자리다. 맛집·학식·도서관·챗봇은 "모임" 이 아니라 "탐색" 에
/// 가까워서 탭 이름도 모여봐요에서 캠퍼스로 바꿨다.
class CampusPageScreen extends ConsumerWidget {
  const CampusPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final user = ref.watch(userSessionProvider);

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('M월 d일 EEEE', 'ko').format(today),
                    style: TextStyles.smallTextBold.copyWith(
                      color: ColorStyles.gray5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '캠퍼스',
                    style: TextStyles.titleTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                ],
              ),
            ),
            const CampusSearchBar(),
            CampusSection(
              title: '오늘 뭐 먹지',
              action: InkWell(
                onTap: () => context.pushNamed('restaurants'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '전체',
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: ColorStyles.gray5),
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
            CampusSection(
              title: '캠퍼스 생활',
              child: Column(
                children: [
                  CampusLinkCard(
                    emoji: '📚',
                    title: '도서관',
                    description: '열람실 좌석 확인하기',
                    background: ColorStyles.gray1,
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
                    background: ColorStyles.gray1,
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
