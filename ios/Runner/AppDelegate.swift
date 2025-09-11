import Flutter
import UIKit
import UserNotifications
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var pushChannel: FlutterMethodChannel?
  private var pendingTapUserInfo: [AnyHashable: Any]?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if let controller = window?.rootViewController as? FlutterViewController {
      pushChannel = FlutterMethodChannel(
        name: "app/push",
        binaryMessenger: controller.binaryMessenger
      )

      pushChannel?.setMethodCallHandler { call, result in
        switch call.method {
        case "setBadge":
          if let args = call.arguments as? [String: Any],
             let count = args["count"] as? Int {
            DispatchQueue.main.async {
              UIApplication.shared.applicationIconBadgeNumber = count
            }
            result(nil)
          } else {
            result(FlutterError(code: "BAD_ARGS",
                                message: "setBadge requires {count: int}",
                                details: nil))
          }

        case "clearBadge":
          DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
          }
          result(nil)

        default:
          result(FlutterMethodNotImplemented)
        }
      }

      if let info = pendingTapUserInfo {
        pushChannel?.invokeMethod("onPushTap", arguments: info)
        pendingTapUserInfo = nil
      }
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }

    if let n = notification.request.content.badge as? NSNumber {
      DispatchQueue.main.async {
        UIApplication.shared.applicationIconBadgeNumber = n.intValue
      }
    }

    pushChannel?.invokeMethod("onPush", arguments: nil)
  }

    @available(iOS 10.0, *)
    override func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let channel = pushChannel {
          channel.invokeMethod("onPushTap", arguments: userInfo)
          channel.invokeMethod("onPush", arguments: nil)
        } else {
          pendingTapUserInfo = userInfo
        }

        completionHandler()
    }


  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    if let aps = userInfo["aps"] as? [String: Any],
       let badge = aps["badge"] as? Int {
      UIApplication.shared.applicationIconBadgeNumber = badge
    }

    pushChannel?.invokeMethod("onPush", arguments: nil)
    completionHandler(.newData)
  }
}
