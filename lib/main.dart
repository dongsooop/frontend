import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/board/recruit/list/recruit_list_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/write/recruit_write_page_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 👇 추가: date picker 등에서 로케일 에러 방지
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
      ],
      initialRoute: '/recruit_write',
      routes: {
        // 특정 페이지 확인용
        '/home': (context) => HomePageScreen(),
        '/mypage': (context) => MyPageScreen(),
        '/chat': (context) => ChatScreen(),
        '/recruit': (context) => RecruitListPageScreen(),
        '/recruit_write': (context) => RecruitWritePageScreen()
      },
    );
  }
}
