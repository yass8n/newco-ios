//
//  SessionDetailViewController.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"
#import "Session.h"
@interface SessionDetailViewController : ApplicationViewController
@property (strong, readwrite, nonatomic) IBOutlet UILabel *status;
@property (strong, readwrite, nonatomic) IBOutlet Session* session;
@property (strong, nonatomic) IBOutlet UIView *statusContainer;
- (IBAction)goToSignIn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *presenter_name;
@property (strong, nonatomic) IBOutlet UIView *presenter_view;
@property (strong, nonatomic) IBOutlet UIView *company_view;

@property (strong, nonatomic) IBOutlet UILabel *company_name;

@property (strong, nonatomic) IBOutlet UILabel *region;
@property (strong, nonatomic) IBOutlet UIView *region_color;
- (IBAction)allAttendees:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *all_attendees;

@end
