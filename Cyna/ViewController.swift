//
//  ViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 3/31/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            //User is logged in, do work such as go to next view controller.
        }
    }
    
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        let login = FBSDKLoginManager.alloc()
        let permissions = ["email"]
        login.logInWithReadPermissions(permissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
        if((error) != nil) {
            //Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
        if(result.grantedPermissions.containsObject("email")) {
            //Grab User Data
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                    //saving user data
                    var user = PFObject(className: "User")
                    user["name"] = result.objectForKey("name")
                    user["first_name"] = result.objectForKey("first_name")
                    user["last_name"] = result.objectForKey("last_name")
                    user["gender"] = result.objectForKey("gender")
                    user["email"] = result.objectForKey("email")
                    var userID = result.objectForKey("id") as NSString
                    var facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
                    user["email"] = result.objectForKey("email")
                    user["profile_picture"] = facebookProfileUrl
                    var account = PFObject(className:"Account")
                    account["account_active"] = true
                    account["account_type"] = "user"
                    user["parent"] = account
                    user.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError!) -> Void in
                        if (success) {
                            // The object has been saved.
                            //switch to home view controller
                            print("Saved User!")
                            //saving account data
                        } else {
                            // There was a problem, check error.description
                            print("ERRROR")
                        }
                    }
                })
            }
        }
        }
        })
    }

    @IBOutlet var loginButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

