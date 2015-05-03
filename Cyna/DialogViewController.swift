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
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        //every message is an object
                        println("I got one message")
                        //grab parse text from file
                        let text = object["text"] as? String
                        println(text)
                            //check if picture is nil
                            if ( text == nil) {
                                //grab parse image from file
                                let userImageFile = object["image"] as! PFFile
                                userImageFile.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
                                    let image = UIImage(data:data!)
                                let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: JSQPhotoMediaItem(image: image))
                                self.messages.append(message)
                                })
                        }
                        else {
                                let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text:text)
                                self.messages.append(message)
                            }
                            self.finishReceivingMessage()
                            println("block end")
                        }
                    }
                }
            }
        println("loaded messages")
    }
    
    func sendMessage(text: String!, sender: String!) {
        var message = PFObject(className:"Message")
        message["text"] = text
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("The image Has been saved")
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
//    func sendMediaMessage(media: UIImage!, sender: String!) {
//        // *** STEP 3: ADD A MESSAGE TO FIREBASE
//        println("send MEDIA MESSAGE")
//        println(media)
//        var local_pic: UIImage? = media
//        println(sender != nil)
//        println(local_pic != nil)
//        println("PRINTED MEDIA")
////        senderImageUrl = "string"
////        messagesRef.childByAutoId().setValue([
////            "media":media,
////            "sender":sender,
////            "imageUrl":senderImageUrl
////            ])
//        //resize image to smaller scale
//        //let size = CGSizeMake(media.size.width / 2.0, media.size.height / 2.0)
//        
//        let size = CGSizeApplyAffineTransform(media.size, CGAffineTransformMakeScale(0.1, 0.1))
//        let hasAlpha = false
//        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
//        
//        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
//        media.drawInRect(CGRect(origin: CGPointZero, size: size))
//        
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        //ending image resizing
//        var imageData: NSData = UIImagePNGRepresentation(media)
//        println("A")
//        self.base64String = imageData.base64EncodedStringWithOptions(.allZeros)
//        println("B")
//        var quoteString = ["string": self.base64String]
//        println("C")
//        //var users = ["image":quoteString]
//        //usersRef.setValue(users)
//        senderImageUrl = "string"
//        println("AAAAAA")
//        println(sender == nil)
//        println(self.base64String == nil)
//        println(senderImageUrl == nil)
//        messagesRef.childByAutoId().setValue([
//            "string":self.base64String,
//            "sender":sender,
//            "imageUrl":senderImageUrl
//            ])
//        self.picture = UIImage()
//        println("send message end")
//    }
    
//    func tempSendMessage(text: String!, sender: String!) {
//        let newPicture = JSQPhotoMediaItem(image: self.picture)
//        let message = Message(text: text, sender: sender, imageUrl: senderImageUrl, senderId: senderId, isMediaMessage: false, media:newPicture)
//        messages.append(message)
//    }
    
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
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        sendUserImage(self.picture)
        println("HEEELPPP")
        print(self.picture)
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
                self.pullFromParse()
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.senderId = NSProcessInfo().globallyUniqueString
        self.senderDisplayName = PFUser.currentUser()!.objectForKey("name") as? String
        super.viewWillAppear(animated)
    }
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//        JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
        
        sendMessage(text, sender: self.senderDisplayName)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        println("Camera pressed!")
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
//        //avatarImageViewForItemAtIndexPath UIImageView!
//        let message = messages[indexPath.item]
//        if let avatar = avatars[message.senderDisplayName()] {
////            return UIImageView(image: avatar)
//            return nil
//        } else {
//            setupAvatarImage(message.senderDisplayName(), imageUrl: message.imageUrl(), incoming: true)
////            return UIImageView(image:avatars[message.senderDisplayName()])
//            return nil
//        }
//            var image_s = UIImage(named: "chat_blank")
//            avatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(image_s, 30.0)
            return ChatView().collectionView(collectionView, avatarImageDataForItemAtIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderDisplayName == senderDisplayName {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
//                cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
//                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
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
