//
//  ProfileDetailCell.h
//  newco-festivals
//
//  Created by Yaseen Anss on 2/19/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *about;

@property (weak, nonatomic) IBOutlet UIImageView *infoIcon;
@property (weak, nonatomic) IBOutlet UILabel *positionAndCompany;
@property (weak, nonatomic) IBOutlet UIButton *website;

@end
