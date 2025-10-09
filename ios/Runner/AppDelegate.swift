import UIKit

import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    // Create a lazy property to hold the Flutter engine.
    lazy var flutterEngine = FlutterEngine(name: "rainwise.flutter.engine")

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Starts the Flutter engine.
        flutterEngine.run()

        // Register plugins with the shared Flutter engine.
        GeneratedPluginRegistrant.register(with: self.flutterEngine)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

