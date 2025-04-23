import 'package:dongsoop/presentation/board/board_page_screen.dart';
import 'package:dongsoop/presentation/board/market/detail/market_detail_page_screen.dart';
import 'package:dongsoop/presentation/board/market/write/market_write_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/detail/recruit_detail_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/detail/recruit_support_page_screen.dart';
import 'package:dongsoop/presentation/board/recruit/write/recruit_write_page_screen.dart';
import 'package:dongsoop/presentation/calendar/calendar_page_screen.dart';
import 'package:dongsoop/presentation/chat/chat_detail_screen.dart';
import 'package:dongsoop/presentation/chat/chat_screen.dart';
import 'package:dongsoop/presentation/home/home_page_screen.dart';
import 'package:dongsoop/presentation/home/notice_list_page_screen.dart';
import 'package:dongsoop/presentation/my_page/my_page_screen.dart';
import 'package:dongsoop/presentation/schedule/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // date picker 등에서 로케일 에러 방지(한국어 사용을 위함)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
      ],
      initialRoute: '/board/list',
      routes: {
        // 특정 페이지 확인용
        '/home': (context) => HomePageScreen(),
        '/notice/list': (context) => NoticeListPageScreen(),
        '/mypage': (context) => MyPageScreen(),
        '/chat': (context) => ChatScreen(),
        '/chatDetail': (context) => ChatDetailScreen(),
        '/schedule': (context) => ScheduleScreen(),
        '/board/list': (context) => BoardPageScreen(),
        '/recruit/write': (context) => RecruitWritePageScreen(),
        '/recruit/detail': (context) => RecruitDetailPageScreen(),
        '/recruit/support': (context) => RecruitSupportPageScreen(),
        '/market/write': (context) => MarketWritePageScreen(),
        '/market/detail': (context) => MarketDetailPageScreen(),
        '/calendar': (context) => CalendarPageScreen(),
      },
    );
  }
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
