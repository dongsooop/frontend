import 'dart:io';

import 'package:dongsoop/core/providers/user_provider.dart';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'domain/chat/model/chat_message.dart';
import 'domain/chat/model/chat_room_member.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Hive(local DB) 초기화
  Hive.registerAdapter(ChatRoomMemberAdapter()); // 채팅방 참여자 목록
  Hive.registerAdapter(ChatMessageAdapter()); // 채팅 내역

  await dotenv.load(); // .env 파일 로드

  if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // 앱 시작 시 유저 정보 (.env 또는 나중에 secure storage)
    Future.microtask(() {
      ref.read(userProvider.notifier).loadUser();
    });
  }

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

      // DatePicker 등에서 한국어 오류 방지
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
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
