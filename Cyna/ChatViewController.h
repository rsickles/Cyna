//
//  ChatViewController.h
//  Cyna
//
//  Created by Varsha Balasubramaniam on 4/28/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>


@interface ChatViewController : UIViewController

@property (nonatomic, strong) QBChatDialog *dialog;

@end
