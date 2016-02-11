//
//  RootViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduleViewController.h"

@interface RootViewController ()
    @property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
    - (IBAction)changedSegmentedControl:(id)sender;
@end

@implementation RootViewController

//waits until shceduleViewController has initialized the Directory variables before enabling the segmented control
-(void)enableFullUserInteraction{
    while (true) {
        [NSThread sleepForTimeInterval:.3];
        if (ApplicationViewController.enableFullUserInteraction == YES){
            self.navigationItem.titleView.userInteractionEnabled = YES;
            [UIApplication sharedApplication].
            networkActivityIndicatorVisible = NO;
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ApplicationViewController.API_KEY = @"08d2f1d3e2dfe3a420b228ad73413cb7";
    ApplicationViewController.API_URL = @"http://newcobaybridgefestivals2015.sched.org";
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.loader startAnimating];
    ApplicationViewController.navItem = self.navigationItem; //saving current nav bar so we can change its contents later
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;

    UIButton *menu =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menu setFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    UIButton *user =  [UIButton buttonWithType:UIButtonTypeCustom];
    [user setImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
    [user addTarget:self action:@selector(goToSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [user setFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:user];
    
    self.navigationItem.titleView.userInteractionEnabled = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    NSDictionary *myUser = [prefs dictionaryForKey:@"user"];
    if (myUser){
        ApplicationViewController.currentUser = [[NSDictionary alloc] init];
        ApplicationViewController.currentUser = myUser;
        [self setUserNavBar:myUser];
    }
    [self setViewControllerWithSegmentedControl:self.segmentedControl];
    
    ApplicationViewController.sysVer = 0;
    
    dispatch_queue_t que = dispatch_queue_create("enableControl", NULL);
    dispatch_async(que, ^{[self enableFullUserInteraction];});
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor myLightGray];
    self.navigationController.navigationBar.tintColor = [UIColor myLightGray];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    ApplicationViewController.currentVC = enumRoot;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changedSegmentedControl:(id)sender {
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    [self changeViewController:index];
}


@end
