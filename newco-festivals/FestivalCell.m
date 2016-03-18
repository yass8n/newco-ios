//
//  FestivalCell.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
//

#import "FestivalCell.h"

@implementation FestivalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    if (self.setToFullWidthOfScreen){
        frame.origin.x -= 4;
        frame.size.width += 8;
    }
    [super setFrame:frame];
}

@end
