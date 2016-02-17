//
//  Animation.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import "Animation.h"

@implementation Animation
-(void)fadeIn:(UIView*)view duration:(float)duration{
    
    [view setAlpha:0.1f];
    
    //fade in
    [UIView animateWithDuration:duration animations:^{
        
        [view setAlpha:1.0f];
        
    }];
}
@end
