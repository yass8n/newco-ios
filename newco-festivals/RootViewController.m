//
//  RootViewController.m
//  newco-IOS
//
//  Created by yassen aniss
//  Copyright (c) 2016 yassen aniss. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduleViewController.h"
#import "SWRevealViewController.h"


@interface RootViewController ()
    @property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
    - (IBAction)changedSegmentedControl:(id)sender;
@end

@implementation RootViewController

//waits until shceduleViewController has initialized the Directory variables before enabling the segmented control

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Credentials sharedCredentials] setApiUrl:@"http://newcolosangeles2015.sched.org"];
    [[Credentials sharedCredentials] setApiKey:@"75e5c2ec2322053c2a8b7b67e309dfc6"];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.loader startAnimating];
    ApplicationViewController.navItem = self.navigationItem; //saving current nav bar so we can change its contents later

    UIButton *menu =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [menu setFrame:CGRectMake(0, 0, 20, 20)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    
    
    [self setDefaultUserIcon];
    
    [self setViewControllerWithSegmentedControl:self.segmentedControl];
    
    ApplicationViewController.sysVer = 0;

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
