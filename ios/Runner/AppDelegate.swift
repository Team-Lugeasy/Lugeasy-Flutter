import Flutter
import UIKit
import GoogleMaps
import Foundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if let apiKey = ProcessInfo.processInfo.environment["GOOGLE_MAP_API_URL"] {
        GMSServices.provideAPIKey(apiKey)
    } else {
        print("API 키를 찾을 수 없습니다.")
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
