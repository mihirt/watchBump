//
//  File.swift
//  Bump-Firebase
//
//  Created by Ryan Johnson on 2/7/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.
//

import UIKit
var photo:String = ""
class selectShare: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ipc:UIImagePickerController!
    @IBOutlet weak var Ammt: UITextField!
    override func viewDidLoad() {

        gref.childByAppendingPath("clients/\(auth.uid)").observeEventType(FEventType.ChildAdded, withBlock: {(snapshot:FDataSnapshot!) in
            var data: AnyObject! = snapshot.value
            var type: AnyObject! = data.objectForKey("type")
            var msg: AnyObject! = data.objectForKey("message")
            println("data to client")
            if ("\(type)" == "action_notification"){
                if (data.objectForKey("action") as String == "send_photo"){
                    photo = data.objectForKey("photo") as String
                    self.performSegueWithIdentifier("modalImage", sender: self)
                } else {
                    var from: AnyObject? = data.objectForKey("fromName")
                    var confirmalert = UIAlertController(title: "You received a Message!", message: "\(msg)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    confirmalert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction!) in
                        //Do nothing
                    }))
                    self.presentViewController(confirmalert, animated: true, completion: nil)
                }
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
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue(["type": "action_request", "action": "pay", "amount": Ammt.text, "uid": auth.uid!, "sessionId": sid])
    }
    @IBAction func selectImage(sender: AnyObject) {
        var ipc = UIImagePickerController()
        ipc.delegate = self
        presentViewController(ipc, animated: true, completion: {})
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        var imageData = UIImagePNGRepresentation(image)
        var strenc = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        gref.childByAppendingPath("serverEvents").childByAutoId().setValue([
            "type": "action_request",
            "action": "send_photo",
            "photo": strenc,
            "uid": auth.uid!,
            "sessionId": sid
            ])
        
        /*var decode = NSData(base64EncodedString: strenc, options: NSDataBase64DecodingOptions.allZeros)
        var decodedimage = UIImage(data: decode!)*/
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}