import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback onTapChatDetail;
  const ChatScreen({super.key, required this.onTapChatDetail});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  String selectedCategory = '전체';
  String selectedMode = '채팅';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(
                 width: double.infinity,
                 height: 44,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   spacing: 16,
                   children: [
                     _buildTopTab(
                       label: '채팅',
                       isSelected: selectedMode == '채팅',
                       onTap: () {
                         setState(() {
                           selectedMode = '채팅';
                         });
                       },
                     ),
                     _buildTopTab(
                       label: '과팅',
                       isSelected: selectedMode == '과팅', // 추후 기능 개발
                       onTap: () {
                         // 추후 기능 개발
                         setState(() {
                           selectedMode = '채팅';
                         });
                       },
                     ),
                   ],
                 ),
               ),
              SizedBox(height: 16),

              // search bar
              Container(
                width: double.infinity,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: ShapeDecoration(
                  color: ColorStyles.gray1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // search page
                      },
                      icon: Icon(
                        Icons.search,
                        color: ColorStyles.gray3,
                        size: 24,
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),

              // chatting category
              SizedBox(
                width: double.infinity,
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    _buildChatCategoryTab(
                      label: '전체',
                      isSelected: selectedCategory == '전체',
                      onTap: () {
                        setState(() {
                          selectedCategory = '전체';
                        });
                      },
                    ),
                    _buildChatCategoryTab(
                      label: '모집',
                      isSelected: selectedCategory == '모집',
                      onTap: () {
                        setState(() {
                          selectedCategory = '모집';
                        });
                      },
                    ),
                    _buildChatCategoryTab(
                      label: '학습자료',
                      isSelected: selectedCategory == '학습자료',
                      onTap: () {
                        setState(() {
                          selectedCategory = '학습자료';
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // 채팅방
              _buildChat(
                title: 'DB 프로그래밍',
                tag: '#컴퓨터소프트웨어공학과 #DB #A+',
                num: '12',
                time: '오후 12:45',
                messegeNum: '99+'
              ),
              SizedBox(height: 32),
              _buildChat(
                  title: 'SQLD 자격증 취득 스터디',
                  tag: '#컴퓨터소프트웨어공학과 #자격증 #SQLD',
                  num: '3',
                  time: '어제',
                  messegeNum: '1'
              )
            ],
          ),
        ),
      ),
    );
  }

  // 상단 탭
  Widget _buildTopTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? TextStyles.titleTextBold.copyWith(
              color: ColorStyles.primaryColor,
            )
                : TextStyles.titleTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ),
      ),
    );
  }

  // 채팅 카테고리 선택
  Widget _buildChatCategoryTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        child: Center(
          child: isSelected
              ? IntrinsicWidth(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorStyles.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                label,
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          )
              : Text(
            label,
            style: TextStyles.largeTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ),
      ),
    );
  }

  // 채팅방
  Widget _buildChat({
    required String title,
    required String tag,
    required String num,
    required String time,
    required String messegeNum,
  }) {
    return GestureDetector(
      onTap: widget.onTapChatDetail,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/test.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        title,
                        style: TextStyles.normalTextBold.copyWith(
                          color: ColorStyles.black
                        ),
                      ),
                      Text(
                        num,
                        style: TextStyles.smallTextRegular.copyWith(
                          color: ColorStyles.gray4
                        ),
                      ),
                    ],
                  ),
                  Text(
                    tag,
                    style: TextStyles.smallTextRegular.copyWith(
                      color: ColorStyles.gray4
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Text(
                  time,
                  style: TextStyles.smallTextRegular.copyWith(
                    color: ColorStyles.gray4
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: ShapeDecoration(
                    color: ColorStyles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    )
                  ),
                  child: Text(
                    messegeNum,
                    style: TextStyles.smallTextBold.copyWith(
                      color: ColorStyles.white
                    ),
                    textAlign: TextAlign.center,
                  )
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}