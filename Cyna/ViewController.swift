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
    var inactive_status = false
    
    override func viewDidAppear(animated: Bool) {
        var currentUser = PFUser.currentUser()
        println("ONE");
        if(FBSDKAccessToken.currentAccessToken() != nil){
            println("TWO");
            //check if user is active
            if (currentUser != nil) {
                println("HERE");
                self.user_is_active({ (active:Bool) -> () in
                    if(active){
                        self.goToHomeScreen()
                    }else {
                        //wait for user to try to login then flash alert
                        self.inactive_status = true;
                    }
                })
            }
        }
}
    
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        if(self.inactive_status==true) {
            self.show_inactive_alert()
        } else {
            self.loginUser()
        }
    }
    
    func loginUser(){
        let login = FBSDKLoginManager.alloc()
        let permissions = ["email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user:PFUser?, error:NSError?) -> Void in
            println(user)
            if let user = user {
                if user.isNew {
                    self.create_new_user(user)
                    self.setUpProfile()
                } else {
                    self.goToHomeScreen()
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }

        }
}
    
    func create_new_user(user:PFUser) {
        FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            user.email = result.objectForKey("email") as? String
            user["name"] = result.objectForKey("name")
            user["first_name"] = result.objectForKey("first_name")
            user["last_name"] = result.objectForKey("last_name")
            user["gender"] = result.objectForKey("gender")
            user["email"] = result.objectForKey("email")
            var userID = result.objectForKey("id")as! NSString
            var facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
            user["profile_picture"] = facebookProfileUrl
            user["account_active"] = true
            user["account_type"] = "user"
            user.saveInBackground()
        }
    }
    
    func setUpProfile(){
        let profile_setup = self.storyboard?.instantiateViewControllerWithIdentifier("profile_setup") as! ProfileSetUpViewController
        self.presentViewController(profile_setup, animated: true, completion: nil)
    }
    
    func goToHomeScreen(){
        let cameraView = self.storyboard?.instantiateViewControllerWithIdentifier("cameraView")as! CameraViewController
        self.presentViewController(cameraView, animated: true, completion: nil)
    }
    
    func user_is_active(completion:(Bool) -> ()) {
        var currentUser = PFUser.currentUser()
        println(currentUser?.objectId);
        var query = PFUser.query()
        query!.getObjectInBackgroundWithId(currentUser?.objectId! as String!, block: { (result:PFObject?, error:NSError?) -> Void in
            //code
            if(result!.objectForKey("account_active") as! Bool == true) {
                                completion(true)
                            }
                            else {
                                completion(false)
                            }

        })
           }
    
    func show_inactive_alert(){
        var alert = UIAlertController(title: "Hey", message: "You are inactive", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBOutlet var loginButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

