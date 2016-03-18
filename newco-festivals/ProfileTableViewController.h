//
//  ProfileTableViewController.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileTableViewController : ApplicationViewController  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSMutableDictionary *users;
@property (weak, nonatomic) NSString* pageTitle;
@property (weak, nonatomic) Session* session;
@property (strong, nonatomic) NSString* type;
@property (nonatomic) BOOL setTheBackButton;

@end
