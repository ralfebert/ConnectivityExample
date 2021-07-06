// Example project ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import Foundation
import WatchConnectivity

class PhoneMessaging: NSObject, ObservableObject {
    @Published var messages = [String]()

    var session: WCSession?

    override init() {
        self.session = WCSession.default
        super.init()
        self.session?.delegate = self
        self.session?.activate()
    }

    func requestInfo() {
        let request = ["request": "date"]
        session?.sendMessage(
            request,
            replyHandler: { response in
                debugPrint("Received response", response)
                DispatchQueue.main.async {
                    self.messages.append("Reply: \(response)")
                }
            },
            errorHandler: { error in
                debugPrint("Error sending message:", error)
            }
        )
    }
}

extension PhoneMessaging: WCSessionDelegate {
    func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("activationDidCompleteWith activationState:\(activationState.rawValue), error: \(String(describing: error))")
    }
}
