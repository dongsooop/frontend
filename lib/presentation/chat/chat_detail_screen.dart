import 'package:dongsoop/presentation/chat/chat_bubble_screen.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dongsoop/main.dart';
import 'package:go_router/go_router.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  ChatDetailScreenState createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends State<ChatDetailScreen> {
  // controller
  final scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  // 더미데이터
  final String uid = '1';
  final List<Map<String, dynamic>> fakeMessages = [
    {
      'userId': '1',
      'nickname': '익명1',
      'message': '얼마까지 알아보고 오셨어요?',
      'timestamp': '오전 10:15',
    },
    {
      'userId': '2',
      'nickname': '익명2',
      'message': '운영체제 실습 족보 판매 보고 연락 드렸습니다.',
      'timestamp': '오전 10:14',
    },
    {
      'userId': '1',
      'nickname': '익명1',
      'message': '안녕하세요!',
      'timestamp': '오전 10:13',
    },
    {
      'userId': '2',
      'nickname': '익명2',
      'message': '안녕하세요',
      'timestamp': '오전 10:12',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 가상 키보드가 나타날 때 Scattoldㅇ 가 자동으로 크기를 조정하여 가상 키보드와 겹치지 않도록 함
        backgroundColor: ColorStyles.gray1,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: ColorStyles.gray1,
            title: Text(
              '운영체제 실습 족보',
              style: TextStyles.largeTextBold.copyWith(
                color: ColorStyles.black
              ),
            ),
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.chevron_left_outlined,
                size: 24,
                color: ColorStyles.black,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // 메뉴 선택 메소드 실행
                },
                icon: SvgPicture.asset(
                  'assets/icons/kebab_menu.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.black,
                    BlendMode.srcIn,
                  ),
                ),
              )
            ],
          )
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 24),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus(); // 채팅 리스트 터치 시 가상 키보드 숨기기
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.separated(
                      reverse: true, // 리스트 아이템을 역순으로 배치
                      shrinkWrap: true, // 상단 배치(Align)
                      controller: scrollController, // 스크롤 위치 컨트롤러
                      itemCount: fakeMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChatBubbleScreen(
                          fakeMessages[index]['nickname'],
                          fakeMessages[index]['message'],
                          fakeMessages[index]['timestamp'],
                          fakeMessages[index]['userId'].toString() == uid,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 52,
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.only(left: 16, right: 8),
                decoration: ShapeDecoration(
                  color: ColorStyles.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: textController,
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.black
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() { });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      width: 44,
                      child: IconButton(
                        onPressed: () {
                          sendMessage();
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
    );
  }

  void sendMessage() {
    final message = textController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      fakeMessages.insert(0, {
        'userId': '1',
        'nickname': '익명1',
        'message': message,
        'timestamp': '오후 9:22',
      });
    });

    textController.clear();

    // 스크롤 맨 아래로 이동
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    logger.i(fakeMessages);
  }
}