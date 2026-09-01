import 'package:dongsoop/core/presentation/components/category_tab_bar.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:dongsoop/presentation/notice/keyword/notice_keyword_section_view.dart';
import 'package:dongsoop/presentation/notice/keyword/providers/notice_keyword_providers.dart';
import 'package:dongsoop/presentation/setting/subscribe_department/subscribe_department_screen.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 통합 설정 화면에서 처음 보여줄 탭.
enum NoticeAlarmSettingTab { department, keyword }

/// 공지 알림을 어떻게 받을지 한곳에서 정하는 화면.
///
/// "어떤 공지 알림을 받을까" 라는 같은 질문에 학과 구독은 *어느 학과*로,
/// 키워드는 *어떤 단어*로 답한다. 둘이 다른 화면에 흩어져 있으면
/// "총학생회 공지만 받기" 같은 설정을 하려고 두 군데를 오가야 한다.
///
/// 학과와 키워드는 종류가 다른 설정이라 상단 탭으로 나누고,
/// 알림/제외는 같은 키워드 목록의 모드라 하단 플로팅으로 한 단계 내렸다.
///
/// 기존 진입점을 그대로 두려고 `/noticeKeyword` 와 `/subscribeDepartmentSetting`
/// 두 경로가 모두 이 화면으로 오되 시작 탭만 다르게 잡는다.
class NoticeAlarmSettingScreen extends HookConsumerWidget {
  final NoticeAlarmSettingTab initialTab;

  const NoticeAlarmSettingScreen({
    super.key,
    this.initialTab = NoticeAlarmSettingTab.department,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(noticeKeywordViewModelProvider.notifier);

    // 키워드는 기기 단위라 로그인 여부와 무관하게 불러온다.
    // 알림/제외가 각각 부르면 같은 요청이 두 번 나가므로 여기서 한 번만 부른다
    useEffect(() {
      Future.microtask(viewModel.loadKeywords);
      return null;
    }, const []);

    ref.listen(noticeKeywordViewModelProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        viewModel.clearError();
      }
    });

    return DefaultTabController(
      length: NoticeAlarmSettingTab.values.length,
      initialIndex: initialTab.index,
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: DetailHeader(
          title: '공지 알림 설정',
          backgroundColor: ColorStyles.white,
          bottom: TabBar(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            labelColor: ColorStyles.primary100,
            labelStyle: TextStyles.normalTextBold,
            unselectedLabelColor: ColorStyles.gray4,
            unselectedLabelStyle: TextStyles.normalTextRegular,
            indicatorColor: ColorStyles.primary100,
            dividerColor: ColorStyles.gray2,
            tabs: const [
              Tab(text: '관심 학과'),
              Tab(text: '키워드'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              SubscribeDepartmentView(),
              _KeywordTab(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 키워드 탭. 알림/제외는 하단 플로팅으로 오간다.
///
/// 학과 탭은 하단에 저장 버튼이 있어 플로팅과 겹치므로 이 탭에서만 띄운다.
class _KeywordTab extends HookWidget {
  const _KeywordTab();

  /// 플로팅에 목록이 가리지 않도록 비워두는 높이
  static const double _floatingGap = 88;

  @override
  Widget build(BuildContext context) {
    final isInclude = useState(true);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: _floatingGap),
          child: NoticeKeywordSectionView(
            type: isInclude.value
                ? NoticeKeywordType.include
                : NoticeKeywordType.exclude,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Center(
            child: CategoryTabBar(
              tabs: const ['알림', '제외'],
              selectedIndex: isInclude.value ? 0 : 1,
              onSelected: (i) => isInclude.value = i == 0,
              isBoard: false,
            ),
          ),
        ),
      ],
    );
  }
}
