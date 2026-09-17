import 'package:dongsoop/domain/eclass/enum/eclass_link_restore_result.dart';
import 'package:dongsoop/domain/notification/entity/push_event.dart';
import 'package:dongsoop/firebase_options.dart';
import 'package:dongsoop/providers/eclass_link_restore_providers.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _backgroundRelinkTimeout = Duration(seconds: 25);

Future<EclassLinkRestoreResult?> handleEclassRelinkPush({
  required Object? type,
  required Future<EclassLinkRestoreResult> Function() restore,
  Future<void> Function()? onRestored,
  Duration timeout = _backgroundRelinkTimeout,
}) async {
  if (!isEclassRelinkPush(type)) return null;

  final result = await restore().timeout(timeout);
  if (result == EclassLinkRestoreResult.restored) {
    await onRestored?.call();
  }
  return result;
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!isEclassRelinkPush(message.data['type'])) return;

  ProviderContainer? container;
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode
          ? const AppleDebugProvider()
          : const AppleAppAttestWithDeviceCheckFallbackProvider(),
    );
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

    if (!dotenv.isInitialized) {
      await dotenv.load();
    }

    container = ProviderContainer();
    final refreshStore = container.read(eclassRelinkRefreshStoreProvider);
    await handleEclassRelinkPush(
      type: message.data['type'],
      restore: () => container!
          .read(eclassLinkRestoreControllerProvider)
          .restoreIfExpired(),
      onRestored: refreshStore.markRefreshRequired,
    );
  } catch (_) {
    // Silent push failures are retried by the existing app-start restore flow.
  } finally {
    container?.dispose();
  }
}
