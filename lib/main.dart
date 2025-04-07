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
      routes: {
        // 특정 페이지 확인용
        '/mypage': (context) => MyPageScreen()
      },
    );
  }
}