import Flutter
import UIKit
import UserNotifications
import flutter_local_notifications
import FirebaseAppCheck
import FirebaseCore

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    #if targetEnvironment(simulator)
      return AppCheckDebugProvider(app: app)
    #else
      if #available(iOS 14.0, *) {
        return AppAttestProvider(app: app)
      } else {
        return DeviceCheckProvider(app: app)
      }
    #endif
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var pushChannel: FlutterMethodChannel?

  private var pendingPushUserInfo: [AnyHashable: Any]?
  private var pendingTapUserInfo: [AnyHashable: Any]?
  private var activeChatRoomId: String?

  private func short(_ v: Any?, max: Int = 140) -> String {
    guard let v = v else { return "nil" }
    let s = String(describing: v)
    if s.count <= max { return s }
    let idx = s.index(s.startIndex, offsetBy: max)
    return String(s[..<idx]) + "…(len=\(s.count))"
  }

  private func typeOf(_ userInfo: [AnyHashable: Any]) -> String {
    return short(userInfo["type"])
  }

  private func msgIdOf(_ userInfo: [AnyHashable: Any]) -> String {
    if let mid = userInfo["gcm.message_id"] { return short(mid) }
    return "nil"
  }

  private func hasAlert(_ userInfo: [AnyHashable: Any]) -> Bool {
    guard let aps = userInfo["aps"] as? [String: Any] else { return false }
    return aps["alert"] != nil
  }

  private func isContentAvailable(_ userInfo: [AnyHashable: Any]) -> Bool {
    guard let aps = userInfo["aps"] as? [String: Any] else { return false }
    if let ca = aps["content-available"] as? Int { return ca == 1 }
    if let ca = aps["content-available"] as? NSNumber { return ca.intValue == 1 }
    if let ca = aps["content-available"] as? String { return ca == "1" }
    return false
  }

  private func logBridge(
    event: String,
    method: String,
    userInfo: [AnyHashable: Any],
    channelReady: Bool,
    queued: Bool
  ) {
    print(
      "[PUSH][iOS][BRIDGE] event=\(event) method=\(method) " +
      "type=\(typeOf(userInfo)) mid=\(msgIdOf(userInfo)) " +
      "alert=\(hasAlert(userInfo)) contentAvail=\(isContentAvailable(userInfo)) " +
      "channelReady=\(channelReady) queued=\(queued)"
    )
  }

  private func invokeToDart(method: String, userInfo: [AnyHashable: Any], event: String) {
    pushChannel?.invokeMethod(method, arguments: userInfo, result: { res in
      print("[PUSH][iOS][BRIDGE] result event=\(event) method=\(method) type=\(self.typeOf(userInfo)) mid=\(self.msgIdOf(userInfo)) res=\(String(describing: res))")
    })
  }

override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {

    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    AppCheck.setAppCheckProviderFactory(MyAppCheckProviderFactory())

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

      if let info = pendingPushUserInfo {
        logBridge(event: "didFinish(flushPendingPush)", method: "onPush", userInfo: info, channelReady: true, queued: false)
        DispatchQueue.main.async { [weak self] in
          self?.invokeToDart(method: "onPush", userInfo: info, event: "didFinish(flushPendingPush)")
        }
        pendingPushUserInfo = nil
      } else {
        print("[PUSH][iOS][BRIDGE] didFinish: no pendingPushUserInfo")
      }

      if let info = pendingTapUserInfo {
        logBridge(event: "didFinish(flushPendingTap)", method: "onPushTap", userInfo: info, channelReady: true, queued: false)
        DispatchQueue.main.async { [weak self] in
          self?.invokeToDart(method: "onPushTap", userInfo: info, event: "didFinish(flushPendingTap)")
        }
        pendingTapUserInfo = nil
      } else {
        print("[PUSH][iOS][BRIDGE] didFinish: no pendingTapUserInfo")
      }
    } else {
      print("[PUSH][iOS][BRIDGE] didFinish: rootViewController is not FlutterViewController (channel not created)")
    }

    return result
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo
    print("[PUSH][iOS] willPresent rawUserInfo=\(userInfo)")

    let type = (userInfo["type"] as? String)?
      .trimmingCharacters(in: .whitespacesAndNewlines)
    let valueRaw = (userInfo["value"] as? String) ?? (userInfo["roomId"] as? String)
    let value = valueRaw?.trimmingCharacters(in: .whitespacesAndNewlines)

    if type == "CHAT", let active = activeChatRoomId, let v = value, active == v {
      completionHandler([])

      if let n = notification.request.content.badge as? NSNumber {
        DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = n.intValue }
      } else if let aps = userInfo["aps"] as? [String: Any],
                let b = aps["badge"] as? Int {
        DispatchQueue.main.async { UIApplication.shared.applicationIconBadgeNumber = b }
      }

      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if self.pushChannel != nil {
          self.logBridge(event: "willPresent(sameChat)", method: "onPush", userInfo: userInfo, channelReady: true, queued: false)
          self.invokeToDart(method: "onPush", userInfo: userInfo, event: "willPresent(sameChat)")
        } else {
          self.logBridge(event: "willPresent(sameChat)", method: "onPush", userInfo: userInfo, channelReady: false, queued: true)
          self.pendingPushUserInfo = userInfo
        }
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
      guard let self = self else { return }
      if self.pushChannel != nil {
        self.logBridge(event: "willPresent", method: "onPush", userInfo: userInfo, channelReady: true, queued: false)
        self.invokeToDart(method: "onPush", userInfo: userInfo, event: "willPresent")
      } else {
        self.logBridge(event: "willPresent", method: "onPush", userInfo: userInfo, channelReady: false, queued: true)
        self.pendingPushUserInfo = userInfo
      }
    }
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    print("[PUSH][iOS] didReceiveTap rawUserInfo=\(userInfo)")

    if pushChannel != nil {
      logBridge(event: "didReceiveTap", method: "onPushTap", userInfo: userInfo, channelReady: true, queued: false)
      DispatchQueue.main.async { [weak self] in
        self?.invokeToDart(method: "onPushTap", userInfo: userInfo, event: "didReceiveTap")
      }
    } else {
      logBridge(event: "didReceiveTap", method: "onPushTap", userInfo: userInfo, channelReady: false, queued: true)
      pendingTapUserInfo = userInfo
    }
    completionHandler()
  }

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    print("[PUSH][iOS] didReceiveRemoteNotification rawUserInfo=\(userInfo)")

    if let aps = userInfo["aps"] as? [String: Any],
       let badge = aps["badge"] as? Int {
      UIApplication.shared.applicationIconBadgeNumber = badge
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if self.pushChannel != nil {
        self.logBridge(event: "didReceiveRemoteNotification", method: "onPush", userInfo: userInfo, channelReady: true, queued: false)
        self.invokeToDart(method: "onPush", userInfo: userInfo, event: "didReceiveRemoteNotification")
      } else {
        self.logBridge(event: "didReceiveRemoteNotification", method: "onPush", userInfo: userInfo, channelReady: false, queued: true)
        self.pendingPushUserInfo = userInfo
      }
    }
    completionHandler(.newData)
  }
}