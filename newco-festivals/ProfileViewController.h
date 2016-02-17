//
//  ProfileViewController.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProfileViewController : ApplicationViewController
@property (weak, nonatomic) IBOutlet UIView *profileImage;
- (IBAction)hideTopView:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UILabel *about;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *positionAndCompany;
@property (weak, nonatomic) IBOutlet UIButton *website;
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)goToWebsite:(id)sender;

@end
