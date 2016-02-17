//
//  CustomUIView.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "CustomUIView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end



@implementation CustomUIView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if([self.delegate respondsToSelector: @selector(receivedTargetTapStart:)]) {
        [self.delegate receivedTargetTapStart:self];
    }
    if (self.highlightedColor){
        if (!self.animating){
            self.backgroundColor = self.highlightedColor;
        }else{
            [UIView animateWithDuration:.6 animations:^{
                self.backgroundColor = self.highlightedColor;
            }completion:^(BOOL completed){
                if([self.delegate respondsToSelector: @selector(receivedTargetTapDone)]) {
                    [self.delegate receivedTargetTapDone];
                }
            }];
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.unHighlightedColor)
        self.backgroundColor = self.unHighlightedColor;
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.unHighlightedColor)
        self.backgroundColor = self.unHighlightedColor;
    
}
@end
