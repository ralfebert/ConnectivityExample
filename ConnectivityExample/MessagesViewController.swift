// Beispielprojekt ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet var messages: UILabel!

    var connectivityHandler: ConnectivityHandler!
    var counter = 0

    @IBAction func sendMessage() {
        self.counter += 1
        self.connectivityHandler.session.sendMessage(["msg": "Message \(counter)"], replyHandler: nil) { error in
            debugPrint("Error sending message: \(error)")
        }
    }

    @IBAction func updateAppContext() {
        self.counter += 1
        try! self.connectivityHandler.session.updateApplicationContext(["msg": "Message \(counter)"])
    }

    @IBAction func transferUserInfo() {
        self.counter += 1
        self.connectivityHandler.session.transferUserInfo(["msg": "Message \(counter)"])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.connectivityHandler = (UIApplication.shared.delegate as? AppDelegate)?.connectivityHandler
    }

    var messagesObservation: NSKeyValueObservation?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateMessages()
        self.messagesObservation = self.connectivityHandler.observe(\.messages) { _, _ in
            OperationQueue.main.addOperation {
                self.updateMessages()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messagesObservation = nil
    }

    func updateMessages() {
        self.messages.text = self.connectivityHandler.messages.joined(separator: "\n")
    }

}
