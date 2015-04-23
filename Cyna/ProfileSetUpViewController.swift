//
//  ProfileSetUpViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/8/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class ProfileSetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveUserInformation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveUserInformation(){
        var currentUser = PFUser.currentUser()
        println(currentUser?.objectId);
        var query = PFUser.query()
        query!.getObjectInBackgroundWithId(currentUser?.objectId! as String!, block: { (result:PFObject?, error:NSError?) -> Void in
            //code
            println(result)
            self.userName.text = result?.objectForKey("name") as? String
            self.userEmail.text = result?.objectForKey("email") as? String
            self.userPhone.text = result?.objectForKey("phone") as? String
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var profileText: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    

}
