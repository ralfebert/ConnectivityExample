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
    
    @IBAction func requestInfo() {
        session?.sendMessage(["request" : "date"], replyHandler: { (response) in
            
            self.messages.append("Reply: \(response)")
            
            }, errorHandler: { (error) -> Void in
                NSLog("Error sending message: %@", error)
        })
    }

    // MARK: - Controller lifecycle
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        session = WCSession.defaultSession()
        session?.delegate = self
        session?.activateSession()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
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
    

}
