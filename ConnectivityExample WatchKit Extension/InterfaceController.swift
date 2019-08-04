// Beispielprojekt ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import Foundation
import WatchConnectivity
import WatchKit

class MessageRow: NSObject {

    @IBOutlet var label: WKInterfaceLabel!

}

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var messagesTable: WKInterfaceTable!

    var session: WCSession?
    var counter = 0

    @IBAction func requestInfo() {
        self.session?.sendMessage(["request": "date"],
                                  replyHandler: { response in
                                      self.messages.append("Reply: \(response)")
                                  },
                                  errorHandler: { error in
                                      print("Error sending message: %@", error)
        })
    }

    @IBAction func sendMessage() {
        self.counter += 1
        self.session?.sendMessage(["msg": "Message \(counter)"], replyHandler: nil) { error in
            debugPrint("Error sending message: \(error)")
        }
    }

    @IBAction func updateAppContext() {
        self.counter += 1
        try! self.session?.updateApplicationContext(["msg": "Message \(counter)"])
    }

    @IBAction func transferUserInfo() {
        self.counter += 1
        self.session?.transferUserInfo(["msg": "Message \(counter)"])
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.messages.append("ready")
    }

    override func willActivate() {
        super.willActivate()

        self.session = WCSession.default
        self.session?.delegate = self
        self.session?.activate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: - Messages Table

    var messages = [String]() {
        didSet {
            OperationQueue.main.addOperation {
                self.updateMessagesTable()
            }
        }
    }

    func updateMessagesTable() {
        let messages = self.messages
        self.messagesTable.setNumberOfRows(messages.count, withRowType: "MessageRow")
        for (i, msg) in messages.enumerated() {
            let row = self.messagesTable.rowController(at: i) as! MessageRow
            row.label.setText(msg)
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let msg = message["msg"]!
        self.messages.append("Message \(msg)")
        WKInterfaceDevice.current().play(.notification)
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
