//
//  BumpViewController.swift
//  Bump-Firebase
//
//  Created by Ryan Johnson on 2/7/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.
//

import UIKit
import CoreMotion

var sid = ""

class BumpViewController: UIViewController {
    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    var timer:NSTimer!
    var timeout:NSTimer!
    var AccelManage:CMMotionManager!
    var timeoutShouldContinue = true
    override func viewDidLoad() {
        AccelManage = CMMotionManager()
        AccelManage.startAccelerometerUpdates()
        Message.numberOfLines = 0;
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("PollAccelerometer"), userInfo: nil, repeats: true)
        println(timer.timeInterval)
        
        gref.childByAppendingPath("clients/\(auth.uid)").removeValue()
        gref.childByAppendingPath("clients/\(auth.uid)").observeEventType(FEventType.ChildAdded, withBlock: {(snapshot:FDataSnapshot!) in
            var data: AnyObject! = snapshot.value
            var type: AnyObject! = data.objectForKey("type");
            println("data to client")
            if ("\(type)" == "confirm_request"){
                self.timeout.invalidate();
                self.timeoutShouldContinue = false
                self.Message.text = "Peer Found. Waiting  for Confirmation"
                var from: AnyObject? = data.objectForKey("from")
                var fromName: AnyObject? = data.objectForKey("fromName")
                var confirmalert = UIAlertController(title: "Bump Partner Found", message: "Would you like to pair with \(fromName!)?", preferredStyle: UIAlertControllerStyle.Alert)
                
                confirmalert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    
                    self.confirm(snapshot)
                }))
                
                confirmalert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    self.Spinner.stopAnimating()
                    self.Message.text = "Connection Cancelled"
                }))
                self.presentViewController(confirmalert, animated: true, completion: nil)
            } else if ("\(type)" == "session_confirmed"){
//                self.navigationController!.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("selectshare") as UIViewController, animated: true, completion: {})
                self.performSegueWithIdentifier("test", sender: self)
            } else {
                println("flerp?")
            }
            
            
        })
        super.viewDidLoad()
    }
    
    func PollAccelerometer(){
        //println(AccelManage)
        if (AccelManage.accelerometerActive){
            if (AccelManage.accelerometerData?.acceleration != nil){
                println(AccelManage.accelerometerData.acceleration.x)
                if (abs(AccelManage.accelerometerData.acceleration.x) > 1.5){
                    BumpButton(self)
                }
            }
        } else {
            println("innactive")
        }
        
        
    }
    
    @IBAction func BumpButton(sender: AnyObject) {
        
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue(["timestamp": "\(round(NSDate().timeIntervalSince1970 as Double))", "type": "bump", "uid": auth.uid])
        Message.text = "Looking for peer..."
        Spinner.startAnimating()
        
        self.timeout = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("BumpTimeout"), userInfo: nil, repeats: false)
        timeoutShouldContinue = true
    }
    
    func BumpTimeout(){
        if (timeoutShouldContinue){
            Message.text = "Peer Not Found. Please retry and verify that your peer's device is working"
            Spinner.stopAnimating()
        }
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