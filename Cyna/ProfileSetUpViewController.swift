//
//  ProfileSetUpViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/8/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class ProfileSetUpViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var profileText: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveUserInformation()
        // Do any additional setup after loading the view.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        menuButton.action = "revealToggle:"
        menuButton.target = self.revealViewController()
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
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
//            self.profileImage.layer.masksToBounds = true
//            self.profileImage.layer.borderWidth = 0;

            
            self.userName.text = result?.objectForKey("name") as? String
            self.userEmail.text = result?.objectForKey("email") as? String
            var imagePath = result?.objectForKey("profile_picture") as? String
            self.profileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string:imagePath!)!)!)
            self.profileImage.contentMode = UIViewContentMode.ScaleAspectFit
            self.profileText.text =
                result?.objectForKey("profile_information") as? String
        })
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
//    
    @IBAction func savePressed(sender: AnyObject) {
        println ("Button is pressed!")
        var text = profileText.text
        var currentUser = PFUser.currentUser()
        var query = PFQuery(className:"_User")
        query.getObjectInBackgroundWithId(currentUser?.objectId! as String!) {
            (gameScore: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let gameScore = gameScore {
                gameScore["profile_information"] = text
                gameScore.saveInBackground()
            }
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
