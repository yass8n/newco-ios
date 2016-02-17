//
//  ProfileCell.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (strong, nonatomic) IBOutlet UIView *image;
@property (weak, nonatomic) IBOutlet UIView *container;

@end
