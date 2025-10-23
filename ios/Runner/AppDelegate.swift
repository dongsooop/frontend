import Flutter
import UIKit
import UserNotifications
import flutter_local_notifications
import FirebaseAppCheck
import FirebaseCore

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    if #available(iOS 14.0, *) {
      return AppAttestProvider(app: app)
    } else {
      return DeviceCheckProvider(app: app)
    }
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var pushChannel: FlutterMethodChannel?
  private var pendingTapUserInfo: [AnyHashable: Any]?
  private var activeChatRoomId: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppCheck.setAppCheckProviderFactory(MyAppCheckProviderFactory())
    FirebaseApp.configure()

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    DispatchQueue.main.async {
      UIApplication.shared.registerForRemoteNotifications()
    }

    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      pushChannel = FlutterMethodChannel(
        name: "app/push",
        binaryMessenger: controller.binaryMessenger
      )

      pushChannel?.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
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

        case "setActiveChat":
          if let args = call.arguments as? [String: Any],
             let rid = (args["roomId"] as? String)?
              .trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
             !rid.isEmpty {
            self.activeChatRoomId = rid
          }
          result(nil)

        case "clearActiveChat":
          self.activeChatRoomId = nil
          result(nil)


        default:
          result(FlutterMethodNotImplemented)
        }
      }

      if let info = pendingTapUserInfo {
        DispatchQueue.main.async { [weak self] in
          self?.pushChannel?.invokeMethod("onPushTap", arguments: info)
        }
        pendingTapUserInfo = nil
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo

    let type = (userInfo["type"] as? String)?
      .trimmingCharacters(in: .whitespacesAndNewlines)
    let valueRaw = (userInfo["value"] as? String) ?? (userInfo["roomId"] as? String)
    let value = valueRaw?
      .trimmingCharacters(in: .whitespacesAndNewlines)

    if type == "CHAT", let active = activeChatRoomId, let v = value, active == v {
      completionHandler([])

      if let n = notification.request.content.badge as? NSNumber {
        DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = n.intValue }
      } else if let aps = userInfo["aps"] as? [String: Any],
                let b = aps["badge"] as? Int {
        DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = b }
      }

      DispatchQueue.main.async { [weak self] in
        self?.pushChannel?.invokeMethod("onPush", arguments: userInfo)
      }
      return
    }

    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }

    if let n = notification.request.content.badge as? NSNumber {
      DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = n.intValue }
    } else if let aps = userInfo["aps"] as? [String: Any],
              let b = aps["badge"] as? Int {
      DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = b }
    }

    DispatchQueue.main.async { [weak self] in
      self?.pushChannel?.invokeMethod("onPush", arguments: userInfo)
    }
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    if let channel = pushChannel {
      DispatchQueue.main.async {
        channel.invokeMethod("onPushTap", arguments: userInfo)
      }
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
    DispatchQueue.main.async { [weak self] in
      self?.pushChannel?.invokeMethod("onPush", arguments: userInfo)
    }
    completionHandler(.newData)
  }
}
