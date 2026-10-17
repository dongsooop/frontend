import 'package:dongsoop/presentation/chat/chat_bubble_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('일반 메시지를 길게 누르면 메시지 메뉴 콜백을 실행한다', (tester) async {
    var longPressCount = 0;
    await tester.pumpWidget(
      _app(
        ChatBubbleScreen(
          nickname: '상대방',
          senderId: 2,
          message: '신고할 메시지',
          timestamp: '오후 1:00',
          isMe: false,
          type: 'CHAT',
          onLongPress: () => longPressCount += 1,
        ),
      ),
    );

    await tester.longPress(find.text('신고할 메시지'));
    await tester.pump();

    expect(longPressCount, 1);
  });

  testWidgets('시스템 메시지는 길게 눌러도 메시지 메뉴를 열지 않는다', (tester) async {
    var longPressCount = 0;
    await tester.pumpWidget(
      _app(
        ChatBubbleScreen(
          nickname: 'SYSTEM',
          senderId: 0,
          message: '2026년 10월 15일 목요일',
          timestamp: '',
          isMe: false,
          type: 'DATE',
          onLongPress: () => longPressCount += 1,
        ),
      ),
    );

    await tester.longPress(find.text('2026년 10월 15일 목요일'));
    await tester.pump();

    expect(longPressCount, 0);
  });

  testWidgets('닉네임 탭 콜백은 말풍선 길게 누르기와 별도로 유지된다', (tester) async {
    var nicknameTapCount = 0;
    var longPressCount = 0;
    await tester.pumpWidget(
      _app(
        ChatBubbleScreen(
          nickname: '상대방',
          senderId: 2,
          message: '안녕하세요',
          timestamp: '오후 1:00',
          isMe: false,
          type: 'CHAT',
          onNicknameTap: () => nicknameTapCount += 1,
          onLongPress: () => longPressCount += 1,
        ),
      ),
    );

    await tester.tap(find.text('상대방'));
    await tester.pump();

    expect(nicknameTapCount, 1);
    expect(longPressCount, 0);
  });
}

Widget _app(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}
