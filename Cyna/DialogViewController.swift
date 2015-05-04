//
//  DialogViewController.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/30/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class DialogViewController: JSQMessagesViewController {

    
    var messages = [JSQMessage]()
    var timer: NSTimer!
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    var senderImageUrl: String!
    var batchMessages = true
    //var ref: Firebase!
    var avatar : JSQMessagesAvatarImage!
    
    var picture = UIImage()
    //var x = JSQMessagesAvatarImageFactory.avatarImageWith
    var base64String: NSString!
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    //var messagesRef: Firebase!
    
    func pullFromParse() {
        println("starting parse")
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        var query = PFQuery(className:"Message")
        query.limit = 25
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                self.automaticallyScrollsToMostRecentMessage = false;
                println("Successfully retrieved \(objects!.count) scores.")
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.addMessage(object)
                    }
                    if(objects.count != 0){
                        self.finishReceivingMessage()
                        self.scrollToBottomAnimated(false)
                    }
                    self.automaticallyScrollsToMostRecentMessage = true;
                }
            }
        println("loaded messages")
    }
}

    
    func addMessage(object:PFObject) -> JSQMessage {
        println("RYAN")
        var message: JSQMessage!
        println("Sickles")
        let text = object["text"] as? String
        println("PRINT TEXT")
        let userImageFile = object["image"] as? PFFile
        println("PRINT FILE")
        //add video
        if(text == nil){
            println("PIC")
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = PFUser.currentUser()!.objectForKey("name") as? String == self.senderDisplayName
            message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: mediaItem)
            userImageFile!.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
                if(error == nil){
                    mediaItem.image = UIImage(data: data!)
                    self.collectionView.reloadData()
                }
            })
        }
        // add text
        else {
            println("TEXT")
            message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text:text)
        }
        self.messages.append(message)
        println("Sameuel")
        return message
    }
    
    func sendMessage(text: String!, sender: String!) {
        var message = PFObject(className:"Message")
        println("HAHAH NOPE")
        message["text"] = text
        //message["sender_display_name"] = self.senderDisplayName
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.finishSendingMessage()
                self.pullFromParse()
                println("The image Has been saved")
            } else {
                // There was a problem, check error.description
            }
        }
    }

    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
//                    avatars[name] = avatarImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = count(name)
        let initials : String? = name.substringToIndex(advance(senderDisplayName.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
//        avatars[name] = userImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println (NSProcessInfo().globallyUniqueString)
        let senderId = NSProcessInfo().globallyUniqueString
        self.senderId = NSProcessInfo().globallyUniqueString
        self.senderDisplayName = PFUser.currentUser()!.objectForKey("name") as? String
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        sendUserImage(self.picture)
        self.pullFromParse()
    }
    
    
    func sendUserImage(picture: UIImage!){
        var message = PFObject(className:"Message")
        let imageData = self.scaleImageToSize(10485760, image: picture)
        let imageFile = PFFile(name: "userimg.png", data: imageData)
        message["image"] = imageFile
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("The image Has been saved")
                self.finishSendingMessage()
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func scaleImageToSize(floatNumber:Int, image:UIImage) -> NSData{
        let img = image
        var compress = 1.0 as CGFloat
        var sub = 0.05 as CGFloat
        var imgData = UIImageJPEGRepresentation(img, compress)
        while((imgData.length) > floatNumber){
            compress = compress - sub
            imgData = UIImageJPEGRepresentation(img, compress)
        }
        return imgData
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("pullFromParse"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        sendMessage(text, sender: self.senderDisplayName)
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        //bubbleImageViewForItemAtIndexPath
        //UIImageView!
        let message = messages[indexPath.item]
        if message.senderDisplayName == senderDisplayName {
//             return UIImageView(image: outgoingBubbleImageView.messageBubbleImage, highlightedImage: outgoingBubbleImageView.messageBubbleHighlightedImage)
            return outgoingBubbleImageView;
        }
//        return UIImageView(image: incomingBubbleImageView.messageBubbleImage, highlightedImage: incomingBubbleImageView.messageBubbleHighlightedImage)
        return incomingBubbleImageView;
        
    }
    
     override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) ->  JSQMessageAvatarImageDataSource!{
            return ChatView().collectionView(collectionView, avatarImageDataForItemAtIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("MESSSAGE COUNT")
        println(messages.count)
        return messages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        println("GATTEESSSSS")
        println(message.senderDisplayName)
        println(senderDisplayName)
//        if message.senderDisplayName == senderDisplayName {
//            println("YES")
//            cell.textView.textColor = UIColor.blackColor()
//        } else {
//            println("NO")
//            cell.textView.textColor = UIColor.whiteColor()
//        }
        println("SUUUCKKKSS")
        return cell
    }

    
//    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderDisplayName == self.senderDisplayName {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
//        // Sent by me, skip
        if message.senderDisplayName == senderDisplayName {
            return CGFloat(0.0);
        }
//
//        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

}
