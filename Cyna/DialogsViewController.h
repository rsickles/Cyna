//
//  DialogsViewController.h
//  Cyna
//
//  Created by Varsha Balasubramaniam on 4/28/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "LocalStorageService.h"
#import "СhatViewController.h"


@interface DialogsViewController : UIViewController

@property (strong, nonatomic) QBChatDialog *createdDialog;

@end
