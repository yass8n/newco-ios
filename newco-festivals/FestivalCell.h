//
//  FestivalCell.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestivalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic) BOOL setToFullWidthOfScreen;
@end
