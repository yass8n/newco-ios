//
//  ApplicationViewController.h
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "colors.h"

@interface ApplicationViewController : UIViewController
- (UIColor *) findFreeColor;
- (void)setBackButton;
- (UIViewController *)topViewController;
- (void)goBack;
- (void)fadeIn:(UIView*)view duration:(float)duration;
- (void)setViewControllerWithSegmentedControl:(UISegmentedControl*)segmentedControl;
- (void)changeViewController:(NSUInteger)index;
- (IBAction)openMenu:(id)sender;
- (IBAction)goToSignIn:(id)sender;

+ (void) setSessionsArray:(NSMutableArray *)object;
+ (void) setLocationColorHash:(NSMutableDictionary *)object;
+ (void) setOrderOfInsertedDates:(NSMutableDictionary *)object;
+ (void) setCompaniesDict:(NSMutableDictionary *)object;
+ (void) setPresentersDict:(NSMutableDictionary *)object;
+ (void) setAttendeesDict:(NSMutableDictionary *)object;
+ (void) setDatesArray:(NSMutableDictionary *)object;
+ (void) setVolunteersDict:(NSMutableDictionary *)object;
+ (void) setSysVer:(GLfloat) duummy;
+ (void) setEnableSegmentedControl:(BOOL) val;

+ (NSMutableArray *) sessionsArray;
+ (NSMutableDictionary*) datesArray;
+ (NSMutableDictionary*) attendeesDict;
+ (NSMutableDictionary*) presentersDict;
+ (NSMutableDictionary*) companiesDict;
+ (NSMutableDictionary*) volunteersDict;
+ (NSMutableDictionary*) orderOfInsertedDates;
+ (NSMutableDictionary*) locationColorHash;
+ (NSMutableArray*) EVENT_COLORS_ARRAY;
+ (GLfloat) sysVer;
+ (BOOL) enableSegmentedControl;

+ (NSString*) myDateToFormat:(NSDate*) date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
+ (void)initEventColorsArray;

@end
