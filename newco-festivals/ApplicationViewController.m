//
//  ApplicationViewController.m
//  newco-IOS
//
//  Created by yassen aniss.
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "ApplicationViewController.h"
#import "ScheduleViewController.h"
#import "DirectoryViewController.h"
#import "SignInViewController.h"

@interface ApplicationViewController ()
// Array of view controllers to switch between
@property (nonatomic, copy) NSArray *allViewControllers;

// Currently selected view controller
@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation ApplicationViewController

static NSMutableArray * sessionsArray;
static NSMutableDictionary* datesArray;
static NSMutableDictionary* attendeesDict;
static NSMutableDictionary* presentersDict;
static NSMutableDictionary* companiesDict;
static NSMutableDictionary* volunteersDict;
static NSMutableDictionary* orderOfInsertedDates;
static NSMutableDictionary* locationColorHash;
static NSMutableArray* EVENT_COLORS_ARRAY;
static GLfloat sysVer;
static BOOL enableSegmentedControl;



+ (NSMutableArray*) sessionsArray { return sessionsArray; }
+ (NSMutableDictionary*) locationColorHash { return locationColorHash; }
+ (NSMutableArray*) EVENT_COLORS_ARRAY { return EVENT_COLORS_ARRAY; }
+ (NSMutableDictionary*) orderOfInsertedDates { return orderOfInsertedDates; }
+ (NSMutableDictionary*) companiesDict { return companiesDict; }
+ (NSMutableDictionary*) presentersDict { return presentersDict; }
+ (NSMutableDictionary*) attendeesDict { return attendeesDict; }
+ (NSMutableDictionary*) datesArray { return datesArray; }
+ (NSMutableDictionary*) volunteersDict { return volunteersDict; }
+ (GLfloat) sysVer { return sysVer; }
+ (BOOL) enableSegmentedControl { return enableSegmentedControl; }

+ (void) setEnableSegmentedControl:(BOOL) val{
    enableSegmentedControl = val;
}

+ (void) setSysVer:(GLfloat) dummy{
    { sysVer = [[[UIDevice currentDevice] systemVersion] floatValue]; }
}

+ (void) setSessionsArray:(NSMutableArray *)object{
    if (sessionsArray == nil){ sessionsArray = object;}
}

+ (void) setLocationColorHash:(NSMutableDictionary *)object{
    if (locationColorHash == nil){locationColorHash = object;}
}

+ (void) setOrderOfInsertedDates:(NSMutableDictionary *)object{
    if (orderOfInsertedDates == nil){orderOfInsertedDates = object;}
}

+ (void) setCompaniesDict:(NSMutableDictionary *)object{
    if (companiesDict == nil){companiesDict = object;}
}

+ (void) setPresentersDict:(NSMutableDictionary *)object{
    if (presentersDict == nil){presentersDict = object;}
}

+ (void) setAttendeesDict:(NSMutableDictionary *)object{
    if (attendeesDict == nil){attendeesDict = object;}
}

+ (void) setDatesArray:(NSMutableDictionary *)object{
    if (datesArray == nil){datesArray = object;}
}

+ (void) setVolunteersDict:(NSMutableDictionary *)object{
    if (volunteersDict == nil){volunteersDict = object;}
}

//called from app delagate when entering active state
+ (void)initEventColorsArray{
    if (EVENT_COLORS_ARRAY == nil){
        EVENT_COLORS_ARRAY = [[NSMutableArray alloc] initWithObjects:
                              [UIColor myRed],
                              [UIColor myGreen],
                              [UIColor myBlue],
                              [UIColor myOrange],
                              [UIColor myPurple],
                              [UIColor myTeal],
                              [UIColor myYellow],
                              [UIColor myPink],
                              [UIColor myDarkBlue],
                              [UIColor myDarkRed],
                              nil];
    }

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
-(void)fadeIn:(UIView*)view duration:(float)duration{
    
    [view setAlpha:0.1f];
    
    //fade in
    [UIView animateWithDuration:duration animations:^{
        
        [view setAlpha:1.0f];
        
    }];
}
- (void)setBackButton{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.jpg"] landscapeImagePhone:[UIImage imageNamed:@"back.jpg"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = item;
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

+ (void)setBorder:(UIView*)obj width:(float)wid radius:(int)rad color:(UIColor*)col{
    obj.layer.borderColor = col.CGColor;
    obj.layer.borderWidth = wid;
    obj.layer.cornerRadius = rad;
}
- (UIColor *) findFreeColor{
    NSUInteger count = [[locationColorHash allKeys] count];
    return [EVENT_COLORS_ARRAY objectAtIndex:count];
}
+ (NSDate*) UTCtoNSDate:(NSString*)utc{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd HH:mm"];
        return [formatter dateFromString:utc];
}
+ (NSString*) myDateToFormat:(NSDate *)date withFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
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





@end
