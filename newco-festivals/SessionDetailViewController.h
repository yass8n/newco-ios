//
//  SessionDetailViewController.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "ConfirmationModalView.h"
@interface SessionDetailViewController : ApplicationViewController <ConfirmationModalDelegate>
    @property (weak, nonatomic) IBOutlet Session* session;
@end
