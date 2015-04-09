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
    }
    
    override func viewDidAppear(animated: Bool) {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            //User is logged in, then just go to view controller
            //self.goToHomeScreen()
        }
    }
    
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        let login = FBSDKLoginManager.alloc()
        let permissions = ["email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            println(user)
            if let user = user {
                if user.isNew {
                    self.create_new_user(user)
                    self.setUpProfile()
                } else {
                    println("User logged in through Facebook!")
                    self.goToHomeScreen()
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })

    }
    
    func create_new_user(user:PFUser) {
        FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            user.email = result.objectForKey("email") as String
            user["name"] = result.objectForKey("name")
            user["first_name"] = result.objectForKey("first_name")
            user["last_name"] = result.objectForKey("last_name")
            user["gender"] = result.objectForKey("gender")
            user["email"] = result.objectForKey("email")
            var userID = result.objectForKey("id") as NSString
            var facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
            user["profile_picture"] = facebookProfileUrl
            var account = PFObject(className:"Account")
            account["account_active"] = true
            account["account_type"] = "user"
            user["parent"] = account
            user.saveInBackground()
        }
    }
    
    func setUpProfile(){
        let profile_setup = self.storyboard?.instantiateViewControllerWithIdentifier("profile_setup") as ProfileSetUpViewController
        self.presentViewController(profile_setup, animated: true, completion: nil)
    }
    
    func goToHomeScreen(){
        let cameraView = self.storyboard?.instantiateViewControllerWithIdentifier("cameraView") as CameraViewController
        self.presentViewController(cameraView, animated: true, completion: nil)
    }

    @IBOutlet var loginButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

