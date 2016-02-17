//
//  CustomUILabel.m
//  newco-IOS
//
//  Created by alondra on 2/14/16.
//  Copyright © 2016 Newco. All rights reserved.
//

#import "CustomUILabel.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.highlightedColor)
        self.backgroundColor = self.highlightedColor;
    if (self.highlightTextColor)
        self.textColor = self.highlightTextColor;
        
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.unHighlightedColor)
        self.backgroundColor = self.unHighlightedColor;
    if (self.unHighlightTextColor)
        self.textColor = self.unHighlightTextColor;

    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.unHighlightedColor)
        self.backgroundColor = self.unHighlightedColor;
    
}

@end
