import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let externalUrlChannelName = "com.minjeong.mateya/external_url"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: externalUrlChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, callback in
        guard call.method == "openUrl" else {
          callback(FlutterMethodNotImplemented)
          return
        }

        guard
          let rawUrl = call.arguments as? String,
          let url = URL(string: rawUrl)
        else {
          callback(false)
          return
        }

        self?.openExternal(url: url, callback: callback)
      }
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func openExternal(url: URL, callback: @escaping FlutterResult) {
    DispatchQueue.main.async {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:]) { opened in
          callback(opened)
        }
      } else {
        callback(false)
      }
    }
  }
}
