//
//  RateView.swift
//  Cyna
//
//  Created by Varsha Balasubramaniam on 4/9/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

public class RateView: UIView {
    
    
    private var emptyImageViews: [UIImageView] = []
    
    private var fullImageViews: [UIImageView] = []
    
    @IBInspectable public var emptyImage: UIImage? {
        didSet {
            for imageView in self.emptyImageViews {
                imageView.image = emptyImage
            }
            self.refresh()
        }
    }
    @IBInspectable public var fullImage: UIImage? {
        didSet {
            for imageView in self.fullImageViews {
                imageView.image = fullImage
            }
            self.refresh()
        }
    }
    
    
    var imageContentMode: UIViewContentMode = UIViewContentMode.ScaleAspectFit
    
    /**
    Minimum rating.
    */
    @IBInspectable public var minRating: Int  = 0 {
        didSet {
            // Update current rating if needed
            if self.rating < minRating {
                self.rating = minRating
                self.refresh()
            }
        }
    }
    
    /**
    Max rating value.
    */
    @IBInspectable public var maxRating: Int = 5 {
        didSet {
            let needsRefresh = maxRating != oldValue
            
            if needsRefresh {
                self.removeImageViews()
                self.initImageViews()
                
                // Relayout and refresh
                self.setNeedsLayout()
                self.refresh()
            }
        }
    }
    
    /**
    Minimum image size.
    */
    @IBInspectable public var minImageSize: CGSize = CGSize(width: 5.0, height: 5.0)
    
    /**
    Set the current rating.
    */
    @IBInspectable public var rating: Int = 0 {
        didSet {
            if rating != oldValue {
                self.refresh()
            }
        }
    }
    
    /**
    Sets whether or not the rating view can be changed by panning.
    */
    @IBInspectable public var editable: Bool = true
    
    
    
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initImageViews()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initImageViews()
    }
    
    
    func refresh() {
        for i in 0..<self.fullImageViews.count {
            let imageView = self.fullImageViews[i]
            
            if self.rating>=(i+1) {
                imageView.layer.mask = nil
                imageView.hidden = false
            }
            else {
                imageView.layer.mask = nil;
                imageView.hidden = true
            }
        }
    }
    
    // MARK: Layout helper classes
    
    // Calculates the ideal ImageView size in a given CGSize
    func sizeForImage(image: UIImage, inSize size:CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSizeMake(width, size.height)
        }
        else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSizeMake(size.width, height)
        }
    }
    
    // Override to calculate ImageView frames
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let emptyImage = self.emptyImage {
            let desiredImageWidth = self.frame.size.width / CGFloat(self.emptyImageViews.count)
            let maxImageWidth = max(self.minImageSize.width, desiredImageWidth)
            let maxImageHeight = max(self.minImageSize.height, self.frame.size.height)
            let imageViewSize = self.sizeForImage(emptyImage, inSize: CGSizeMake(maxImageWidth, maxImageHeight))
            let imageXOffset = (self.frame.size.width - (imageViewSize.width * CGFloat(self.emptyImageViews.count))) /
                CGFloat((self.emptyImageViews.count - 1))
            
            for i in 0..<self.maxRating {
                let imageFrame = CGRectMake(i==0 ? 0:CGFloat(i)*(imageXOffset+imageViewSize.width), 0, imageViewSize.width, imageViewSize.height)
                
                var imageView = self.emptyImageViews[i]
                imageView.frame = imageFrame
                
                imageView = self.fullImageViews[i]
                imageView.frame = imageFrame
            }
            
            self.refresh()
        }
    }
    
    func removeImageViews() {
        // Remove old image views
        for i in 0..<self.emptyImageViews.count {
            var imageView = self.emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = self.fullImageViews[i]
            imageView.removeFromSuperview()
        }
        self.emptyImageViews.removeAll(keepCapacity: false)
        self.fullImageViews.removeAll(keepCapacity: false)
    }
    
    func initImageViews() {
        if self.emptyImageViews.count != 0 {
            return
        }
        
        // Add new image views
        for i in 0..<self.maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = self.imageContentMode
            emptyImageView.image = self.emptyImage
            self.emptyImageViews.append(emptyImageView)
            self.addSubview(emptyImageView)
            
            let fullImageView = UIImageView()
            fullImageView.contentMode = self.imageContentMode
            fullImageView.image = self.fullImage
            self.fullImageViews.append(fullImageView)
            self.addSubview(fullImageView)
        }
    }
    
    // MARK: Touch events
    
    // Calculates new rating based on touch location in view
    func handleTouchAtLocation(touchLocation: CGPoint) {
        if !self.editable {
            return
        }
        
        var newRating: Int = 0
        for i in stride(from: (self.maxRating-1), through: 0, by: -1) {
            let imageView = self.emptyImageViews[i]
            if touchLocation.x > imageView.frame.origin.x {
                newRating = i + 1
                break
            }
        }
        
        // Check min rating
        //self.rating = newRating < self.minRating ? self.minRating:newRating
        self.rating = newRating
        
    }
    
    override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let touchLocation = touch.locationInView(self)
            self.handleTouchAtLocation(touchLocation)
        }
    }
    
    override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.anyObject() as? UITouch {
            let touchLocation = touch.locationInView(self)
            self.handleTouchAtLocation(touchLocation)
        }
    }
    
    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        // Update delegate
        
    }
    
    
}

