//
//  colors.m
//  newco-IOS
//
//  Created by yassen aniss on 7/22/15.
//  Copyright (c) 2015 yassen aniss. All rights reserved.
//

#import "colors.h"

@implementation UIColor(myLightGray)
+(UIColor *)myLightGray {
    float rd = 238.00/255.00;
    float gr = 238.00/255.00;
    float bl = 238.00/255.00;
    return [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0f];
}
@end