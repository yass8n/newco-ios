//
//  ApplicationViewController.m
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
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
#import "Helper.h"
#import "WebViewController.h"
#import "SVProgressHUD.h"
#import "ModalView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Twitter/Twitter.h>
#import "FestivalCell.h"


@interface ApplicationViewController ()
// Array of view controllers to switch between
@property (nonatomic, copy) NSArray *allViewControllers;
@property (nonatomic, assign) sharedByEnum sharedBy;
@property (nonatomic, strong) Session* sharingSession;

// Currently selected view controller
@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

#import "constants.h"

@end

@implementation ApplicationViewController
static BOOL menuOpen = NO;
static GLfloat sysVer;
static UINavigationItem* navItem;
static UIView* rightNav;
static UIView* leftNav;
static UITapGestureRecognizer *singleFingerTap;
static UIViewController *theTopViewController;

+ (UIView*) rightNav { return rightNav; }
+ (UIView*) leftNav { return leftNav; }
+ (UINavigationItem*) navItem {return navItem;};
+ (GLfloat) sysVer { return sysVer; }
+ (BOOL) menuOpen {return menuOpen; }
+ (UIViewController *)topViewController{return theTopViewController;}

+ (void) setTopViewController:(UIViewController*)object{
    theTopViewController = object;
}
+ (void) setMenuOpen:(BOOL)object{
    menuOpen = object;
}

+ (void) setNavItem:(UINavigationItem*)object{
    navItem = object;
}

+ (void) setLeftNav:(UIView*) object{
    leftNav = object;
}
+ (void) setRightNav:(UIView*) object{
    rightNav = object;
}

+ (void) setSysVer:(GLfloat) dummy{
    { sysVer = [[[UIDevice currentDevice] systemVersion] floatValue]; }
}

+(void) fakeMenuTap{
    [(UIButton*)leftNav sendActionsForControlEvents: UIControlEventTouchUpInside];
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    theTopViewController = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTouchWhenMenuOpen:)];
    singleFingerTap.delegate = self;
    [self.view addGestureRecognizer:singleFingerTap];
}
-(void)showNeedTicketModal{
    CGRect modalFrame = CGRectMake(30, 150, self.view.frame.size.width - 60, 160);
    
    NSString *modalTitle = @"You need a ticket to start building your schedule.";
    
    UIColor *modalTitleColor =  [Helper getUIColorObjectFromHexString:@"#34495e" alpha:1.0];
    UIFont *proximaBold = [UIFont fontWithName: @"ProximaNova-Bold" size: 18];
    NSDictionary *boldDict = [NSDictionary dictionaryWithObject:proximaBold forKey:NSFontAttributeName];
    UIFont *proximaSemi = [UIFont fontWithName: @"ProximaNova-Semibold" size: 18];
    NSDictionary *regular = [NSDictionary dictionaryWithObject: proximaSemi forKey:NSFontAttributeName];
    NSMutableAttributedString *regularString = [[NSMutableAttributedString alloc] initWithString:modalTitle attributes: regular];
    [regularString addAttribute:NSForegroundColorAttributeName value:modalTitleColor range:(NSMakeRange(0, [regularString length]))];

    
    ConfirmationModalView* modalView =  [[ConfirmationModalView alloc] initWithFrame:modalFrame title:regularString yesText:@"Buy Ticket" noText:@"Not Now" imageColor:[Helper getUIColorObjectFromHexString:@"#34495e" alpha:1.0] image:[UIImage imageNamed:@"ticket"] roundedDisplay:NO];
    modalView.modalType = @"ticket";
    modalView.confirmationModalDelegate = self;
    UIView * topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [topView.window addSubview:modalView];
    modalView.baseModalDelegate = self;
    [modalView showModalAtTop:YES];

}
-(void)buyTickets{
    [self showWebViewWithUrl:[NSString stringWithFormat:@"http://festivals.newco.co/%@/tickets", [[Credentials sharedCredentials].festival objectForKey:@"name"]]];
}
- (void)yesButtonClicked:(ConfirmationModalView*)modal{
    if ([modal.modalType isEqualToString:@"ticket"]){
        [modal hideModal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self buyTickets];
        });
        
    }
}
- (void)noButtonClicked:(ConfirmationModalView*)modal{
    [modal hideModal];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (menuOpen) {
        return YES;
    }
    return NO;
}
-(void)handleTouchWhenMenuOpen:(UITapGestureRecognizer *)recognizer {
    [ApplicationViewController fakeMenuTap];
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
-(UITableViewCell*)cellForFestival:(NSDictionary *)festival atIndexPath:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView backGroundColor:(UIColor*) color fullWidth:(BOOL)isFullWidth{
    FestivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"festival_cell" forIndexPath:indexPath];
    cell.setToFullWidthOfScreen = isFullWidth;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[festival objectForKey:@"hero_image"]]
                  placeholderImage:[Helper imageFromColor:[UIColor myPlaceHolderColor]]];
    
    BOOL needs_image_info = [[festival objectForKey:@"needs_image_info"] boolValue];
    
    if (needs_image_info){
        cell.title.hidden = NO;
        cell.logo.hidden = NO;
        cell.dateView.hidden = NO;
        cell.date.text = [festival objectForKey:@"date"];
        cell.title.text = [[festival objectForKey:@"city"] uppercaseString];
        cell.title.textColor = [UIColor whiteColor];
    }else{
        cell.dateView.hidden = YES;
        cell.title.hidden = YES;
        cell.logo.hidden = YES;
    }
    cell.contentView.backgroundColor = color;
    
    return cell;
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
- (IBAction)goToSignIn:(id)sender  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
    vc.setTheBackButton = YES;
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
- (void) setUserImage:(CGRect)rect withAvatar:(NSString*)avatar withUser:(NSDictionary*)user intoView:(UIView*)view withType:(NSString*)type{
    UserImage *userImage = [[UserImage alloc] initWithFrame:rect];
    userImage.user = user;
    userImage.type = type;
    userImage.bounds = rect; //resizes userImage to be exact size of cell image
    [userImage.image sd_setImageWithURL:[NSURL URLWithString:avatar]
                       placeholderImage:[Helper imageFromColor:[UIColor myPlaceHolderColor]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (error){
                               [self setUserInitial:rect withFont:rect.size.width / 2 withUser:user intoView:view withType:type];
                           }
                       }];
    [view addSubview: userImage];
}
- (void)goToProfileTable: (NSMutableDictionary*) people withTitle: (NSString*) title withSession:(Session *)session withType:(NSString*)type{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileTable"];
    [vc setUsers:people];
    [vc setPageTitle:title];
    [vc setSession:session];
    [vc setType:type];
    vc.setTheBackButton = YES;
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

-(void)addTextAbove:(NSString *)textAbove
{
    for (UIView* subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UITableView class]])
        {
            UILabel *tv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            
            [tv setText:textAbove];
            [tv setBackgroundColor:[UIColor myLightGray]];
            [self.view addSubview:tv];
            
            CGRect frame = subView.frame;
            frame.origin.y = tv.frame.size.height;
            [subView setFrame:frame];
        }
    }
}
-(void) showPageLoader {
    [SVProgressHUD setForegroundColor:[UIColor clearColor]];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD show];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
}
-(void) hidePageLoader {
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = NO;
}
-(void)showWebViewWithUrl:(NSString*)url{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Web"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController setViewControllers: @[vc] animated: YES];
    vc.url = url;
    [self.navigationController presentViewController:navController animated:YES completion:^{
    }];
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
    sessionCell.location.text = [currentSession audience];
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
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
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
-(void)setErrorView:(UIView*)view{
    [view.layer setBorderColor:[UIColor redColor].CGColor];
    if ([view isKindOfClass:[UITextField class]]){
        [view becomeFirstResponder];
    }
}
-(void)setUserNavBar:(NSDictionary*)myUser{
    if ( !rightNav ){
        UIButton *user =  [UIButton buttonWithType:UIButtonTypeCustom];
        user.layer.borderWidth = 1;
        user.layer.cornerRadius = 13;
        user.clipsToBounds = YES;
        NSString * avatar = [myUser objectForKey:@"avatar"];
        NSString * name = [myUser objectForKey:@"name"];
        if ([avatar isEqual:[NSNull null]] || [avatar  isEqual: @""] || avatar == nil){
            user.backgroundColor = [UIColor myLightGray];
            if (![name isEqual: @""] && name != nil){
                [user setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [user setTitle:[[[myUser objectForKey:@"name"] substringToIndex:1]capitalizedString] forState:UIControlStateNormal];
            }
        }else {
            [user setBackgroundImageWithURL:[myUser objectForKey:@"avatar"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user.png"]];
        }
        [user addTarget:self action:@selector(goToUserProfile:)forControlEvents:UIControlEventTouchUpInside];
        [user setFrame:CGRectMake(0, 0, 26, 26)];
        navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:user];
        NSMutableDictionary* mutableUser = [[Credentials sharedCredentials].currentUser mutableCopy];
        [Credentials sharedCredentials].currentUser = [mutableUser copy];
        rightNav = user;
    }else{
        [(UIButton*)rightNav removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [(UIButton *)rightNav addTarget:self action:@selector(goToUserProfile:)forControlEvents:UIControlEventTouchUpInside];
    }
    
}

+ (void)fetchCurrentUserSessions:(UIView*)withView{
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSessionsUpdated" object:nil];
    }];
}


-(void) setRightNavButton{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    if ([Credentials sharedCredentials].currentUser && [[Credentials sharedCredentials].currentUser count]){
        [self setUserNavBar:[Credentials sharedCredentials].currentUser];
    }else{
        [self setDefaultUserIcon];
    }
}
- (void)setDefaultUserIcon{
    if (rightNav){
        [(UIButton*)rightNav removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [(UIButton*)rightNav addTarget:self action:@selector(goToSignIn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIButton *user =  [UIButton buttonWithType:UIButtonTypeCustom];
        [user setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [user addTarget:self action:@selector(goToSignIn:) forControlEvents:UIControlEventTouchUpInside];
        [user setFrame:CGRectMake(0, 0, 20, 20)];
        navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:user];
        rightNav = user;
    }
}
#pragma Mark-Share
-(void)socialModalGone:(shareEnum)result session:(Session *)session {
    
    self.sharingSession = session;
    double window_width = self.view.frame.size.width;
    double window_height = self.view.frame.size.height;
    if (session){
        CGRect rect = CGRectMake(window_width/3, window_height/2, window_width/3, window_width/3);
        if (result == copy){
             NSString* userId = [[Credentials sharedCredentials].currentUser count] > 0 ? [[Credentials sharedCredentials].currentUser objectForKey:@"id"] : @"0";
            WebService * webservice = [[WebService alloc]init];
            [webservice registerSharedSession:self.sharingSession.title note:@"copied" userId:userId];
            NSDictionary* festival = [Credentials sharedCredentials].festival;
            [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@/event/%@", [festival objectForKey:@"url"], session.id_];
            ModalView *modalView = [[ModalView alloc] initWithFrame:rect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [modalView showSuccessModal:@"Link Copied!" onWindow:self.view.window];
            });
        }else {
            if (result == facebook){
                [self postToFaceBook:session];
            }else if (result == twitter){
                [self postToTwitter:session];
            }
        }
    }
}
#pragma Mark-Facebook Share
-(void)postToFaceBook:(Session*)session{
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    NSDictionary* festival = [Credentials sharedCredentials].festival;
    content.contentTitle = [session.title capitalizedString];//title
    NSString *subDesc = @"Check out";
    if (session.picked){
        subDesc = @"I'm going to";
    }
    NSString * desc = [[NSString alloc]initWithFormat:@"%@ %@ at Newco %@", subDesc, session.title, [[festival objectForKey:@"city"]capitalizedString]];
    content.contentDescription = desc;//description
    content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/event/%@", [festival objectForKey:@"url"], session.id_]];
    
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.fromViewController = self;
//    dialog.shareContent = content;
//    dialog.delegate = self;
//    dialog.mode = FBSDKShareDialogModeNative; // if you don't set this before canShow call, canShow would always return YES
//    if (![dialog canShow]) {
//        // fallback presentation when there is no FB app
//        dialog.mode = FBSDKShareDialogModeFeedBrowser;
//    }
//    [dialog show];
    
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];
    
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    double window_width = self.view.frame.size.width;
    double window_height = self.view.frame.size.height;
    CGRect rect = CGRectMake(window_width/3, window_height/2, window_width/3, window_width/3);
    ModalView *modalView = [[ModalView alloc] initWithFrame:rect];
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
     NSString* userId = [[Credentials sharedCredentials].currentUser count] > 0 ? [[Credentials sharedCredentials].currentUser objectForKey:@"id"] : @"0";
    WebService * webservice = [[WebService alloc]init];
    [webservice registerSharedSession:self.sharingSession.title note:@"facebook" userId:userId];
    if (!isInstalled) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [modalView showSuccessModal:@"Posted!" onWindow:self.view.window];
        });
    }
}

- (void) sharerDidCancel:(id<FBSDKSharing>)sharer{
}

- (void)sharer:	(id<FBSDKSharing>)sharer didFailWithError:
(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FaceBook Post Failed"
                                                    message:@"Something went wrong."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
#pragma Mark-Twitter share
-(void)postToTwitter:(Session*)session{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                

            } else {
                double window_width = self.view.frame.size.width;
                double window_height = self.view.frame.size.height;
                CGRect rect = CGRectMake(window_width/3, window_height/2, window_width/3, window_width/3);
                ModalView *modalView = [[ModalView alloc] initWithFrame:rect];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [modalView showSuccessModal:@"Posted!" onWindow:self.view.window];
                });
                 NSString* userId = [[Credentials sharedCredentials].currentUser count] > 0 ? [[Credentials sharedCredentials].currentUser objectForKey:@"id"] : @"0";
                WebService * webservice = [[WebService alloc]init];
                [webservice registerSharedSession:session.title note:@"twitter" userId:userId];
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler = myBlock;
        
        //Adding the Text to the facebook post value from iOS
        NSDictionary* festival = [Credentials sharedCredentials].festival;
        NSString *subDesc = @"Check out";
        if (session.picked){
            subDesc = @"I'm going to";
        }
        NSString * desc = [[NSString alloc]initWithFormat:@"%@ %@ at Newco %@", subDesc, session.title, [[festival objectForKey:@"city"]capitalizedString]];
        [controller setInitialText:desc];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/event/%@", [festival objectForKey:@"url"], session.id_]]];
        
        //Adding the Image to the facebook post value from iOS
        
        //        [controller addImage:[UIImage imageNamed:@"fb.png"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=twitter"]];
        NSString *stringURL = @"twitter://";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Twitter Account."
                                                            message:@"There are no twitter accounts configured. You can add or create a twitter account in Home->Settings->Twitter."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

@end