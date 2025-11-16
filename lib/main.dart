import 'dart:io';

import 'package:dongsoop/core/app_scaffold_messenger.dart';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/core/storage/firebase_messaging_service.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:dongsoop/core/storage/notification_permission_service.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:dongsoop/firebase_options.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:dongsoop/presentation/app/push_sync_controller.dart';
import 'domain/chat/model/chat_message.dart';
import 'domain/chat/model/chat_room_detail.dart';
import 'domain/chat/model/chat_room_member.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // .env 파일 로드
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  try {
    final token = await FirebaseAppCheck.instance.getToken();
    print('[AppCheck] token=$token');
  } catch (e) {
    print('[AppCheck] getToken error at boot: $e');
  }


  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);

  await Hive.initFlutter();
  Hive.registerAdapter(LocalTimetableInfoAdapter());
  Hive.registerAdapter(ChatRoomMemberAdapter());
  Hive.registerAdapter(ChatRoomDetailAdapter());
  Hive.registerAdapter(ChatMessageAdapter());

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
  DateTime? _lastBadgeRefreshAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ref.read(pushSyncControllerProvider);

    FirebaseMessagingService.instance().setReadCallback(
          (int id) => ref.read(notificationViewModelProvider.notifier).read(id),
    );
    FirebaseMessagingService.instance().setBadgeRefreshCallback(
          () => _refreshBadgeThrottled(ref, force: false),
    );
    FirebaseMessagingService.instance().setBadgeCallback(
          (int n) => ref.read(notificationBadgeViewModelProvider.notifier).setBadge(n),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationPermissionServiceProvider).requestOnce();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshBadgeThrottled(ref, force: false);
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
      _refreshBadgeThrottled(ref, force: false);
    }
  }

  Future<void> _refreshBadgeThrottled(WidgetRef ref, {required bool force}) async {
    final now = DateTime.now();
    if (!force &&
        _lastBadgeRefreshAt != null &&
        now.difference(_lastBadgeRefreshAt!) < const Duration(milliseconds: 350)) {
      return;
    }
    _lastBadgeRefreshAt = now;
    try {
      await ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge(force: force);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        scaffoldBackgroundColor: ColorStyles.white,
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ColorStyles.gray2.withValues(alpha: 0.4), // 선택된 영역 배경색
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
