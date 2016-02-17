//
//  NSString+NSStringAdditions.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import "NSString+NSStringAdditions.h"

@implementation NSString (NSStringAdditions)
-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    s = [s stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return s;
}
@end
