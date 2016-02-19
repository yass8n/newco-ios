//
//  Helper.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+ (NSString*) myDateToFormat:(NSDate*) date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (int)lineCountForLabel:(UILabel *)label;
+ (NSString*)firebaseSafeUrl:(NSString*)url;
@end
