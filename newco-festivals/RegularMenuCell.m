//
//  Regular.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import "RegularMenuCell.h"

@implementation RegularMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize itemSize = CGSizeMake(22, 22);
    self.imageView.frame =  CGRectMake(10,self.contentView.frame.size.height/4,itemSize.width,itemSize.height);
    self.textLabel.frame =  CGRectMake(itemSize.width + 20,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
}

@end
