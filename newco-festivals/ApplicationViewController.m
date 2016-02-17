//
//  ApplicationViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ScheduleViewController.h"
#import "DirectoryViewController.h"
#import "SignInViewController.h"
#import "ProfileViewController.h"
#import "ProfileTableViewController.h"
#import "UserInitial.h"
#import "UserImage.h"
#import "SessionDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface ApplicationViewController ()
// Array of view controllers to switch between
@property (nonatomic, copy) NSArray *allViewControllers;

// Currently selected view controller
@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

#import "constants.h"

@end

@implementation ApplicationViewController

static GLfloat sysVer;
static CurrentViewController currentVC;
static UINavigationItem* navItem;

+ (UINavigationItem*) navItem {return navItem;};
+ (CurrentViewController) currentVC { return currentVC; }
+ (GLfloat) sysVer { return sysVer; }

+ (void) setNavItem:(UINavigationItem*)object{
    navItem = object;
}

+ (void) setCurrentVC:(CurrentViewController) object{
    currentVC = object;
}

+ (void) setSysVer:(GLfloat) dummy{
    { sysVer = [[[UIDevice currentDevice] systemVersion] floatValue]; }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (void)setBackButton{
    UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [back setFrame:CGRectMake(0, 0, 25, 25)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}
-(IBAction)goBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setViewControllerWithSegmentedControl: (UISegmentedControl*) segmentedControl{
    self.segmentedControl = segmentedControl;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleViewController *vcA  = [storyboard instantiateViewControllerWithIdentifier:@"Schedule"];
    DirectoryViewController *vcB  = [storyboard instantiateViewControllerWithIdentifier:@"Directory"];
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:vcA, vcB, nil];
    
    // Ensure a view controller is loaded
    self.segmentedControl.selectedSegmentIndex = 0;
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.segmentedControl.selectedSegmentIndex]];
}

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        
        // Set the new view controller frame (in this case to be the size of the available screen bounds)
        // Calulate any other frame animations here (e.g. for the oldVC)
        CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;        newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds)+navBarHeight + statusBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-navBarHeight - statusBarHeight);
        
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            // Add the new view controller view to the view hierarchy
            [self.view addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}
-(void)changeViewController:(NSUInteger)index{
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
    }
}
-(IBAction)openMenu:(id)sender  {
    NSLog(@"open menu");
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}
- (IBAction)goToSignIn:(id)sender  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToProfile:(NSDictionary*)user withType:(NSString *)type{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    [vc setUser:user];
    [vc setType:type];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)goToUserProfile:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    [vc setUser:[Credentials sharedCredentials].currentUser];
    [vc setType:@"attendee"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView*) setUserInitial:(CGRect)rect withFont:(int)font withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type;{
    UserInitial *initial = [[UserInitial alloc] initWithFrame:rect];
    [initial.text.titleLabel setFont:[UIFont systemFontOfSize:font]];
    initial.user = user;
    initial.type = type;
    NSString* name = [user objectForKey:@"name"];
    if (name && ![name isEqual: @""]){
        [initial.text setTitle: [[name substringToIndex:1]capitalizedString] forState:UIControlStateNormal]; // To set the title
    }
    [view addSubview: initial];
    return  initial;
}
- (UIView*) setUserImage:(CGRect)rect withAvatar:(NSString*)avatar withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type{
    UserImage *userImage = [[UserImage alloc] initWithFrame:rect];
    userImage.user = user;
    userImage.type = type;
    userImage.bounds = rect; //resizes userImage to be exact size of cell image
    [userImage.image sd_setImageWithURL:[NSURL URLWithString:avatar]
                       placeholderImage:[UIImage imageNamed:@"user.png"]];
    [view addSubview: userImage];
    return userImage;
}
- (void)goToProfileTable: (NSMutableDictionary*) people withTitle: (NSString*) title withSession:(Session *)session withType:(NSString*)type{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:people];
    [vc setPageTitle:title];
    [vc setSession:session];
    [vc setType:type];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setMultiLineTitle:(NSString*)title fontColor:(UIColor*)color{
    [self setInvisibleRightButton]; //to take up extra space so title is centered
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 17.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = title;
    self.navigationItem.titleView = label;
}
- (void)setInvisibleRightButton{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.jpg"] landscapeImagePhone:[UIImage imageNamed:@"back.jpg"] style:UIBarButtonItemStylePlain target:self action:@selector(null)];
    item.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
}


-(SessionCell*) setupSessionCellforTableVew:(UITableView *)tableView withIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict{
    // this seems to do the trick because NSInteger is not an object and forKey expects an object
    NSUInteger section = indexPath.section;
    NSNumber *sectionObject = [NSNumber numberWithInteger:section];
    NSDate* date = [orderOfInsertedDatesDict objectForKey:sectionObject];
    SessionCell * sessionCell = [tableView dequeueReusableCellWithIdentifier:@"session_cell"];
    Session * currentSession = [datesDict objectForKey:date ][indexPath.row];
    sessionCell.status.text = [currentSession status];
    NSString* time = [[currentSession start_time] and @" - " ];
    sessionCell.time.text = [time and [currentSession end_time] ];
    sessionCell.title.text = [currentSession title];
    sessionCell.note1.text = [currentSession note1];
    sessionCell.outerContainer.backgroundColor = [currentSession color];
    sessionCell.innnerContainer.backgroundColor = sessionCell.outerContainer.backgroundColor;
    
    sessionCell.title.lineBreakMode = NSLineBreakByWordWrapping; //used in conjunction with linebreaks = 0
    sessionCell.note1.lineBreakMode = NSLineBreakByWordWrapping;
    sessionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (ApplicationViewController.sysVer < 8.00){
        sessionCell.outerContainer.clipsToBounds = YES;
    }
    
    [sessionCell layoutIfNeeded]; //fixes issue where the first cells that are initially showing are not wrapping content for note1
    
    //storyboard contains border properties
    //opacity for speed
    [sessionCell.contentView setOpaque:YES];
    [sessionCell.backgroundView setOpaque:YES];
    sessionCell.layer.shouldRasterize = YES;
    sessionCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    if (currentSession.picked){
        [sessionCell.checkMark setHidden:NO];
    }else {
        [sessionCell.checkMark setHidden:YES];
    }
    if (currentSession.enabled){
        [sessionCell.outerContainer setAlpha:1];
    }else{
        [sessionCell.outerContainer setAlpha:.5];
    }
    
    return sessionCell;
}
- (void) didSelectSessionInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SessionDetail"];
    
    NSNumber *sectionObject = [NSNumber numberWithInteger:indexPath.section];
    NSDate* date = [orderOfInsertedDatesDict objectForKey:sectionObject];
    [vc setSession:[datesDict objectForKey:date ][indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section forTableView:(UITableView*)tableView withDatesDict:(NSMutableDictionary*)datesDict withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict{
    NSNumber *sectionObject = [NSNumber numberWithInteger:section];
    NSString* date = [orderOfInsertedDatesDict objectForKey:sectionObject];

    return [[datesDict objectForKey:date] count];
}
-(SessionCellHeader*)viewForHeaderInSection:(NSInteger)section forTableView:(UITableView*)tableView withOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDict{
    
    // 1. Dequeue the custom header cell
    SessionCellHeader* headerCell = [tableView dequeueReusableCellWithIdentifier:@"session_cell_header"];
    
    // 2. Set the various properties
    NSNumber *sectionObject = [NSNumber numberWithInteger:section];
    headerCell.date.text = [orderOfInsertedDatesDict objectForKey:sectionObject];
    [headerCell.date sizeToFit];
    
    // 3. And return
    return headerCell;
    
}

-(void)showBadConnectionAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                    message:@"You must be connected to the internet to use this app."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)setUserNavBar:(NSDictionary*)myUser{
    NSString* navSet = [[Credentials sharedCredentials].currentUser objectForKey:@"navSet"];
    if ( (!navSet) || [navSet  isEqual: [NSNull null]] || navSet == nil){
        UIButton *back =  [UIButton buttonWithType:UIButtonTypeCustom];
        back.layer.borderWidth = 1;
        back.layer.cornerRadius = 13;
        back.clipsToBounds = YES;
        NSString * avatar = [myUser objectForKey:@"avatar"];
        NSString * name = [myUser objectForKey:@"name"];
        if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""] || avatar == nil){
            back.backgroundColor = [UIColor myLightGray];
            if (![name isEqual: @""] && name != nil){
                [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [back setTitle:[[[myUser objectForKey:@"name"] substringToIndex:1]capitalizedString] forState:UIControlStateNormal];
            }
        }else {
            [back setBackgroundImageWithURL:[myUser objectForKey:@"avatar"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user.png"]];
        }
        [back addTarget:self action:@selector(goToUserProfile:)forControlEvents:UIControlEventTouchUpInside];
        [back setFrame:CGRectMake(0, 0, 26, 26)];
        navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        NSMutableDictionary* mutableUser = [[Credentials sharedCredentials].currentUser mutableCopy];
        [mutableUser setValue:@"YES" forKey:@"navSet"];
        [Credentials sharedCredentials].currentUser = [mutableUser copy];
    }

}
-(void)fetchCurrentUserSessions:(UIView*)withView{
    WebService * webService = [[WebService alloc] initWithView:withView];
    [webService fetchCurrentUserSessions:[[Credentials sharedCredentials].currentUser objectForKey:@"username"] withAuthToken:[[Credentials sharedCredentials].currentUser objectForKey:@"auth"] callback:^(NSArray *sessionKeyArray) {
        NSMutableDictionary* userSessions = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < [sessionKeyArray count]; i++){
            NSString* event_key = [sessionKeyArray objectAtIndex:i];
            Session * s = [[FestivalData sharedFestivalData].sessionsDict objectForKey:event_key];
            if (s && ![s isEqual:[NSNull null]]){
                [userSessions setObject:@"YES" forKey:event_key];
            }
        }
        [FestivalData sharedFestivalData].currentUserSessions = userSessions;
        [[FestivalData sharedFestivalData] updateSessionsValidity:[[FestivalData sharedFestivalData].currentUserSessions allKeys] invalidateSessions:YES];
    }];
}


-(void) setRightNavButton{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    if ([[Credentials sharedCredentials].currentUser count]){
        [self setUserNavBar:[Credentials sharedCredentials].currentUser];
    }else{
        [self setDefaultUserIcon];
    }
}
- (void)setDefaultUserIcon{
    UIButton *user =  [UIButton buttonWithType:UIButtonTypeCustom];
    [user setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    [user addTarget:self action:@selector(goToSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [user setFrame:CGRectMake(0, 0, 20, 20)];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:user];
}


@end
