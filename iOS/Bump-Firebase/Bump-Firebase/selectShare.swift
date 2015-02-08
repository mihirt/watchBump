//
//  File.swift
//  Bump-Firebase
//
//  Created by Ryan Johnson on 2/7/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.
//

import UIKit

class selectShare: UIViewController {
    
    @IBOutlet weak var Ammt: UITextField!
    override func viewDidLoad() {

        gref.childByAppendingPath("clients/\(auth.uid)").observeEventType(FEventType.ChildAdded, withBlock: {(snapshot:FDataSnapshot!) in
            var data: AnyObject! = snapshot.value
            var type: AnyObject! = data.objectForKey("type")
            var msg: AnyObject! = data.objectForKey("message")
            println("data to client")
            if ("\(type)" == "action_notification"){
                var from: AnyObject? = data.objectForKey("from")
                var confirmalert = UIAlertController(title: "You received a Message!", message: "\(msg)", preferredStyle: UIAlertControllerStyle.Alert)
                
                confirmalert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction!) in
                    //Do nothing
                }))
                self.presentViewController(confirmalert, animated: true, completion: nil)
            } else {
                println("flerp?")
            }
        });
        super.viewDidLoad()
    
    }
    @IBAction func destroy(sender: AnyObject) {
        self.performSegueWithIdentifier("returnToBump", sender: self)
    }
    @IBAction func SendContactInfo(sender: AnyObject) {
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue(["type": "action_request", "action": "send_contact", "contact": "Unicorns and Rainbows", "uid": auth.uid, "sessionId": sid])
    }
    @IBAction func illumani(sender: AnyObject) {
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue(["type": "action_request", "action": "pay", "amount": Ammt.text, "uid": auth.uid, "sessionId": sid])
    }
}