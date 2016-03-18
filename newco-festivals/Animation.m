//
//  Animation.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
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
