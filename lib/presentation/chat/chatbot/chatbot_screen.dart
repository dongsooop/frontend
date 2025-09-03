import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/chat/chatbot/chatbot_bubble.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatbotScreen extends HookConsumerWidget{
  const ChatbotScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatbotState = ref.watch(chatbotViewModelProvider);
    final viewModel = ref.read(chatbotViewModelProvider.notifier);

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    final List<Map<String, dynamic>> fakeMessages = [
      {
        'isMe': true,
        'text': '군인은 현역을 면한 후가 아니면 국무총리로 임명될 수 없다.',
      },
      {
        'isMe': false,
        'text': '정기회의 회기는 100일을, 임시회의 회기는 30일을 초과할 수 없다.',
      },
      {
        'isMe': true,
        'text': '국회의원의 수는 법률로 정하되, 200인 이상으로 한다. 농업생산성의 제고와 농지의 합리적인 이용을 위하거나 불가피한 사정으로 발생하는 농지의 임대차와 위탁경영은 법률이 정하는 바에 의하여 인정된다.',
      },
      {
        'isMe': false,
        'text': '헌법개정은 국회재적의원 과반수 또는 대통령의 발의로 제안된다.',
      },{
        'isMe': true,
        'text': '대통령의 국법상 행위는 문서로써 하며, 이 문서에는 국무총리와 관계 국무위원이 부서한다. 군사에 관한 것도 또한 같다.',
      },

    ];

    useEffect(() {
      if (chatbotState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CustomConfirmDialog(
              title: '채팅 오류',
              content: chatbotState.errorMessage!,
              onConfirm: () {
                context.pop();
                context.pop();
              },
              confirmText: '확인',
              dismissOnConfirm: false,
              isSingleAction: true,
            ),
          );
        });
      }
      return null;
    }, [chatbotState.errorMessage]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorStyles.gray1,
      appBar: DetailHeader(
        title: '챗봇 동냥이',
        backgroundColor: ColorStyles.gray1,
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
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: fakeMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        // final msg = fakeMessages[index];
                        return ChatbotBubble(
                          text: fakeMessages[index]['text'],
                          isMe: fakeMessages[index]['isMe'],
                          isLoading: false,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ),
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
                          onPressed: () {
                            final text = textController.text.trim();
                            if (text.isNotEmpty && text != '') {
                              textController.clear();
                              scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}