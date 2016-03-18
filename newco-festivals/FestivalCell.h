//
//  FestivalCell.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestivalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet CustomUIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic) BOOL setToFullWidthOfScreen;
@end
