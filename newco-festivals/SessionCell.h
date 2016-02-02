//
//  SessionCell.h
//  newco-IOS
//
//  Created by yassen aniss .
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *note1;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIView *innnerContainer;
@property (strong, nonatomic) IBOutlet UIView *outerContainer;
@property (strong, nonatomic) IBOutlet UIView *statusContainer;

@end
