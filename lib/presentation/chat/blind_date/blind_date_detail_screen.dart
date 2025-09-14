import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/chat/widgets/match_vote_bottom_sheet.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlindDateDetailScreen extends HookConsumerWidget {

  const BlindDateDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider
    final state = ref.watch(blindDateDetailViewModelProvider);
    final viewModel = ref.read(blindDateDetailViewModelProvider.notifier);

    // user
    final user = ref.watch(userSessionProvider);
    final int? userId = user?.id;
    final String nickname = '익명 3';

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      if (userId != null)
        Future.microtask(() {
          viewModel.connect(userId);
        });

      return () async {
        Future.microtask(() => viewModel.disconnect());
      };
    }, const []);

    useEffect(() {
      // Future.microtask(() async {
      //   viewModel.joinBlindDate();
      // });

      return () {
        // Future.microtask(() {
        //   viewModel.close();
        // });
      };
    }, []);

    // useEffect(() {
    //   if (state.errorMessage != null) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (_) => CustomConfirmDialog(
    //           title: '과팅 오류',
    //           content: state.errorMessage!,
    //           onConfirm: () {
    //             context.pop();
    //             context.pop();
    //           },
    //           confirmText: '확인',
    //           dismissOnConfirm: false,
    //           isSingleAction: true,
    //         ),
    //       );
    //     });
    //   }
    //   return null;
    // }, [state.errorMessage]);

    // if (state.isLoading) {
    //   return Scaffold(
    //     backgroundColor: ColorStyles.white,
    //     appBar: DetailHeader(
    //       title: '',
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         spacing: 8,
    //         children: [
    //           CircularProgressIndicator(color: ColorStyles.primaryColor,),
    //           SizedBox(height: 16,),
    //           Text(
    //             '참여자를 모집하고 있어요...',
    //             style: TextStyles.normalTextRegular.copyWith(
    //               color: ColorStyles.black,
    //             ),
    //           ),
    //           Text(
    //             '${state.participants.toString()}/7',
    //             style: TextStyles.normalTextBold.copyWith(
    //               color: ColorStyles.black,
    //             ),
    //           ),
    //         ],
    //       )
    //     ),
    //   );
    // }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorStyles.gray1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          backgroundColor: ColorStyles.gray1,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text(
                '모여봐요 동숲',
                style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
              ),
              Text(
                state.participants.toString(),
                style: TextStyles.largeTextRegular.copyWith(color: ColorStyles.gray3),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              context.pop(true);
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 24,
              color: ColorStyles.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: EdgeInsets.only(top: 24),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                  ),
                ),

                // 채팅 입력창
                Container(
                  width: double.infinity,
                  height: 52,
                  margin: EdgeInsets.only(top: 16, bottom: 24),
                  padding: EdgeInsets.only(left: 16, right: 8),
                  decoration: ShapeDecoration(
                    color: ColorStyles.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: null,
                          cursorColor: ColorStyles.gray4,
                          keyboardType: TextInputType.multiline,
                          controller: textController,
                          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                          decoration: InputDecoration(border: InputBorder.none,),
                        ),
                      ),
                      SizedBox(
                        height: 44,
                        width: 44,
                        child: IconButton(
                          onPressed: () async {
                            // 한 프레임 뒤에서 바텀시트 실행 필요
                            await MatchVoteBottomSheet.show(
                              context,
                              candidates: ['익명1', '익명2', '익명3', '익명4', '익명5', '익명6', '익명7'],
                              onSubmit: (selected) async {
                                print('selected: $selected');
                                // selected == null 이면 미선택
                                // 서버 전송 로직 작성
                                // await repo.sendVote(selected);
                              },
                              seconds: 10, // 기본 10초
                            );
                            // textController.clear();
                            // // 스크롤 맨 아래로 이동
                            // scrollController.animateTo(
                            //   0,
                            //   duration: const Duration(milliseconds: 300),
                            //   curve: Curves.easeInOut,
                            // );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/send.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              ColorStyles.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}