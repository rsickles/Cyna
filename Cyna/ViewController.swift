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
        super.viewDidLoad()
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            // User is logged in, do work such as go to next view controller.
//        } else {
//            //must log user in
//            let login = FBSDKLoginManager.alloc()
//            let permissions = ["email"]
//            login.logInWithReadPermissions(permissions, handler: { (result:FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
//                print(result)
//            })
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

