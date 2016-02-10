//
//  ApplicationViewController.h
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colors.h"

@interface ApplicationViewController : UIViewController
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
@property (nonatomic, strong) NSMutableArray *sessionsArray;
@property (nonatomic, strong) NSMutableDictionary* datesArray;
@property (nonatomic, strong) NSMutableDictionary* orderOfInsertedDates;
@property (nonatomic, strong) NSMutableDictionary* locationColorHash;
@property (nonatomic, strong) NSMutableArray* EVENT_COLORS_ARRAY;

- (UIColor *) findFreeColor;
+ (NSString*) myDateToFormat:(NSDate*) date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
@end
