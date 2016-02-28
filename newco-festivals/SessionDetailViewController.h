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
#import <MessageUI/MessageUI.h>
@interface SessionDetailViewController : ApplicationViewController <ConfirmationModalDelegate, MFMailComposeViewControllerDelegate>
    @property (weak, nonatomic) IBOutlet Session* session;
@end
