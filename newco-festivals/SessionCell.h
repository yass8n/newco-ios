//
//  SessionCell.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *note1;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *innnerContainer;
@property (weak, nonatomic) IBOutlet UIView *outerContainer;
@property (weak, nonatomic) IBOutlet UIView *statusContainer;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (nonatomic, weak) UIViewController *controller;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;

@end
