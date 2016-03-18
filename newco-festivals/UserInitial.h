//
//  UserInitial.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInitial : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
- (IBAction)initial:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *text;
@property (weak, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString* type;

@end
