import 'dart:io';

import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/core/storage/firebase_messaging_service.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:dongsoop/firebase_options.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'domain/chat/model/chat_message.dart';
import 'domain/chat/model/chat_room_detail.dart';
import 'domain/chat/model/chat_room_member.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM Token: $fcmToken");

  await Hive.initFlutter();
  Hive.registerAdapter(LocalTimetableInfoAdapter());
  Hive.registerAdapter(ChatRoomMemberAdapter());
  Hive.registerAdapter(ChatRoomDetailAdapter());
  Hive.registerAdapter(ChatMessageAdapter());

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

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  static const MethodChannel _pushChannel = MethodChannel('app/push');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    FirebaseMessagingService.instance().setReadCallback(
          (int id) => ref.read(notificationViewModelProvider.notifier).read(id),
    );

    FirebaseMessagingService.instance().setBadgeRefreshCallback(
          () => ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge(force: true),
    );

    FirebaseMessagingService.instance().setBadgeCallback(
          (int n) => ref.read(notificationBadgeViewModelProvider.notifier).setBadge(n),
    );

    _pushChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPush':
        // 배지/목록 동기화(사일런트, 포그라운드 수신 등)
          await ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge(force: true);
          break;

        case 'onPushTap':
          final raw = call.arguments;
          if (raw is Map) {
            final args = raw.map((k, v) => MapEntry(k.toString(), v));
            final type = args['type']?.toString();
            final value = args['value']?.toString();
            final id = int.tryParse(args['id']?.toString() ?? '');
            final badge = int.tryParse(args['badge']?.toString() ?? '');

            if (type != null && value != null) {
              try {
                await Future.microtask(() {});
                await PushRouter.routeFromTypeValue(type: type, value: value);
              } catch (_) {}
            }

            if (id != null && id > 0) {
              try {
                await ref.read(notificationViewModelProvider.notifier).read(id);
              } catch (_) {}
            }

            if (badge != null) {
              ref.read(notificationBadgeViewModelProvider.notifier).setBadge(badge);
            } else {
              await ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge(force: true);
            }
          }
          break;
      }
      return;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        scaffoldBackgroundColor: ColorStyles.white,
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ColorStyles.gray2, // 선택된 영역 배경색
          cursorColor: ColorStyles.gray4,               // 커서 색상
          selectionHandleColor: ColorStyles.gray4 // 핸들 색상 (양 끝 점)
        ),
        appBarTheme: AppBarTheme(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
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
