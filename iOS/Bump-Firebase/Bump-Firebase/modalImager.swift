//
//  modalImager.swift
//  Bump-Firebase
//
//  Created by Ryan Johnson on 2/8/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.
//

import UIKit

class modalImager: UIViewController{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        var decode = NSData(base64EncodedString: photo, options: NSDataBase64DecodingOptions.allZeros)
        var decodedimage = UIImage(data: decode!)
        img.image = decodedimage;
        super.viewDidLoad()
    }
    @IBAction func exit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Save(sender: AnyObject) {
        //UIImageWriteToSavedPhotosAlbum(img.image!, self, Selector("doneSave"), nil);
        UIImageWriteToSavedPhotosAlbum(img.image!, nil, nil, nil);
    }
    func doneSave(){
        label.text = "Saved!"
    }
}
