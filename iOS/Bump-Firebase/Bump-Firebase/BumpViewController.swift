//
//  BumpViewController.swift
//  Bump-Firebase
//
//  Created by Ryan Johnson on 2/7/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.
//

import UIKit
var sid = ""
class BumpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        gref.childByAppendingPath("clients/\(auth.uid)").removeValue()
        gref.childByAppendingPath("clients/\(auth.uid)").observeEventType(FEventType.ChildAdded, withBlock: {(snapshot:FDataSnapshot!) in
            var data: AnyObject! = snapshot.value
            var type: AnyObject! = data.objectForKey("type");
            println("data to client")
            if ("\(type)" == "confirm_request"){
                var from: AnyObject? = data.objectForKey("from")
                var confirmalert = UIAlertController(title: "Bump Partner Found", message: "Would you like to pair with \(from!)?", preferredStyle: UIAlertControllerStyle.Alert)
                
                confirmalert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    
                    self.confirm(snapshot)
                }))
                
                confirmalert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    //Do nothing
                }))
                self.presentViewController(confirmalert, animated: true, completion: nil)
            } else if ("\(type)" == "session_confirmed"){
//                self.navigationController!.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("selectshare") as UIViewController, animated: true, completion: {})
                self.performSegueWithIdentifier("test", sender: self)
            } else {
                println("flerp?")
            }
            
            
        })
    }
    
    @IBAction func BumpButton(sender: AnyObject) {
        
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue(["timestamp": "\(round(NSDate().timeIntervalSince1970 as Double))", "type": "bump", "uid": auth.uid])
    }
    
    func confirm(snapshot:FDataSnapshot){
        var data: AnyObject! = snapshot.value
        var from: AnyObject? = data.objectForKey("from")
        var sidd: AnyObject? = data.objectForKey("sessionId")
        
        var dictionary = ["type": "confirmed", "uid": "\(auth.uid!)", "from": "\(from!)", "sessionId": "\(sidd!)"]
        
        sid = "\(sidd!)"
        
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue(dictionary)

    }
}