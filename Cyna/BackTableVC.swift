//
//  BackTableVC.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/29/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import Foundation


class BackTableVC: UITableViewController {
    var TableArray = [String]()
    var account_id: String = ""
    override func viewDidLoad() {
        TableArray = ["Edit Profile","Become An Expert","Logout"]
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderWidth = 0;
        self.setProfilePic()
    }
    
    @IBOutlet var name: UILabel!
    @IBOutlet var credit: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileView: UIView!
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    func setProfilePic(){
        var currentUser = PFUser.currentUser()
        println(currentUser?.objectId);
        var query = PFUser.query()
        query!.getObjectInBackgroundWithId(currentUser?.objectId! as String!, block: { (result:PFObject?, error:NSError?) -> Void in
            //code
            var pic_url = result?.objectForKey("profile_picture") as! String
            var name = result?.objectForKey("name") as! String
            var credit = result?.objectForKey("credit") as! String
            let url = NSURL(string: pic_url)
            var imageData :NSData = NSData(contentsOfURL: url!)!
            var bgImage = UIImage(data:imageData)
            self.profileImage.image = bgImage
            self.name.text = name
            self.credit.text = credit + " credits"
        })
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(TableArray[indexPath.row] == "Logout") {
            PFUser.logOut()
            let homeView = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            self.presentViewController(homeView, animated: true, completion: nil)
        }
    }
    //use below to check for log out
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var DestVC = segue.destinationViewController as! CameraViewController
//        var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
    
//        DestVC.varView = indexPath.row
//    }
}