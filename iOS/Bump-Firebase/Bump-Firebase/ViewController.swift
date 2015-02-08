//
//  ViewController.swift
//  Bump-Firebase
//
//  Created by Ryan Johnson on 2/7/15.
//  Copyright (c) 2015 Ryan Johnson. All rights reserved.

import UIKit
var gref:Firebase!
var auth:FAuthData!
class ViewController: UIViewController {
    var ref:Firebase!
    
    
    override func viewDidLoad() {
        ref = Firebase(url: "https://kvtest.firebaseio.com")
        gref = ref

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func FacebookIt(sender: AnyObject) {
        FBSession.openActiveSessionWithReadPermissions(["public_profile","email"], allowLoginUI: true,
            completionHandler: { (session:FBSession!, state:FBSessionState, error:NSError!) in
                if error != nil {
                    println("Facebook login failed. Error \(error)")
                } else if state.rawValue == FBSessionState.Open.rawValue {
                    let accessToken = session.accessTokenData.accessToken
                    self.ref.authWithOAuthProvider("facebook", token: accessToken,
                        withCompletionBlock: { error, authData in
                            if error != nil {
                                println("Login failed. \(error)")
                            } else {
                                println("Logged in! \(authData)")
                                self.doLoggedInAction(authData)
                            }
                    })
                }
        })
    }
    
    func doLoggedInAction(authData:FAuthData){
        println(authData.uid)
        auth = authData

        gref.childByAppendingPath("users/\(auth.uid)").setValue(auth.providerData)
        
        self.navigationController!.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("mainview") as UIViewController, animated: true, completion: {})
    }

    @IBAction func Logout(sender: AnyObject) {
        ref.unauth()
        var session = FBSession.activeSession()
        session.closeAndClearTokenInformation()
    }
}

