//
//  ApplicationViewController.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "colors.h"
#import "SessionCell.h"
#import "SessionCellHeader.h"
#import "Session.h"
#import "ShareModalView.h"
#import "ConfirmationModalView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static CGFloat animatedDistance;
@interface ApplicationViewController : UIViewController <UIGestureRecognizerDelegate, ShareModalDelegate, FBSDKSharingDelegate, BaseModalDelegate, ConfirmationModalDelegate>
-(void)buyTickets;
-(void)showNeedTicketModal;
-(void)setErrorView:(UIView*)view;
-(void)showWebViewWithUrl:(NSString*)url;
-(void)showPageLoader;
-(void)hidePageLoader;
- (void)setBackButton;
- (void)goBack;
- (void)setViewControllerWithSegmentedControl:(UISegmentedControl*)segmentedControl;
- (void)changeViewController:(NSUInteger)index;
- (IBAction)goToSignIn:(id)sender;
- (void) setRightNavButton;
- (void)goToProfile:(NSDictionary*)user withType:(NSString*)type;
- (UIView*) setUserInitial:(CGRect)rect withFont:(int)font withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;
- (void) setUserImage:(CGRect)rect withAvatar:(NSString*)avatar withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;
- (void)goToProfileTable:(NSMutableDictionary*)people withTitle:(NSString*)title withSession: (NSObject *)session withType:(NSString*)type;
- (void)setMultiLineTitle:(NSString*)title fontColor:(UIColor*)color;
- (SessionCell*) setupSessionCellforTableVew:(UITableView *)tableView withIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (void) didSelectSessionInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
-(UITableViewCell*)cellForFestival:(NSDictionary *)festival atIndexPath:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView backGroundColor:(UIColor*) color fullWidth:(BOOL)isFullWidth;
- (NSInteger)numberOfRowsInSection:(NSInteger)section forTableView:(UITableView*)tableView withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;
- (SessionCellHeader*)viewForHeaderInSection:(NSInteger)section forTableView:(UITableView*)tableView withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict;


-(void)showBadConnectionAlert;
-(void)setUserNavBar:(NSDictionary*)myUser;
-(void)setInvisibleRightButton;
-(void)setDefaultUserIcon;

+ (void) setSysVer:(GLfloat) duummy;
+ (void) setNavItem:(UINavigationItem*) object;
+ (void) setLeftNav:(UIView*) object;
+ (void) setRightNav:(UIView*) object;
+ (void) setMenuOpen:(BOOL) object;
+ (void) fakeMenuTap;
+ (void) fetchCurrentUserSessions:(UIView*)withView;
+ (void) setTopViewController:(UIViewController*)object;


+ (UIView*) leftNav;
+ (UIView*) rightNav;
+ (GLfloat) sysVer;
+ (UINavigationItem*) navItem;
+ (BOOL) menuOpen;
+ (UIViewController *)topViewController;
+ (NSArray *)audienceArray;
+ (NSArray *)locationArray;


@end