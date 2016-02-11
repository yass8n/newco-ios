//
//  ProfileViewController.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationViewController.h"
@interface ProfileViewController : ApplicationViewController
@property (weak, nonatomic) IBOutlet UIView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *positionAndCompany;
@property (weak, nonatomic) IBOutlet UIButton *website;
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString *type;
- (IBAction)goToWebsite:(id)sender;

@end
