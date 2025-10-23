import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/home/providers/chatbot_provider.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chatbot_bubble.dart';

class ChatbotScreen extends HookConsumerWidget{
  const ChatbotScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatbotMessagesProvider);
    final chatbotState = ref.watch(chatbotViewModelProvider);
    final viewModel = ref.read(chatbotViewModelProvider.notifier);

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      Future.microtask(() => viewModel.init());
      return null;
    }, const []);

    useEffect(() {
      textController.addListener(() {
        viewModel.onChanged(textController.text.trim());
      });
      return null;
    }, [textController]);

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
            margin: EdgeInsets.only(top: 8),
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
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final msg = messages[index];
                        return ChatbotBubble(
                          text: msg.text,
                          isMe: msg.isMe,
                          isLoading: msg.typing,
                          isSystem: msg.isSystem,
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
                          maxLength: 64,
                          cursorColor: ColorStyles.gray4,
                          keyboardType: TextInputType.multiline,
                          controller: textController,
                          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '최대 64글자까지 입력 가능해요',
                            hintStyle: TextStyles.normalTextRegular.copyWith(color: ColorStyles.gray4),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            counterText: '',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 44,
                        width: 44,
                        child: IconButton(
                          onPressed: () {
                            if (!chatbotState.isEnabled || chatbotState.isLoading) return;

                            final text = textController.text.trim();
                            if (text.isNotEmpty && text != '') {
                              viewModel.sendChatbotMessage(text);

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
                            colorFilter: ColorFilter.mode(
                              (!chatbotState.isEnabled || chatbotState.isLoading)
                                  ? ColorStyles.gray4
                                  : ColorStyles.primaryColor,
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