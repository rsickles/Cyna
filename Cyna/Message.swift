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
    
    convenience init(text: String?, sender: String?) {
        self.init(text: text, sender: sender, imageUrl: nil)
    }
    
    init(text: String?, sender: String?, imageUrl: String?) {
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = NSDate()
        self.imageUrl_ = imageUrl
    }
    
    func text() -> String! {
        return text_;
    }
    
    func senderDisplayName() -> String! {
        return sender_;
    }
    
    func senderId() -> String! {
        return "1"
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func messageHash() -> UInt {
        return 1
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
}