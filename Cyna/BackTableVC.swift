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
    override func viewDidLoad() {
        TableArray = ["Become An Expert","Credit/Payment","Logout"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
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