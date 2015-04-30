//
//  PaymentViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/29/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet var navItem: UINavigationItem!
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "Back")
        self.navItem.leftBarButtonItem = backButton
    }
    func Back(){
        let cameraView = self.storyboard?.instantiateViewControllerWithIdentifier("revealController") as! SWRevealViewController
        self.presentViewController(cameraView, animated: true, completion: nil)
    }
}
