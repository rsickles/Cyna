//
//  Message.swift
//  Cyna
//
//  Created by Ryan Sickles on 4/30/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import Foundation

class Message : NSObject, JSQMessageData {
    
    
    var text_: String
    var sender_: String
    var date_: NSDate
    var imageUrl_: String?
    var senderId_: String?
    var isMediaMessage_: Bool
    var media_: JSQMessageMediaData
    
//    convenience init(text: String?, sender: String?) {
//        self.init(text: text, sender: sender, imageUrl: nil, senderid: senderid)
//    }
    
    init(text: String?, sender: String?, imageUrl: String?, senderId: String?, isMediaMessage: Bool, media: JSQMessageMediaData) {
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = NSDate()
        self.imageUrl_ = imageUrl
        self.senderId_ = senderId
        self.isMediaMessage_ = isMediaMessage
        self.media_ = media
    }
    
    func text() -> String! {
        return text_;
    }
    
    func senderDisplayName() -> String! {
        return sender_;
    }
    
    func senderId() -> String! {
        return senderId_
    }
    
    func isMediaMessage() -> Bool {
        return isMediaMessage_
    }
    
    func messageHash() -> UInt {
        return 1
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func media() -> JSQMessageMediaData! {
        return media_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
}