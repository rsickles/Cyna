//
//  BecomeExpertViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/29/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class BecomeExpertViewController: UIViewController {

    @IBOutlet var barButton: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "Back")
        self.barButton.leftBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Back(){
        let cameraView = self.storyboard?.instantiateViewControllerWithIdentifier("revealController") as! SWRevealViewController
        self.presentViewController(cameraView, animated: true, completion: nil)
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
