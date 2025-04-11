import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        // 특정 페이지 확인용
        '/home': (context) => HomePageScreen(),
        '/mypage': (context) => MyPageScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
