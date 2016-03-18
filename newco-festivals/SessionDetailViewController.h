//
//  SessionDetailViewController.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "ConfirmationModalView.h"
#import <MessageUI/MessageUI.h>
@interface SessionDetailViewController : ApplicationViewController <ConfirmationModalDelegate, MFMailComposeViewControllerDelegate>
    @property (weak, nonatomic) IBOutlet Session* session;
@end
