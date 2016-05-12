//
//  Helper.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;
typedef void (^ CompletionBlock)(void);
@interface Helper : NSObject
+ (NSString*) myDateToFormat:(NSDate*) date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (int)lineCountForLabel:(UILabel *)label;
+ (CGSize)sizeForLabel:(UILabel *)label ;
+ (NSString*)firebaseSafeUrl:(NSString*)url;
+(void)buttonTappedAnimation:(UIView*)view;
+(NSDictionary*)order;
+(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr;
@end
