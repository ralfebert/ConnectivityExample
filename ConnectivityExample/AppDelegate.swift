// Beispielprojekt ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connectivityHandler: ConnectivityHandler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if WCSession.isSupported() {
            self.connectivityHandler = ConnectivityHandler()
        } else {
            debugPrint("WCSession not supported (f.e. on iPad).")
        }

        return true
    }

}
