//
//  ApplicationViewController.h
//  newco-IOS
//
//  Created by yassen aniss
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
- (void)setBackButton;
- (UIViewController *)topViewController;
- (void)goBack;
- (void)setViewControllerWithSegmentedControl:(UISegmentedControl*)segmentedControl;
- (void)changeViewController:(NSUInteger)index;
- (IBAction)openMenu:(id)sender;
- (IBAction)goToSignIn:(id)sender;
-(void) setRightNavButton;
- (void)goToProfile:(NSDictionary*)user withType:(NSString*)type;
- (UIView*) setUserInitial:(CGRect)rect withFont:(int)font withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;
- (UIView*) setUserImage:(CGRect)rect withAvatar:(NSString*)avatar withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;
- (void)goToProfileTable:(NSMutableDictionary*)people withTitle:(NSString*)title withSession: (NSObject *)session withType:(NSString*)type;
- (void)setMultiLineTitle:(NSString*)title fontColor:(UIColor*)color;

- (SessionCell*) setupSessionCellforTableVew:(UITableView *)tableView withIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (void) didSelectSessionInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (NSInteger)numberOfRowsInSection:(NSInteger)section forTableView:(UITableView*)tableView withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
-(SessionCellHeader*)viewForHeaderInSection:(NSInteger)section forTableView:(UITableView*)tableView withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;


-(void)showBadConnectionAlert;
-(void)setUserNavBar:(NSDictionary*)myUser;
-(void)fetchCurrentUserSessions:(UIView*)withView;
-(void)setInvisibleRightButton;
-(void)setDefaultUserIcon;

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


+ (void) setSysVer:(GLfloat) duummy;
+ (void) setCurrentVC:(CurrentViewController) object;
+ (void) setNavItem:(UINavigationItem*) object;

+ (GLfloat) sysVer;
+ (CurrentViewController) currentVC;
+ (UINavigationItem*) navItem;


@end
