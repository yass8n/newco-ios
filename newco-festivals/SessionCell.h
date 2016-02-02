//
//  SessionCell.h
//  newco-festivals
//
//  Created by yassen aniss
//  Copyright © 2016 newco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *note1;
@property (strong, nonatomic) IBOutlet UILabel *note2;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIView *container;

@end
