//
//  UserInitial.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInitial : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)initial:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *text;
@property (weak, nonatomic) NSString *username;
@end
