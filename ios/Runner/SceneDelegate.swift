import UIKit
import Flutter

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        // Get the AppDelegate to access the shared FlutterEngine.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }

        self.window = UIWindow(windowScene: windowScene)

        // Create a FlutterViewController attached to the shared engine.
        let flutterViewController = FlutterViewController(
            engine: appDelegate.flutterEngine,
            nibName: nil,
            bundle: nil
        )

        self.window?.rootViewController = flutterViewController
        self.window?.makeKeyAndVisible()
    }
}
