import 'dart:io';

import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // .env 파일을 로드

  // // 공지 API 호출 테스트 코드
  // final dio = Dio();
  // final repository = NoticeRepositoryImpl(dio);
  // final useCase = NoticeUseCase(repository);
  //
  // try {
  //   final notices = await useCase(page: 0);
  //   logger.i('공지 개수: ${notices.length}');
  //   for (final notice in notices) {
  //     loggerNoStack.i('[공지] ${notice.title} | ${notice.createdAt}');
  //   }
  // } catch (e, st) {
  //   logger.e('공지 API 호출 중 에러 발생', error: e, stackTrace: st);
  // }

  if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        scaffoldBackgroundColor: ColorStyles.white,
        useMaterial3: true,
      ),
      routerConfig: router,
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
    );
  }
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
