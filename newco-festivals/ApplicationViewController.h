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
#import "SessionCell.h"
#import "SessionCellHeader.h"
#import "Session.h"
#import "PageLoader.h"

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
- (void)goToProfile:(NSDictionary*)user withType:(NSString*)type;
- (UIView*) setUserInitial:(CGRect)rect withFont:(int)font withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;
- (UIView*) setUserImage:(CGRect)rect withAvatar:(NSString*)avatar withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;
- (void)goToProfileTable:(NSMutableDictionary*)people withTitle:(NSString*)title withSession: (NSObject *)session withType:(NSString*)type;
- (void)setMultiLineTitle:(NSString*)title fontColor:(UIColor*)color;
- (void)initializeSessionArray:(NSMutableArray*)array withData:(NSArray *) jsonArray withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict initializeEverything:(BOOL)initEverything;
- (SessionCell*) setupSessionCellforTableVew:(UITableView *)tableView withIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (void) didSelectSessionInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (NSInteger)numberOfRowsInSection:(NSInteger)section forTableView:(UITableView*)tableView withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
-(SessionCellHeader*)viewForHeaderInSection:(NSInteger)section forTableView:(UITableView*)tableView withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (void)setDatesDict:(NSMutableDictionary*)datesDict setOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict forSessions:(NSMutableArray*)sessions;
-(void)showPageLoaderInView:(UIView*)superView;
-(void)removePageLoaderFromView:(UIView*)superView;
-(void)showBadConnectionAlert;
-(void)setUserNavBar:(NSDictionary*)myUser;

typedef NS_ENUM(NSInteger, CurrentViewController)
{
    enumRoot = 1,
    enumSchedule,
    enumDirectory,
    enumProfileTable,
    enumProfile,
    enumSessionDetail,
    enumSignin
};



+ (void) setSessionsArray:(NSMutableArray *)object;
+ (void) setSessionsDict:(NSMutableDictionary *)object;
+ (void) setLocationColorDict:(NSMutableDictionary *)object;
+ (void) setOrderOfInsertedDatesDict:(NSMutableDictionary *)object;
+ (void) setCompaniesDict:(NSMutableDictionary *)object;
+ (void) setPresentersDict:(NSMutableDictionary *)object;
+ (void) setAttendeesDict:(NSMutableDictionary *)object;
+ (void) setDatesDict:(NSMutableDictionary *)object;
+ (void) setVolunteersDict:(NSMutableDictionary *)object;
+ (void) setSysVer:(GLfloat) duummy;
+ (void) setEnableFullUserInteraction:(BOOL) object;
+ (void) setCurrentVC:(CurrentViewController) object;
+ (void) setCurrentUserSessions:(NSMutableDictionary*) object;
+ (void) setNavItem:(UINavigationItem*) object;
+ (void) setCurrentUser:(NSDictionary*) currentUser;
+ (void) setAPI_URL:(NSString*) API_URL;
+ (void) setAPI_KEY:(NSString*) API_KEY;




+ (NSMutableArray *) sessionsArray;
+ (NSMutableDictionary *) sessionsDict;
+ (NSMutableDictionary*) datesDict;
+ (NSMutableDictionary*) attendeesDict;
+ (NSMutableDictionary*) presentersDict;
+ (NSMutableDictionary*) companiesDict;
+ (NSMutableDictionary*) volunteersDict;
+ (NSMutableDictionary*) orderOfInsertedDatesDict;
+ (NSMutableDictionary*) locationColorDict;
+ (NSMutableArray*) EVENT_COLORS_ARRAY;
+ (GLfloat) sysVer;
+ (BOOL) enableFullUserInteraction;
+ (CurrentViewController) currentVC;
+ (NSMutableDictionary*) currentUserSessions;
+ (UINavigationItem*) navItem;
+ (NSDictionary*) currentUser;
+ (NSString*) API_URL;
+ (NSString*) API_KEY;

+ (NSString*) myDateToFormat:(NSDate*) date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col;
+ (void)initEventColorsArray;

@end
