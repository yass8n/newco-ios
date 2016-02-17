//
//  SessionDetailViewController.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
@interface SessionDetailViewController : ApplicationViewController
    @property (weak, nonatomic) IBOutlet Session* session;
@end
