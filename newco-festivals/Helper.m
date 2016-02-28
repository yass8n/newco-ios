//
//  Helper.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright © 2016 Newco. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
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
+(void)buttonTappedAnimation:(UIView *)view{
    [UIView animateWithDuration:.1 animations:^{
        view.transform = CGAffineTransformMakeScale(.97,.97);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            view.transform = CGAffineTransformMakeScale(1,1);
        }];
    }];
}
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col{
    obj.layer.borderColor = col.CGColor;
    obj.layer.borderWidth = wid;
    obj.layer.cornerRadius = rad;
}
+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height / label.font.lineHeight);
}
+ (CGSize)sizeForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
    
    return size;
}
+(NSString*)firebaseSafeUrl:(NSString *)url{
    url = [url stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    url = [url stringByReplacingOccurrencesOfString:@"#" withString:@"-"];
    url = [url stringByReplacingOccurrencesOfString:@"$" withString:@"-"];
    url = [url stringByReplacingOccurrencesOfString:@"[" withString:@"-"];
    url = [url stringByReplacingOccurrencesOfString:@"]" withString:@"-"];
    return [NSString stringWithFormat:@"%@/%@", firebaseUrl, url];
}

@end
