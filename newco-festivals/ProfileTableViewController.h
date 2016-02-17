//
//  ProfileTableViewController.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileTableViewController : ApplicationViewController  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSMutableDictionary *users;
@property (weak, nonatomic) NSString* pageTitle;
@property (weak, nonatomic) Session* session;
@property (strong, nonatomic) NSString* type;
@property (nonatomic) BOOL setTheBackButton;

@end
