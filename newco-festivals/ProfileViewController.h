//
//  ProfileViewController.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProfileViewController : ApplicationViewController
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString *type;
- (IBAction)goToWebsite:(id)sender;

@end
