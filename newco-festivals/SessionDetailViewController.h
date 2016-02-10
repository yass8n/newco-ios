//
//  SessionDetailViewController.h
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"
#import "Session.h"
@interface SessionDetailViewController : ApplicationViewController
@property (strong, readwrite, nonatomic) IBOutlet UILabel *status;
@property (strong, readwrite, nonatomic) IBOutlet Session* session;

@end
