//
//  CustomUIView.m
//  newco-IOS
//
//  Created by yassen aniss on 8/3/15.
//  Copyright (c) 2015 yassen aniss. All rights reserved.
//

#import "CustomUIView.h"
#import "ApplicationViewController.h"
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
    if (self.highlghtedColor)
        self.backgroundColor = self.highlghtedColor;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.unHighlghtedColor)
        self.backgroundColor = self.unHighlghtedColor;
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.unHighlghtedColor)
        self.backgroundColor = self.unHighlghtedColor;
    
}
@end
