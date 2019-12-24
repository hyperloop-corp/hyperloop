import UIKit
import Flutter
import GoogleMaps
import Keys

let keys = RunnerKeys()

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey(keys.googleMapsAPIKey)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
