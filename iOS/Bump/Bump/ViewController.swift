//
//  ViewController.swift
//  Bump
//
//  Created by Ryan Johnson on 2/7/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PBPebbleCentralDelegate {
    @IBOutlet weak var Subtitle: UILabel!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    var watch:PBWatch?
    var timer:NSTimer!
    var i = 0;
    
    var uuid:[UInt8] = [0x13, 0x32, 0x15, 0xF0, 0xCF, 0x20, 0x4c, 0x05, 0x99, 0x7B, 0x3c, 0x9b, 0xE5, 0xA6, 0x4E, 0x5b]
    
    var data:NSData!
    
    override func viewDidLoad() {
        data = NSData(bytes: uuid, length: uuid.count)
        var central = PBPebbleCentral.defaultCentral()
        central.delegate = self;
        central.appUUID = data
        
        watch = central.lastConnectedWatch()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("CheckBT"), userInfo: nil, repeats: true)

        watch!.appMessagesAddReceiveUpdateHandler({(watch:PBWatch!, data:[NSObject:AnyObject]!) in
            
            println(data)
            return true
        })
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func CheckBT(){
        if (watch == nil){
            i++
            println("looking... \(i) \(Optional(watch))")
        }else{
            println(Optional(watch))
            timer.invalidate()
            Spinner.stopAnimating()
            Subtitle.text = "Connected to \(watch!.name)"
        }
    }

    @IBAction func PushMSG(sender: AnyObject) {
        
        
        watch!.appMessagesPushUpdate([0: "asd", 3: "derp"], withUUID: data, onSent: {(watch, data, error) in
            println((watch, data, error))
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

