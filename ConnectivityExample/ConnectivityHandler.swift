// Beispielprojekt ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import AudioToolbox
import Foundation
import WatchConnectivity

class ConnectivityHandler: NSObject, WCSessionDelegate {

    var session = WCSession.default

    @objc dynamic var messages = [String]()

    override init() {
        super.init()

        self.session.delegate = self
        self.session.activate()

        debugPrint("Paired Watch: \(self.session.isPaired), Watch App Installed: \(self.session.isWatchAppInstalled)")
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        debugPrint("sessionDidBecomeInactive: \(session)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        debugPrint("sessionDidDeactivate: \(session)")
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        debugPrint("sessionWatchStateDidChange: \(session)")

        debugPrint("Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")

    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        debugPrint("didReceiveMessage: \(message)")
        if message["request"] as? String == "date" {
            self.messages.append("Watch requested info")
            replyHandler(["date": "\(Date())"])
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let msg = message["msg"]!
        self.messages.append("Message \(msg)")
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        let msg = applicationContext["msg"]!
        self.messages.append("AppContext \(msg)")
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        let msg = userInfo["msg"]!
        self.messages.append("UserInfo \(msg)")
    }

}
