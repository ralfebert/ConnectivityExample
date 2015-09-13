//
//  InterfaceController.swift
//  ConnectivityExample WatchKit Extension
//
//  Created by Ralf Ebert on 13/09/15.
//  Copyright © 2015 Example. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class MessageRow : NSObject {
    
    @IBOutlet var label: WKInterfaceLabel!
    
}

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var session : WCSession?
    var counter = 0

    // MARK: - IB
    
    @IBAction func requestInfo() {
        session?.sendMessage(["request" : "date"], replyHandler: { (response) in
            
            self.messages.append("Reply: \(response)")
            
            }, errorHandler: { (error) -> Void in
                NSLog("Error sending message: %@", error)
        })
    }
    
    @IBAction func sendMessage() {
        session?.sendMessage(["msg" : "Message \(++counter)"], replyHandler: nil) { (error) in
            NSLog("Error sending message: %@", error)
        }
    }

    @IBAction func updateAppContext(sender: AnyObject) {
        try! session?.updateApplicationContext(["msg" : "Message \(++counter)"])
    }
    
    @IBAction func transferUserInfo(sender: AnyObject) {
        session?.transferUserInfo(["msg" : "Message \(++counter)"])
    }
    
    // MARK: - Controller lifecycle
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        session = WCSession.defaultSession()
        session?.delegate = self
        session?.activateSession()
    }
    
    // MARK: - Messages Table
    
    @IBOutlet var messagesTable: WKInterfaceTable!

    var messages = [String]() {
        didSet {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.updateMessagesTable()
            }
        }
    }
    
    func updateMessagesTable() {
        let msgCount = messages.count
        messagesTable.setNumberOfRows(msgCount, withRowType: "MessageRow")
        for(var i = 0; i < msgCount; i++) {
            let row = messagesTable.rowControllerAtIndex(i) as! MessageRow
            row.label.setText(messages[i])
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Notification)
        
        let msg = message["msg"]!
        self.messages.append("Message \(msg)")
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let msg = applicationContext["msg"]!
        self.messages.append("AppContext \(msg)")
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let msg = userInfo["msg"]!
        self.messages.append("UserInfo \(msg)")
    }

}
