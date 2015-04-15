//
//  RateViewController.swift
//  Cyna
//
//  Created by Varsha Balasubramaniam on 4/9/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {


    @IBOutlet var ratingView: RateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Required float rating view params
        self.ratingView.emptyImage = UIImage(named: "EmptyStar")
        self.ratingView.fullImage = UIImage(named: "FullStar")
        // Optional params
        self.ratingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.rating = 0
        self.ratingView.editable = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
