//
//  ViewController.swift
//  ConnectivityExample
//
//  Created by Ralf Ebert on 13/09/15.
//  Copyright © 2015 Example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var connectivityHandler : ConnectivityHandler!
    var counter = 0

    @IBOutlet weak var messagesLabel: UILabel!
    
    @IBAction func sendMessage(sender: AnyObject) {
        connectivityHandler.session.sendMessage(["msg" : "Message \(++counter)"], replyHandler: nil) { (error) in
            NSLog("Error sending message: %@", error)
        }
    }
    
    @IBAction func updateAppContext(sender: AnyObject) {
        try! connectivityHandler.session.updateApplicationContext(["msg" : "Message \(++counter)"])
    }
    
    @IBAction func transferUserInfo(sender: AnyObject) {
        connectivityHandler.session.transferUserInfo(["msg" : "Message \(++counter)"])
    }
    
    var observeConnectivityHandler = false {
        didSet {
            guard oldValue != observeConnectivityHandler else { return }
            
            if observeConnectivityHandler {
                connectivityHandler.addObserver(self, forKeyPath: "messages", options: NSKeyValueObservingOptions(), context: nil)
            } else {
                connectivityHandler.removeObserver(self, forKeyPath: "messages")
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === connectivityHandler {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.updateMessages()
            })
        }
    }
    
    func updateMessages() {
        self.messagesLabel.text = self.connectivityHandler.messages.joinWithSeparator("\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectivityHandler = (UIApplication.sharedApplication().delegate as? AppDelegate)?.connectivityHandler
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.observeConnectivityHandler = true
        updateMessages()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.observeConnectivityHandler = false
    }
    
    deinit {
        self.observeConnectivityHandler = false
    }

}

