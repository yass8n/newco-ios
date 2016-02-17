//
//  Helper.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (NSString*) myDateToFormat:(NSDate *)date withFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
+ (NSDate*) UTCtoNSDate:(NSString*)utc{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormat dateFromString:utc];
}
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col{
    obj.layer.borderColor = col.CGColor;
    obj.layer.borderWidth = wid;
    obj.layer.cornerRadius = rad;
}

@end
