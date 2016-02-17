//
//  Helper.h
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+ (NSString*) myDateToFormat:(NSDate*) date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
@end
